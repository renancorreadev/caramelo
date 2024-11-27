// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Script} from "forge-std/Script.sol";
import {Token} from "../src/Token.sol";

contract DeployCaramelo is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerPrivateKey);

        // Parâmetros de inicialização
        string memory tokenName = "Caramelo";
        string memory tokenSymbol = "CAR";
        uint256 totalSupply = 1_000_000_000_000_000; // 1 trilhão de tokens
        uint256 taxFee = 5;
        uint256 liquidityFee = 5;
        uint256 burnFee = 3;
        uint256 maxTxAmount = 10000; // Ajuste o limite
        uint256 numTokensSellToAddToLiquidity = 5000; // Ajuste conforme necessário

        // Deploy do contrato
        CarameloV2 caramelo = new CarameloV2();
        caramelo.initialize(
            tokenName,
            tokenSymbol,
            totalSupply,
            taxFee,
            liquidityFee,
            burnFee,
            maxTxAmount,
            numTokensSellToAddToLiquidity,
        );

        console.log("Token deployed at:", address(caramelo));

        vm.stopBroadcast();
    }
}
