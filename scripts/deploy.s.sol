// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Script} from "forge-std/Script.sol";
import {Token} from "../contracts/Token.sol";
import {console} from 'forge-std/console.sol';

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
        Token caramelo = new Token();

        caramelo.initialize(
            tokenName,
            tokenSymbol,
            totalSupply,
            taxFee,
            liquidityFee,
            burnFee,
            maxTxAmount,
            numTokensSellToAddToLiquidity
        );

        console.log("Token deployed at:", address(caramelo));

        vm.stopBroadcast();
    }
}


/** 
forge verify-contract --chain-id 97 --watch \
--compiler-version "v0.8.2+commit.661d1103" \
0xb60CDB1Cba0245B9db7188F0CEe4979EB8a52fe7 contracts/Token.sol:Token

 */