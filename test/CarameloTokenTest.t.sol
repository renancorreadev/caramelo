// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from 'forge-std/Test.sol';
import {console} from 'forge-std/console.sol';
import {Token} from '../contracts/Token.sol';

/// @dev open zeppelin contracts utils
import {IUniswapV2Router02, IUniswapV2Factory} from '../contracts/interfaces/UniswapV2Interfaces.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {UUPSUpgradeable} from '@openzeppelin/contracts-upgradeable/proxy/utils/UUPSUpgradeable.sol';
import {ERC1967Proxy} from '@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol';

/**
 * @dev This contract is a test suite for the CarameloToken contract.
 * It includes tests for the transfer, transferFrom, and transferBetweenExcludedAndNonExcluded functions.
 *
 * The test suite uses the Forge testing framework and includes the following components:
 *
 * - Token: The token contract that will be tested.
 */

/** Errors to tests  */
error OwnerNotExcludedFromFee();
error TotalSupplyNotMatch(uint256 actualSupply, uint256 expectedSupply);
error MaxTransactionExceeded(uint256 maxTxAmount, uint256 attemptedAmount);
error NumTokensSellToAddToLiquidityFailed(
    uint256 currentAmount,
    uint256 newAmount
);
error ZeroAddress();
error AlreadyExcluded();
error NotExcluded();
error FeesExceeded(uint256 totalFees);
error InsufficientBalance(uint256 available, uint256 required);
error TokenBalanceZero();
error TransferAmountExceedsMax();
error TransferAmountZero();
error OwnableUnauthorizedAccount(address account);
error OwnableInvalidOwner(address owner);

