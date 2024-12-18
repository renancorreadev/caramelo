// SPDX-License-Identifier: MIT
pragma solidity ^0.8.2;

import {Script} from "forge-std/Script.sol";
import {Caramelo} from "../contracts/Caramelo.sol";
import {CarameloPreSale} from "../contracts/CarameloPreSale.sol";
import {console} from 'forge-std/console.sol';

contract Deploy is Script {
    function run() external {
        uint256 deployerPrivateKey = vm.envUint("PRIVATE_KEY");
        address PRESALE_WALLET = 0xf39Fd6e51aad88F6F4ce6aB8827279cffFb92266;
        address DEV_WALLET = 0x05b0cF5Efa12dc9bd83558b4787120a9297D9246;
        address COMMUNITY_WALLET = 0x770A14689463D15e7f2f28c581CC61FAf076E35c;
    


        vm.startBroadcast(deployerPrivateKey);
        // Parâmetros de inicialização
        string memory tokenName = "Caramelo";
        string memory tokenSymbol = "CAR";
        uint256 totalSupply = 1_000_000_000_000_000; // 1 trilhão de tokens
        uint8 tokenDecimals = 6;
        uint256 taxFee = 5; // 5%
        uint256 liquidityFee = 5; // 5%
        uint256 maxTxAmount = 50_000_000_000_000; // 50 bilhões de tokens 5% do totalSupply
        uint256 numTokensSellToAddToLiquidity =200_000_000_000_000; // 20% do totalSupply - 200 bilhões de tokens

        Caramelo caramelo = new Caramelo(
          tokenName,
          tokenSymbol,
          totalSupply,
          tokenDecimals,
          taxFee,
          liquidityFee,
          maxTxAmount,
          numTokensSellToAddToLiquidity
        );


        // PreSale
        uint256 ratePhase1 = 100_000_000 * 10 ** 6; // 1 BNB = 60,000 tokens
        uint256 ratePhase2 = 60_000_000 * 10 ** 6; // 1 BNB = 60,000 tokens
        uint256 ratePhase3 = 50_000_000 * 10 ** 6; // 1 BNB = 50,000 tokens;
        uint256 _tokensAvailable = 84_000_000_000 * 10 ** 6; // 20% of total supply;
        uint256 _maxTokensBuy = 4_200_000_000 * 10 ** 6; // 5% of 84,000,000,000;

        CarameloPreSale carameloPreSale = new CarameloPreSale(
          address(caramelo),
          ratePhase1,
          ratePhase2,
          ratePhase3,
          _tokensAvailable,
          _maxTokensBuy
        );
        
        console.log("Caramelo deployed at:", address(caramelo));
        console.log("PreSale deployed at:", address(carameloPreSale));


        console.log("1. Excluindo contrato carameloPreSale das taxas");
        caramelo.excludeFromFee(address(carameloPreSale));

        
        console.log("3. Transferindo tokens para pre sale contract");
        uint256 tokensAvailable = carameloPreSale.tokensAvailable();
        caramelo.transfer(address(carameloPreSale), tokensAvailable);


        console.log("4. Inicializando pre-venda");
        carameloPreSale.initializePreSale();


        console.log("5. Adicionando enderecos a whitelist");
        address[] memory whitelist = new address[](2);
        whitelist[0] = DEV_WALLET;
        whitelist[1] = COMMUNITY_WALLET;
        carameloPreSale.addMultipleToWhitelist(whitelist);

        vm.stopBroadcast();
    }
}


/** 
forge verify-contract --chain-id 97 --watch \
--compiler-version "v0.8.2+commit.661d1103" \
0xb60CDB1Cba0245B9db7188F0CEe4979EB8a52fe7 contracts/Token.sol:Token

 */