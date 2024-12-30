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


// File contracts/utils/CarameloPreSaleErrors.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.22;

/// @dev Enum for the presale phases
enum Phase {
    Phase1, // 0 -> 100,000 tokens por BNB
    Phase2, // 1 -> 200,000 tokens por BNB
    Phase3, // 2 -> 300,000 tokens por BNB
    Ended // 3 -> ended 
}
/// @dev Custom errors for the presale contract
error InsufficientFunds(uint256 required, uint256 available);
error InvalidPhase(string message, Phase phase);
error PreSaleNotActive();
error NoTokensAvailable(string message, uint256 available, uint256 requested);
error InvalidTokenAmount(string message, uint256 amount);
error PreSaleAlreadyInitialized(string message, uint256 tokensAvailable);
error ZeroAddress();
error WithdrawalFailed();
error MaxTokensBuyExceeded(uint256 allowed, uint256 attempted);
error InvalidPhaseRate(string message, uint256 rate);


// File contracts/CarameloPreSale.sol

// Original license: SPDX_License_Identifier: MIT
pragma solidity ^0.8.22;


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
     * @notice Withdraw unsold tokens after the presale has ended.
     * @dev Transfers the remaining tokens to the owner's address.
     */
    function withdrawUnsoldTokens() external onlyOwner {
        if (currentPhase != Phase.Ended) {
            revert PreSaleNotActive();
        }

        uint256 remainingTokens = tokensAvailable;
        if (remainingTokens > 0) {
            tokensAvailable = 0; 
            if (!token.transfer(owner(), remainingTokens)) {
                revert WithdrawalFailed();
            }
        }
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
