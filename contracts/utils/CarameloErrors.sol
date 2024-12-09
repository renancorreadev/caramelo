// SPDX-License-Identifier: MIT
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