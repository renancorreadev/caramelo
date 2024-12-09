# Solidity API

## InsufficientFunds

```solidity
error InsufficientFunds(uint256 required, uint256 available)
```

## InvalidPhase

```solidity
error InvalidPhase()
```

## PreSaleNotActive

```solidity
error PreSaleNotActive()
```

## NoTokensAvailable

```solidity
error NoTokensAvailable()
```

## InvalidTokenAmount

```solidity
error InvalidTokenAmount()
```

## PreSaleAlreadyInitialized

```solidity
error PreSaleAlreadyInitialized()
```

## ZeroAddress

```solidity
error ZeroAddress()
```

## WithdrawalFailed

```solidity
error WithdrawalFailed()
```

## IERC20

### transfer

```solidity
function transfer(address recipient, uint256 amount) external returns (bool)
```

### balanceOf

```solidity
function balanceOf(address account) external view returns (uint256)
```

## CarameloPreSale

### Phase

_Phases of Pre Sale_

```solidity
enum Phase {
  Phase1,
  Phase2,
  Phase3,
  Ended
}
```

### currentPhase

```solidity
enum CarameloPreSale.Phase currentPhase
```

### token

```solidity
contract IERC20 token
```

### tokensAvailable

```solidity
uint256 tokensAvailable
```

### tokensSold

```solidity
uint256 tokensSold
```

### phaseRates

```solidity
mapping(enum CarameloPreSale.Phase => uint256) phaseRates
```

_// 1 BNB = X tokens por fase_

### totalBNBReceived

```solidity
uint256 totalBNBReceived
```

### preSaleInitialized

```solidity
bool preSaleInitialized
```

### PreSaleInitialized

```solidity
event PreSaleInitialized(uint256 tokensAvailable)
```

### PhaseUpdated

```solidity
event PhaseUpdated(enum CarameloPreSale.Phase newPhase)
```

### TokensPurchased

```solidity
event TokensPurchased(address buyer, uint256 amount, uint256 cost)
```

### PreSaleEnded

```solidity
event PreSaleEnded()
```

### FundsWithdrawn

```solidity
event FundsWithdrawn(address owner, uint256 amount)
```

### constructor

```solidity
constructor(address tokenAddress, uint256 ratePhase1, uint256 ratePhase2, uint256 ratePhase3, uint256 _tokensAvailable) public
```

### onlyActivePreSale

```solidity
modifier onlyActivePreSale()
```

### initializePreSale

```solidity
function initializePreSale() external
```

### buyTokens

```solidity
function buyTokens() public payable
```

### updatePhase

```solidity
function updatePhase(enum CarameloPreSale.Phase newPhase) external
```

### endPreSale

```solidity
function endPreSale() external
```

### withdrawFunds

```solidity
function withdrawFunds() external
```

### tokensRemaining

```solidity
function tokensRemaining() external view returns (uint256)
```

### receive

```solidity
receive() external payable
```

## IUniswapV2Router02

### factory

```solidity
function factory() external pure returns (address)
```

### WETH

```solidity
function WETH() external pure returns (address)
```

### addLiquidityETH

```solidity
function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity)
```

### swapExactTokensForETHSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external
```

## IUniswapV2Factory

### createPair

```solidity
function createPair(address tokenA, address tokenB) external returns (address pair)
```

## AlreadyInitialized

```solidity
error AlreadyInitialized()
```

## ZeroAddress

```solidity
error ZeroAddress()
```

## InvalidAmount

```solidity
error InvalidAmount()
```

## AlreadyExcluded

```solidity
error AlreadyExcluded()
```

## NotExcluded

```solidity
error NotExcluded()
```

## FeesExceeded

```solidity
error FeesExceeded(uint256 totalFees)
```

## ContractLocked

```solidity
error ContractLocked()
```

## SwapProtocolAlreadyConfigured

```solidity
error SwapProtocolAlreadyConfigured()
```

## MaxTransactionExceeded

```solidity
error MaxTransactionExceeded(uint256 maxTxAmount, uint256 attemptedAmount)
```

## InsufficientBalance

```solidity
error InsufficientBalance(uint256 available, uint256 required)
```

## InvalidTaxFee

```solidity
error InvalidTaxFee()
```

## InvalidLiquidityFee

```solidity
error InvalidLiquidityFee()
```

## InvalidBurnFee

```solidity
error InvalidBurnFee()
```

## ApprovalFailed

```solidity
error ApprovalFailed(address owner, address spender, uint256 amount)
```

## NumTokensSellToAddToLiquidityFailed

```solidity
error NumTokensSellToAddToLiquidityFailed(uint256 currentAmount, uint256 newAmount)
```

## UpgradesAreFrozen

```solidity
error UpgradesAreFrozen()
```

## InvalidImplementation

```solidity
error InvalidImplementation()
```

## TokenBalanceZero

```solidity
error TokenBalanceZero()
```

## LiquidityAdditionFailed

```solidity
error LiquidityAdditionFailed()
```

## TransferAmountZero

```solidity
error TransferAmountZero()
```

## TransferAmountExceedsMax

```solidity
error TransferAmountExceedsMax()
```

## Token

### taxFee

```solidity
uint256 taxFee
```

### liquidityFee

```solidity
uint256 liquidityFee
```

### burnFee

```solidity
uint256 burnFee
```

### maxTxAmount

```solidity
uint256 maxTxAmount
```

### numTokensSellToAddToLiquidity

```solidity
uint256 numTokensSellToAddToLiquidity
```

### swapAndLiquifyEnabled

```solidity
bool swapAndLiquifyEnabled
```

### uniswapV2Router

```solidity
contract IUniswapV2Router02 uniswapV2Router
```

### uniswapV2Pair

```solidity
address uniswapV2Pair
```

### contractVersion

```solidity
string contractVersion
```

### Transfer

```solidity
event Transfer(address from, address to, uint256 value)
```

### Approval

```solidity
event Approval(address owner, address spender, uint256 value)
```

### TokensBurned

```solidity
event TokensBurned(address burner, uint256 burnAmount)
```

### FeesDistributed

```solidity
event FeesDistributed(uint256 reflectionFee, uint256 liquidityFee, uint256 burnFee)
```

### SwapAndLiquify

```solidity
event SwapAndLiquify(uint256 tokensSwapped, uint256 ethReceived, uint256 tokensAddedToLiquidity)
```

### UniswapConfigured

```solidity
event UniswapConfigured(address router, address pair)
```

### ExcludedFromFee

```solidity
event ExcludedFromFee(address account)
```

### SwapAndLiquifyEnabledUpdated

```solidity
event SwapAndLiquifyEnabledUpdated(bool enabled)
```

### FeesUpdated

```solidity
event FeesUpdated(uint256 _taxFee, uint256 _liquidityFee, uint256 _burnFee)
```

### MaxTxAmountUpdated

```solidity
event MaxTxAmountUpdated(uint256 newMaxTxAmount)
```

### NumTokensSellToAddToLiquidityUpdated

```solidity
event NumTokensSellToAddToLiquidityUpdated(uint256 newNumTokensSellToAddToLiquidity)
```

### UniswapV2RouterUpdated

```solidity
event UniswapV2RouterUpdated(address newRouter)
```

### IncludedInFee

```solidity
event IncludedInFee(address account)
```

### LiquidityAdded

```solidity
event LiquidityAdded(uint256 tokenAmount, uint256 ethAmount, uint256 liquidity)
```

### lockTheSwap

```solidity
modifier lockTheSwap()
```

### constructor

```solidity
constructor() public
```

### initialize

```solidity
function initialize(string tokenName, string tokenSymbol, uint256 _totalSupply, uint8 _token_decimals, uint256 _taxFee, uint256 _liquidityFee, uint256 _burnFee, uint256 _maxTokensTXAmount, uint256 _numTokensSellToAddToLiquidity, string version) public
```

### name

```solidity
function name() public view returns (string)
```

### symbol

```solidity
function symbol() public view returns (string)
```

### reflectionBalanceOf

```solidity
function reflectionBalanceOf(address account) public view returns (uint256)
```

### decimals

```solidity
function decimals() public view returns (uint8)
```

### allowance

```solidity
function allowance(address owner, address spender) public view returns (uint256)
```

### totalSupply

```solidity
function totalSupply() public view returns (uint256)
```

### balanceOf

```solidity
function balanceOf(address account) public view returns (uint256)
```

### freezeUpgrades

```solidity
function freezeUpgrades() external
```

### transfer

```solidity
function transfer(address recipient, uint256 amount) public returns (bool)
```

### transferFrom

```solidity
function transferFrom(address sender, address recipient, uint256 amount) public returns (bool)
```

### setMaxTxAmount

```solidity
function setMaxTxAmount(uint256 newMaxTxAmount) external
```

### updateUniswapV2Router

```solidity
function updateUniswapV2Router(address newRouter) external
```

### setNumTokensSellToAddToLiquidity

```solidity
function setNumTokensSellToAddToLiquidity(uint256 newNumTokensSellToAddToLiquidity) external
```

### isAccountExcludedFromFree

```solidity
function isAccountExcludedFromFree(address account) public view returns (bool)
```

### includeInFee

```solidity
function includeInFee(address account) external
```

### excludeFromFee

```solidity
function excludeFromFee(address account) external
```

### setFees

```solidity
function setFees(uint256 _taxFee, uint256 _liquidityFee, uint256 _burnFee) external
```

### approve

```solidity
function approve(address spender, uint256 amount) public returns (bool)
```

### configureSwapProtocol

```solidity
function configureSwapProtocol(address routerAddress) external
```

### isSwapAndLiquifyEnabled

```solidity
function isSwapAndLiquifyEnabled() external view returns (bool)
```

### setSwapAndLiquifyEnabled

```solidity
function setSwapAndLiquifyEnabled(bool _enabled) external
```

### getImplementation

```solidity
function getImplementation() external view returns (address)
```

### _authorizeUpgrade

```solidity
function _authorizeUpgrade(address newImplementation) internal view
```

_Function that should revert when `msg.sender` is not authorized to upgrade the contract. Called by
{upgradeTo} and {upgradeToAndCall}.

Normally, this function will use an xref:access.adoc[access control] modifier such as {Ownable-onlyOwner}.

```solidity
function _authorizeUpgrade(address) internal override onlyOwner {}
```_

### receive

```solidity
receive() external payable
```

## IUniswapV2Router02

### WETH

```solidity
function WETH() external pure returns (address)
```

### factory

```solidity
function factory() external pure returns (address)
```

### swapExactTokensForETHSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForETHSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external
```

