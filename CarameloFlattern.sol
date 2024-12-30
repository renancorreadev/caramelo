// Sources flattened with hardhat v2.22.16 https://hardhat.org

// SPDX-License-Identifier: MIT

// File @openzeppelin/contracts/utils/Context.sol@v5.0.0

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (utils/Context.sol)

pragma solidity ^0.8.20;

/**
 * @dev Provides information about the current execution context, including the
 * sender of the transaction and its data. While these are generally available
 * via msg.sender and msg.data, they should not be accessed in such a direct
 * manner, since when dealing with meta-transactions the account sending and
 * paying for execution may not be the actual sender (as far as an application
 * is concerned).
 *
 * This contract is only required for intermediate, library-like contracts.
 */
abstract contract Context {
    function _msgSender() internal view virtual returns (address) {
        return msg.sender;
    }

    function _msgData() internal view virtual returns (bytes calldata) {
        return msg.data;
    }
}


// File @openzeppelin/contracts/access/Ownable.sol@v5.0.0

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (access/Ownable.sol)

pragma solidity ^0.8.20;

/**
 * @dev Contract module which provides a basic access control mechanism, where
 * there is an account (an owner) that can be granted exclusive access to
 * specific functions.
 *
 * The initial owner is set to the address provided by the deployer. This can
 * later be changed with {transferOwnership}.
 *
 * This module is used through inheritance. It will make available the modifier
 * `onlyOwner`, which can be applied to your functions to restrict their use to
 * the owner.
 */
