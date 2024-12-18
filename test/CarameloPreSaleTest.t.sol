// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from 'forge-std/Test.sol';
import {console} from 'forge-std/console.sol';
import {Caramelo} from '../contracts/Caramelo.sol';
import {CarameloPreSale} from '../contracts/CarameloPresale.sol';
import {Phase, InsufficientFunds, InvalidPhase, PreSaleNotActive, NoTokensAvailable, InvalidTokenAmount, PreSaleAlreadyInitialized, ZeroAddress, WithdrawalFailed, MaxTokensBuyExceeded, InvalidPhaseRate} from '../contracts/utils/CarameloPreSaleErrors.sol';

/**
 * @dev This contract is a test suite for the CarameloPreSale contract.
 * It includes tests for the initialization, participation, and finalization of the presale.
 *
 * The test suite uses the Forge testing framework and includes the following components:
 *
 * - Caramelo: The carameloContract contract that will be sold during the presale.
 * - CarameloPreSale: The presale contract that manages the sale of tokens.
 * - RejectEther: A contract used to reject any ether sent to it, ensuring no accidental transfers.
 *
 * The test suite verifies the following:
 *
 * - Deployment and initialization of the CarameloPreSale contract.
 * - Participation in the presale by different users.
 * - Handling of invalid participation attempts (e.g., insufficient funds, invalid carameloContract amounts).
 * - Finalization of the presale and distribution of tokens.
 * - Ensuring the state and functionality are preserved throughout the presale process.
 *
 * The test suite also includes various utility functions and event checks to ensure the correctness of the presale process.
 */

// Reject ether
contract RejectEther {
    fallback() external payable {
        revert('Rejecting ether');
    }

    receive() external payable {
        revert('Rejecting ether');
    }
}

