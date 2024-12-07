// SPDX-License-Identifier: MIT
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
