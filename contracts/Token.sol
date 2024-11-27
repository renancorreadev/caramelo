// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

import {UUPSUpgradeable} from '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import {Initializable} from '@openzeppelin/contracts-upgradeable/proxy/utils/Initializable.sol';
import {OwnableUpgradeable} from '@openzeppelin/contracts-upgradeable/access/OwnableUpgradeable.sol';

interface IUniswapV2Router01 {
    function factory() external pure returns (address);
    function WETH() external pure returns (address);

    function addLiquidity(
        address tokenA,
        address tokenB,
        uint amountADesired,
        uint amountBDesired,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB, uint liquidity);

    function addLiquidityETH(
        address token,
        uint amountTokenDesired,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    )
        external
        payable
        returns (uint amountToken, uint amountETH, uint liquidity);

    function removeLiquidity(
        address tokenA,
        address tokenB,
        uint liquidity,
        uint amountAMin,
        uint amountBMin,
        address to,
        uint deadline
    ) external returns (uint amountA, uint amountB);

    function removeLiquidityETH(
        address token,
        uint liquidity,
        uint amountTokenMin,
        uint amountETHMin,
        address to,
        uint deadline
    ) external returns (uint amountToken, uint amountETH);
}

interface IUniswapV2Router02 is IUniswapV2Router01 {
    function swapExactTokensForETHSupportingFeeOnTransferTokens(
        uint amountIn,
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external;

    function swapExactETHForTokensSupportingFeeOnTransferTokens(
        uint amountOutMin,
        address[] calldata path,
        address to,
        uint deadline
    ) external payable;
}

interface IUniswapV2Factory {
    event PairCreated(
        address indexed token0,
        address indexed token1,
        address pair,
        uint
    );

    function feeTo() external view returns (address);
    function feeToSetter() external view returns (address);

    function getPair(
        address tokenA,
        address tokenB
    ) external view returns (address pair);
    function allPairs(uint) external view returns (address pair);
    function allPairsLength() external view returns (uint);