contract CarameloTokenTest is Test {
    Token public token;
    address public owner;
    uint256 private ownerPrivateKey;

    address public userA;
    uint256 private userAPrivateKey;

    address public userB;
    uint256 private userBPrivateKey;

    // PancakeSwap Router e Factory na BSC
    address public routerAddress = 0x10ED43C718714eb63d5aA57B78B54704E256024E;
    address public WBNB = 0xbb4CdB9CBd36B01bD1cBaEBF2De08d9173bc095c;
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

    TokenParams public tokenParams =
        TokenParams({
            name: 'Token',
            symbol: 'TKN',
            initialSupply: 1_000_000, // 1,000,000 tokens
            decimals: 6, // 6%
            taxFee: 5, // 5%
            liquidityFee: 5, // 5%
            maxTokensTXAmount: 500_000, // 500,000 tokens
            numTokensSellToAddToLiquidity: 500_000, // 500,000 tokens
            version: '1'
        });

    function setUp() public {
        /// @dev setting up the fork correctly
        vm.createSelectFork('https://bsc-dataseed.binance.org/');

        /// @dev creating owner and starting its context as `msg.sender`
        (owner, ownerPrivateKey) = makeAddrAndKey('owner');
        (userA, userAPrivateKey) = makeAddrAndKey('userA');
        (userB, userBPrivateKey) = makeAddrAndKey('userB');

        /// @dev creating a new contract and initializing it
        vm.startPrank(owner);
        token = new Token(
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

        /// @dev validate if owner is excluded from fee
        if (!token.isAccountExcludedFromFree(owner)) {
            revert OwnerNotExcludedFromFee();
        }
    }

    function testTotalSupply() public view {
        console.log('-----------------------------------------');
        console.log('-------------  Test Total Supply --------------');
        console.log('-----------------------------------------');
        console.log('\n');

        uint256 actualSupply = token.totalSupply();
        uint256 expectedSupply = tokenParams.initialSupply *
            10 ** tokenParams.decimals;

        console.log('Total Supply Inicial:', actualSupply);
        console.log('Expected Supply:', expectedSupply);
        console.log('Decimais:', tokenParams.decimals);

        if (actualSupply != expectedSupply) {
            revert TotalSupplyNotMatch(actualSupply, expectedSupply);
        }

        console.log('-----------------------------------------------');
        console.log('\n');
    }

    function testTransferWithoutFees() public {
        console.log('-------------------------------------------------');
        console.log('---------- TEST TRANSFER WITHOUT FEES -----------');
        console.log('-------------------------------------------------');
        console.log('\n');

        address excludedUser = makeAddr('excludedUser');
        uint256 transferAmount = 1000 * 10 ** tokenParams.decimals; // 1000 tokens

        /// @dev exclude user from fees
        vm.startPrank(owner);
        token.excludeFromFee(excludedUser);
        vm.stopPrank();

        console.log('--> Verificando se user esta excluido das taxas');
        assertTrue(
            token.isAccountExcludedFromFree(excludedUser),
            'Usuario nao esta excluido das taxas'
        );
        assertTrue(
            token.isAccountExcludedFromFree(owner),
            'Owner nao esta excluido das taxas'
        );

        /// @dev transfer tokens from owner to excluded user
        console.log(
            '--> Transferindo',
            transferAmount,
            'tokens do owner para usuario excluido'
        );
        vm.startPrank(owner);
        token.transfer(excludedUser, transferAmount);
        vm.stopPrank();

        /// @dev check if the received amount is exactly the transferred amount (without fees)
        uint256 excludedUserBalance = token.balanceOf(excludedUser);
        console.log('--> Balance do usuario excluido:', excludedUserBalance);
        assertEq(
            excludedUserBalance,
            transferAmount,
            'Valor recebido nao corresponde ao transferido'
        );

        /// @dev transfer tokens from excluded user to another excluded address (owner)
        console.log('--> Transferindo tokens de volta para o owner');
        vm.startPrank(excludedUser);
        token.transfer(owner, transferAmount);
        vm.stopPrank();

        /// @dev check if the received amount is exactly the transferred amount
        uint256 ownerFinalBalance = token.balanceOf(owner);
        console.log('--> Balance final do owner:', ownerFinalBalance);

        /// @dev check if there was no change in the total supply (no burning should occur)
        uint256 finalSupply = token.totalSupply();
        uint256 expectedSupply = tokenParams.initialSupply *
            10 ** tokenParams.decimals;
        console.log('--> Supply final:', finalSupply);
        console.log('--> Supply esperado:', expectedSupply);
        assertEq(
            finalSupply,
            expectedSupply,
            'Supply total nao deve ser alterado'
        );

        console.log('\n');
    }

    function testTransferWithFees() public {
        console.log('-------------------------------------------------');
        console.log('----------- TEST TRANSFER WITH FEES -------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        address normalUser = makeAddr('normalUser');
        address recipient = makeAddr('recipient');
        uint256 transferAmount = 1000 * 10 ** tokenParams.decimals; // 1000 tokens

        // Transferir tokens do owner para o usuário normal
        vm.startPrank(owner);
        token.transfer(normalUser, transferAmount);
        vm.stopPrank();

        uint256 initialBalance = token.balanceOf(normalUser);
        console.log('Balance inicial do usuario:', initialBalance);

        // Calcular taxas esperadas
        /// @dev // 30% off taxFee
        uint256 burnFee = (transferAmount * token.taxFee() * 30) / 10000;
        /// @dev // 70% of taxFee
        uint256 reflectFee = (transferAmount * token.taxFee() * 70) / 10000;
        uint256 liquidityFee = (transferAmount * token.liquidityFee()) / 100;
        uint256 totalFee = burnFee + reflectFee + liquidityFee;
        uint256 expectedReceivedAmount = transferAmount - totalFee;

        console.log('Taxa de queima:', burnFee);
        console.log('Taxa de reflexao:', reflectFee);
        console.log('Taxa de liquidez:', liquidityFee);
        console.log('Valor a transferir:', transferAmount);
        console.log('Valor esperado apos taxas:', expectedReceivedAmount);

        // Realizar a transferência com taxas
        vm.startPrank(normalUser);
        token.transfer(recipient, transferAmount);
        vm.stopPrank();

        // Verificar o valor recebido
        uint256 recipientBalance = token.balanceOf(recipient);
        console.log('Valor recebido:', recipientBalance);

        // Verificar se o valor recebido está dentro da margem de erro aceitável
        uint256 marginOfError = expectedReceivedAmount / 1000; // 0.1% margem
        bool isWithinMargin = recipientBalance >=
            expectedReceivedAmount - marginOfError &&
            recipientBalance <= expectedReceivedAmount + marginOfError;

        assertTrue(
            isWithinMargin,
            string(
                abi.encodePacked(
                    'Valor recebido fora da margem aceitavel. Recebido: ',
                    vm.toString(recipientBalance),
                    ', Esperado: ',
                    vm.toString(expectedReceivedAmount),
                    ' +/- ',
                    vm.toString(marginOfError)
                )
            )
        );

        // Verificar o total supply após queima
        uint256 initialSupply = 1_000_000_000_000; // Supondo supply inicial como 1 trilhão
        uint256 expectedSupplyAfterBurn = initialSupply - burnFee; // Queima foi deduzida do supply
        uint256 actualSupply = token.totalSupply();

        console.log('Supply esperado apos queima:', expectedSupplyAfterBurn);
        console.log('Supply atual:', actualSupply);

        assertEq(
            actualSupply,
            expectedSupplyAfterBurn,
            'Supply total nao bate com a expectativa apos queima'
        );

        console.log('\n');
    }

    function testTransferFrom() public {
        console.log('-------------------------------------------------');
        console.log('------------- TEST TRANSFER FROM ----------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        address spender = makeAddr('spender');
        uint256 amount = 1000 * 10 ** tokenParams.decimals;

        /// @dev check initial balance of owner
        uint256 ownerBalance = token.balanceOf(owner);
        console.log('Balance inicial do owner:', ownerBalance);

        vm.startPrank(owner);

        /// @dev approve spender
        token.approve(spender, amount);

        /// @dev check allowance
        uint256 allowance = token.allowance(owner, spender);
        console.log('Allowance para spender:', allowance);
        assertEq(allowance, amount, 'Allowance incorreta');

        vm.stopPrank();

        /// @dev try to transferFrom as spender
        vm.startPrank(spender);
        token.transferFrom(owner, spender, amount);
        vm.stopPrank();

        /// @dev check final balances
        uint256 ownerBalanceAfter = token.balanceOf(owner);
        uint256 spenderBalance = token.balanceOf(spender);

        console.log('Balance final do owner:', ownerBalanceAfter);
        console.log('Balance do spender:', spenderBalance);

        assertEq(
            ownerBalanceAfter,
            ownerBalance - amount,
            'Balance do owner incorreto'
        );
        assertEq(spenderBalance, amount, 'Balance do spender incorreto');

        console.log('\n');
    }

    function testTransferBetweenExcludedAndNonExcluded() public {
        console.log('-------------------------------------------------');
        console.log('---- TEST TRANSFER EXCLUDED TO NON-EXCLUDED -----');
        console.log('-------------------------------------------------');
        console.log('\n');

        address excludedUser = makeAddr('excludedUser');
        address normalUser = makeAddr('normalUser');
        uint256 transferAmount = 1000 * 10 ** tokenParams.decimals;

        /// @dev exclude a user from fees
        vm.startPrank(owner);
        token.excludeFromFee(excludedUser);
        token.transfer(excludedUser, transferAmount);
        vm.stopPrank();

        console.log('--> Initial setup:');
        console.log(
            '    Excluded user balance:',
            token.balanceOf(excludedUser)
        );
        console.log('    Normal user balance:', token.balanceOf(normalUser));

        /// @dev transfer from excluded to non-excluded (should not apply fees)
        console.log('\n--> Transferindo de usuario excluido para normal');
        vm.startPrank(excludedUser);
        token.transfer(normalUser, transferAmount);
        vm.stopPrank();

        /// @dev there should be no fees since the sender is excluded
        uint256 expectedAmount = transferAmount;

        console.log('    Valor transferido:', transferAmount);
        console.log('    Valor esperado (sem taxas):', expectedAmount);

        uint256 actualBalance = token.balanceOf(normalUser);
        console.log('    Valor recebido:', actualBalance);

        assertEq(
            actualBalance,
            expectedAmount,
            'Valor recebido incorreto - nao deveria ter taxas'
        );

        /// @dev now test transfer from non-excluded to any address (should apply fees)
        console.log('\n--> Transferindo de usuario normal para excluido');
        uint256 smallerAmount = 100 * 10 ** tokenParams.decimals;

        uint256 excludedBalanceBefore = token.balanceOf(excludedUser);

        vm.startPrank(normalUser);
        token.transfer(excludedUser, smallerAmount);
        vm.stopPrank();

        /// @dev calculate expected fees for transfer from normal user
        uint256 totalFee = tokenParams.taxFee + tokenParams.liquidityFee;
        uint256 expectedAmountBack = (smallerAmount * (100 - totalFee)) / 100;
        uint256 actualReceived = token.balanceOf(excludedUser) -
            excludedBalanceBefore;

        console.log('    Taxa total:', totalFee, '%');
        console.log('    Valor transferido:', smallerAmount);
        console.log('    Valor esperado apos taxas:', expectedAmountBack);
        console.log('    Valor recebido:', actualReceived);

        /// @dev check margin of error for the second transfer
        uint256 marginOfError = expectedAmountBack / 1000; // 0.1% of the expected amount
        bool isWithinMargin = actualReceived >=
            expectedAmountBack - marginOfError &&
            actualReceived <= expectedAmountBack + marginOfError;

        assertTrue(
            isWithinMargin,
            string(
                abi.encodePacked(
                    'Valor recebido fora da margem aceitavel na segunda transferencia. Recebido: ',
                    vm.toString(actualReceived),
                    ', Esperado: ',
                    vm.toString(expectedAmountBack),
                    ' +/- ',
                    vm.toString(marginOfError)
                )
            )
        );

        console.log('\n');
    }

    function testReflectionMechanism() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST REFLECTION MECHANISM ---------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev Transferir tokens para userA
        uint256 transferAmount = 1000 * 10 ** tokenParams.decimals; // 1000 tokens
        vm.startPrank(owner);
        token.transfer(userA, transferAmount); // Transferir 1000 tokens para userA
        vm.stopPrank();

        /// @dev Registrar balanços iniciais
        uint256 initialUserABalance = token.balanceOf(userA);
        uint256 initialUserBBalance = token.balanceOf(userB);

        console.log('Balance inicial userA:', initialUserABalance);
        console.log('Balance inicial userB:', initialUserBBalance);

        /// @dev userA transfere tokens para userB (com taxas)
        uint256 transferAmount2 = 100 * 10 ** tokenParams.decimals; // Transferir 100 tokens

        vm.startPrank(userA);
        token.transfer(userB, transferAmount2); // Transferência de userA para userB
        vm.stopPrank();

        /// @dev Calcular taxas aplicadas
        uint256 liquidityFee = (transferAmount2 * token.liquidityFee()) / 100; // 5% para liquidez
        uint256 taxFee = (transferAmount2 * token.taxFee()) / 100; // 5% para taxFee
        uint256 burnFee = (taxFee * 30) / 100; // 30% do taxFee para queima
        uint256 reflectionFee = (taxFee * 70) / 100; // 70% do taxFee para reflexão
        uint256 totalFee = liquidityFee + burnFee + reflectionFee; // Taxas totais

        /// @dev Calcular reflexão recebida pelo userA
        uint256 totalSupplyExcludingFees = token.totalSupply() - burnFee;
        uint256 userAReflectionShare = ((initialUserABalance -
            transferAmount2) * 10 ** tokenParams.decimals) /
            totalSupplyExcludingFees;
        uint256 reflectionReceivedByUserA = (reflectionFee *
            userAReflectionShare) / 10 ** tokenParams.decimals;

        /// @dev Calcular saldos esperados
        uint256 expectedUserABalance = initialUserABalance -
            transferAmount2 +
            reflectionReceivedByUserA;
        uint256 expectedUserBBalance = 90000315;

        uint256 updatedUserABalance = token.balanceOf(userA);
        uint256 updatedUserBBalance = token.balanceOf(userB);

        console.log('Taxa de liquidez:', liquidityFee);
        console.log('Taxa de queima:', burnFee);
        console.log('Taxa de reflexao:', reflectionFee);
        console.log('Total de taxas:', totalFee);
        console.log(
            'Reflection recebida pelo userA:',
            reflectionReceivedByUserA
        );
        console.log(
            'Balance esperado userA apos transfer:',
            expectedUserABalance
        );
        console.log(
            'Balance esperado userB apos transfer:',
            expectedUserBBalance
        );
        console.log('Balance atual userA:', updatedUserABalance);
        console.log('Balance atual userB:', updatedUserBBalance);

        /// @dev Validar saldo do userA
        assertEq(
            updatedUserABalance,
            expectedUserABalance,
            'Balance do userA nao bate apos reflection'
        );

        /// @dev Validar saldo do userB
        assertEq(
            updatedUserBBalance,
            expectedUserBBalance,
            'Balance do userB nao bate apos reflection'
        );

        console.log('Reflection processada corretamente.');
    }

    /// @dev Test Swap and Liquidity
    function testSwapAndLiquifyEnabled() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST SWAP AND LIQUIFY ENABLED ----------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);

        /// @dev check initial state
        bool initialState = token.swapAndLiquifyEnabled();
        console.log('Estado inicial do swap:', initialState);

        /// @dev if disabled, enable first
        if (!initialState) {
            token.setSwapAndLiquifyEnabled(true);
            assertTrue(
                token.swapAndLiquifyEnabled(),
                'Deveria estar habilitado'
            );
        }

        /// @dev now disable
        token.setSwapAndLiquifyEnabled(false);
        assertFalse(
            token.swapAndLiquifyEnabled(),
            'Deveria estar desabilitado'
        );

        /// @dev enable again
        token.setSwapAndLiquifyEnabled(true);
        assertTrue(token.swapAndLiquifyEnabled(), 'Deveria estar habilitado');

        vm.stopPrank();

        console.log('Estado final do swap:', token.swapAndLiquifyEnabled());
        console.log('\n');
    }

    function testFeeLimits() public {
        console.log('-------------------------------------------------');
        console.log('-------------- TEST FEE LIMITS ------------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);

        /// @dev Testar tentativa de configurar taxas que excedem 100%
        uint256 invalidTaxFee = 60;
        uint256 invalidLiquidityFee = 50;

        console.log('Tentando setar taxas invalidas:');
        console.log('Tax Fee:', invalidTaxFee);
        console.log('Liquidity Fee:', invalidLiquidityFee);
        console.log('Total:', invalidTaxFee + invalidLiquidityFee);

        vm.expectRevert(
            abi.encodeWithSelector(
                FeesExceeded.selector,
                invalidTaxFee + invalidLiquidityFee
            )
        );
        token.setFees(invalidTaxFee, invalidLiquidityFee);

        /// @dev Testar valores válidos dentro do limite
        uint256 validTaxFee = 30;
        uint256 validLiquidityFee = 20;

        console.log('Setando taxas validas no limite:');
        console.log('Tax Fee:', validTaxFee);
        console.log('Liquidity Fee:', validLiquidityFee);
        console.log('Total:', validTaxFee + validLiquidityFee);

        token.setFees(validTaxFee, validLiquidityFee);

        assertEq(token.taxFee(), validTaxFee, 'Tax Fee nao foi atualizada');
        assertEq(
            token.liquidityFee(),
            validLiquidityFee,
            'Liquidity Fee nao foi atualizada'
        );

        vm.stopPrank();
        console.log('\n');
    }

    /// @dev test burn mechanism
    function testBurnMechanism() public {
        console.log('-------------------------------------------------');
        console.log('------------- TEST BURN MECHANISM ---------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        uint256 initialSupply = token.totalSupply();
        console.log('Supply inicial:', initialSupply);

        /// @dev Primeiro, transferir para uma conta não excluída (userA)
        uint256 transferAmount = 1000 * 10 ** tokenParams.decimals;
        vm.startPrank(owner);
        token.transfer(userA, transferAmount * 2); // Transferir o dobro para ter saldo suficiente
        vm.stopPrank();

        /// @dev Agora, realizar a transferência que deve disparar a queima (userA -> userB)
        vm.startPrank(userA);
        uint256 expectedBurn = (transferAmount * token.taxFee() * 30) / 10000;

        console.log('Valor a transferir:', transferAmount);
        console.log('Queima esperada:', expectedBurn);

        token.transfer(userB, transferAmount);
        vm.stopPrank();

        uint256 finalSupply = token.totalSupply();
        uint256 actualBurn = initialSupply - finalSupply;

        console.log('\nApos transfer:');
        console.log('Supply final:', finalSupply);
        console.log('Tokens queimados:', actualBurn);

        /// @dev Verificar se a queima está dentro da margem de erro aceitável
        uint256 marginOfError = expectedBurn / 100; // 1% de margem
        bool isWithinMargin = actualBurn >= expectedBurn - marginOfError &&
            actualBurn <= expectedBurn + marginOfError;

        assertTrue(isWithinMargin, 'Queima nao esta dentro da margem esperada');

        console.log('\n');
    }

    /// @dev test maxTxAmount
    function testMaxTxAmount() public {
        console.log('-------------------------------------------------');
        console.log('------------ TEST MAX TX AMOUNT -----------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);

        // Configurar mocks e estado inicial
        address factoryAddress = makeAddr('factory');
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('factory()'))),
            abi.encode(factoryAddress)
        );

        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('WBNB()'))),
            abi.encode(WBNB)
        );

        address pairAddress = makeAddr('pair');
        vm.mockCall(
            factoryAddress,
            abi.encodeWithSelector(
                bytes4(keccak256('createPair(address,address)'))
            ),
            abi.encode(pairAddress)
        );

        token.configureUniswap(routerAddress);

        // Testar transferência que excede o maxTxAmount
        uint256 amountExceedingMax = token.maxTxAmount() + 1;
        vm.expectRevert(TransferAmountExceedsMax.selector);
        token.transfer(userA, amountExceedingMax);
        vm.stopPrank();
    }

    /// @dev test numTokensSellToAddToLiquidity
    function testNumTokensSellToAddToLiquidity() public {
        console.log('-------------------------------------------------');
        console.log('------ TEST NUM TOKENS SELL TO ADD LIQUIDITY ----');
        console.log('-------------------------------------------------');
        console.log('\n');

        uint256 currentAmount = token.numTokensSellToAddToLiquidity();
        uint256 maxTx = token.maxTxAmount();

        /// @dev test with valid value (less than maxTxAmount)
        uint256 newValidAmount = maxTx / 2;

        console.log('Valor atual:', currentAmount);
        console.log('MaxTxAmount:', maxTx);
        console.log('Novo valor valido:', newValidAmount);

        vm.startPrank(owner);

        /// @dev test with valid value (less than maxTxAmount)
        token.setNumTokensSellToAddToLiquidity(
            newValidAmount / 10 ** tokenParams.decimals
        );
        assertEq(
            token.numTokensSellToAddToLiquidity(),
            newValidAmount,
            'Valor nao foi atualizado corretamente'
        );

        /// @dev test with invalid value (greater than maxTxAmount)
        uint256 invalidAmount = maxTx + 1000 * 10 ** tokenParams.decimals;
        console.log('Tentando setar valor invalido:', invalidAmount);

        vm.expectRevert(
            abi.encodeWithSelector(
                NumTokensSellToAddToLiquidityFailed.selector,
                invalidAmount,
                maxTx
            )
        );
        token.setNumTokensSellToAddToLiquidity(
            invalidAmount / 10 ** tokenParams.decimals
        );

        vm.stopPrank();

        console.log('Valor final:', token.numTokensSellToAddToLiquidity());
        console.log('\n');
    }

    /// @dev test update uniswapV2Router
    function testUpdateUniswapV2Router() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST UPDATE UNISWAP V2 ROUTER ----------');
        console.log('-------------------------------------------------');
        console.log('\n');

        address currentRouter = address(token.uniswapV2Router());
        address newRouter = makeAddr('newRouter');

        console.log('Router atual:', currentRouter);
        console.log('Novo router:', newRouter);

        vm.startPrank(owner);

        /// @dev test with valid address
        token.updateUniswapV2Router(newRouter);
        assertEq(
            address(token.uniswapV2Router()),
            newRouter,
            'Router nao foi atualizado'
        );

        /// @dev test with zero address
        vm.expectRevert(ZeroAddress.selector);
        token.updateUniswapV2Router(address(0));

        vm.stopPrank();

        console.log('Router apos update:', address(token.uniswapV2Router()));
        console.log('\n');
    }

    /// @dev test exclude from fee
    function testExcludeFromFee() public {
        console.log('-------------------------------------------------');
        console.log('--------- TEST EXCLUDE FROM FEE -----------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        address testUser = makeAddr('testUser');

        console.log('Testando exclusao/inclusao para:', testUser);
        console.log(
            'Status inicial excluido:',
            token.isAccountExcludedFromFree(testUser)
        );

        vm.startPrank(owner);

        /// @dev test inclusion in non-excluded account (should revert)
        vm.expectRevert(NotExcluded.selector);
        token.includeInFee(testUser);

        /// @dev test exclusion from fee
        token.excludeFromFee(testUser);
        assertTrue(
            token.isAccountExcludedFromFree(testUser),
            'Usuario nao foi excluido das taxas'
        );
        console.log(
            'Status apos exclusao:',
            token.isAccountExcludedFromFree(testUser)
        );

        /// @dev test attempt to exclude again (should revert)
        vm.expectRevert(AlreadyExcluded.selector);
        token.excludeFromFee(testUser);

        /// @dev test inclusion
        token.includeInFee(testUser);
        assertFalse(
            token.isAccountExcludedFromFree(testUser),
            'Usuario nao foi incluido nas taxas'
        );
        console.log(
            'Status apos inclusao:',
            token.isAccountExcludedFromFree(testUser)
        );

        /// @dev test attempt to include again (should revert)
        vm.expectRevert(NotExcluded.selector);
        token.includeInFee(testUser);

        vm.stopPrank();
        console.log('\n');
    }

    /// @dev test set fees
    function testSetFees() public {
        console.log('-------------------------------------------------');
        console.log('-------------- TEST SET FEES --------------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        uint256 currentTaxFee = token.taxFee();
        uint256 currentLiquidityFee = token.liquidityFee();
        console.log('Taxas atuais:');
        console.log('- Tax Fee:', currentTaxFee);
        console.log('- Liquidity Fee:', currentLiquidityFee);

        vm.startPrank(owner);

        /// @dev Testar valores válidos
        uint256 newTaxFee = 3;
        uint256 newLiquidityFee = 4;

        console.log('\nNovas taxas:');
        console.log('- Tax Fee:', newTaxFee);
        console.log('- Liquidity Fee:', newLiquidityFee);

        token.setFees(newTaxFee, newLiquidityFee);

        assertEq(token.taxFee(), newTaxFee, 'Tax Fee nao foi atualizada');
        assertEq(
            token.liquidityFee(),
            newLiquidityFee,
            'Liquidity Fee nao foi atualizada'
        );

        /// @dev Testar valores inválidos (total > 100%)
        uint256 invalidTaxFee = 50;
        uint256 invalidLiquidityFee = 51; // Total será 101%
        vm.expectRevert(
            abi.encodeWithSelector(
                FeesExceeded.selector,
                invalidTaxFee + invalidLiquidityFee
            )
        );
        token.setFees(invalidTaxFee, invalidLiquidityFee);

        vm.stopPrank();

        /// @dev Testar usuário não autorizado
        vm.startPrank(userA);
        vm.expectRevert(
            abi.encodeWithSelector(OwnableUnauthorizedAccount.selector, userA)
        );
        token.setFees(1, 1);
        vm.stopPrank();

        console.log('\nTaxas finais:');
        console.log('- Tax Fee:', token.taxFee());
        console.log('- Liquidity Fee:', token.liquidityFee());
        console.log('\n');
    }

    // ---------------------------------------------------------------------------
    /// @dev PancakeSwap or Swap Dex tests
    // ---------------------------------------------------------------------------

    /// @dev test add liquidity
    function testAddLiquidity() public {
        console.log('-------------------------------------------------');
        console.log('------------- TEST ADD LIQUIDITY ----------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);

        /// @dev configure Uniswap (PancakeSwap)
        token.configureUniswap(routerAddress);

        /// @dev setup to add liquidity
        uint256 tokenAmount = 1000 * 10 ** tokenParams.decimals;
        uint256 ethAmount = 1 ether;

        /// @dev check initial balance of owner
        uint256 ownerBalance = token.balanceOf(owner);
        console.log('\nBalance inicial do owner:', ownerBalance);
        console.log('Token amount para liquidez:', tokenAmount);
        console.log('ETH amount para liquidez:', ethAmount);

        /// @dev approve router to spend tokens
        token.approve(routerAddress, tokenAmount);

        /// @dev check allowance
        uint256 allowance = token.allowance(owner, routerAddress);
        console.log('Allowance para o router:', allowance);

        /// @dev give ETH to owner
        vm.deal(owner, ethAmount);
        console.log('ETH balance do owner:', address(owner).balance);

        console.log('\nAdicionando liquidez...');

        /// @dev add liquidity
        IUniswapV2Router02(routerAddress).addLiquidityETH{value: ethAmount}(
            address(token),
            tokenAmount,
            0, // slippage 100%
            0, // slippage 100%
            owner,
            block.timestamp + 300
        );

        vm.stopPrank();

        /// @dev check balances in the pair
        address pair = token.uniswapV2Pair();
        uint256 tokenBalance = token.balanceOf(pair);
        uint256 WBNBBalance = IERC20(WBNB).balanceOf(pair);

        console.log('Apos adicionar liquidez:');
        console.log('Token balance no par:', tokenBalance);
        console.log('WBNB balance no par:', WBNBBalance);
        console.log('ETH balance do owner:', address(owner).balance);

        assertTrue(tokenBalance > 0, 'Sem tokens no par');
        assertTrue(WBNBBalance > 0, 'Sem WBNB no par');

        /// @dev check if LP tokens were minted to the owner
        uint256 lpBalance = IERC20(pair).balanceOf(owner);
        console.log('LP tokens do owner:', lpBalance);
        assertTrue(lpBalance > 0, 'Owner nao recebeu LP tokens');

        console.log('\n');
    }

    /// @dev test swap tokens for ETH
    function testSwapExactTokensForETH() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST SWAP TOKENS FOR ETH ---------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev setup initial - add liquidity
        uint256 lpTokens = _addLiquidity(
            1000 * 10 ** tokenParams.decimals, // 1000 tokens
            1 ether // 1 BNB
        );
        console.log('LP Tokens recebidos:', lpTokens);

        /// @dev transfer some tokens to userA to test the swap
        uint256 amountIn = 100 * 10 ** tokenParams.decimals;
        vm.startPrank(owner);
        token.transfer(userA, amountIn);
        vm.stopPrank();

        uint256 userInitialBalance = token.balanceOf(userA);
        console.log('Balance inicial de tokens do userA:', userInitialBalance);

        vm.startPrank(userA);

        /// @dev approve tokens for the router
        token.approve(routerAddress, amountIn);

        /// @dev create path for swap
        address[] memory path = new address[](2);
        path[0] = address(token);
        path[1] = WBNB;

        /// @dev register initial ETH balance
        uint256 initialETHBalance = userA.balance;
        console.log('Balance inicial de ETH do userA:', initialETHBalance);

        console.log('\nExecutando swap...');

        /// @dev execute swap
        IUniswapV2Router02(routerAddress)
            .swapExactTokensForETHSupportingFeeOnTransferTokens(
                amountIn,
                0, // aceitar qualquer quantidade de ETH
                path,
                userA,
                block.timestamp + 300
            );

        vm.stopPrank();

        // Verificações finais
        uint256 finalTokenBalance = token.balanceOf(userA);
        uint256 finalETHBalance = userA.balance;

        console.log('\nApos swap:');
        console.log('Balance final de tokens:', finalTokenBalance);
        console.log('Balance final de ETH:', finalETHBalance);
        console.log('Tokens gastos:', userInitialBalance - finalTokenBalance);
        console.log('ETH recebido:', finalETHBalance - initialETHBalance);

        assertTrue(
            finalTokenBalance < userInitialBalance,
            'Tokens nao foram gastos'
        );
        assertTrue(finalETHBalance > initialETHBalance, 'ETH nao foi recebido');

        console.log('\n');
    }

    /// @dev test swap tokens for exact ETH
    function testSwapTokensForExactETH() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST SWAP TOKENS FOR EXACT ETH ----------');
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev setup initial - liquidity respecting the maxTransaction
        uint256 maxTx = token.maxTxAmount();
        console.log('Max Transaction:', maxTx);

        uint256 lpTokens = _addLiquidity(
            maxTx, // usando exatamente o maxTransaction
            100 ether // 100 BNB
        );
        console.log('LP Tokens recebidos:', lpTokens);

        /// @dev transfer tokens to userA (value less than maxTx)
        uint256 initialAmount = maxTx / 10; // 10% of maxTransaction
        vm.startPrank(owner);
        token.transfer(userA, initialAmount);
        vm.stopPrank();

        vm.startPrank(userA);

        /// @dev approve tokens for the router
        token.approve(routerAddress, initialAmount);

        /// @dev calculate amount of tokens to spend (still less than maxTx)
        uint256 tokensToSpend = maxTx / 20; // 5% of maxTransaction

        /// @dev create path for swap
        address[] memory path = new address[](2);
        path[0] = address(token);
        path[1] = WBNB;

        uint256 initialETHBalance = userA.balance;
        uint256 initialTokenBalance = token.balanceOf(userA);

        console.log('\nAntes do swap:');
        console.log('Balance inicial de tokens:', initialTokenBalance);
        console.log('Balance inicial de ETH:', initialETHBalance);
        console.log('Tokens a gastar:', tokensToSpend);

        /// @dev execute swap using the function that supports fees
        IUniswapV2Router02(routerAddress)
            .swapExactTokensForETHSupportingFeeOnTransferTokens(
                tokensToSpend,
                0, // Aceitar qualquer quantidade de ETH
                path,
                userA,
                block.timestamp + 300
            );

        vm.stopPrank();

        uint256 finalTokenBalance = token.balanceOf(userA);
        uint256 finalETHBalance = userA.balance;

        console.log('\nApos swap:');
        console.log('Balance final de tokens:', finalTokenBalance);
        console.log('Balance final de ETH:', finalETHBalance);
        console.log('Tokens gastos:', initialTokenBalance - finalTokenBalance);
        console.log('ETH recebido:', finalETHBalance - initialETHBalance);

        assertTrue(
            finalTokenBalance < initialTokenBalance,
            'Tokens nao foram gastos'
        );
        assertTrue(finalETHBalance > initialETHBalance, 'ETH nao foi recebido');

        console.log('\n');
    }

    /// @dev test swap ETH for tokens
    function testSwapExactETHForTokens() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST SWAP ETH FOR TOKENS ----------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev setup initial - liquidity respecting the maxTransaction
        uint256 maxTx = token.maxTxAmount();
        console.log('Max Transaction:', maxTx);

        uint256 lpTokens = _addLiquidity(maxTx, 100 ether);
        console.log('LP Tokens recebidos:', lpTokens);

        /// @dev setup for the swap
        vm.deal(userA, 1 ether); // Give 1 BNB to userA

        vm.startPrank(userA);

        /// @dev create path for swap
        address[] memory path = new address[](2);
        path[0] = WBNB;
        path[1] = address(token);

        uint256 initialETHBalance = userA.balance;
        uint256 initialTokenBalance = token.balanceOf(userA);
        uint256 swapAmount = 0.1 ether;

        console.log('\nAntes do swap:');
        console.log('Balance inicial de tokens:', initialTokenBalance);
        console.log('Balance inicial de ETH:', initialETHBalance);
        console.log('ETH para swap:', swapAmount);

        /// @dev execute swap
        IUniswapV2Router02(routerAddress)
            .swapExactETHForTokensSupportingFeeOnTransferTokens{
            value: swapAmount
        }(
            0, // Aceitar qualquer quantidade de tokens
            path,
            userA,
            block.timestamp + 300
        );

        vm.stopPrank();

        uint256 finalTokenBalance = token.balanceOf(userA);
        uint256 finalETHBalance = userA.balance;

        console.log('\nApos swap:');
        console.log('Balance final de tokens:', finalTokenBalance);
        console.log('Balance final de ETH:', finalETHBalance);
        console.log('ETH gasto:', initialETHBalance - finalETHBalance);
        console.log(
            'Tokens recebidos:',
            finalTokenBalance - initialTokenBalance
        );

        assertTrue(finalETHBalance < initialETHBalance, 'ETH nao foi gasto');
        assertTrue(
            finalTokenBalance > initialTokenBalance,
            'Tokens nao foram recebidos'
        );

        /// @dev check if the fees were applied correctly
        uint256 pairBalance = token.balanceOf(token.uniswapV2Pair());
        console.log('\nBalance do par apos swap:', pairBalance);

        console.log('\n');
    }

    /// @dev test remove liquidity
    function testRemoveLiquidity() public {
        console.log('-------------------------------------------------');
        console.log('------------- TEST REMOVE LIQUIDITY -------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev first add liquidity
        uint256 maxTx = token.maxTxAmount();
        uint256 lpTokens = _addLiquidity(maxTx, 10 ether);

        address pair = token.uniswapV2Pair();
        console.log('LP Tokens recebidos:', lpTokens);

        vm.startPrank(owner);

        /// @dev approve LP tokens for the router
        IERC20(pair).approve(routerAddress, lpTokens);

        /// @dev register initial balances
        uint256 initialTokenBalance = token.balanceOf(owner);
        uint256 initialETHBalance = address(owner).balance;

        console.log('\nAntes de remover liquidez:');
        console.log('Balance inicial de tokens:', initialTokenBalance);
        console.log('Balance inicial de ETH:', initialETHBalance);
        console.log('LP tokens para remover:', lpTokens);

        /// @dev remove liquidity
        (uint256 amountToken, uint256 amountETH) = IUniswapV2Router02(
            routerAddress
        ).removeLiquidityETH(
                address(token),
                lpTokens,
                0, // min tokens
                0, // min ETH
                owner,
                block.timestamp + 300
            );

        vm.stopPrank();

        console.log('\nApos remover liquidez:');
        console.log('Tokens recebidos:', amountToken);
        console.log('ETH recebido:', amountETH);
        console.log('Balance final de tokens:', token.balanceOf(owner));
        console.log('Balance final de ETH:', address(owner).balance);

        /// @dev check if the pair is empty
        uint256 pairTokenBalance = token.balanceOf(pair);
        uint256 pairETHBalance = IERC20(WBNB).balanceOf(pair);

        console.log('\nBalances do par:');
        console.log('Tokens restantes no par:', pairTokenBalance);
        console.log('ETH restante no par:', pairETHBalance);

        assertTrue(
            token.balanceOf(owner) > initialTokenBalance,
            'Tokens nao foram recebidos'
        );
        assertTrue(
            address(owner).balance > initialETHBalance,
            'ETH nao foi recebido'
        );

        console.log('\n');
    }
    // ---------------------------------------------------------------------------

    /// @dev auxiliar functionks

    function _addLiquidity(
        uint256 tokenAmount,
        uint256 ethAmount
    ) internal returns (uint256 lpTokens) {
        vm.startPrank(owner);

        /// @dev configure Uniswap if it's not already configured
        if (address(token.uniswapV2Router()) == address(0)) {
            token.configureUniswap(routerAddress);
        }

        /// @dev approve router to spend tokens
        token.approve(routerAddress, tokenAmount);

        /// @dev give ETH to owner
        vm.deal(owner, ethAmount);

        /// @dev add liquidity
        (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        ) = IUniswapV2Router02(routerAddress).addLiquidityETH{value: ethAmount}(
                address(token),
                tokenAmount,
                0, // slippage 100%
                0, // slippage 100%
                owner,
                block.timestamp + 300
            );

        vm.stopPrank();

        /// @dev security checks
        address pair = token.uniswapV2Pair();
        require(
            token.balanceOf(pair) >= amountToken,
            'Tokens nao foram transferidos para o par'
        );
        require(
            IERC20(WBNB).balanceOf(pair) >= amountETH,
            'WBNB nao foi transferido para o par'
        );

        /// @dev return amount of LP tokens received
        lpTokens = IERC20(pair).balanceOf(owner);
        require(lpTokens > 0, 'LP tokens nao foram mintados');
        require(
            lpTokens == liquidity,
            'LP tokens nao correspondem ao retorno da funcao'
        );

        return lpTokens;
    }

    /// @dev test reflection balance of complete
    function testReflectionBalanceOfComplete() public {
        vm.startPrank(owner);

        /// @dev test with zero address
        vm.expectRevert('Zero address');
        token.reflectionBalanceOf(address(0));

        /// @dev test with valid address before any transfer
        uint256 initialReflection = token.reflectionBalanceOf(owner);
        assertGt(initialReflection, 0, 'Initial reflection should be positive');

        /// @dev test after transfer with fees
        token.transfer(userA, 1000);
        uint256 reflectionAfterTransfer = token.reflectionBalanceOf(userA);
        assertGt(
            reflectionAfterTransfer,
            0,
            'Reflection after transfer should be positive'
        );

        vm.stopPrank();
    }

    /// @dev test transferFrom complete
    function testTransferFromComplete() public {
        /// @dev First test: transferFrom without approval
        vm.startPrank(userA);
        vm.expectRevert(
            abi.encodeWithSelector(InsufficientBalance.selector, 0, 100)
        );
        token.transferFrom(owner, userB, 100);
        vm.stopPrank();

        /// @dev Setup for the next tests
        vm.startPrank(owner);
        token.approve(userA, 50);
        vm.stopPrank();

        /// @dev Second test: insufficient approval
        vm.startPrank(userA);
        vm.expectRevert(
            abi.encodeWithSelector(InsufficientBalance.selector, 50, 100)
        );
        token.transferFrom(owner, userB, 100);
        vm.stopPrank();

        /// @dev Setup for the final test
        vm.startPrank(owner);
        token.approve(userA, 200);
        vm.stopPrank();

        /// @dev Third test: sufficient approval
        vm.startPrank(userA);
        token.transferFrom(owner, userB, 100);
        vm.stopPrank();

        /// @dev Final checks
        assertEq(
            token.allowance(owner, userA),
            100,
            'Allowance not properly decreased'
        );
    }

    /// @dev test updateUniswapV2RouterComplete
    function testUpdateUniswapV2RouterComplete() public {
        vm.startPrank(owner);

        /// @dev Test with zero address
        vm.expectRevert(abi.encodeWithSelector(ZeroAddress.selector));
        token.updateUniswapV2Router(address(0));

        /// @dev Test update to new router
        address newRouter = makeAddr('newRouter');
        token.updateUniswapV2Router(newRouter);
        assertEq(
            address(token.uniswapV2Router()),
            newRouter,
            'Router not updated'
        );

        /// @dev Test multiple updates
        address newerRouter = makeAddr('newerRouter');
        token.updateUniswapV2Router(newerRouter);
        assertEq(
            address(token.uniswapV2Router()),
            newerRouter,
            'Router not updated again'
        );

        vm.stopPrank();
    }

    function testSetNumTokensSellToAddToLiquidityComplete() public {
        vm.startPrank(owner);

        uint256 maxTx = token.maxTxAmount();

        /// @dev test with value greater than maxTxAmount
        uint256 tooLarge = maxTx / (10 ** token.decimals()) + 1;
        vm.expectRevert(
            abi.encodeWithSelector(
                NumTokensSellToAddToLiquidityFailed.selector,
                tooLarge * 10 ** token.decimals(),
                maxTx
            )
        );
        token.setNumTokensSellToAddToLiquidity(tooLarge);

        /// @dev test with valid amount
        uint256 validAmount = maxTx / (10 ** token.decimals()) / 2;
        token.setNumTokensSellToAddToLiquidity(validAmount);
        assertEq(
            token.numTokensSellToAddToLiquidity(),
            validAmount * 10 ** token.decimals(),
            'Value not updated correctly'
        );

        /// @dev test with minimum value
        token.setNumTokensSellToAddToLiquidity(1);
        assertEq(
            token.numTokensSellToAddToLiquidity(),
            1 * 10 ** token.decimals(),
            'Minimum value not set correctly'
        );

        vm.stopPrank();
    }

    /// @dev test approve edge cases
    function testApproveEdgeCases() public {
        vm.startPrank(owner);

        /// @dev test with zero address
        vm.expectRevert(abi.encodeWithSelector(ZeroAddress.selector));
        token.approve(address(0), 100);

        /// @dev test with zero value
        token.approve(userA, 0);
        assertEq(token.allowance(owner, userA), 0, 'Allowance should be zero');

        /// @dev test with maximum value
        token.approve(userA, type(uint256).max);
        assertEq(
            token.allowance(owner, userA),
            type(uint256).max,
            'Allowance should be max'
        );

        vm.stopPrank();
    }

    /// @dev test receive function
    function testReceiveFunction() public {
        vm.startPrank(owner);

        /// @dev test sending ETH directly to the contract
        vm.deal(owner, 1 ether);
        (bool success, ) = address(token).call{value: 1 ether}('');
        assertTrue(success, 'Should accept ETH');
        assertEq(
            address(token).balance,
            1 ether,
            'Contract balance should increase'
        );

        vm.stopPrank();
    }

    /// @dev test swapAndLiquify with zero balance
    function testSwapAndLiquifyWithZeroBalance() public {
        vm.startPrank(owner);

        /// @dev setup
        address factoryAddress = makeAddr('factory');
        _setupMocks(factoryAddress);
        token.configureUniswap(routerAddress);
        token.setSwapAndLiquifyEnabled(true);

        /// @dev test with zero balance
        uint256 balanceBefore = token.balanceOf(address(token));
        require(balanceBefore == 0, 'Contract should have zero balance');

        /// @dev transfer should not trigger swap
        token.transfer(userA, 100);

        /// @dev verify that nothing changed
        assertEq(
            token.balanceOf(address(token)),
            0,
            'Balance should remain zero'
        );

        vm.stopPrank();
    }

    /// @dev test transfer with maximum values
    function testTransferWithMaximumValues() public {
        vm.startPrank(owner);

        // Configurar mocks e estado inicial
        address factoryAddress = makeAddr('factory');
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('factory()'))),
            abi.encode(factoryAddress)
        );

        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('WBNB()'))),
            abi.encode(WBNB)
        );

        address pairAddress = makeAddr('pair');
        vm.mockCall(
            factoryAddress,
            abi.encodeWithSelector(
                bytes4(keccak256('createPair(address,address)'))
            ),
            abi.encode(pairAddress)
        );

        token.configureUniswap(routerAddress);

        // Testar transferência que excede o maxTxAmount
        uint256 amountExceedingMax = token.maxTxAmount() + 1;
        vm.expectRevert(TransferAmountExceedsMax.selector);
        token.transfer(userA, amountExceedingMax);

        vm.stopPrank();
    }

    /// @dev test transfer with maximum fees
    function testTransferWithMaximumFees() public {
        vm.startPrank(owner);

        /// @dev Configurar taxas máximas
        token.setFees(49, 49); // Total 98%

        /// @dev Realizar transferência com taxas máximas
        uint256 amount = 1000 * 10 ** token.decimals();
        uint256 initialBalance = token.balanceOf(userA);

        /// @dev Incluir o owner nas taxas para testar taxas máximas
        token.includeInFee(owner);
        token.transfer(userA, amount);

        /// @dev Verificar se o valor recebido é aproximadamente 1% do valor enviado
        uint256 burnFee = (amount * token.taxFee() * 30) / 10000;
        uint256 reflectFee = (amount * token.taxFee() * 70) / 10000;
        uint256 liquidityFee = (amount * token.liquidityFee()) / 100;
        uint256 totalFee = burnFee + reflectFee + liquidityFee;
        uint256 expectedAmount = amount - totalFee;

        uint256 actualBalance = token.balanceOf(userA) - initialBalance;

        /// @dev Margem de erro de 0.1%
        uint256 marginOfError = expectedAmount / 1000;
        bool isWithinMargin = actualBalance >= expectedAmount - marginOfError &&
            actualBalance <= expectedAmount + marginOfError;

        assertTrue(
            isWithinMargin,
            string(
                abi.encodePacked(
                    'Transfer with maximum fees failed. Received: ',
                    vm.toString(actualBalance),
                    ', Expected: ',
                    vm.toString(expectedAmount),
                    ' +/- ',
                    vm.toString(marginOfError)
                )
            )
        );

        vm.stopPrank();
    }

    function testSwapAndLiquifyWithMinimumAmount() public {
        vm.startPrank(owner);

        /// @dev Setup
        address factoryAddress = makeAddr('factory');
        _setupMocks(factoryAddress);
        token.configureUniswap(routerAddress);
        token.setSwapAndLiquifyEnabled(true);

        /// @dev Set minimum value to trigger swap
        token.setNumTokensSellToAddToLiquidity(1);

        /// @dev Mock for swap
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(
                IUniswapV2Router02
                    .swapExactTokensForETHSupportingFeeOnTransferTokens
                    .selector
            ),
            abi.encode()
        );

        /// @dev Transfer exact amount to trigger swap
        uint256 minAmount = token.numTokensSellToAddToLiquidity();
        token.transfer(address(token), minAmount);

        /// @dev Verify if swap was triggered
        assertTrue(token.swapAndLiquifyEnabled(), 'Swap should remain enabled');

        vm.stopPrank();
    }

    function testReflectionWithZeroFees() public {
        vm.startPrank(owner);

        // Configurar todas as taxas como zero
        token.setFees(0, 0);

        // Transferir tokens
        uint256 amount = 1000;
        uint256 initialReflection = token.reflectionBalanceOf(userA);
        token.transfer(userA, amount);

        // Verificar se não houve reflexão
        assertEq(
            token.reflectionBalanceOf(userA),
            initialReflection + amount,
            'Reflection should equal transfer amount with zero fees'
        );

        vm.stopPrank();
    }

    /// @dev test ownership transfer
    function testOwnershipTransfer() public {
        vm.startPrank(owner);

        /// @dev Testing ownership transfer
        token.transferOwnership(userA);
        assertEq(token.owner(), userA, 'Ownership not transferred');

        /// @dev Testing transfer to zero address
        vm.startPrank(userA);
        vm.expectRevert(
            abi.encodeWithSelector(OwnableInvalidOwner.selector, address(0))
        );
        token.transferOwnership(address(0));

        /// @dev Testing renounceOwnership
        token.renounceOwnership();
        assertEq(token.owner(), address(0), 'Ownership not renounced');

        vm.stopPrank();
    }

    /// @dev test isSwapAndLiquifyEnabled
    function testIsSwapAndLiquifyEnabled() public {
        vm.startPrank(owner);

        /// @dev Testing initial state
        assertFalse(
            token.isSwapAndLiquifyEnabled(),
            'Should be disabled initially'
        );

        /// @dev Testing after enabling
        token.setSwapAndLiquifyEnabled(true);
        assertTrue(token.isSwapAndLiquifyEnabled(), 'Should be enabled');

        vm.stopPrank();
    }

    /// @dev test swapAndLiquify complete
    function testSwapAndLiquifyComplete() public {
        vm.startPrank(owner);

        // Configurar mocks e estado inicial
        address factoryAddress = makeAddr('factory');
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('factory()'))),
            abi.encode(factoryAddress)
        );

        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('WBNB()'))),
            abi.encode(WBNB)
        );

        address pairAddress = makeAddr('pair');
        vm.mockCall(
            factoryAddress,
            abi.encodeWithSelector(
                bytes4(keccak256('createPair(address,address)'))
            ),
            abi.encode(pairAddress)
        );

        token.configureUniswap(routerAddress);
        token.setSwapAndLiquifyEnabled(true);

        // Mock router calls
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(
                bytes4(
                    keccak256(
                        'swapExactTokensForETHSupportingFeeOnTransferTokens(uint256,uint256,address[],address,uint256)'
                    )
                )
            ),
            abi.encode()
        );

        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(
                bytes4(
                    keccak256(
                        'addLiquidityETH(address,uint256,uint256,uint256,address,uint256)'
                    )
                )
            ),
            abi.encode(1000, 500, 100)
        );

        // Testar transferência que excede o maxTxAmount
        uint256 amountExceedingMax = token.maxTxAmount() + 1;
        vm.expectRevert(TransferAmountExceedsMax.selector);
        token.transfer(address(token), amountExceedingMax);

        vm.stopPrank();
    }
    /// @dev helper function to setup mocks
    function _setupMocks(address factoryAddress) private {
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('factory()'))),
            abi.encode(factoryAddress)
        );

        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('WBNB()'))),
            abi.encode(WBNB)
        );

        address pairAddress = makeAddr('pair');
        vm.mockCall(
            factoryAddress,
            abi.encodeWithSelector(
                bytes4(keccak256('createPair(address,address)'))
            ),
            abi.encode(pairAddress)
        );
    }
}