### swapExactTokensForTokens

```solidity
function swapExactTokensForTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapTokensForExactTokens

```solidity
function swapTokensForExactTokens(uint256 amountOut, uint256 amountInMax, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapExactTokensForTokensSupportingFeeOnTransferTokens

```solidity
function swapExactTokensForTokensSupportingFeeOnTransferTokens(uint256 amountIn, uint256 amountOutMin, address[] path, address to, uint256 deadline) external
```

### swapTokensForExactETH

```solidity
function swapTokensForExactETH(uint256 amountOut, uint256 amountInMax, address[] path, address to, uint256 deadline) external returns (uint256[] amounts)
```

### swapExactETHForTokens

```solidity
function swapExactETHForTokens(uint256 amountOutMin, address[] path, address to, uint256 deadline) external payable returns (uint256[] amounts)
```

### swapETHForExactTokens

```solidity
function swapETHForExactTokens(uint256 amountOut, address[] path, address to, uint256 deadline) external payable returns (uint256[] amounts)
```

### swapExactETHForTokensSupportingFeeOnTransferTokens

```solidity
function swapExactETHForTokensSupportingFeeOnTransferTokens(uint256 amountOutMin, address[] path, address to, uint256 deadline) external payable
```

### addLiquidity

```solidity
function addLiquidity(address tokenA, address tokenB, uint256 amountADesired, uint256 amountBDesired, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB, uint256 liquidity)
```

### addLiquidityETH

```solidity
function addLiquidityETH(address token, uint256 amountTokenDesired, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external payable returns (uint256 amountToken, uint256 amountETH, uint256 liquidity)
```

### removeLiquidity

```solidity
function removeLiquidity(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline) external returns (uint256 amountA, uint256 amountB)
```

### removeLiquidityETH

```solidity
function removeLiquidityETH(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountToken, uint256 amountETH)
```

### removeLiquidityWithPermit

```solidity
function removeLiquidityWithPermit(address tokenA, address tokenB, uint256 liquidity, uint256 amountAMin, uint256 amountBMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountA, uint256 amountB)
```

### removeLiquidityETHWithPermit

```solidity
function removeLiquidityETHWithPermit(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountToken, uint256 amountETH)
```

### removeLiquidityETHSupportingFeeOnTransferTokens

```solidity
function removeLiquidityETHSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline) external returns (uint256 amountETH)
```

### removeLiquidityETHWithPermitSupportingFeeOnTransferTokens

```solidity
function removeLiquidityETHWithPermitSupportingFeeOnTransferTokens(address token, uint256 liquidity, uint256 amountTokenMin, uint256 amountETHMin, address to, uint256 deadline, bool approveMax, uint8 v, bytes32 r, bytes32 s) external returns (uint256 amountETH)
```

### quote

```solidity
function quote(uint256 amountA, uint256 reserveA, uint256 reserveB) external pure returns (uint256 amountB)
```

### getAmountOut

```solidity
function getAmountOut(uint256 amountIn, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountOut)
```

### getAmountIn

```solidity
function getAmountIn(uint256 amountOut, uint256 reserveIn, uint256 reserveOut) external pure returns (uint256 amountIn)
```

### getAmountsOut

```solidity
function getAmountsOut(uint256 amountIn, address[] path) external view returns (uint256[] amounts)
```

### getAmountsIn

```solidity
function getAmountsIn(uint256 amountOut, address[] path) external view returns (uint256[] amounts)
```

## IUniswapV2Factory

### createPair

```solidity
function createPair(address tokenA, address tokenB) external returns (address pair)
```

### getPair

```solidity
function getPair(address tokenA, address tokenB) external view returns (address pair)
```

### allPairs

```solidity
function allPairs(uint256) external view returns (address pair)
```

### allPairsLength

```solidity
function allPairsLength() external view returns (uint256)
```

### feeTo

```solidity
function feeTo() external view returns (address)
```

### feeToSetter

```solidity
function feeToSetter() external view returns (address)
```

### setFeeTo

```solidity
function setFeeTo(address) external
```

### setFeeToSetter

```solidity
function setFeeToSetter(address) external
```

