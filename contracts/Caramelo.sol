// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';
import {ReentrancyGuard} from '@openzeppelin/contracts/utils/ReentrancyGuard.sol';
import {
    TokenomicsAlreadyInitialized,
    ZeroAddress,
    InvalidAmount,
    AlreadyExcluded,
    NotExcluded,
    FeesExceeded,
    ContractLocked,
    SwapProtocolAlreadyConfigured,
    MaxTransactionExceeded,
    InsufficientBalance,
    InvalidTaxFee,
    InvalidLiquidityFee,
    InvalidBurnFee,
    ApprovalFailed,
    NumTokensSellToAddToLiquidityFailed,
    UpgradesAreFrozen,
    InvalidImplementation,
    TokenBalanceZero,
    LiquidityAdditionFailed,
    TransferAmountZero,
    TransferAmountExceedsMax,
    ZeroValue,
    InvalidTokenomicsPercentage,
    BurnExceedsTotalSupply
} from './utils/CarameloErrors.sol';

import {IUniswapV2Router02, IUniswapV2Factory} from './interfaces/UniswapV2Interfaces.sol';

contract Caramelo is Ownable, ReentrancyGuard {
    uint256 private constant MAX = ~uint256(0);
    uint256 private constant FEE_DIVISOR = 100000;

    uint256 private _tTotal;
    uint256 private _rTotal;
    uint256 private _tFeeTotal;

    string private _name;
    string private _symbol;
    uint8 private _decimals;
    bool private initTokenomics = false;

    mapping(address => uint256) private _rOwned;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) private _isExcludedFromFee;

    uint256 public taxFee;
    uint256 public liquidityFee;

    uint256 public maxTxAmount;
    uint256 public numTokensSellToAddToLiquidity;

    bool public swapAndLiquifyEnabled = false;
    bool private inSwapAndLiquify = false;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    /** @dev Events */
    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event TokensBurned(address indexed burner, uint256 burnAmount);
    event FeesDistributed(
        uint256 reflectionFee,
        uint256 liquidityFee,
        uint256 burnFee
    );
    event SwapAndLiquify(
        uint256 tokensSwapped,
        uint256 ethReceived,
        uint256 tokensAddedToLiquidity
    );
    event UniswapConfigured(address indexed router, address indexed pair);
    event ExcludedFromFee(address indexed account);
    event SwapAndLiquifyEnabledUpdated(bool enabled);
    event FeesUpdated(uint256 indexed _taxFee, uint256 indexed _liquidityFee);
    event MaxTxAmountUpdated(uint256 newMaxTxAmount);
    event NumTokensSellToAddToLiquidityUpdated(
        uint256 newNumTokensSellToAddToLiquidity
    );
    event UniswapV2RouterUpdated(address newRouter);
    event IncludedInFee(address indexed account);
    event LiquidityAdded(
        uint256 tokenAmount,
        uint256 ethAmount,
        uint256 liquidity
    );

    /** @dev Modifier to lock the swap */
    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    /** @dev Tokenomics configuration */
    struct TokenomicsConfig {
        address wallet;
        uint256 percentage;
    }

    /**  @dev Tokenomics configuration */
    TokenomicsConfig[6] public tokenomics;

    constructor(
        string memory tokenName,
        string memory tokenSymbol,
        uint256 _totalSupply,
        uint8 _token_decimals,
        uint256 _taxFee,
        uint256 _liquidityFee,
        uint256 _maxTokensTXAmount,
        uint256 _numTokensSellToAddToLiquidity
    ) Ownable(msg.sender) ReentrancyGuard() {
        /// @dev Validate the sum of the fees
        if (_taxFee + _liquidityFee > FEE_DIVISOR) {
            revert FeesExceeded(_taxFee + _liquidityFee);
        }

        _name = tokenName;
        _symbol = tokenSymbol;
        _decimals = _token_decimals;

        _tTotal = _totalSupply * (10 ** uint256(_decimals));
        _rTotal = (MAX - (MAX % _tTotal));

        taxFee = _taxFee;
        liquidityFee = _liquidityFee;

        maxTxAmount = _maxTokensTXAmount * 10 ** _decimals;
        numTokensSellToAddToLiquidity =
            _numTokensSellToAddToLiquidity *
            10 ** _decimals;

        _rOwned[_msgSender()] = _rTotal;
        _isExcludedFromFee[_msgSender()] = true;
        _isExcludedFromFee[address(this)] = true;

        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    /** @dev Getters */

    /** @dev Get name of token   */
    function name() public view returns (string memory) {
        return _name;
    }

    /** @dev Get symbol of token */
    function symbol() public view returns (string memory) {
        return _symbol;
    }

    /** @dev Get reflection balance of an account */
    function reflectionBalanceOf(
        address account
    ) public view returns (uint256) {
        require(account != address(0), 'Zero address');
        return _rOwned[account] / _getRate();
    }

    /** @dev Get decimals of token */
    function decimals() public view returns (uint8) {
        return _decimals;
    }

    /** @dev Get allowance of an account */
    function allowance(
        address owner,
        address spender
    ) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    /** @dev Get total supply of token */
    function totalSupply() public view returns (uint256) {
        return _tTotal;
    }

    /** @dev Get balance of an account */
    function balanceOf(address account) public view returns (uint256) {
        if (_rOwned[account] == 0) {
            return 0;
        }
        return _rOwned[account] / _getRate();
    }

    /** @dev Initialize tokenomics */
    /** 
        @notice this function execute one 
    */
    function initializeTokenomics() external onlyOwner {
        if (initTokenomics) {
            revert TokenomicsAlreadyInitialized(
                'Tokenomics already initialized!'
            );
        }
        /// @dev Tokenomics Transfers
        /// --> @dev Community Wallet
        tokenomics[0] = TokenomicsConfig({
            wallet: msg.sender, // Community Wallet is deployer
            percentage: 50 // 50% percentage
        });
        /// --> @dev ONG Wallet
        tokenomics[1] = TokenomicsConfig({
            wallet: 0x5CffE6546affdCEEa5Fc02838Ad7B1aAec3Fc00A, // ONG Wallet
            percentage: 15 // 15% percentage
        });
        /// --> @dev Marketing Wallet
        tokenomics[2] = TokenomicsConfig({
            wallet: 0x51B8470fE0DA250B5893Ee5B26574FEb32282F2b, // Marketing Wallet
            percentage: 10 // 10% percentage
        });

        /// --> @dev Team One Wallet
        tokenomics[3] = TokenomicsConfig({
            wallet: 0x24f515276052D412f659aa28a6DD7f39a52F6aD7, // Team One Wallet
            percentage: 10 // 10% percentage
        });
        /// --> @dev Team Second Wallet
        tokenomics[4] = TokenomicsConfig({
            wallet: 0xd3A2bd9cFB11067fa80Aca88bED48fa7CF0e2dcC, // Team Second Wallet
            percentage: 10 // 10% percentage
        });
        /// --> @dev Developer Wallet
        tokenomics[5] = TokenomicsConfig({
            wallet: 0x05b0cF5Efa12dc9bd83558b4787120a9297D9246,
            percentage: 5
        });

        /// @dev Validate the sum of the percentages
        uint256 totalPercentage = 0;
        for (uint256 i = 0; i < tokenomics.length; i++) {
            if (tokenomics[i].wallet == address(0)) revert ZeroAddress();
            totalPercentage += tokenomics[i].percentage;
        }

        if (totalPercentage != 100) revert InvalidTokenomicsPercentage();

        /// @dev Initial transfer to each wallet
        for (uint256 i = 0; i < tokenomics.length; i++) {
            uint256 allocation = (_tTotal * tokenomics[i].percentage) / 100;

            _transfer(_msgSender(), tokenomics[i].wallet, allocation);
        }

        initTokenomics = true;
    }

    /** @dev Transfer tokens */
    function transfer(
        address recipient,
        uint256 amount
    ) public nonReentrant returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    /** @dev Transfer tokens from an account */
    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public nonReentrant returns (bool) {
        uint256 currentAllowance = _allowances[sender][_msgSender()];
        if (currentAllowance < amount) {
            revert InsufficientBalance(currentAllowance, amount);
        }

        _transfer(sender, recipient, amount);

        unchecked {
            _approve(sender, _msgSender(), currentAllowance - amount);
        }

        return true;
    }

    /** @dev Set max transaction amount */
    function setMaxTxAmount(uint256 newMaxTxAmount) external onlyOwner {
        maxTxAmount = newMaxTxAmount * 10 ** _decimals;
        emit MaxTxAmountUpdated(newMaxTxAmount);
    }

    /** @dev Update Uniswap V2 Router */
    function updateUniswapV2Router(address newRouter) external onlyOwner {
        if (newRouter == address(0)) {
            revert ZeroAddress();
        }

        uniswapV2Router = IUniswapV2Router02(newRouter);
        emit UniswapV2RouterUpdated(newRouter);
    }

    /** @dev Set number of tokens to add to liquidity */
    function setNumTokensSellToAddToLiquidity(
        uint256 newNumTokensSellToAddToLiquidity
    ) external onlyOwner {
        numTokensSellToAddToLiquidity =
            newNumTokensSellToAddToLiquidity *
            10 ** _decimals;

        if (numTokensSellToAddToLiquidity > maxTxAmount) {
            revert NumTokensSellToAddToLiquidityFailed(
                numTokensSellToAddToLiquidity,
                maxTxAmount
            );
        }

        emit NumTokensSellToAddToLiquidityUpdated(
            newNumTokensSellToAddToLiquidity
        );
    }

    /** @dev Check if an account is excluded from fee */
    function isAccountExcludedFromFree(
        address account
    ) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    /** @dev Include an account in fee */
    function includeInFee(address account) external onlyOwner {
        if (!_isExcludedFromFee[account]) {
            revert NotExcluded();
        }
        _isExcludedFromFee[account] = false;
        emit IncludedInFee(account);
    }

    /** @dev Exclude an account from fee */
    function excludeFromFee(address account) external onlyOwner {
        if (_isExcludedFromFee[account]) {
            revert AlreadyExcluded();
        }

        _isExcludedFromFee[account] = true;
        emit ExcludedFromFee(account);
    }

    /** @dev Burn tokens */
    /** @param amount: Amount of tokens to burn */
    function burn(uint256 amount) external onlyOwner {
        _burn(amount);
    }

    /** 
        @notice Set fees for tax and liquidity
        @param _taxFee: Tax fee
        @param _liquidityFee: Liquidity fee
        @dev Total fee cannot exceed FEE_DIVISOR
    */
    function setFees(
        uint256 _taxFee,
        uint256 _liquidityFee
    ) external onlyOwner {
        uint256 totalFee = _taxFee + _liquidityFee;
        if (totalFee > FEE_DIVISOR) {
            revert FeesExceeded(totalFee);
        }
        taxFee = _taxFee;
        liquidityFee = _liquidityFee;

        emit FeesUpdated(_taxFee, _liquidityFee);
    }

    /** @notice Approve an allowance for a spender
     * @param spender Address of the spender
     * @param amount Amount of tokens to approve
     * @return A boolean indicating if the approval was successful
     */
    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    /** @dev Internal function to approve an allowance for a spender */
    /** @param owner: Address of the owner */
    /** @param spender: Address of the spender */
    /** @param amount: Amount of tokens to approve */
    function _approve(address owner, address spender, uint256 amount) private {
        if (owner == address(0) || spender == address(0)) {
            revert ZeroAddress();
        }

        _allowances[owner][spender] = amount;

        emit Approval(owner, spender, amount);
    }

    /** @dev Internal function to transfer tokens */
    /** @param sender: Address of the sender */
    /** @param recipient: Address of the recipient */
    /** @param amount: Amount of tokens to transfer */
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        if (sender == address(0)) revert ZeroAddress();
        if (recipient == address(0)) revert ZeroAddress();
        if (amount == 0) revert TransferAmountZero();

        /// @dev verify if the transfer amount exceeds the maxTxAmount
        if (sender != owner() && maxTxAmount > 0 && amount > maxTxAmount) {
            revert TransferAmountExceedsMax();
        }

        uint256 contractTokenBalance = balanceOf(address(this));

        if (
            contractTokenBalance >= numTokensSellToAddToLiquidity &&
            !inSwapAndLiquify &&
            sender != uniswapV2Pair
        ) {
            swapAndLiquify(contractTokenBalance);
        }

        bool takeFee = !_isExcludedFromFee[sender];

        uint256 tFee = 0;
        uint256 tLiquidity = 0;
        uint256 tBurn = 0;

        if (takeFee) {
            tFee = (amount * taxFee) / FEE_DIVISOR;

            /// @dev Burn 30% of the taxFee
            tBurn = (tFee * 30000) / FEE_DIVISOR; // 30% using FEE_DIVISOR

            /// @dev Distribute 70% of the taxFee to holders
            tFee = tFee - tBurn;

            /// @dev Calculate liquidity fee
            tLiquidity = (amount * liquidityFee) / FEE_DIVISOR;
        }

        uint256 tTransferAmount = amount - tFee - tLiquidity - tBurn;

        /// @dev Update sender's balance
        _rOwned[sender] -= amount * _getRate();

        /// @dev Update recipient's balance
        _rOwned[recipient] += tTransferAmount * _getRate();

        /// @dev Process fees if applicable
        if (takeFee) {
            _reflectFee(tFee);
            _takeLiquidity(tLiquidity);

            /// @dev Adjust total supply by burning tokens
            _burn(tBurn);

            /// @dev Emit event for detailed tracking
            emit FeesDistributed(tFee, tLiquidity, tBurn);
            emit TokensBurned(sender, tBurn);
        }

        emit Transfer(sender, recipient, tTransferAmount);
    }

    /** @dev Configure Uniswap */
    /** @param routerAddress: Address of the router */
    function configureSwapProtocol(address routerAddress) external onlyOwner {
        if (
            address(uniswapV2Router) != address(0) ||
            uniswapV2Pair != address(0)
        ) {
            revert SwapProtocolAlreadyConfigured();
        }
        if (routerAddress == address(0)) {
            revert ZeroAddress();
        }

        uniswapV2Router = IUniswapV2Router02(routerAddress);

        address pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
            address(this),
            uniswapV2Router.WETH()
        );

        if (pair == address(0)) {
            revert ZeroAddress();
        }

        uniswapV2Pair = pair;
        _isExcludedFromFee[pair] = true;
        _isExcludedFromFee[routerAddress] = true;

        emit UniswapConfigured(routerAddress, pair);
    }

    /** @dev Check if swap and liquify is enabled */
    /** @return A boolean indicating if swap and liquify is enabled */
    function isSwapAndLiquifyEnabled() external view returns (bool) {
        return swapAndLiquifyEnabled;
    }

    /** @dev Swap and liquify tokens */
    /** @param contractTokenBalance: Amount of tokens to swap and liquify */
    /** @dev Lock the swap to prevent reentrancy */
    function swapAndLiquify(uint256 contractTokenBalance) private lockTheSwap {
        if (contractTokenBalance == 0) {
            revert TokenBalanceZero();
        }

        uint256 half = contractTokenBalance / 2;
        uint256 otherHalf = contractTokenBalance - half;

        uint256 initialBalance = address(this).balance;

        swapTokensForEth(half);

        uint256 newBalance = address(this).balance - initialBalance;

        addLiquidity(otherHalf, newBalance);

        emit SwapAndLiquify(half, newBalance, otherHalf);
    }

    /** @dev Set swap and liquify enabled */
    /** @param _enabled: Boolean indicating if swap and liquify is enabled */
    function setSwapAndLiquifyEnabled(bool _enabled) external onlyOwner {
        if (swapAndLiquifyEnabled == _enabled) {
            revert(
                _enabled
                    ? 'Swap is already enabled'
                    : 'Swap is already disabled'
            );
        }
        swapAndLiquifyEnabled = _enabled;
        emit SwapAndLiquifyEnabledUpdated(_enabled);
    }

    /** @dev Swap tokens for ETH */
    /** @param tokenAmount: Amount of tokens to swap */
    function swapTokensForEth(uint256 tokenAmount) private {
        address[] memory path = new address[](2);
        path[0] = address(this);
        path[1] = uniswapV2Router.WETH();

        _approve(address(this), address(uniswapV2Router), tokenAmount);

        uniswapV2Router.swapExactTokensForETHSupportingFeeOnTransferTokens(
            tokenAmount,
            0,
            path,
            address(this),
            block.timestamp
        );
    }

    /** @dev Add liquidity */
    /** @param tokenAmount: Amount of tokens to add */
    /** @param ethAmount: Amount of ETH to add */
    function addLiquidity(uint256 tokenAmount, uint256 ethAmount) private {
        // Verificar se o router é válido
        if (address(uniswapV2Router) == address(0)) {
            revert ZeroAddress();
        }

        /// @dev approve router to spend tokens
        _approve(address(this), address(uniswapV2Router), tokenAmount);

        /// @dev add liquidity with returned values checks
        (uint amountToken, uint amountETH, uint liquidity) = uniswapV2Router
            .addLiquidityETH{value: ethAmount}(
            address(this),
            tokenAmount,
            0, // Accept any amount of tokens
            0, // Accept any amount of ETH
            owner(), // LP tokens will go to the owner
            block.timestamp
        );

        /// @dev verify if liquidity addition was successful
        if (liquidity == 0) {
            revert LiquidityAdditionFailed();
        }

        emit LiquidityAdded(amountToken, amountETH, liquidity);
    }

    /** @dev Withdraw BNB */
    /** @param amount: Amount of BNB to withdraw */
    function withdrawBNB(uint256 amount) external onlyOwner {
        if (address(this).balance < amount) {
            revert InsufficientBalance(address(this).balance, amount);
        }
        payable(msg.sender).transfer(amount);
    }

    /** @dev Reflect fee */
    /** @param tFee: Amount of fee to reflect */
    function _reflectFee(uint256 tFee) private {
        uint256 rFee = tFee * _getRate();
        _rTotal -= rFee;
        _tFeeTotal += tFee;

        emit FeesDistributed(tFee, 0, 0); // Apenas reflexão
    }

    /** @dev Take liquidity fee */
    /** @param tLiquidity: Amount of liquidity fee to take */
    function _takeLiquidity(uint256 tLiquidity) private {
        uint256 rLiquidity = tLiquidity * _getRate();
        _rOwned[address(this)] += rLiquidity;
    }

    /** @dev Burn tokens */
    /** @param tBurn: Amount of tokens to burn */
    function _burn(uint256 tBurn) private {
        /// @dev Check if tBurn exceeds the available total supply
        if (tBurn > _tTotal) {
            revert BurnExceedsTotalSupply(tBurn, _tTotal);
        }
        /// @dev Burn tokens if amount is greater than zero
        if (tBurn > 0) {
            uint256 rBurn = tBurn * _getRate();
            _rTotal -= rBurn;
            _tTotal -= tBurn;
            /// @dev Emit event for detailed tracking
            emit TokensBurned(address(this), tBurn);
        } else {
            /// @dev Revert if amount is zero
            revert ZeroValue();
        }
    }

    /** @dev Get rate */
    /** @return A uint256 representing the rate */
    function _getRate() private view returns (uint256) {
        require(_tTotal > 0, 'Total supply must be greater than zero');
        return _rTotal / _tTotal;
    }

    receive() external payable {}
}
