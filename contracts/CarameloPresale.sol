// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';
import {ReentrancyGuard} from '@openzeppelin/contracts/utils/ReentrancyGuard.sol';

import {
    Phase,
    InsufficientFunds,
    InvalidPhase,
    PreSaleNotActive,
    NoTokensAvailable,
    InvalidTokenAmount,
    PreSaleAlreadyInitialized,
    ZeroAddress,
    WithdrawalFailed,
    MaxTokensBuyExceeded,
    InvalidPhaseRate
} from './utils/CarameloPreSaleErrors.sol';

interface IERC20 {
    function transfer(
        address recipient,
        uint256 amount
    ) external returns (bool);
    function balanceOf(address account) external view returns (uint256);
}

contract CarameloPreSale is Ownable, ReentrancyGuard {
    Phase public currentPhase;
    IERC20 public token;
    uint256 public tokensAvailable;
    uint256 public tokensSold;
    mapping(Phase => uint256) public phaseRates;
    uint256 public totalBNBReceived;
    bool public preSaleInitialized;

    // Whitelist e limites
    mapping(address => bool) public whitelist;
    mapping(address => uint256) public tokensPurchasedByAddress;
    uint256 public maxTokensBuy;

    event PreSaleInitialized(uint256 tokensAvailable);
    event PhaseUpdated(Phase newPhase);
    event TokensPurchased(address indexed buyer, uint256 amount, uint256 cost);
    event PreSaleEnded();
    event FundsWithdrawn(address indexed owner, uint256 amount);
    event AddressWhitelisted(address indexed account);
    event WhitelistUpdated(address indexed account, bool status);
    event MaxTokensBuyUpdated(uint256 newLimit);

    constructor(
        address tokenAddress,
        uint256 ratePhase1,
        uint256 ratePhase2,
        uint256 ratePhase3,
        uint256 _tokensAvailable,
        uint256 _maxTokensBuy
    ) Ownable(msg.sender) {
        if (tokenAddress == address(0)) revert ZeroAddress();

        token = IERC20(tokenAddress);
        phaseRates[Phase.Phase1] = ratePhase1;
        phaseRates[Phase.Phase2] = ratePhase2;
        phaseRates[Phase.Phase3] = ratePhase3;
        tokensAvailable = _tokensAvailable;
        maxTokensBuy = _maxTokensBuy;
        currentPhase = Phase.Phase1;
    }

    modifier onlyActivePreSale() {
        if (currentPhase == Phase.Ended) revert PreSaleNotActive();
        _;
    }

    function initializePreSale() external onlyOwner {
        if (preSaleInitialized)
            revert PreSaleAlreadyInitialized(
                'The presale Already initialized with: ',
                tokensAvailable
            );
        uint256 contractTokenBalance = token.balanceOf(address(this));
        if (contractTokenBalance < tokensAvailable)
            revert InvalidTokenAmount(
                'Invalid token amount: ',
                contractTokenBalance
            );

        preSaleInitialized = true;
        emit PreSaleInitialized(tokensAvailable);
    }

    /**
     * @notice Buy tokens during the active presale phase.
     * @custom:value amount of BNB sent by the user to buy tokens.
     * @dev Calculates the amount of tokens based on the current phase rate and transfers them to the buyer.
     *      Validates the user's BNB balance, current phase, and token limits.
     * @custom:revert InsufficientFunds
     *      - Condition: The user does not have enough BNB to complete the purchase.
     *      - Example: required = 1 BNB, available = 0.5 BNB.
     *
     * @custom:revert InvalidPhase
     *      - Condition: The presale is not in a valid phase for purchasing tokens.
     *      - Example: message = "Presale not active", phase = 0.
     *
     * @custom:revert MaxTokensBuyExceeded
     *      - Condition: The user attempts to purchase more tokens than allowed by the current phase or presale rules.
     *      - Example: allowed = 5000 tokens, attempted = 6000 tokens.
     *
     * @custom:revert NoTokensAvailable
     *      - Condition: The presale contract does not have enough tokens to fulfill the purchase request.
     *      - Example: available = 1000 tokens, requested = 2000 tokens.
     *
     * @custom:revert InvalidTokenAmount
     *      - Condition: The user attempts to buy an invalid amount of tokens (e.g., zero or negative).
     *      - Example: message = "Token amount must be greater than zero", amount = 0.
     */

    function buyTokens() public payable nonReentrant onlyActivePreSale {
        if (msg.value == 0) revert InsufficientFunds(1, msg.value);

        uint256 rate = phaseRates[currentPhase];
        if (rate == 0) {
            revert InvalidPhase('Invalid phase rate for phase: ', currentPhase);
        }

        /// @dev calculate the amount of tokens to transfer
        uint256 tokensToTransfer = (msg.value * rate) / 1 ether;

        if (tokensToTransfer > tokensAvailable) {
            revert NoTokensAvailable(
                'Insufficient tokens available in presale. Available: ',
                tokensAvailable,
                tokensToTransfer
            );
        }

        uint256 maxAllowedTokens = whitelist[msg.sender]
            ? type(uint256).max
            : maxTokensBuy;
        if (
            tokensPurchasedByAddress[msg.sender] + tokensToTransfer >
            maxAllowedTokens
        ) {
            revert MaxTokensBuyExceeded(
                maxAllowedTokens,
                tokensPurchasedByAddress[msg.sender] + tokensToTransfer
            );
        }

        tokensAvailable -= tokensToTransfer;
        tokensSold += tokensToTransfer;
        totalBNBReceived += msg.value;
        tokensPurchasedByAddress[msg.sender] += tokensToTransfer;

        // Transferência dos tokens para o comprador
        if (!token.transfer(msg.sender, tokensToTransfer))
            revert InvalidTokenAmount(
                'Invalid token amount: ',
                tokensToTransfer
            );

        emit TokensPurchased(msg.sender, tokensToTransfer, msg.value);
    }

    /**
     * @notice Update the current phase of the presale.
     * @param newPhase The new phase to set.
     * @custom:example example
     * - Phase1: 0
     * - Phase2: 1
     * - Phase3: 2
     * - Ended: 3
     */
    function updatePhase(Phase newPhase) external onlyOwner onlyActivePreSale {
        if (newPhase <= currentPhase || newPhase == Phase.Ended)
            revert InvalidPhase('Invalid phase: ', newPhase);
        currentPhase = newPhase;

        emit PhaseUpdated(newPhase);
    }

    /**
     * @notice Update the rate for a specific phase.
     * @param phase The phase to update the rate for.
     * @param newRate The new rate to set.
     * @custom:example example
     * - Phase1: 0 | 1000 tokens per BNB
     * - Phase2: 1 | 2000 tokens per BNB
     * - Phase3: 2 | 3000 tokens per BNB
     */

    function updatePhaseRate(Phase phase, uint256 newRate) external onlyOwner {
        if (newRate == 0) {
            revert InvalidPhaseRate('Invalid phase rate: ', newRate);
        }
        phaseRates[phase] = newRate;
    }

    /**
     * @notice End the presale.
     */
    function endPreSale() external onlyOwner onlyActivePreSale {
        currentPhase = Phase.Ended;
        emit PreSaleEnded();
    }

    /**
     * @notice Withdraw funds from the presale.
     */
    function withdrawFunds() external nonReentrant onlyOwner {
        uint256 balance = address(this).balance;
        if (balance == 0) revert InsufficientFunds(1, balance);

        (bool success, ) = payable(owner()).call{value: balance}('');
        if (!success) revert WithdrawalFailed();

        emit FundsWithdrawn(owner(), balance);
    }

    /**
     * @notice Get the remaining tokens available in the presale.
     * @return tokensRemaining The remaining tokens available.
     */
    function tokensRemaining() external view returns (uint256) {
        return tokensAvailable;
    }

    /**
     * @notice Add an address to the whitelist.
     * @param account The address to add to the whitelist.
     */
    function addToWhitelist(address account) external onlyOwner {
        whitelist[account] = true;
        emit AddressWhitelisted(account);
    }

    /**
     * @notice Add multiple addresses to the whitelist in a single transaction
     * @param accounts Array of addresses to add to the whitelist
     * @dev Uses unchecked to save gas on incrementing i
     * @dev Emits AddressWhitelisted event for each address
     */
    function addMultipleToWhitelist(
        address[] calldata accounts
    ) external onlyOwner {
        uint256 length = accounts.length;
  
        unchecked {
            for (uint256 i; i < length; ++i) {
                address account = accounts[i];
                if (account == address(0)) revert ZeroAddress();
                if (!whitelist[account]) {
                    /// @dev Check to avoid duplicate events
                    whitelist[account] = true;
                    emit AddressWhitelisted(account);
                }
            }
        }
    }

    /**
     * @notice Remove an address from the whitelist.
     * @param account The address to remove from the whitelist.
     */
    function removeFromWhitelist(address account) external onlyOwner {
        whitelist[account] = false;
        emit WhitelistUpdated(account, false);
    }

    /**
     * @notice Update the maximum number of tokens a user can buy.
     * @param newLimit The new limit to set.
     */
    function updateMaxTokensBuy(uint256 newLimit) external onlyOwner {
        maxTokensBuy = newLimit;
        emit MaxTokensBuyUpdated(newLimit);
    }

    /**
     * @notice Receive BNB from the user.
     */
    receive() external payable {
        buyTokens();
    }
}
