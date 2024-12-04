// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from 'forge-std/Test.sol';
import {console} from 'forge-std/console.sol';
import {Token} from '../contracts/Token.sol';
import {CarameloPreSale} from '../contracts/CarameloPreSale.sol';

/**
 * @dev This contract is a test suite for the CarameloPreSale contract.
 * It includes tests for the initialization, participation, and finalization of the presale.
 * 
 * The test suite uses the Forge testing framework and includes the following components:
 * 
 * - Token: The token contract that will be sold during the presale.
 * - CarameloPreSale: The presale contract that manages the sale of tokens.
 * - RejectEther: A contract used to reject any ether sent to it, ensuring no accidental transfers.
 * 
 * The test suite verifies the following:
 * 
 * - Deployment and initialization of the CarameloPreSale contract.
 * - Participation in the presale by different users.
 * - Handling of invalid participation attempts (e.g., insufficient funds, invalid token amounts).
 * - Finalization of the presale and distribution of tokens.
 * - Ensuring the state and functionality are preserved throughout the presale process.
 * 
 * The test suite also includes various utility functions and event checks to ensure the correctness of the presale process.
 */

error InsufficientFunds(uint256 required, uint256 available);
error InvalidPhase();
error PreSaleNotActive();
error NoTokensAvailable();
error InvalidTokenAmount();
error PreSaleAlreadyInitialized();
error ZeroAddress();
error WithdrawalFailed();

// Reject ether
contract RejectEther {
    fallback() external payable {
        revert('Rejecting ether');
    }

    receive() external payable {
        revert('Rejecting ether');
    }
}

