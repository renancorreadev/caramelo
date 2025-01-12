// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from 'forge-std/Test.sol';
import {console} from 'forge-std/console.sol';
import {Caramelo} from '../contracts/Caramelo.sol';
import {CarameloPreSale} from '../contracts/CarameloPreSale.sol';
import {Phase, InsufficientFunds, InvalidPhase, PreSaleNotActive, NoTokensAvailable, InvalidTokenAmount, PreSaleAlreadyInitialized, ZeroAddress, WithdrawalFailed, MaxTokensBuyExceeded, InvalidPhaseRate} from '../contracts/utils/CarameloPreSaleErrors.sol';

/**
 * @dev This contract is a test suite for the CarameloPreSale contract.
 * It includes tests for the initialization, participation, and finalization of the presale.
 */
contract RejectEther {
    fallback() external payable {
        revert('Rejecting ether');
    }

    receive() external payable {
        revert('Rejecting ether');
    }
}

contract CarameloPreSaleTest is Test {
    Caramelo public carameloContract;
    CarameloPreSale public carameloPreSale;

    address public owner;
    uint256 private ownerPrivateKey;

    address public userA;
    uint256 private userAPrivateKey;

    address public userB;
    uint256 private userBPrivateKey;

    address public presaleWallet;
    uint256 private presaleWalletPrivateKey;

    // ------------------------------------------------------------------------
    /** @dev Caramelo Constructor parameters */
    struct TokenParams {
        string name;
        string symbol;
        uint256 initialSupply;
        uint8 decimals;
        uint256 taxFee;
        uint256 liquidityFee;
        uint256 maxTokensTXAmount;
        uint256 numTokensSellToAddToLiquidity;
    }

    /** @dev PreSale Constructor parameters */
    struct PreSaleParams {
        uint256 ratePhase1;
        uint256 ratePhase2;
        uint256 ratePhase3;
        uint256 tokensAvailable;
        uint256 maxTokensBuy;
    }

    /** @dev Token parameters */
    TokenParams public tokenParams =
        TokenParams({
            name: 'Caramelo Coin',
            symbol: 'CARAMELO',
            initialSupply: 420_000_000_000_000_000, // 420,000,000
            decimals: 9,
            taxFee: 5000, // 5%
            liquidityFee: 5000, // 5%
            maxTokensTXAmount: 84_000_000_000_000_000, // 20% de 420_000_000_000_000_000
            numTokensSellToAddToLiquidity: 4200000000000000 // 5% de 84_000_000_000_000_000
        });

    /** @dev PreSale parameters */
    PreSaleParams public preSaleParams =
        PreSaleParams({
            ratePhase1: 5250000000000000000000, // 1 BNB = 5,250,000 tokens
            ratePhase2: 4000000000000000000000, // 1 BNB = 4,000,000 tokens
            ratePhase3: 3000000000000000000000, // 1 BNB = 3,000,000 tokens
            tokensAvailable: 42000000000000000000000000, // 42,000,000 tokens
            maxTokensBuy: 1050000000000000000000 // 200 BNB 
        });

    // ------------------------------------------------------------------------

    /** @dev Setup function */
    function setUp() public {
        /*
         * @dev Create a fork of the BSC network
         */
        vm.createSelectFork('https://bsc-dataseed.binance.org/');

        /// @dev makes an address and a private key
        (owner, ownerPrivateKey) = makeAddrAndKey('owner');
        (userA, userAPrivateKey) = makeAddrAndKey('userA');
        (userB, userBPrivateKey) = makeAddrAndKey('userB');
        (presaleWallet, presaleWalletPrivateKey) = makeAddrAndKey(
            'presaleWallet'
        );

        /// @dev starts the prank of the owner
        vm.startPrank(owner);
        carameloContract = new Caramelo(
            tokenParams.name,
            tokenParams.symbol,
            tokenParams.initialSupply,
            tokenParams.decimals,
            tokenParams.taxFee,
            tokenParams.liquidityFee,
            tokenParams.maxTokensTXAmount,
            tokenParams.numTokensSellToAddToLiquidity
        );
        vm.stopPrank();

        /// @dev starts the prank of the owner
        vm.startPrank(owner);
        carameloPreSale = new CarameloPreSale(
            address(carameloContract),
            preSaleParams.ratePhase1,
            preSaleParams.ratePhase2,
            preSaleParams.ratePhase3,
            preSaleParams.tokensAvailable,
            preSaleParams.maxTokensBuy
        );

        // carameloContract.initializeTokenomics();
        /// @dev Exclude the pre-sale from the fees before transferring the tokens
        carameloContract.excludeFromFee(address(carameloPreSale));
        carameloContract.excludeFromFee(presaleWallet);

        /// @dev Transfer the tokens to the pre-sale contract
        carameloContract.transfer(
            address(carameloPreSale),
            preSaleParams.tokensAvailable
        );
        console.log(
            'Tokens transferidos para o contrato de pre-venda:',
            carameloContract.balanceOf(address(carameloPreSale))
        );

        carameloPreSale.initializePreSale();
        assertEq(
            uint256(carameloPreSale.currentPhase()),
            uint256(Phase.Phase1),
            'A fase da pre-venda deve ser a fase 1'
        );

        Phase phase = carameloPreSale.currentPhase(); // Phase 0 = 1
        console.log('Fase da pre-venda: ', uint256(phase));

        // Fix the rate of the pre-sale
        carameloPreSale.updateMaxTokensBuy(5250000000000000000000);

        carameloPreSale.addToWhitelist(userA);

        vm.stopPrank();
    }

    function testBuy() external {
        vm.deal(userA, 1 ether);
        vm.startPrank(userA);
        carameloPreSale.buyTokens{value: 1 ether}();

        uint256 tokensTransferido = carameloContract.balanceOf(userA);

        console.log('Tokens transferidos para o user A: ', tokensTransferido);
        vm.stopPrank();
    }

    function testBuyAllTokensInFirstPhase() external {
        uint256 tokensPerBNB = preSaleParams.ratePhase1; // 5,250,000,000,000,000,000,000 tokens por BNB
        uint256 totalTokens = preSaleParams.tokensAvailable; // 42,000,000,000,000,000,000,000,000 tokens disponiveis
        uint256 maxTokensBuy = preSaleParams.maxTokensBuy; // Limite de tokens por transacao

        uint256 bnbRequired = totalTokens / tokensPerBNB; // Total de BNB necessario
        console.log(
            'BNB necessario para comprar todos os tokens: ',
            bnbRequired
        );
        uint256 remainingTokens = totalTokens;

        // Inicializando a quantidade de BNB na conta do usuario
        vm.deal(userA, bnbRequired * 1 ether); // Adiciona 8000 BNB para a conta do userA

        uint256 totalTokensBought = 0;
        uint256 transactionsCount = 0; // Variavel para contar as transacoes

        vm.startPrank(userA); // Inicia o "prank" do usuario

        while (remainingTokens > 0) {
            // Calcula os tokens a serem comprados sem ultrapassar o limite
            uint256 tokensToBuy = remainingTokens >= maxTokensBuy ? maxTokensBuy : remainingTokens;
        
            // Certifica que tokensToBuy não ultrapassa maxTokensBuy
            if (tokensToBuy > maxTokensBuy) {
                tokensToBuy = maxTokensBuy;
            }
        
            // Calcula o BNB necessário para os tokens
            uint256 bnbAmount = (tokensToBuy * 1 ether) / tokensPerBNB;
        
            // Garante que o valor em BNB seja válido e maior que zero
            require(bnbAmount > 0, "BNB amount calculated is zero");
        
            // Certifica que o valor de BNB não exceda o limite definido (1 ether por transação)
            if (bnbAmount > 1 ether) {
                bnbAmount = 1 ether;
            }
        
            // Chama a função de compra
            carameloPreSale.buyTokens{value: bnbAmount}();
        
            // Atualiza os contadores de tokens e BNB restantes
            totalTokensBought += tokensToBuy;
            remainingTokens -= tokensToBuy;
        
            // Incrementa o número de transações
            transactionsCount++;
        
            // Log de informações
            console.log("Tokens comprados na transacao: ", tokensToBuy);
            console.log("Tokens restantes: ", remainingTokens);
            console.log("Numero de transacoes realizadas ate agora: ", transactionsCount);
        }
        
        

        uint256 userTokenBalance = carameloContract.balanceOf(userA);
        assertEq(
            userTokenBalance,
            totalTokens,
            'O usuario nao recebeu todos os tokens disponiveis'
        );

        uint256 contractTokenBalance = carameloContract.balanceOf(
            address(carameloPreSale)
        );
        assertEq(
            contractTokenBalance,
            0,
            'O contrato ainda tem tokens restantes'
        );

        uint256 contractBNBBalance = address(carameloPreSale).balance;
        assertEq(
            contractBNBBalance,
            bnbRequired * 1 ether,
            'O contrato nao recebeu o valor correto de BNB'
        );

        console.log(
            'Total de tokens transferidos para o user A: ',
            userTokenBalance
        );
        console.log('BNB recebido pelo contrato: ', contractBNBBalance);
        console.log(
            'Numero total de transacoes realizadas: ',
            transactionsCount
        );

        vm.stopPrank(); // Finaliza o "prank"
    }

    /**
     * MAX PERMITIDO = 4_200_000_000_000_000_000
     * 1 BNB = 5_250_000_000_000_000_000
     * 0.003 BNB = 15,750,000,000,000
     *
     *  4200000000000000000
     *  15,750,000,000,000 - ultrapassa
     *
     * 0.0008 BNB = 4200000000000000000 Tokens ERC20
     *
     * 42 000 000 000 000 000
     */

    // /** @dev Test function to withdraw funds */
    // function testWithdrawFunds() public {
    //     console.log('-------------------------------------------------');
    //     console.log('---------------- TEST WITHDRAW FUNDS -------------');
    //     console.log('-------------------------------------------------');
    //     console.log('\n');

    //     vm.startPrank(owner);
    //     console.log('--> Inicializando pre-venda');
    //     carameloPreSale.initializePreSale();
    //     vm.stopPrank();

    //     console.log('--> Realizando compra para ter fundos no contrato');
    //     vm.deal(userA, 1 ether);
    //     vm.startPrank(userA);
    //     carameloPreSale.buyTokens{value: 1 ether}();
    //     vm.stopPrank();

    //     uint256 initialOwnerBalance = owner.balance;
    //     uint256 contractBalance = address(carameloPreSale).balance;

    //     vm.startPrank(owner);
    //     console.log('--> Retirando fundos do contrato');
    //     carameloPreSale.withdrawFunds();
    //     vm.stopPrank();

    //     uint256 finalOwnerBalance = owner.balance;
    //     assertEq(
    //         finalOwnerBalance,
    //         initialOwnerBalance + contractBalance,
    //         'O saldo do owner deve ter aumentado corretamente'
    //     );
    //     assertEq(
    //         address(carameloPreSale).balance,
    //         0,
    //         'O saldo do contrato deve ser zero apos a retirada'
    //     );
    //     console.log('\n');
    // }

    // /** @dev Test function to buy tokens on Phase 1 */
    // function testBuyTokensOnPhase1() public {
    //     console.log('-------------------------------------------------');
    //     console.log(
    //         '---------------- TEST BUY TOKENS PHASE 1 ----------------'
    //     );
    //     console.log('-------------------------------------------------');
    //     console.log('\n');

    //     // Inicializar a pré-venda
    //     vm.startPrank(owner);
    //     carameloPreSale.initializePreSale();
    //     vm.stopPrank();

    //     uint256 initialTokenBalance = carameloContract.balanceOf(userA);
    //     uint256 initialContractBalance = address(carameloPreSale).balance;
    //     uint256 initialTokensAvailable = carameloPreSale.tokensRemaining();

    //     // Usuário A compra tokens
    //     uint256 bnbAmount = 1 ether; // Usuário enviará 1 BNB
    //     uint256 expectedTokens = (bnbAmount * preSaleParams.ratePhase1) / 1 ether;

    //     vm.deal(userA, bnbAmount);
    //     vm.startPrank(userA);
    //     carameloPreSale.buyTokens{value: bnbAmount}();
    //     vm.stopPrank();

    //     uint256 finalTokenBalance = carameloContract.balanceOf(userA);
    //     uint256 finalContractBalance = address(carameloPreSale).balance;
    //     uint256 finalTokensAvailable = carameloPreSale.tokensRemaining();

    //     assertEq(
    //         finalTokenBalance,
    //         initialTokenBalance + expectedTokens,
    //         'O saldo do user A deve ter aumentado corretamente.'
    //     );
    //     assertEq(
    //         finalTokensAvailable,
    //         initialTokensAvailable - expectedTokens,
    //         'O saldo de tokens alocados para pre-venda deve ter diminuido corretamente.'
    //     );
    //     assertEq(
    //         finalContractBalance,
    //         initialContractBalance + bnbAmount,
    //         'O saldo de BNB no contrato deve ter aumentado corretamente.'
    //     );
    //     console.log('\n');
    // }

    // /** @dev Test function to buy tokens on Phase 2 */
    // function testBuyTokensOnPhase2() public {
    //     console.log('-------------------------------------------------');
    //     console.log(
    //         '---------------- TEST BUY TOKENS PHASE 2 ----------------'
    //     );
    //     console.log('-------------------------------------------------');
    //     console.log('\n');

    //     // Inicializar a pré-venda
    //     vm.startPrank(owner);
    //     carameloPreSale.initializePreSale();
    //     carameloPreSale.updatePhase(Phase.Phase2);
    //     vm.stopPrank();

    //     uint256 initialTokenBalance = carameloContract.balanceOf(userA);
    //     uint256 initialContractBalance = address(carameloPreSale).balance;
    //     uint256 initialTokensAvailable = carameloPreSale.tokensRemaining();

    //     uint256 bnbAmount = 1 ether;
    //     uint256 expectedTokens = (bnbAmount * preSaleParams.ratePhase2) / 1 ether;

    //     vm.deal(userA, bnbAmount);
    //     vm.startPrank(userA);
    //     carameloPreSale.buyTokens{value: bnbAmount}();
    //     vm.stopPrank();

    //     uint256 finalTokenBalance = carameloContract.balanceOf(userA);
    //     uint256 finalContractBalance = address(carameloPreSale).balance;
    //     uint256 finalTokensAvailable = carameloPreSale.tokensRemaining();

    //     assertEq(
    //         finalTokenBalance,
    //         initialTokenBalance + expectedTokens,
    //         'O saldo do user A deve ter aumentado corretamente.'
    //     );
    //     assertEq(
    //         finalTokensAvailable,
    //         initialTokensAvailable - expectedTokens,
    //         'O saldo de tokens alocados para pre-venda deve ter diminuido corretamente.'
    //     );
    //     assertEq(
    //         finalContractBalance,
    //         initialContractBalance + bnbAmount,
    //         'O saldo de BNB no contrato deve ter aumentado corretamente.'
    //     );
    //     console.log('\n');
    // }

    // /** @dev Test function to buy tokens on Phase 3 */
    // function testBuyTokenOnPhase3() public {
    //     console.log('-------------------------------------------------');
    //     console.log(
    //         '---------------- TEST BUY TOKENS PHASE 3 ----------------'
    //     );
    //     console.log('-------------------------------------------------');
    //     console.log('\n');

    //     // Set phase to Phase3
    //     vm.startPrank(owner);
    //     carameloPreSale.updatePhase(Phase.Phase3);
    //     vm.stopPrank();

    //     uint256 initialTokenBalance = carameloContract.balanceOf(userA);
    //     uint256 initialContractBalance = address(carameloPreSale).balance;
    //     uint256 initialTokensAvailable = carameloPreSale.tokensRemaining();

    //     uint256 bnbAmount = 1 ether;
    //     uint256 expectedTokens = (bnbAmount * preSaleParams.ratePhase3) / 1 ether;

    //     vm.deal(userA, bnbAmount);
    //     vm.startPrank(userA);
    //     carameloPreSale.buyTokens{value: bnbAmount}();
    //     vm.stopPrank();

    //     uint256 finalTokenBalance = carameloContract.balanceOf(userA);
    //     uint256 finalContractBalance = address(carameloPreSale).balance;
    //     uint256 finalTokensAvailable = carameloPreSale.tokensRemaining();

    //     assertEq(
    //         finalTokenBalance,
    //         initialTokenBalance + expectedTokens,
    //         'O saldo do user A deve ter aumentado corretamente.'
    //     );
    //     assertEq(
    //         finalTokensAvailable,
    //         initialTokensAvailable - expectedTokens,
    //         'O saldo de tokens alocados para pre-venda deve ter diminuido corretamente.'
    //     );
    //     assertEq(
    //         finalContractBalance,
    //         initialContractBalance + bnbAmount,
    //         'O saldo de BNB no contrato deve ter aumentado corretamente.'
    //     );
    //     console.log('\n');
    // }
}