abstract contract Ownable is Context {
    address private _owner;

    /**
     * @dev The caller account is not authorized to perform an operation.
     */
    error OwnableUnauthorizedAccount(address account);

    /**
     * @dev The owner is not a valid owner account. (eg. `address(0)`)
     */
    error OwnableInvalidOwner(address owner);

    event OwnershipTransferred(address indexed previousOwner, address indexed newOwner);

    /**
     * @dev Initializes the contract setting the address provided by the deployer as the initial owner.
     */
    constructor(address initialOwner) {
        if (initialOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(initialOwner);
    }

    /**
     * @dev Throws if called by any account other than the owner.
     */
    modifier onlyOwner() {
        _checkOwner();
        _;
    }

    /**
     * @dev Returns the address of the current owner.
     */
    function owner() public view virtual returns (address) {
        return _owner;
    }

    /**
     * @dev Throws if the sender is not the owner.
     */
    function _checkOwner() internal view virtual {
        if (owner() != _msgSender()) {
            revert OwnableUnauthorizedAccount(_msgSender());
        }
    }

    /**
     * @dev Leaves the contract without owner. It will not be possible to call
     * `onlyOwner` functions. Can only be called by the current owner.
     *
     * NOTE: Renouncing ownership will leave the contract without an owner,
     * thereby disabling any functionality that is only available to the owner.
     */
    function renounceOwnership() public virtual onlyOwner {
        _transferOwnership(address(0));
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Can only be called by the current owner.
     */
    function transferOwnership(address newOwner) public virtual onlyOwner {
        if (newOwner == address(0)) {
            revert OwnableInvalidOwner(address(0));
        }
        _transferOwnership(newOwner);
    }

    /**
     * @dev Transfers ownership of the contract to a new account (`newOwner`).
     * Internal function without access restriction.
     */
    function _transferOwnership(address newOwner) internal virtual {
        address oldOwner = _owner;
        _owner = newOwner;
        emit OwnershipTransferred(oldOwner, newOwner);
    }
}


// File @openzeppelin/contracts/utils/ReentrancyGuard.sol@v5.0.0

// Original license: SPDX_License_Identifier: MIT
// OpenZeppelin Contracts (last updated v5.0.0) (utils/ReentrancyGuard.sol)

pragma solidity ^0.8.20;

/**
 * @dev Contract module that helps prevent reentrant calls to a function.
 *
 * Inheriting from `ReentrancyGuard` will make the {nonReentrant} modifier
 * available, which can be applied to functions to make sure there are no nested
 * (reentrant) calls to them.
 *
 * Note that because there is a single `nonReentrant` guard, functions marked as
 * `nonReentrant` may not call one another. This can be worked around by making
 * those functions `private`, and then adding `external` `nonReentrant` entry
 * points to them.
 *
 * TIP: If you would like to learn more about reentrancy and alternative ways
 * to protect against it, check out our blog post
 * https://blog.openzeppelin.com/reentrancy-after-istanbul/[Reentrancy After Istanbul].
 */
abstract contract ReentrancyGuard {
    // Booleans are more expensive than uint256 or any type that takes up a full
    // word because each write operation emits an extra SLOAD to first read the
    // slot's contents, replace the bits taken up by the boolean, and then write
    // back. This is the compiler's defense against contract upgrades and
    // pointer aliasing, and it cannot be disabled.

    // The values being non-zero value makes deployment a bit more expensive,
    // but in exchange the refund on every call to nonReentrant will be lower in
    // amount. Since refunds are capped to a percentage of the total
    // transaction's gas, it is best to keep them low in cases like this one, to
    // increase the likelihood of the full refund coming into effect.
    uint256 private constant NOT_ENTERED = 1;
    uint256 private constant ENTERED = 2;

    uint256 private _status;

    /**
     * @dev Unauthorized reentrant call.
     */
    error ReentrancyGuardReentrantCall();

    constructor() {
        _status = NOT_ENTERED;
    }

    /**
     * @dev Prevents a contract from calling itself, directly or indirectly.
     * Calling a `nonReentrant` function from another `nonReentrant`
     * function is not supported. It is possible to prevent this from happening
     * by making the `nonReentrant` function external, and making it call a
     * `private` function that does the actual work.
     */
    modifier nonReentrant() {
        _nonReentrantBefore();
        _;
        _nonReentrantAfter();
    }

    function _nonReentrantBefore() private {
        // On the first call to nonReentrant, _status will be NOT_ENTERED
        if (_status == ENTERED) {
            revert ReentrancyGuardReentrantCall();
        }

        // Any calls to nonReentrant after this point will fail
        _status = ENTERED;
    }

    function _nonReentrantAfter() private {
        // By storing the original value once again, a refund is triggered (see
        // https://eips.ethereum.org/EIPS/eip-2200)
        _status = NOT_ENTERED;
    }

    /**
     * @dev Returns true if the reentrancy guard is currently set to "entered", which indicates there is a
     * `nonReentrant` function in the call stack.
     */
    function _reentrancyGuardEntered() internal view returns (bool) {
        return _status == ENTERED;
    }
}


// File contracts/interfaces/UniswapV2Interfaces.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.22;

interface IUniswapV2Router02 {
    function WETH() external pure returns (address);

    function factory() external pure returns (address);

    /// @dev swap exact tokens for ETH supporting fee on transfer tokens
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    /// @dev swap exact ETH for tokens supporting fee on transfer tokens
    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable;

    /// @dev swap exact tokens for tokens supporting fee on transfer tokens
    function swapExactTokensForTokensSupportingFeeOnTransferTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external;

    function swapExactTokensForTokens(
        uint256 amountIn,
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactTokens(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapTokensForExactETH(
        uint256 amountOut,
        uint256 amountInMax,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external returns (uint256[] memory amounts);

    function swapExactETHForTokens(
        uint256 amountOutMin,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    function swapETHForExactTokens(
        uint256 amountOut,
        address[] calldata path,
        address to,
        uint256 deadline
    ) external payable returns (uint256[] memory amounts);

    // Liquidity functions
    function addLiquidity(
        address tokenA,
        address tokenB,
        uint256 amountADesired,
        uint256 amountBDesired,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB, uint256 liquidity);

    function addLiquidityETH(
        address token,
        uint256 amountTokenDesired,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    )
        external
        payable
        returns (uint256 amountToken, uint256 amountETH, uint256 liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETH(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityWithPermit(
        address tokenA,
        address tokenB,
        uint256 liquidity,
        uint256 amountAMin,
        uint256 amountBMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountA, uint256 amountB);

    function removeLiquidityETHWithPermit(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountToken, uint256 amountETH);

    function removeLiquidityETHSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline
    ) external returns (uint256 amountETH);

    function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(
        address token,
        uint256 liquidity,
        uint256 amountTokenMin,
        uint256 amountETHMin,
        address to,
        uint256 deadline,
        bool approveMax,
        uint8 v,
        bytes32 r,
        bytes32 s
    ) external returns (uint256 amountETH);

    // Quote and price functions
    function quote(
        uint256 amountA,
        uint256 reserveA,
        uint256 reserveB
    ) external pure returns (uint256 amountB);

    function getAmountOut(
        uint256 amountIn,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountOut);

    function getAmountIn(
        uint256 amountOut,
        uint256 reserveIn,
        uint256 reserveOut
    ) external pure returns (uint256 amountIn);

    function getAmountsOut(
        uint256 amountIn,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);

    function getAmountsIn(
        uint256 amountOut,
        address[] calldata path
    ) external view returns (uint256[] memory amounts);
}

interface IUniswapV2Factory {
    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);

    function allPairs(uint256) external view returns (address pair);

    function allPairsLength() external view returns (uint256);

    function feeTo() external view returns (address);

    function feeToSetter() external view returns (address);

    function setFeeTo(address) external;

    function setFeeToSetter(address) external;
}
interface IUniswapV2Pair {
    function getReserves()
        external
        view
        returns (uint112 reserve0, uint112 reserve1, uint32 blockTimestampLast);

    function token0() external view returns (address);

    function token1() external view returns (address);
}


// File contracts/utils/CarameloErrors.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.22;

/// @dev Custom errors for the token contract
error TokenomicsAlreadyInitialized(string message);
error ZeroAddress();
error InvalidAmount();
error AlreadyExcluded();
error NotExcluded();
error FeesExceeded(uint256 totalFees);
error ContractLocked();
error SwapProtocolAlreadyConfigured();
error MaxTransactionExceeded(uint256 maxTxAmount, uint256 attemptedAmount);
error InsufficientBalance(uint256 available, uint256 required);
error InvalidTaxFee();
error InvalidLiquidityFee();
error InvalidBurnFee();
error ApprovalFailed(address owner, address spender, uint256 amount);
error NumTokensSellToAddToLiquidityFailed(uint256 currentAmount, uint256 newAmount);
error UpgradesAreFrozen();
error InvalidImplementation();
error TokenBalanceZero();
error LiquidityAdditionFailed();
error TransferAmountZero();
error TransferAmountExceedsMax();
error ZeroValue();
error InvalidTokenomicsPercentage();
error OwnerNotExcludedFromFee();
error TotalSupplyNotMatch(uint256 actualSupply, uint256 expectedSupply);
error BurnExceedsTotalSupply(uint256 tBurn, uint256 _tTotal);


// File contracts/Caramelo.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.22;



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
            wallet: 0x9Bfb2e701bcc5C4E02539f74C0E66593b5D13a4a, // Marketing Wallet
            percentage: 10 // 10% percentage
        });

        /// --> @dev Team One Wallet
        tokenomics[3] = TokenomicsConfig({
            wallet: 0x24f515276052D412f659aa28a6DD7f39a52F6aD7, // Team One Wallet
            percentage: 10 // 10% percentage
        });
        /// --> @dev Team Second Wallet
        tokenomics[4] = TokenomicsConfig({
            wallet: 0x14864Bc81FEed0ec2AA2E1826f82b1801D55C47f, // Team Second Wallet
            percentage: 10 // 10% percentage
        });
        /// --> @dev Developer Wallet
        tokenomics[5] = TokenomicsConfig({
            wallet: 0x003Bfb0098f7ACea6d7D9C1b866268a8Bd36C2e2,
            percentage: 5 // 5% percentage
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
