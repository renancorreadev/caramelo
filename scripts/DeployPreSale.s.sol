// SPDX-License-Identifier: MIT
pragma solidity ^0.8.22;

import {Script} from "forge-std/Script.sol";
import {Token} from "../contracts/Token.sol";
import {CarameloPreSale} from "../contracts/CarameloPreSale.sol";
import {console} from "forge-std/console.sol";

contract DeployPreSale is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);
        // Deploy PreSale contract
        uint256 totalSupply = 1_000_000_000_000_000; // 1 trilhão de tokens
        uint256 ratePhase1 = 1000; // 1 BNB = 1000 tokens in Phase 1
        uint256 ratePhase2 = 800;  // 1 BNB = 800 tokens in Phase 2
        uint256 ratePhase3 = 600;  // 1 BNB = 600 tokens in Phase 3
        uint256 tokensForPreSale = totalSupply * 30 / 100; // 30% of total supply for presale
        address carameloAddress = address(0x367e257B64457B0C558735766f42f17B110D7709);

        CarameloPreSale preSale = new CarameloPreSale(
            carameloAddress,
            ratePhase1,
            ratePhase2,
            ratePhase3,
            tokensForPreSale
        );

        console.log("PreSale deployed at:", address(preSale));
        vm.stopBroadcast();
    }
}
