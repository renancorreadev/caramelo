// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Ownable} from "@openzeppelin/contracts/access/Ownable.sol";
import {ReentrancyGuard} from "@openzeppelin/contracts/utils/ReentrancyGuard.sol";

error InsufficientFunds(uint256 required, uint256 available);
error InvalidPhase();
error PreSaleNotActive();
error NoTokensAvailable();
error InvalidTokenAmount();
error PreSaleAlreadyInitialized();
error ZeroAddress();
error WithdrawalFailed();

interface IERC20 {
    function transfer(address recipient, uint256 amount) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract CarameloPreSale is Ownable, ReentrancyGuard {
    /// @dev Phases of Pre Sale
    enum Phase { Phase1, Phase2, Phase3, Ended }

    Phase public currentPhase;
    IERC20 public token;
    uint256 public tokensAvailable;
    uint256 public tokensSold;

    /// @dev // 1 BNB = X tokens por fase
    mapping(Phase => uint256) public phaseRates; 
    uint256 public totalBNBReceived;

    bool public preSaleInitialized;

    event PreSaleInitialized(uint256 tokensAvailable);
    event PhaseUpdated(Phase newPhase);
    event TokensPurchased(address indexed buyer, uint256 amount, uint256 cost);
    event PreSaleEnded();
    event FundsWithdrawn(address indexed owner, uint256 amount);

    // MaxTxLimit = 100 000 tokens 

    // permitir lista de enderecos para comprar mais que MaxTxLimit
    constructor(
        address tokenAddress,
        uint256 ratePhase1,
        uint256 ratePhase2,
        uint256 ratePhase3,
        uint256 _tokensAvailable
    ) Ownable(msg.sender) {
        if (tokenAddress == address(0)) revert ZeroAddress();

        token = IERC20(tokenAddress);
        phaseRates[Phase.Phase1] = ratePhase1;
        phaseRates[Phase.Phase2] = ratePhase2;
        phaseRates[Phase.Phase3] = ratePhase3;
        tokensAvailable = _tokensAvailable;
        currentPhase = Phase.Phase1;
    }

    modifier onlyActivePreSale() {
        if (currentPhase == Phase.Ended) revert PreSaleNotActive();
        _;
    }

    function initializePreSale() external onlyOwner {
        if (preSaleInitialized) revert PreSaleAlreadyInitialized();
        uint256 contractTokenBalance = token.balanceOf(address(this));
        if (contractTokenBalance < tokensAvailable) revert InvalidTokenAmount();

        preSaleInitialized = true;
        emit PreSaleInitialized(tokensAvailable);
    }

    function buyTokens() public payable nonReentrant onlyActivePreSale {
        if (msg.value == 0) revert InsufficientFunds(1, msg.value);

        uint256 rate = phaseRates[currentPhase];
        if (rate == 0) revert InvalidPhase();

        // Calcula a quantidade de tokens a ser transferida, considerando os decimais
        uint256 tokensToTransfer = (msg.value * rate) / 1 ether;

        if (tokensToTransfer > tokensAvailable) revert NoTokensAvailable();

        tokensAvailable -= tokensToTransfer;
        tokensSold += tokensToTransfer;
        totalBNBReceived += msg.value;

        // Transferência dos tokens para o comprador
        if (!token.transfer(msg.sender, tokensToTransfer)) revert InvalidTokenAmount();

        emit TokensPurchased(msg.sender, tokensToTransfer, msg.value);
    }

    function updatePhase(Phase newPhase) external onlyOwner onlyActivePreSale {
        if (newPhase <= currentPhase || newPhase == Phase.Ended) revert InvalidPhase();
        currentPhase = newPhase;

        emit PhaseUpdated(newPhase);
    }

    function endPreSale() external onlyOwner onlyActivePreSale {
        currentPhase = Phase.Ended;
        emit PreSaleEnded();
    }

    function withdrawFunds() external nonReentrant onlyOwner {
        uint256 balance = address(this).balance;
        if (balance == 0) revert InsufficientFunds(1, balance);

        (bool success, ) = payable(owner()).call{value: balance}("");
        if (!success) revert WithdrawalFailed();

        emit FundsWithdrawn(owner(), balance);
    }

    function tokensRemaining() external view returns (uint256) {
        return tokensAvailable;
    }

   
    receive() external payable {
        buyTokens();
    }
}