contract TokenPresaleTest is Test {
    Token public token;
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
    /** @dev Token Constructor parameters */
    struct TokenParams {
        string name;
        string symbol;
        uint256 initialSupply;
        uint8 decimals;
        uint256 taxFee;
        uint256 liquidityFee;
        uint256 maxTokensTXAmount;
        uint256 numTokensSellToAddToLiquidity;
        string version;
    }

    struct PreSaleParams {
        uint256 ratePhase1;
        uint256 ratePhase2;
        uint256 ratePhase3;
        uint256 tokensAvailable;
    }

    TokenParams public tokenParams =
        TokenParams({
            name: 'Token',
            symbol: 'TKN',
            initialSupply: 1_000_000, 
            decimals: 6, 
            taxFee: 5, 
            liquidityFee: 5,
            maxTokensTXAmount: 500_000 * 10 ** 6, 
            numTokensSellToAddToLiquidity: 50_000 * 10 ** 6, 
            version: '1'
        });

    PreSaleParams public preSaleParams =
        PreSaleParams({
            ratePhase1: 100_000 * 10 ** 6, // 1 BNB = 100,000 tokens
            ratePhase2: 60_000 * 10 ** 6, // 1 BNB = 60,000 tokens
            ratePhase3: 50_000 * 10 ** 6, // 1 BNB = 50,000 tokens
            tokensAvailable: 300_000 * 10 ** 6 // 300,000 tokens
        });
    // ------------------------------------------------------------------------

    function setUp() public {
        // Configurando o fork corretamente
        vm.createSelectFork('https://bsc-dataseed.binance.org/');

        // Criando usuários fictícios
        (owner, ownerPrivateKey) = makeAddrAndKey('owner');
        (userA, userAPrivateKey) = makeAddrAndKey('userA');
        (userB, userBPrivateKey) = makeAddrAndKey('userB');
        (presaleWallet, presaleWalletPrivateKey) = makeAddrAndKey('presaleWallet');

        // Criando e inicializando o token
        vm.startPrank(owner);
        token = new Token();
        token.initialize(
            tokenParams.name,
            tokenParams.symbol,
            tokenParams.initialSupply,
            tokenParams.decimals,
            tokenParams.taxFee,
            tokenParams.liquidityFee,
            tokenParams.maxTokensTXAmount,
            tokenParams.numTokensSellToAddToLiquidity,
            tokenParams.version
        );
        vm.stopPrank();

        // Criando o contrato de pré-venda
        vm.startPrank(owner);
        carameloPreSale = new CarameloPreSale(
            address(token),
            preSaleParams.ratePhase1,
            preSaleParams.ratePhase2,
            preSaleParams.ratePhase3,
            preSaleParams.tokensAvailable
        );

        // IMPORTANTE: Excluir a pré-venda das taxas ANTES de transferir os tokens
        token.excludeFromFee(address(carameloPreSale));
        token.excludeFromFee(presaleWallet);

        // Agora transfere os tokens para o contrato de pré-venda
        token.transfer(address(carameloPreSale), preSaleParams.tokensAvailable);
        console.log(
            'Tokens transferidos para o contrato de pre-venda:',
            token.balanceOf(address(carameloPreSale))
        );
        vm.stopPrank();
    }

    function testWithdrawFunds() public {
        console.log('-------------------------------------------------');
        console.log('---------------- TEST WITHDRAW FUNDS -------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);
        console.log('--> Inicializando pre-venda');
        carameloPreSale.initializePreSale();
        vm.stopPrank();

        console.log('--> Realizando compra para ter fundos no contrato');
        vm.deal(userA, 1 ether);
        vm.startPrank(userA);
        carameloPreSale.buyTokens{value: 1 ether}();
        vm.stopPrank();

        uint256 initialOwnerBalance = owner.balance;
        uint256 contractBalance = address(carameloPreSale).balance;

        vm.startPrank(owner);
        console.log('--> Retirando fundos do contrato');
        carameloPreSale.withdrawFunds();
        vm.stopPrank();

        uint256 finalOwnerBalance = owner.balance;
        assertEq(
            finalOwnerBalance,
            initialOwnerBalance + contractBalance,
            'O saldo do owner deve ter aumentado corretamente'
        );
        assertEq(
            address(carameloPreSale).balance,
            0,
            'O saldo do contrato deve ser zero apos a retirada'
        );
        console.log('\n');
    }
    // ------------------------------------------------------------------------
    // Buy tokens
    // ------------------------------------------------------------------------
    function testBuyTokensOnPhase1() public {
        console.log('-------------------------------------------------');
        console.log(
            '---------------- TEST BUY TOKENS PHASE 1 ----------------'
        );
        console.log('-------------------------------------------------');
        console.log('\n');

        // Inicializar a pré-venda
        vm.startPrank(owner);
        carameloPreSale.initializePreSale();
        vm.stopPrank();

        // Verificar estado inicial
        uint256 initialTokenBalance = token.balanceOf(userA);
        uint256 initialContractBalance = address(carameloPreSale).balance;
        uint256 initialTokensAvailable = carameloPreSale.tokensRemaining();

        console.log(
            '--> Saldo inicial de tokens do user A:',
            initialTokenBalance
        );
        console.log(
            '--> Saldo inicial de tokens alocados para pre-venda:',
            initialTokensAvailable
        );

        console.log(
            '--> Saldo BNB inicial do contrato:',
            initialContractBalance
        );

        // Usuário A compra tokens
        uint256 bnbAmount = 1 ether; // Usuário enviará 1 BNB
        uint256 expectedTokens = (bnbAmount * preSaleParams.ratePhase1) /
            1 ether;
        console.log('--> expectedTokens:', expectedTokens);

        vm.deal(userA, bnbAmount);
        vm.startPrank(userA);

        // Realiza a compra
        carameloPreSale.buyTokens{value: bnbAmount}();
        vm.stopPrank();

        // Verificar estado após a compra
        uint256 finalTokenBalance = token.balanceOf(userA);
        uint256 finalContractBalance = address(carameloPreSale).balance;
        uint256 finalTokensAvailable = carameloPreSale.tokensRemaining();

        console.log('--> Saldo final de tokens do user A:', finalTokenBalance);
        console.log(
            '--> Saldo final de tokens alocados para pre-venda:',
            finalTokensAvailable
        );
        console.log(
            '==> Saldo de BNB no contrato apos a compra:',
            finalContractBalance
        );

        assertEq(
            finalTokenBalance,
            initialTokenBalance + expectedTokens,
            'O saldo do user A deve ter aumentado corretamente.'
        );
        assertEq(
            finalTokensAvailable,
            initialTokensAvailable - expectedTokens,
            'O saldo de tokens alocados para pre-venda deve ter diminuido corretamente.'
        );
        assertEq(
            finalContractBalance,
            initialContractBalance + bnbAmount,
            'O saldo de BNB no contrato deve ter aumentado corretamente.'
        );
        console.log('\n');
    }

    function testBuyTokensOnPhase2() public {
        console.log('-------------------------------------------------');
        console.log(
            '---------------- TEST BUY TOKENS PHASE 2 ----------------'
        );
        console.log('-------------------------------------------------');
        console.log('\n');

        // Inicializar a pré-venda
        vm.startPrank(owner);
        carameloPreSale.initializePreSale();
        vm.stopPrank();

        // Atualizar a fase
        vm.startPrank(owner);
        carameloPreSale.updatePhase(CarameloPreSale.Phase.Phase2);
        vm.stopPrank();

        uint256 initialTokenBalance = token.balanceOf(userA);
        uint256 initialContractBalance = address(carameloPreSale).balance;
        uint256 initialTokensAvailable = carameloPreSale.tokensRemaining();

        console.log(
            '--> Saldo inicial de tokens do user A:',
            initialTokenBalance
        );
        console.log(
            '--> Saldo inicial de tokens alocados para pre-venda:',
            initialTokensAvailable
        );
        console.log(
            '--> Saldo BNB inicial do contrato:',
            initialContractBalance
        );

        uint256 bnbAmount = 1 ether;
        uint256 expectedTokens = (bnbAmount * preSaleParams.ratePhase2) /
            1 ether;
        console.log('--> expectedTokens phase 2:', expectedTokens);

        vm.deal(userA, bnbAmount);
        vm.startPrank(userA);
        carameloPreSale.buyTokens{value: bnbAmount}();
        vm.stopPrank();

        // Verificar estado após a compra
        uint256 finalTokenBalance = token.balanceOf(userA);
        uint256 finalContractBalance = address(carameloPreSale).balance;
        uint256 finalTokensAvailable = carameloPreSale.tokensRemaining();

        console.log('--> Saldo final de tokens do user A:', finalTokenBalance);
        console.log(
            '--> Saldo final de tokens alocados para pre-venda:',
            finalTokensAvailable
        );
        console.log(
            '==> Saldo de BNB no contrato apos a compra:',
            finalContractBalance
        );

        assertEq(
            finalTokenBalance,
            initialTokenBalance + expectedTokens,
            'O saldo do user A deve ter aumentado corretamente.'
        );

        assertEq(
            finalTokensAvailable,
            initialTokensAvailable - expectedTokens,
            'O saldo de tokens alocados para pre-venda deve ter diminuido corretamente.'
        );

        assertEq(
            finalContractBalance,
            initialContractBalance + bnbAmount,
            'O saldo de BNB no contrato deve ter aumentado corretamente.'
        );
        console.log('\n');
    }

    function testBuyTokenOnPhase3() public {
        console.log('-------------------------------------------------');
        console.log(
            '---------------- TEST BUY TOKENS PHASE 3 ----------------'
        );
        console.log('-------------------------------------------------');
        console.log('\n');

        // Set phase to Phase3
        vm.startPrank(owner);
        carameloPreSale.updatePhase(CarameloPreSale.Phase.Phase3);
        vm.stopPrank();

        uint256 initialTokenBalance = token.balanceOf(userA);
        uint256 initialContractBalance = address(carameloPreSale).balance;
        uint256 initialTokensAvailable = carameloPreSale.tokensRemaining();

        console.log(
            '--> Saldo inicial de tokens alocados para pre-venda:',
            initialTokensAvailable
        );
        console.log(
            '--> Saldo BNB inicial do contrato:',
            initialContractBalance
        );

        uint256 bnbAmount = 1 ether;
        uint256 expectedTokens = (bnbAmount * preSaleParams.ratePhase3) /
            1 ether;
        console.log('--> expectedTokens phase 3:', expectedTokens);

        vm.deal(userA, bnbAmount);
        vm.startPrank(userA);
        carameloPreSale.buyTokens{value: bnbAmount}();
        vm.stopPrank();

        // Verificar estado após a compra
        uint256 finalTokenBalance = token.balanceOf(userA);
        uint256 finalContractBalance = address(carameloPreSale).balance;
        uint256 finalTokensAvailable = carameloPreSale.tokensRemaining();

        console.log('--> Saldo final de tokens do user A:', finalTokenBalance);
        console.log(
            '--> Saldo final de tokens alocados para pre-venda:',
            finalTokensAvailable
        );
        console.log(
            '==> Saldo de BNB no contrato apos a compra:',
            finalContractBalance
        );

        assertEq(
            finalTokenBalance,
            initialTokenBalance + expectedTokens,
            'O saldo do user A deve ter aumentado corretamente.'
        );

        assertEq(
            finalTokensAvailable,
            initialTokensAvailable - expectedTokens,
            'O saldo de tokens alocados para pre-venda deve ter diminuido corretamente.'
        );

        assertEq(
            finalContractBalance,
            initialContractBalance + bnbAmount,
            'O saldo de BNB no contrato deve ter aumentado corretamente.'
        );
        console.log('\n');
    }

    function testMultipleBuys() public {
        console.log('-------------------------------------------------');
        console.log('---------------- TEST MULTIPLE BUYS ----------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        // Inicializar a pré-venda
        vm.startPrank(owner);
        carameloPreSale.initializePreSale();
        carameloPreSale.updatePhase(CarameloPreSale.Phase.Phase3);
        vm.stopPrank();

        uint256 initialTokenBalance = token.balanceOf(userA);
        uint256 initialContractBalance = address(carameloPreSale).balance;
        uint256 initialTokensAvailable = carameloPreSale.tokensRemaining();

        console.log(
            '--> Saldo inicial de tokens do user A:',
            initialTokenBalance
        );
        console.log(
            '--> Saldo inicial de tokens alocados para pre-venda:',
            initialTokensAvailable
        );
        console.log(
            '--> Saldo BNB inicial do contrato:',
            initialContractBalance
        );

        // Primeira compra: 1 BNB = 50,000 * 10^6 tokens
        uint256 bnbAmount1 = 1 ether;
        // Segunda compra: 2 BNB = 100,000 * 10^6 tokens
        uint256 bnbAmount2 = 2 ether;

        // Calcula tokens esperados considerando a taxa da Phase3 (50,000 * 10^6 tokens por BNB)
        uint256 expectedTokens1 = (bnbAmount1 * preSaleParams.ratePhase3) /
            1 ether; // 50,000 * 10^6
        uint256 expectedTokens2 = (bnbAmount2 * preSaleParams.ratePhase3) /
            1 ether; // 100,000 * 10^6

        console.log('--> Expected tokens primeira compra:', expectedTokens1);
        console.log('--> Expected tokens segunda compra:', expectedTokens2);

        vm.deal(userA, bnbAmount1 + bnbAmount2);
        vm.startPrank(userA);
        carameloPreSale.buyTokens{value: bnbAmount1}();
        carameloPreSale.buyTokens{value: bnbAmount2}();
        vm.stopPrank();

        // Verificar estado após as compras
        uint256 finalTokenBalance = token.balanceOf(userA);
        uint256 finalContractBalance = address(carameloPreSale).balance;
        uint256 finalTokensAvailable = carameloPreSale.tokensRemaining();

        console.log('--> Saldo final de tokens do user A:', finalTokenBalance);
        console.log(
            '--> Saldo final de tokens alocados para pre-venda:',
            finalTokensAvailable
        );
        console.log(
            '==> Saldo de BNB no contrato apos as compras:',
            finalContractBalance
        );

        assertEq(
            finalTokenBalance,
            initialTokenBalance + expectedTokens1 + expectedTokens2,
            'O saldo do user A deve ter aumentado corretamente.'
        );

        assertEq(
            finalTokensAvailable,
            initialTokensAvailable - (expectedTokens1 + expectedTokens2),
            'O saldo de tokens alocados para pre-venda deve ter diminuido corretamente.'
        );

        assertEq(
            finalContractBalance,
            initialContractBalance + bnbAmount1 + bnbAmount2,
            'O saldo de BNB no contrato deve ter aumentado corretamente.'
        );

        console.log('\n');
    }
    // ------------------------------------------------------------------------
    // ------------------------------------------------------------------------

    function testRevertZeroAddress() public {
        console.log('-------------------------------------------------');
        console.log('------------ TEST REVERT ZERO ADDRESS ------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);
        console.log('--> Tentando criar contrato com address zero');

        vm.expectRevert(ZeroAddress.selector);
        new CarameloPreSale(
            address(0),
            preSaleParams.ratePhase1,
            preSaleParams.ratePhase2,
            preSaleParams.ratePhase3,
            preSaleParams.tokensAvailable
        );
        vm.stopPrank();
        console.log('\n');
    }

    function testRevertPreSaleAlreadyInitialized() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST REVERT ALREADY INITIALIZED --------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);
        console.log('--> Inicializando pre-venda pela primeira vez');
        carameloPreSale.initializePreSale();

        console.log('--> Tentando inicializar pre-venda novamente');
        vm.expectRevert(PreSaleAlreadyInitialized.selector);
        carameloPreSale.initializePreSale();
        vm.stopPrank();
        console.log('\n');
    }

    function testRevertInvalidTokenAmount() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST REVERT INVALID TOKEN AMOUNT --------');
        console.log('-------------------------------------------------');
        console.log('\n');

        // Criar uma nova instância do contrato sem transferir tokens
        vm.startPrank(owner);
        CarameloPreSale newPreSale = new CarameloPreSale(
            address(token),
            preSaleParams.ratePhase1,
            preSaleParams.ratePhase2,
            preSaleParams.ratePhase3,
            preSaleParams.tokensAvailable
        );

        uint256 halfTokens = preSaleParams.tokensAvailable / 2;
        console.log('--> Tokens necessarios:', preSaleParams.tokensAvailable);
        console.log('--> Transferindo apenas:', halfTokens);

        token.transfer(address(newPreSale), halfTokens);
        console.log(
            '--> Saldo atual do contrato:',
            token.balanceOf(address(newPreSale))
        );

        console.log('--> Tentando inicializar com tokens insuficientes');
        vm.expectRevert(InvalidTokenAmount.selector);
        newPreSale.initializePreSale();
        vm.stopPrank();
        console.log('\n');
    }

    function testRevertPreSaleNotActive() public {
        console.log('-------------------------------------------------');
        console.log('--------- TEST REVERT PRESALE NOT ACTIVE --------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);
        console.log('--> Inicializando pre-venda');
        carameloPreSale.initializePreSale();

        console.log(
            '--> Verificando fase atual:',
            uint(carameloPreSale.currentPhase())
        );

        console.log('--> Encerrando pre-venda');
        carameloPreSale.endPreSale();

        console.log(
            '--> Fase apos encerramento:',
            uint(carameloPreSale.currentPhase())
        );
        vm.stopPrank();

        // Tentar comprar tokens com outro usuário
        vm.startPrank(userA);
        vm.deal(userA, 1 ether);
        console.log('--> Tentando comprar tokens com pre-venda encerrada');
        vm.expectRevert(PreSaleNotActive.selector);
        carameloPreSale.buyTokens{value: 1 ether}();
        vm.stopPrank();
        console.log('\n');
    }

    function testRevertNoTokensAvailable() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST REVERT NO TOKENS AVAILABLE --------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);
        console.log('--> Inicializando pre-venda');
        carameloPreSale.initializePreSale();
        vm.stopPrank();

        uint256 bnbRequired = (preSaleParams.tokensAvailable * 1 ether) /
            preSaleParams.ratePhase1;
        console.log(
            '--> BNB necessarios para comprar todos tokens:',
            bnbRequired
        );

        vm.deal(userA, bnbRequired + 1 ether);
        vm.startPrank(userA);

        console.log('--> Comprando todos os tokens disponiveis');
        carameloPreSale.buyTokens{value: bnbRequired}();

        console.log('--> Tentando comprar mais tokens');
        vm.expectRevert(NoTokensAvailable.selector);
        carameloPreSale.buyTokens{value: 1 ether}();
        vm.stopPrank();
        console.log('\n');
    }

    function testRevertWithdrawalFailed() public {
        console.log('-------------------------------------------------');
        console.log('--------- TEST REVERT WITHDRAWAL FAILED ---------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);
        console.log('--> Inicializando pre-venda');
        carameloPreSale.initializePreSale();
        vm.stopPrank();

        console.log('--> Realizando compra para ter fundos no contrato');
        vm.deal(userA, 1 ether);
        vm.startPrank(userA);
        carameloPreSale.buyTokens{value: 1 ether}();
        vm.stopPrank();

        // Criar um contrato malicioso que rejeita pagamentos
        console.log('--> Criando contrato malicioso');
        RejectEther rejectEther = new RejectEther();

        vm.startPrank(owner);
        console.log(
            '--> Saldo atual do contrato:',
            address(carameloPreSale).balance
        );

        // Definir o endereço do contrato malicioso como destinatário dos fundos
        // mas mantendo o owner como dono do contrato
        console.log(
            '--> Tentando realizar withdrawal para contrato que rejeita ETH'
        );

        // Forçar a falha na transferência
        vm.etch(owner, address(rejectEther).code);

        vm.expectRevert(WithdrawalFailed.selector);
        carameloPreSale.withdrawFunds();
        vm.stopPrank();
        console.log('\n');
    }
    // ------------------------------------------------------------------------
    // ------------------------------------------------------------------------
}