/**
 * @dev This contract is a test suite for the CarameloPreSale contract.
 */
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
            name: 'Caramelo',
            symbol: 'TKN',
            initialSupply: 420_000_000_000_000,
            decimals: 6,
            taxFee: 50000, // 5%
            liquidityFee: 50000, // 5%
            maxTokensTXAmount: 84_000_000_000 * 10 ** 6, // 20% de 420_000_000_000_000
            numTokensSellToAddToLiquidity: 16_800_000_000 * 10 ** 6 // 40% de 420_000_000_000_000
        });

    /** @dev PreSale parameters */
    PreSaleParams public preSaleParams =
        PreSaleParams({
            ratePhase1: 100_000_000 * 10 ** 6, // 1 BNB = 100,000 tokens
            ratePhase2: 60_000_000 * 10 ** 6, // 1 BNB = 60,000 tokens
            ratePhase3: 50_000_000 * 10 ** 6, // 1 BNB = 50,000 tokens
            tokensAvailable: 84_000_000_000 * 10 ** 6, // 20% of total supply
            maxTokensBuy: 4_200_000_000 * 10 ** 6 // 5% of 84,000,000,000
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
        vm.stopPrank();
    }

    /** @dev Test function to withdraw funds */
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
    /** @dev Test function to buy tokens on Phase 1 */
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
        uint256 initialTokenBalance = carameloContract.balanceOf(userA);
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
        uint256 finalTokenBalance = carameloContract.balanceOf(userA);
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

    /** @dev Test function to buy tokens on Phase 2 */
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
        carameloPreSale.updatePhase(Phase.Phase2);
        vm.stopPrank();

        uint256 initialTokenBalance = carameloContract.balanceOf(userA);
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
        uint256 finalTokenBalance = carameloContract.balanceOf(userA);
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

    /** @dev Test function to buy tokens on Phase 3 */
    function testBuyTokenOnPhase3() public {
        console.log('-------------------------------------------------');
        console.log(
            '---------------- TEST BUY TOKENS PHASE 3 ----------------'
        );
        console.log('-------------------------------------------------');
        console.log('\n');

        // Set phase to Phase3
        vm.startPrank(owner);
        carameloPreSale.updatePhase(Phase.Phase3);
        vm.stopPrank();

        uint256 initialTokenBalance = carameloContract.balanceOf(userA);
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
        uint256 finalTokenBalance = carameloContract.balanceOf(userA);
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

    /** @dev Test function to buy tokens on multiple phases */
    function testMultipleBuys() public {
        console.log('-------------------------------------------------');
        console.log('---------------- TEST MULTIPLE BUYS ----------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        // Inicializar a pré-venda
        vm.startPrank(owner);
        carameloPreSale.initializePreSale();
        carameloPreSale.updatePhase(Phase.Phase3);
        vm.stopPrank();

        uint256 initialTokenBalance = carameloContract.balanceOf(userA);
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
        uint256 finalTokenBalance = carameloContract.balanceOf(userA);
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
    // End of tests for buyTokens
    // ------------------------------------------------------------------------

    /** @dev Test function to revert if the address is zero */
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
            preSaleParams.tokensAvailable,
            preSaleParams.maxTokensBuy
        );
        vm.stopPrank();
        console.log('\n');
    }

    /** @dev Test function to revert if the pre-sale is already initialized */
    function testRevertPreSaleAlreadyInitialized() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST REVERT ALREADY INITIALIZED --------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);
        console.log('--> Inicializando pre-venda pela primeira vez');
        carameloPreSale.initializePreSale();

        console.log('--> Tentando inicializar pre-venda novamente');
        vm.expectRevert(
            abi.encodeWithSelector(
                PreSaleAlreadyInitialized.selector,
                'The presale Already initialized with: ',
                preSaleParams.tokensAvailable
            )
        );
        carameloPreSale.initializePreSale();
        vm.stopPrank();
        console.log('\n');
    }

    /** @dev Test function to revert if the token amount is invalid */
    function testRevertInvalidTokenAmount() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST REVERT INVALID TOKEN AMOUNT --------');
        console.log('-------------------------------------------------');
        console.log('\n');

        // Criar uma nova instância do contrato sem transferir tokens
        vm.startPrank(owner);
        CarameloPreSale newPreSale = new CarameloPreSale(
            address(carameloContract),
            preSaleParams.ratePhase1,
            preSaleParams.ratePhase2,
            preSaleParams.ratePhase3,
            preSaleParams.tokensAvailable,
            preSaleParams.maxTokensBuy
        );

        uint256 halfTokens = preSaleParams.tokensAvailable / 2;
        console.log('--> Tokens necessarios:', preSaleParams.tokensAvailable);
        console.log('--> Transferindo apenas:', halfTokens);

        carameloContract.transfer(address(newPreSale), halfTokens);
        console.log(
            '--> Saldo atual do contrato:',
            carameloContract.balanceOf(address(newPreSale))
        );

        console.log('--> Tentando inicializar com tokens insuficientes');
        vm.expectRevert(
            abi.encodeWithSelector(
                InvalidTokenAmount.selector,
                'Invalid token amount: ',
                halfTokens
            )
        );
        newPreSale.initializePreSale();
        vm.stopPrank();
        console.log('\n');
    }

    /** @dev Test function to revert if the pre-sale is not active */
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

    /** @dev Test function to revert if no tokens are available */
    function testRevertNoTokensAvailable() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST REVERT NO TOKENS AVAILABLE --------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);
        console.log('--> Inicializando pre-venda');
        carameloPreSale.initializePreSale();

        /// @dev Add userA to whitelist to ignore maxTokensBuy
        console.log('--> Adicionando userA a whitelist');
        carameloPreSale.addToWhitelist(userA);
        vm.stopPrank();

        uint256 tokensAvailable = carameloPreSale.tokensRemaining();
        uint256 bnbRequired = (tokensAvailable * 1 ether) /
            preSaleParams.ratePhase1;

        console.log('--> Tokens disponiveis:', tokensAvailable);
        console.log(
            '--> BNB necessarios para comprar todos tokens:',
            bnbRequired
        );

        vm.deal(userA, bnbRequired + 1 ether);
        vm.startPrank(userA);

        console.log('--> Comprando todos os tokens disponiveis');
        carameloPreSale.buyTokens{value: bnbRequired}();

        /// @dev Calculate the attempted purchase
        uint256 additionalBnb = 1 ether;
        uint256 attemptedPurchase = (additionalBnb * preSaleParams.ratePhase1) /
            1 ether;

        console.log('\n--> Tentando comprar mais tokens');
        console.log('    Tentativa de compra:', attemptedPurchase);
        console.log(
            '    Tokens disponiveis:',
            carameloPreSale.tokensRemaining()
        );

        vm.expectRevert(
            abi.encodeWithSelector(
                NoTokensAvailable.selector,
                'Insufficient tokens available in presale. Available: ',
                0,
                attemptedPurchase
            )
        );
        carameloPreSale.buyTokens{value: additionalBnb}();
        vm.stopPrank();

        console.log('\n');
    }

    /** @dev Test function to revert if the withdrawal fails */
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

        /// @dev Create a malicious contract that rejects payments
        console.log('--> Criando contrato malicioso');
        RejectEther rejectEther = new RejectEther();

        vm.startPrank(owner);
        console.log(
            '--> Saldo atual do contrato:',
            address(carameloPreSale).balance
        );

        /// @dev Set the malicious contract address as the recipient of the funds
        /// but keep the owner as the contract owner
        console.log(
            '--> Tentando realizar withdrawal para contrato que rejeita ETH'
        );

        /// @dev Force the transfer to fail
        vm.etch(owner, address(rejectEther).code);

        vm.expectRevert(WithdrawalFailed.selector);
        carameloPreSale.withdrawFunds();
        vm.stopPrank();
        console.log('\n');
    }

    /** @dev Test function to buy tokens on whitelist with higher limit */
    function testWhitelistPurchaseWithHigherLimit() public {
        console.log('-------------------------------------------------');
        console.log(
            '--------- TEST WHITELIST PURCHASE WITH HIGHER LIMIT ---------'
        );
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev initializePreSale
        vm.startPrank(owner);
        carameloPreSale.initializePreSale();

        /// @dev addToWhitelist
        carameloPreSale.addToWhitelist(userA);
        vm.stopPrank();

        /// @dev verify initial state
        uint256 initialTokenBalance = carameloContract.balanceOf(userA);
        uint256 initialTokensAvailable = carameloPreSale.tokensRemaining();
        console.log(
            '--> Saldo inicial de tokens do user A:',
            initialTokenBalance
        );

        /// @dev calculate bnb amount to buy all available tokens
        uint256 bnbAmount = (initialTokensAvailable * 1 ether) /
            preSaleParams.ratePhase1;
        uint256 expectedTokens = (bnbAmount * preSaleParams.ratePhase1) /
            1 ether;

        vm.deal(userA, bnbAmount);
        vm.startPrank(userA);
        carameloPreSale.buyTokens{value: bnbAmount}();
        vm.stopPrank();

        /// @dev verify final state
        uint256 finalTokenBalance = carameloContract.balanceOf(userA);
        uint256 finalTokensAvailable = carameloPreSale.tokensRemaining();

        console.log('--> Saldo final de tokens do user A:', finalTokenBalance);

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
        console.log('\n');
    }

    /** @dev Test function to verify that non-whitelist users respect the maxTokensBuy limit */
    function testNonWhitelistUserRespectsMaxTokensBuy() public {
        console.log('-------------------------------------------------');
        console.log(
            '--------- TEST NON-WHITELIST USER MAX TOKENS BUY ---------'
        );
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev initializePreSale
        vm.startPrank(owner);
        carameloPreSale.initializePreSale();

        /// @dev updateMaxTokensBuy
        uint256 newMaxTokensBuy = 2_000 * 10 ** 6;
        carameloPreSale.updateMaxTokensBuy(newMaxTokensBuy);
        vm.stopPrank();

        /// @dev verify initial state
        uint256 initialTokenBalance = carameloContract.balanceOf(userB);

        /// @dev calculate bnb amount to buy more than the allowed limit
        uint256 bnbAmount = ((newMaxTokensBuy + 1) * 1 ether) /
            preSaleParams.ratePhase1; // Calcula o valor em BNB necessário para ultrapassar o limite
        vm.deal(userB, bnbAmount);
        vm.startPrank(userB);

        vm.expectRevert(
            abi.encodeWithSelector(
                MaxTokensBuyExceeded.selector,
                newMaxTokensBuy,
                newMaxTokensBuy + 1
            )
        );
        carameloPreSale.buyTokens{value: bnbAmount}();

        vm.stopPrank();

        /// @dev verify final state
        uint256 finalTokenBalance = carameloContract.balanceOf(userB);
        assertEq(
            finalTokenBalance,
            initialTokenBalance,
            'O saldo do user B deve permanecer inalterado.'
        );
        console.log('\n');
    }

    /** @dev Test function to update the maxTokensBuy */
    function testUpdateMaxTokensBuy() public {
        console.log('-------------------------------------------------');
        console.log('--------- TEST UPDATE MAX TOKENS BUY ---------');
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev initializePreSale
        vm.startPrank(owner);
        carameloPreSale.initializePreSale();

        /// @dev updateMaxTokensBuy
        uint256 newMaxTokensBuy = 3_000 * 10 ** 6;
        carameloPreSale.updateMaxTokensBuy(newMaxTokensBuy);

        /// @dev verify maxTokensBuy
        assertEq(
            carameloPreSale.maxTokensBuy(),
            newMaxTokensBuy,
            'O novo limite de maxTokensBuy deve ser refletido corretamente.'
        );

        vm.stopPrank();
        console.log('\n');
    }

    /** @dev Test function to add and remove from whitelist */
    function testAddAndRemoveFromWhitelist() public {
        console.log('-------------------------------------------------');
        console.log('--------- TEST ADD AND REMOVE FROM WHITELIST ---------');
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev Add userA to whitelist
        vm.startPrank(owner);
        carameloPreSale.addToWhitelist(userA);
        assertEq(
            carameloPreSale.whitelist(userA),
            true,
            'O userA deveria estar na whitelist.'
        );

        /// @dev Remove userA from whitelist
        carameloPreSale.removeFromWhitelist(userA);
        assertEq(
            carameloPreSale.whitelist(userA),
            false,
            'O userA deveria ter sido removido da whitelist.'
        );
        vm.stopPrank();
        console.log('\n');
    }

    /** @dev Test function to buy after whitelist removal */
    function testBuyAfterWhitelistRemoval() public {
        console.log('-------------------------------------------------');
        console.log('--------- TEST BUY AFTER WHITELIST REMOVAL ---------');
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev initializePreSale
        vm.startPrank(owner);
        carameloPreSale.initializePreSale();

        /// @dev addToWhitelist and then remove
        carameloPreSale.addToWhitelist(userA);
        carameloPreSale.removeFromWhitelist(userA);
        vm.stopPrank();

        /// @dev verify initial state
        uint256 initialTokenBalance = carameloContract.balanceOf(userA);

        /// @dev try to buy more than maxTokensBuy
        uint256 newMaxTokensBuy = 2_000 * 10 ** 6;
        vm.startPrank(owner);
        carameloPreSale.updateMaxTokensBuy(newMaxTokensBuy);
        vm.stopPrank();

        uint256 bnbAmount = ((newMaxTokensBuy + 1) * 1 ether) /
            /// @dev Calculate bnb amount to buy more than the allowed limit
            preSaleParams.ratePhase1;
        vm.deal(userA, bnbAmount);
        vm.startPrank(userA);

        vm.expectRevert(
            abi.encodeWithSelector(
                MaxTokensBuyExceeded.selector,
                newMaxTokensBuy,
                newMaxTokensBuy + 1
            )
        );
        carameloPreSale.buyTokens{value: bnbAmount}();

        vm.stopPrank();

        /// @dev verify final state
        uint256 finalTokenBalance = carameloContract.balanceOf(userA);
        assertEq(
            finalTokenBalance,
            initialTokenBalance,
            'O saldo do user A deve permanecer inalterado apos remocao da whitelist.'
        );
        console.log('\n');
    }

    /** @dev Test function to revert if the user tries to buy more than available tokens */
    function testBuyMoreThanAvailableTokens() public {
        console.log('-------------------------------------------------');
        console.log('--------- TEST BUY MORE THAN AVAILABLE TOKENS ---------');
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev initializePreSale
        vm.startPrank(owner);
        carameloPreSale.initializePreSale();
        vm.stopPrank();

        /// @dev verify initial state
        uint256 availableTokens = carameloPreSale.tokensRemaining();
        // Tentar comprar 1 carameloContract a mais que o disponível
        uint256 tokensToTransfer = availableTokens + 1;
        uint256 bnbToSend = (tokensToTransfer * 1 ether) /
            preSaleParams.ratePhase1;

        vm.deal(userA, bnbToSend);
        vm.startPrank(userA);

        vm.expectRevert(
            abi.encodeWithSelector(
                NoTokensAvailable.selector,
                'Insufficient tokens available in presale. Available: ',
                availableTokens,
                tokensToTransfer
            )
        );
        carameloPreSale.buyTokens{value: bnbToSend}();
        vm.stopPrank();
    }

    /** @dev Test function to revert if the user buys tokens without updating the phase */
    function testBuyWithoutPhaseUpdate() public {
        console.log('-------------------------------------------------');
        console.log('--------- TEST BUY WITHOUT PHASE UPDATE ---------');
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev initializePreSale
        vm.startPrank(owner);
        carameloPreSale.initializePreSale();
        vm.stopPrank();

        /// @dev verify initial state
        uint256 initialTokenBalance = carameloContract.balanceOf(userA);
        uint256 ratePhase1 = preSaleParams.ratePhase1;

        /// @dev buy tokens without updating phase
        uint256 bnbAmount = 1 ether; // 1 BNB
        uint256 expectedTokens = (bnbAmount * ratePhase1) / 1 ether;

        vm.deal(userA, bnbAmount);
        vm.startPrank(userA);
        carameloPreSale.buyTokens{value: bnbAmount}();
        vm.stopPrank();

        /// @dev verify final state
        uint256 finalTokenBalance = carameloContract.balanceOf(userA);

        assertEq(
            finalTokenBalance,
            initialTokenBalance + expectedTokens,
            'O saldo do user A deve ter aumentado corretamente na mesma fase.'
        );
        console.log('\n');
    }

    /** @dev Test function to buy exact maxTokensBuy */
    function testBuyExactMaxTokensBuy() public {
        console.log('-------------------------------------------------');
        console.log('--------- TEST BUY EXACT MAX TOKENS BUY ---------');
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev initializePreSale
        vm.startPrank(owner);
        carameloPreSale.initializePreSale();

        /// @dev calculate exact BNB for maxTokensBuy
        uint256 bnbAmount = (preSaleParams.maxTokensBuy * 1 ether) /
            preSaleParams.ratePhase1;
        uint256 expectedTokens = (bnbAmount * preSaleParams.ratePhase1) /
            1 ether;
        vm.stopPrank();

        vm.deal(userA, bnbAmount);
        vm.startPrank(userA);

        /// @dev attempt to buy exact maxTokensBuy
        carameloPreSale.buyTokens{value: bnbAmount}();
        vm.stopPrank();

        uint256 userTokens = carameloContract.balanceOf(userA);
        assertEq(
            userTokens,
            expectedTokens,
            'O saldo do user A deve ser igual ao limite max permitido.'
        );
        console.log('\n');
    }

    /** @dev Test function to revert if the phase rate is zero */
    function testRevertWhenPhaseRateIsZero() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST REVERT WHEN PHASE RATE IS ZERO --------');
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev Inicializa a pré-venda
        vm.startPrank(owner);
        console.log('--> Inicializando pre-venda');
        carameloPreSale.initializePreSale();

        /// @dev Tenta atualizar a taxa da fase atual para zero
        console.log('--> Tentando atualizar taxa da fase atual para zero');

        vm.expectRevert(
            abi.encodeWithSelector(
                InvalidPhaseRate.selector,
                'Invalid phase rate: ',
                0
            )
        );
        carameloPreSale.updatePhaseRate(Phase.Phase1, 0);
        vm.stopPrank();

        console.log('\n');
    }

    /** @dev Test function to add multiple addresses to the whitelist */
    // function testAddMultipleToWhitelist() public {
    //     console.log('-------------------------------------------------');
    //     console.log('------ TEST ADD MULTIPLE TO WHITELIST -----------');
    //     console.log('-------------------------------------------------');
    //     console.log('\n');

    //     address[] memory accounts = new address[](3);
    //     accounts[0] = userA;
    //     accounts[1] = userB;
    //     accounts[2] = presaleWallet;

    //     vm.startPrank(owner);
    //     carameloPreSale.addMultipleToWhitelist(accounts);
    //     vm.stopPrank();

    //     for (uint256 i = 0; i < accounts.length; i++) {
    //         assertTrue(
    //             carameloPreSale.whitelist(accounts[i]),
    //             "Address should be whitelisted"
    //         );
    //     }

    //     // Test with empty array
    //     address[] memory emptyArray = new address[](0);
    //     vm.startPrank(owner);
    //     vm.expectRevert(
    //         abi.encodeWithSelector(
    //             InvalidTokenAmount.selector,
    //             "Empty array provided: ",
    //             0
    //         )
    //     );
    //     carameloPreSale.addMultipleToWhitelist(emptyArray);
    //     vm.stopPrank();

    //     // Test with array containing zero address
    //     address[] memory invalidArray = new address[](1);
    //     invalidArray[0] = address(0);
    //     vm.startPrank(owner);
    //     vm.expectRevert(ZeroAddress.selector);
    //     carameloPreSale.addMultipleToWhitelist(invalidArray);
    //     vm.stopPrank();

    //     console.log('\n');
    // }

    /** @dev Test function to add multiple addresses to the whitelist and buy above max */
    function testAddMultipleToWhitelistAndBuyAboveMax() public {
        console.log('-------------------------------------------------');
        console.log('------ TEST MULTIPLE WHITELIST BUY ABOVE MAX ----');
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev Setup 10 addresses to whitelist
        address[] memory accounts = new address[](10);
        accounts[0] = makeAddr("investor1");
        accounts[1] = makeAddr("investor2");
        accounts[2] = makeAddr("investor3");
        accounts[3] = makeAddr("investor4");
        accounts[4] = makeAddr("investor5");
        accounts[5] = makeAddr("investor6");
        accounts[6] = makeAddr("investor7");
        accounts[7] = makeAddr("investor8");
        accounts[8] = makeAddr("investor9");
        accounts[9] = makeAddr("investor10");

        /// @dev Log all addresses
        console.log("Generated addresses for whitelist:");
        for(uint256 i = 0; i < accounts.length; i++) {
            console.log(string.concat("Investor ", vm.toString(i + 1), ": ", vm.toString(accounts[i])));
        }
        console.log("\n");

        /// @dev Initialize presale and add multiple addresses to whitelist
        vm.startPrank(owner);
        carameloPreSale.initializePreSale();
        carameloContract.transfer(address(carameloPreSale), carameloPreSale.tokensRemaining());
        carameloPreSale.addMultipleToWhitelist(accounts);
        vm.stopPrank();

        /// @dev Setup purchase amounts
        uint256 maxTokensBuy = carameloPreSale.maxTokensBuy();
        uint256 amountAboveMax = maxTokensBuy * 2; // Try to buy double the max
        uint256 bnbNeeded = (amountAboveMax * 1 ether) / preSaleParams.ratePhase1;

        console.log("Max tokens buy limit:", maxTokensBuy);
        console.log("Attempting to buy:", amountAboveMax);
        console.log("BNB needed:", bnbNeeded);

        /// @dev Test non-whitelisted address first
        address nonWhitelisted = makeAddr("nonWhitelisted");
        vm.deal(nonWhitelisted, bnbNeeded);
        
        vm.startPrank(nonWhitelisted);
        console.log("\nTesting purchase for non-whitelisted address:", nonWhitelisted);
        
        vm.expectRevert(
            abi.encodeWithSelector(
                MaxTokensBuyExceeded.selector,
                maxTokensBuy,
                amountAboveMax
            )
        );
        carameloPreSale.buyTokens{value: bnbNeeded}();
        vm.stopPrank();
        
        /// @dev Test purchase for each whitelisted address
        for(uint256 i = 0; i < accounts.length; i++) {
            address buyer = accounts[i];
            console.log("\nTesting purchase for Investor", i + 1, ":", buyer);
            
            uint256 initialBalance = carameloContract.balanceOf(buyer);
            vm.deal(buyer, bnbNeeded);
            
            vm.startPrank(buyer);
            carameloPreSale.buyTokens{value: bnbNeeded}();
            vm.stopPrank();
            
            uint256 finalBalance = carameloContract.balanceOf(buyer);
            uint256 purchased = finalBalance - initialBalance;
            
            console.log("Initial balance:", initialBalance);
            console.log("Final balance:", finalBalance);
            console.log("Tokens purchased:", purchased);
            
            assertTrue(
                purchased > maxTokensBuy,
                "Whitelisted address should be able to buy above maxTokensBuy"
            );
            
            assertTrue(
                purchased == amountAboveMax,
                "Should receive exact amount requested"
            );
        }

        console.log('\n');
    }

    // ------------------------------------------------------------------------
    // ----------------------- END OF TESTS ----------------------------------
    // ------------------------------------------------------------------------
}