    function createPair(
        address tokenA,
        address tokenB
    ) external returns (address pair);
}

contract Token is Initializable, UUPSUpgradeable, OwnableUpgradeable {
    uint256 private constant MAX = ~uint256(0);
    uint256 private _tTotal;
    uint256 private _rTotal;
    uint256 private _tFeeTotal;

    string private _name;
    string private _symbol;
    uint8 private _decimals;

    mapping(address => uint256) private _rOwned;
    mapping(address => uint256) private _tOwned;
    mapping(address => mapping(address => uint256)) private _allowances;

    mapping(address => bool) private _isExcludedFromFee;
    mapping(address => bool) private _isExcluded;
    address[] private _excluded;

    uint256 public taxFee;
    uint256 public liquidityFee;
    uint256 public burnFee;

    uint256 public maxTxAmount;
    uint256 public numTokensSellToAddToLiquidity;

    bool public swapAndLiquifyEnabled;
    bool private inSwapAndLiquify;

    IUniswapV2Router02 public uniswapV2Router;
    address public uniswapV2Pair;

    modifier lockTheSwap() {
        inSwapAndLiquify = true;
        _;
        inSwapAndLiquify = false;
    }

    event Transfer(address indexed from, address indexed to, uint256 value);
    event Approval(
        address indexed owner,
        address indexed spender,
        uint256 value
    );
    event TokensAndETHRecovered(uint256 tokenAmount, uint256 ethAmount);

    constructor() {}

    function initialize(
        string memory tokenName,
        string memory tokenSymbol,
        uint256 _totalSupply,
        uint256 _taxFee,
        uint256 _liquidityFee,
        uint256 _burnFee,
        uint256 _maxTxAmount,
        uint256 _numTokensSellToAddToLiquidity,
        address routerAddress
    ) public initializer {
        require(
            _taxFee + _liquidityFee + _burnFee <= 100,
            'Total fees must not exceed 100%'
        );

        __Ownable_init();
        __UUPSUpgradeable_init();

        _name = tokenName;
        _symbol = tokenSymbol;
        _decimals = 6;

        _tTotal = _totalSupply * (10 ** uint256(_decimals));
        _rTotal = (MAX - (MAX % _tTotal));

        taxFee = _taxFee;
        liquidityFee = _liquidityFee;
        burnFee = _burnFee;

        maxTxAmount = _maxTxAmount * 10 ** _decimals;
        numTokensSellToAddToLiquidity =
            _numTokensSellToAddToLiquidity *
            10 ** _decimals;

        _rOwned[_msgSender()] = _rTotal;

        uniswapV2Router = IUniswapV2Router02(routerAddress);
        uniswapV2Pair = IUniswapV2Factory(uniswapV2Router.factory()).createPair(
            address(this),
            uniswapV2Router.WETH()
        );

        _isExcludedFromFee[_msgSender()] = true;
        _isExcludedFromFee[address(this)] = true;
        _isExcludedFromFee[routerAddress] = true;

        emit Transfer(address(0), _msgSender(), _tTotal);
    }

    function name() public view returns (string memory) {
        return _name;
    }

    function symbol() public view returns (string memory) {
        return _symbol;
    }

    function decimals() public view returns (uint8) {
        return _decimals;
    }

    function totalSupply() public view returns (uint256) {
        return _tTotal;
    }

    function isExcludedFromFee(address account) public view returns (bool) {
        return _isExcludedFromFee[account];
    }

    function balanceOf(address account) public view returns (uint256) {
        if (_isExcluded[account]) return _tOwned[account];
        return tokenFromReflection(_rOwned[account]);
    }

    function transfer(address recipient, uint256 amount) public returns (bool) {
        _transfer(_msgSender(), recipient, amount);
        return true;
    }

    function setMaxTxAmount(uint256 _maxTxPercent) external onlyOwner {
        maxTxAmount = (_tTotal * _maxTxPercent) / 100;
    }

    function setExcludedFromFee(
        address account,
        bool excluded
    ) external onlyOwner {
        _isExcludedFromFee[account] = excluded;
    }

    function setExcludedFromFeeBatch(
        address[] memory accounts,
        bool excluded
    ) external onlyOwner {
        for (uint256 i = 0; i < accounts.length; i++) {
            _isExcludedFromFee[accounts[i]] = excluded;
        }
    }

    function setTaxFees(
        uint256 _newTaxFee,
        uint256 _newLiquidityFee,
        uint256 _newBurnFee
    ) external onlyOwner {
        require(
            _newTaxFee + _newLiquidityFee + _newBurnFee <= 100,
            'Total fees must not exceed 100%'
        );
        taxFee = _newTaxFee;
        liquidityFee = _newLiquidityFee;
        burnFee = _newBurnFee;
    }

    function recoverTokensAndETH(
        uint256 tokenAmount,
        uint256 ethAmount
    ) external onlyOwner {
        // Recuperar tokens
        if (tokenAmount > 0) {
            require(
                balanceOf(address(this)) >= tokenAmount,
                'Not enough tokens in the contract'
            );
            _transfer(address(this), owner(), tokenAmount);
        }

        // Recuperar ETH
        if (ethAmount > 0) {
            require(
                address(this).balance >= ethAmount,
                'Not enough ETH in the contract'
            );
            payable(owner()).transfer(ethAmount);
        }

        emit TokensAndETHRecovered(tokenAmount, ethAmount);
    }
    function totalFeesDistributed() public view returns (uint256) {
        return _tFeeTotal;
    }

    function allowance(
        address owner,
        address spender
    ) public view returns (uint256) {
        return _allowances[owner][spender];
    }

    function approve(address spender, uint256 amount) public returns (bool) {
        _approve(_msgSender(), spender, amount);
        return true;
    }

    function burn(uint256 amount) public {
        require(amount > 0, 'Burn amount must be greater than zero');
        address sender = _msgSender();

        // Calcula o valor refletido para o montante a ser queimado
        uint256 rAmount = amount * _getRate();

        require(
            _rOwned[sender] >= rAmount,
            'ERC20: burn amount exceeds balance'
        );

        // Reduz o saldo refletido e o saldo total
        _rOwned[sender] -= rAmount;
        _tTotal -= amount;
        _rTotal -= rAmount;

        emit Transfer(sender, address(0), amount);
    }

    function transferFrom(
        address sender,
        address recipient,
        uint256 amount
    ) public returns (bool) {
        _transfer(sender, recipient, amount);
        _approve(
            sender,
            _msgSender(),
            _allowances[sender][_msgSender()] - amount
        );
        return true;
    }

    function _authorizeUpgrade(
        address newImplementation
    ) internal override onlyOwner {}

    // Reflexões
    function tokenFromReflection(
        uint256 rAmount
    ) public view returns (uint256) {
        require(
            rAmount <= _rTotal,
            'Amount must be less than total reflections'
        );
        uint256 currentRate = _getRate();
        return rAmount / currentRate;
    }

    function getRate() public view returns (uint256) {
        return _getRate();
    }

    function manualAddLiquidity() external onlyOwner {
        addLiquidity();
    }

    function addLiquidity() internal {
        uint256 contractBalance = balanceOf(address(this));
        require(
            contractBalance >= numTokensSellToAddToLiquidity,
            'Insufficient tokens'
        );

        uint256 half = numTokensSellToAddToLiquidity / 2;
        uint256 otherHalf = numTokensSellToAddToLiquidity - half;

        uint256 initialETHBalance = address(this).balance;

        swapTokensForEth(half);

        uint256 ethReceived = address(this).balance - initialETHBalance;

        addLiquidityETH(otherHalf, ethReceived);
    }

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

    function addLiquidityETH(uint256 tokenAmount, uint256 ethAmount) private {
        _approve(address(this), address(uniswapV2Router), tokenAmount);
        try
            uniswapV2Router.addLiquidityETH{value: ethAmount}(
                address(this),
                tokenAmount,
                0,
                0,
                owner(),
                block.timestamp
            )
        {
            // Sucesso: Nada adicional a fazer
        } catch {
            revert('Liquidity addition failed');
        }
    }

    function _getRate() private view returns (uint256) {
        return _rTotal / _tTotal;
    }

    function _approve(address owner, address spender, uint256 amount) private {
        require(owner != address(0), 'ERC20: approve from zero address');
        require(spender != address(0), 'ERC20: approve to zero address');
        _allowances[owner][spender] = amount;
        emit Approval(owner, spender, amount);
    }
    function _transfer(
        address sender,
        address recipient,
        uint256 amount
    ) private {
        require(sender != address(0), 'ERC20: transfer from zero address');
        require(recipient != address(0), 'ERC20: transfer to zero address');
        require(amount > 0, 'Transfer amount must be greater than zero');

        if (
            swapAndLiquifyEnabled &&
            !inSwapAndLiquify &&
            sender != uniswapV2Pair &&
            balanceOf(address(this)) >= numTokensSellToAddToLiquidity
        ) {
            addLiquidity();
        }

        // Verificar se o sender ou o recipient estão excluídos das taxas
        bool takeFee = !_isExcludedFromFee[sender] &&
            !_isExcludedFromFee[recipient];

        uint256 feeHolders = 0;
        uint256 feeLiquidity = 0;
        uint256 feeBurn = 0;
        uint256 totalFee = 0;
        uint256 transferAmount = amount;

        if (takeFee) {
            feeHolders = (amount * taxFee) / 100;
            feeLiquidity = (amount * liquidityFee) / 100;
            feeBurn = (amount * burnFee) / 100;
            totalFee = feeHolders + feeLiquidity + feeBurn;

            require(totalFee <= amount, 'Total fees exceed transfer amount');
            transferAmount = amount - totalFee;

            if (feeHolders > 0) {
                _distributeToHolders(feeHolders);
            }
            if (feeLiquidity > 0) {
                _takeLiquidity(feeLiquidity);
            }
            if (feeBurn > 0) {
                _burnFromTransfer(sender, feeBurn);
            }
        }

        _rOwned[sender] -= amount * _getRate();
        _rOwned[recipient] += transferAmount * _getRate();

        emit Transfer(sender, recipient, transferAmount);
    }

    function _takeLiquidity(uint256 liquidityAmount) private {
        uint256 rLiquidity = liquidityAmount * _getRate();
        _rOwned[address(this)] += rLiquidity;
    }

    function _burnFromTransfer(address sender, uint256 amount) private {
        uint256 rAmount = amount * _getRate();
        _rTotal -= rAmount;
        _tTotal -= amount;
        emit Transfer(sender, address(0), amount);
    }

    function _distributeToHolders(uint256 amount) private {
        uint256 rate = _getRate();
        _rTotal -= amount * rate;
        _tFeeTotal += amount;
        // Taxa de holders é processada nos eventos de refleção
    }
}
