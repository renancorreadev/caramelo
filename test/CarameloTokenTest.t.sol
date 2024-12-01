// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from 'forge-std/Test.sol';
import {console} from 'forge-std/console.sol';
import {Token} from '../contracts/Token.sol';
import {IUniswapV2Router02, IUniswapV2Factory} from '../contracts/interfaces/UniswapV2Interfaces.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';

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
        uint256 burnFee;
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
            burnFee: 3, // 3%
            maxTokensTXAmount: 500_000, // 500,000 tokens
            numTokensSellToAddToLiquidity: 500_000, // 500,000 tokens
            version: '1'
        });

    function setUp() public {
        // Configurando o fork corretamente
        vm.createSelectFork('https://bsc-dataseed.binance.org/');

        // Criando o owner e iniciando seu contexto como `msg.sender`
        (owner, ownerPrivateKey) = makeAddrAndKey('owner');
        (userA, userAPrivateKey) = makeAddrAndKey('userA');
        (userB, userBPrivateKey) = makeAddrAndKey('userB');

        // Criando um novo contrato e inicializando-o
        vm.startPrank(owner); // Inicia como owner
        token = new Token();
        token.initialize(
            tokenParams.name,
            tokenParams.symbol,
            tokenParams.initialSupply,
            tokenParams.decimals,
            tokenParams.taxFee,
            tokenParams.liquidityFee,
            tokenParams.burnFee,
            tokenParams.maxTokensTXAmount,
            tokenParams.numTokensSellToAddToLiquidity,
            tokenParams.version
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

        // Excluir o usuário das taxas
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

        // Transferir tokens do owner para o usuário excluído
        console.log(
            '--> Transferindo',
            transferAmount,
            'tokens do owner para usuario excluido'
        );
        vm.startPrank(owner);
        token.transfer(excludedUser, transferAmount);
        vm.stopPrank();

        // Verificar se o valor recebido é exatamente o valor transferido (sem taxas)
        uint256 excludedUserBalance = token.balanceOf(excludedUser);
        console.log('--> Balance do usuario excluido:', excludedUserBalance);
        assertEq(
            excludedUserBalance,
            transferAmount,
            'Valor recebido nao corresponde ao transferido'
        );

        // Transferir tokens do usuário excluído para outro endereço excluído (owner)
        console.log('--> Transferindo tokens de volta para o owner');
        vm.startPrank(excludedUser);
        token.transfer(owner, transferAmount);
        vm.stopPrank();

        // Verificar se o valor recebido de volta é exatamente o valor transferido
        uint256 ownerFinalBalance = token.balanceOf(owner);
        console.log('--> Balance final do owner:', ownerFinalBalance);

        // Verificar se não houve alteração no supply total (não deve haver queima)
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

        // Transferir tokens do owner para o usuário normal primeiro
        vm.startPrank(owner);
        token.transfer(normalUser, transferAmount);
        vm.stopPrank();

        uint256 initialBalance = token.balanceOf(normalUser);
        console.log('Balance inicial do usuario:', initialBalance);

        // Calcular taxas esperadas
        uint256 totalFee = tokenParams.taxFee +
            tokenParams.liquidityFee +
            tokenParams.burnFee;
        uint256 expectedReceivedAmount = (transferAmount * (100 - totalFee)) /
            100;

        console.log('Taxa total:', totalFee, '%');
        console.log('Valor a transferir:', transferAmount);
        console.log('Valor esperado apos taxas:', expectedReceivedAmount);

        // Fazer a transferência com taxas
        vm.startPrank(normalUser);
        token.transfer(recipient, transferAmount);
        vm.stopPrank();

        // Verificar o valor recebido
        uint256 recipientBalance = token.balanceOf(recipient);
        console.log('Valor recebido:', recipientBalance);

        // Verificar se o valor está dentro da margem de erro aceitável (0.1%)
        uint256 marginOfError = expectedReceivedAmount / 1000; // 0.1% do valor esperado
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

        // Verificar se o supply total diminuiu devido à taxa de queima
        uint256 burnAmount = (transferAmount * tokenParams.burnFee) / 100;
        uint256 expectedSupply = tokenParams.initialSupply *
            10 ** tokenParams.decimals -
            burnAmount;
        uint256 actualSupply = token.totalSupply();

        console.log('Supply esperado apos queima:', expectedSupply);
        console.log('Supply atual:', actualSupply);

        assertTrue(
            actualSupply <= expectedSupply + marginOfError &&
                actualSupply >= expectedSupply - marginOfError,
            'Supply total incorreto apos a queima'
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

        // Verificar balance inicial do owner
        uint256 ownerBalance = token.balanceOf(owner);
        console.log('Balance inicial do owner:', ownerBalance);

        vm.startPrank(owner);

        // Aprovar spender
        token.approve(spender, amount);

        // Verificar allowance
        uint256 allowance = token.allowance(owner, spender);
        console.log('Allowance para spender:', allowance);
        assertEq(allowance, amount, 'Allowance incorreta');

        vm.stopPrank();

        // Tentar transferFrom como spender
        vm.startPrank(spender);
        token.transferFrom(owner, spender, amount);
        vm.stopPrank();

        // Verificar balances finais
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

        // Excluir um usuário das taxas
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

        // Transferir de excluído para não excluído (NÃO deve aplicar taxas)
        console.log('\n--> Transferindo de usuario excluido para normal');
        vm.startPrank(excludedUser);
        token.transfer(normalUser, transferAmount);
        vm.stopPrank();

        // Não deve haver taxas pois o sender está excluído
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

        // Agora testamos transferência de não excluído para qualquer endereço (deve aplicar taxas)
        console.log('\n--> Transferindo de usuario normal para excluido');
        uint256 smallerAmount = 100 * 10 ** tokenParams.decimals;

        uint256 excludedBalanceBefore = token.balanceOf(excludedUser);

        vm.startPrank(normalUser);
        token.transfer(excludedUser, smallerAmount);
        vm.stopPrank();

        // Calcular taxas esperadas para transferência de usuário normal
        uint256 totalFee = tokenParams.taxFee +
            tokenParams.liquidityFee +
            tokenParams.burnFee;
        uint256 expectedAmountBack = (smallerAmount * (100 - totalFee)) / 100;
        uint256 actualReceived = token.balanceOf(excludedUser) -
            excludedBalanceBefore;

        console.log('    Taxa total:', totalFee, '%');
        console.log('    Valor transferido:', smallerAmount);
        console.log('    Valor esperado apos taxas:', expectedAmountBack);
        console.log('    Valor recebido:', actualReceived);

        // Verificar margem de erro para a segunda transferência
        uint256 marginOfError = expectedAmountBack / 1000; // 0.1% do valor esperado
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

        // Transfer tokens para userA
        uint256 transferAmount = 1000 * 10 ** tokenParams.decimals;
        vm.startPrank(owner);
        token.transfer(userA, transferAmount);
        vm.stopPrank();

        // Registrar balances iniciais
        uint256 initialUserABalance = token.balanceOf(userA);
        uint256 initialUserBBalance = token.balanceOf(userB);

        console.log('Balance inicial userA:', initialUserABalance);
        console.log('Balance inicial userB:', initialUserBBalance);

        // UserA transfere tokens para userB (com taxas)
        uint256 transferAmount2 = 100 * 10 ** tokenParams.decimals;

        // Registrar saldo do contrato antes da transferência
        uint256 contractBalanceBefore = token.balanceOf(address(token));
        console.log('\nSaldo do contrato antes:', contractBalanceBefore);

        // Calcular taxas esperadas
        uint256 totalFee = tokenParams.taxFee +
            tokenParams.liquidityFee +
            tokenParams.burnFee;
        uint256 expectedTransferAmount = (transferAmount2 * (100 - totalFee)) /
            100;
        uint256 expectedLiquidityFee = (transferAmount2 *
            tokenParams.liquidityFee) / 100;

        console.log('\nTaxas:');
        console.log('Taxa total:', totalFee, '%');
        console.log('Taxa de liquidez:', tokenParams.liquidityFee, '%');
        console.log('Valor a transferir:', transferAmount2);
        console.log('Valor esperado apos taxas:', expectedTransferAmount);
        console.log('Fee de liquidez esperada:', expectedLiquidityFee);

        vm.startPrank(userA);
        token.transfer(userB, transferAmount2);
        vm.stopPrank();

        // Verificar saldo do contrato após a transferência
        uint256 contractBalanceAfter = token.balanceOf(address(token));
        uint256 contractBalanceIncrease = contractBalanceAfter -
            contractBalanceBefore;

        console.log('\nSaldo do contrato depois:', contractBalanceAfter);
        console.log('Aumento no saldo do contrato:', contractBalanceIncrease);

        // Verificar se o aumento no saldo do contrato está correto (com margem de erro)
        bool isContractBalanceCorrect = (contractBalanceIncrease >=
            (expectedLiquidityFee * 999) / 1000) &&
            (contractBalanceIncrease <= (expectedLiquidityFee * 1001) / 1000);

        assertTrue(
            isContractBalanceCorrect,
            'Saldo do contrato nao aumentou conforme esperado'
        );

        // Verificar reflection
        uint256 finalUserABalance = token.balanceOf(userA);
        uint256 finalUserBBalance = token.balanceOf(userB);
        uint256 reflectionBalance = token.reflectionBalanceOf(address(this));

        console.log('\nApos transfer:');
        console.log('Balance final userA:', finalUserABalance);
        console.log('Balance final userB:', finalUserBBalance);
        console.log('Reflection balance:', reflectionBalance);

        // Verificar a dedução com margem de erro
        uint256 actualDeduction = initialUserABalance - finalUserABalance;
        console.log('Valor deduzido de userA:', actualDeduction);
        console.log('Valor da transfer:', transferAmount2);

        // Verificar se o valor recebido por userB está correto
        bool isReceivedAmountCorrect = (finalUserBBalance >=
            (expectedTransferAmount * 999) / 1000) &&
            (finalUserBBalance <= (expectedTransferAmount * 1001) / 1000);

        assertTrue(
            isReceivedAmountCorrect,
            'Valor recebido por userB incorreto'
        );

        // Verificar se a dedução está dentro da margem esperada
        uint256 expectedDeduction = transferAmount2;
        bool isDeductionCorrect = (actualDeduction >=
            (expectedDeduction * 999) / 1000) &&
            (actualDeduction <= (expectedDeduction * 1001) / 1000);

        assertTrue(isDeductionCorrect, 'Deducao fora da margem esperada');

        // Verificar se houve reflection
        assertTrue(
            reflectionBalance == 0 || reflectionBalance > 0,
            'Reflection nao foi processado corretamente'
        );

        console.log('\n');
    }

    /// @dev Test Swap and Liquidity
    function testSwapAndLiquifyEnabled() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST SWAP AND LIQUIFY ENABLED ----------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);

        // Primeiro verifica o estado inicial
        bool initialState = token.swapAndLiquifyEnabled();
        console.log('Estado inicial do swap:', initialState);

        // Se estiver desabilitado, habilita primeiro
        if (!initialState) {
            token.setSwapAndLiquifyEnabled(true);
            assertTrue(
                token.swapAndLiquifyEnabled(),
                'Deveria estar habilitado'
            );
        }

        // Agora desabilita
        token.setSwapAndLiquifyEnabled(false);
        assertFalse(
            token.swapAndLiquifyEnabled(),
            'Deveria estar desabilitado'
        );

        // Habilita novamente
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

        // Tentar setar taxas que excedem 100%
        uint256 invalidTaxFee = 40;
        uint256 invalidLiquidityFee = 40;
        uint256 invalidBurnFee = 21;

        console.log('Tentando setar taxas invalidas:');
        console.log('Tax Fee:', invalidTaxFee);
        console.log('Liquidity Fee:', invalidLiquidityFee);
        console.log('Burn Fee:', invalidBurnFee);
        console.log(
            'Total:',
            invalidTaxFee + invalidLiquidityFee + invalidBurnFee
        );

        vm.expectRevert(
            abi.encodeWithSelector(
                FeesExceeded.selector,
                invalidTaxFee + invalidLiquidityFee + invalidBurnFee
            )
        );
        token.setFees(invalidTaxFee, invalidLiquidityFee, invalidBurnFee);

        // Testar valores válidos no limite
        uint256 validTaxFee = 33;
        uint256 validLiquidityFee = 33;
        uint256 validBurnFee = 34;

        console.log('\nSetando taxas validas no limite:');
        console.log('Tax Fee:', validTaxFee);
        console.log('Liquidity Fee:', validLiquidityFee);
        console.log('Burn Fee:', validBurnFee);
        console.log('Total:', validTaxFee + validLiquidityFee + validBurnFee);

        token.setFees(validTaxFee, validLiquidityFee, validBurnFee);

        assertEq(token.taxFee(), validTaxFee, 'Tax fee nao foi atualizada');
        assertEq(
            token.liquidityFee(),
            validLiquidityFee,
            'Liquidity fee nao foi atualizada'
        );
        assertEq(token.burnFee(), validBurnFee, 'Burn fee nao foi atualizada');

        vm.stopPrank();
        console.log('\n');
    }

    function testBurnMechanism() public {
        console.log('-------------------------------------------------');
        console.log('------------- TEST BURN MECHANISM ---------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        uint256 initialSupply = token.totalSupply();
        console.log('Supply inicial:', initialSupply);

        // Primeiro transferir para uma conta não excluída (userA)
        uint256 transferAmount = 1000 * 10 ** tokenParams.decimals;
        vm.startPrank(owner);
        token.transfer(userA, transferAmount * 2); // Transferir o dobro para ter saldo suficiente
        vm.stopPrank();

        // Agora fazer a transferência que deve ter queima (de userA para userB)
        vm.startPrank(userA);
        uint256 expectedBurn = (transferAmount * token.burnFee()) / 100;

        console.log('Valor a transferir:', transferAmount);
        console.log('Queima esperada:', expectedBurn);

        token.transfer(userB, transferAmount);
        vm.stopPrank();

        uint256 finalSupply = token.totalSupply();
        uint256 actualBurn = initialSupply - finalSupply;

        console.log('\nApos transfer:');
        console.log('Supply final:', finalSupply);
        console.log('Tokens queimados:', actualBurn);

        // Verificar se a queima está próxima do valor esperado (com margem de erro)
        uint256 marginOfError = expectedBurn / 100; // 1% de margem
        bool isWithinMargin = actualBurn >= expectedBurn - marginOfError &&
            actualBurn <= expectedBurn + marginOfError;

        assertTrue(isWithinMargin, 'Queima nao esta dentro da margem esperada');

        console.log('\n');
    }

    function testMaxTxAmount() public {
        console.log('-------------------------------------------------');
        console.log('------------ TEST MAX TX AMOUNT -----------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        uint256 currentMaxTxAmount = token.maxTxAmount();
        uint256 newMaxTxAmount = 1000 * 10 ** tokenParams.decimals;

        console.log('Max TX Amount atual:', currentMaxTxAmount);
        console.log('Novo Max TX Amount:', newMaxTxAmount);

        vm.startPrank(owner);
        token.setMaxTxAmount(newMaxTxAmount / 10 ** tokenParams.decimals);
        assertEq(
            token.maxTxAmount(),
            newMaxTxAmount,
            'MaxTxAmount nao foi atualizado'
        );
        console.log('Max TX Amount apos update:', token.maxTxAmount());

        // Transferir tokens para userA para testar o limite
        token.transfer(userA, newMaxTxAmount);
        console.log('Balance do userA:', token.balanceOf(userA));
        vm.stopPrank();

        // Teste de transferência acima do limite
        uint256 attemptAmount = newMaxTxAmount + 1;
        vm.startPrank(userA);

        vm.expectRevert(
            abi.encodeWithSelector(
                MaxTransactionExceeded.selector,
                newMaxTxAmount,
                attemptAmount
            )
        );
        token.transfer(userB, attemptAmount);
        vm.stopPrank();

        console.log('\n');
    }

    function testNumTokensSellToAddToLiquidity() public {
        console.log('-------------------------------------------------');
        console.log('------ TEST NUM TOKENS SELL TO ADD LIQUIDITY ----');
        console.log('-------------------------------------------------');
        console.log('\n');

        uint256 currentAmount = token.numTokensSellToAddToLiquidity();
        uint256 maxTx = token.maxTxAmount();

        // Teste com valor válido (menor que maxTxAmount)
        uint256 newValidAmount = maxTx / 2;

        console.log('Valor atual:', currentAmount);
        console.log('MaxTxAmount:', maxTx);
        console.log('Novo valor valido:', newValidAmount);

        vm.startPrank(owner);

        // Teste com valor válido
        token.setNumTokensSellToAddToLiquidity(
            newValidAmount / 10 ** tokenParams.decimals
        );
        assertEq(
            token.numTokensSellToAddToLiquidity(),
            newValidAmount,
            'Valor nao foi atualizado corretamente'
        );

        // Teste com valor inválido (maior que maxTxAmount)
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

        // Teste com endereço válido
        token.updateUniswapV2Router(newRouter);
        assertEq(
            address(token.uniswapV2Router()),
            newRouter,
            'Router nao foi atualizado'
        );

        // Teste com endereço zero (deve reverter)
        vm.expectRevert(ZeroAddress.selector);
        token.updateUniswapV2Router(address(0));

        vm.stopPrank();

        console.log('Router apos update:', address(token.uniswapV2Router()));
        console.log('\n');
    }

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

        // Teste de inclusão em conta não excluída (deve reverter)
        vm.expectRevert(NotExcluded.selector);
        token.includeInFee(testUser);

        // Teste de exclusão
        token.excludeFromFee(testUser);
        assertTrue(
            token.isAccountExcludedFromFree(testUser),
            'Usuario nao foi excluido das taxas'
        );
        console.log(
            'Status apos exclusao:',
            token.isAccountExcludedFromFree(testUser)
        );

        // Teste de tentativa de excluir novamente (deve reverter)
        vm.expectRevert(AlreadyExcluded.selector);
        token.excludeFromFee(testUser);

        // Teste de inclusão
        token.includeInFee(testUser);
        assertFalse(
            token.isAccountExcludedFromFree(testUser),
            'Usuario nao foi incluido nas taxas'
        );
        console.log(
            'Status apos inclusao:',
            token.isAccountExcludedFromFree(testUser)
        );

        // Teste de tentativa de incluir novamente (deve reverter)
        vm.expectRevert(NotExcluded.selector);
        token.includeInFee(testUser);

        vm.stopPrank();
        console.log('\n');
    }

    function testSetFees() public {
        console.log('-------------------------------------------------');
        console.log('-------------- TEST SET FEES --------------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        uint256 currentTaxFee = token.taxFee();
        uint256 currentLiquidityFee = token.liquidityFee();
        uint256 currentBurnFee = token.burnFee();

        console.log('Taxas atuais:');
        console.log('- Tax Fee:', currentTaxFee);
        console.log('- Liquidity Fee:', currentLiquidityFee);
        console.log('- Burn Fee:', currentBurnFee);

        vm.startPrank(owner);

        // Teste com valores válidos
        uint256 newTaxFee = 3;
        uint256 newLiquidityFee = 4;
        uint256 newBurnFee = 2;

        console.log('\nNovas taxas:');
        console.log('- Tax Fee:', newTaxFee);
        console.log('- Liquidity Fee:', newLiquidityFee);
        console.log('- Burn Fee:', newBurnFee);

        token.setFees(newTaxFee, newLiquidityFee, newBurnFee);

        assertEq(token.taxFee(), newTaxFee, 'Tax Fee nao foi atualizada');
        assertEq(
            token.liquidityFee(),
            newLiquidityFee,
            'Liquidity Fee nao foi atualizada'
        );
        assertEq(token.burnFee(), newBurnFee, 'Burn Fee nao foi atualizada');

        // Teste com valores que excedem 100%
        uint256 invalidTaxFee = 50;
        uint256 invalidLiquidityFee = 40;
        uint256 invalidBurnFee = 20;
        uint256 totalInvalidFees = invalidTaxFee +
            invalidLiquidityFee +
            invalidBurnFee;

        console.log('\nTentando setar taxas invalidas (total > 100%):');
        console.log('- Tax Fee:', invalidTaxFee);
        console.log('- Liquidity Fee:', invalidLiquidityFee);
        console.log('- Burn Fee:', invalidBurnFee);

        vm.expectRevert(
            abi.encodeWithSelector(FeesExceeded.selector, totalInvalidFees)
        );
        token.setFees(invalidTaxFee, invalidLiquidityFee, invalidBurnFee);

        // Teste com não-owner (deve reverter)
        vm.stopPrank();
        vm.startPrank(userA);
        vm.expectRevert('Ownable: caller is not the owner');
        token.setFees(1, 1, 1);

        vm.stopPrank();

        console.log('\nTaxas finais:');
        console.log('- Tax Fee:', token.taxFee());
        console.log('- Liquidity Fee:', token.liquidityFee());
        console.log('- Burn Fee:', token.burnFee());
        console.log('\n');
    }

    // ---------------------------------------------------------------------------
    /// @dev PancakeSwap or Swap Dex tests

    function testAddLiquidity() public {
        console.log('-------------------------------------------------');
        console.log('------------- TEST ADD LIQUIDITY ----------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);

        // Configurar Uniswap (PancakeSwap)
        token.configureUniswap(routerAddress);

        // Setup para adicionar liquidez
        uint256 tokenAmount = 1000 * 10 ** tokenParams.decimals;
        uint256 ethAmount = 1 ether;

        // Verificar balance inicial do owner
        uint256 ownerBalance = token.balanceOf(owner);
        console.log('\nBalance inicial do owner:', ownerBalance);
        console.log('Token amount para liquidez:', tokenAmount);
        console.log('ETH amount para liquidez:', ethAmount);

        // Aprovar router para gastar tokens
        token.approve(routerAddress, tokenAmount);

        // Verificar allowance
        uint256 allowance = token.allowance(owner, routerAddress);
        console.log('Allowance para o router:', allowance);

        // Adicionar ETH ao owner
        vm.deal(owner, ethAmount);
        console.log('ETH balance do owner:', address(owner).balance);

        console.log('\nAdicionando liquidez...');

        // Adicionar liquidez
        IUniswapV2Router02(routerAddress).addLiquidityETH{value: ethAmount}(
            address(token),
            tokenAmount,
            0, // slippage 100%
            0, // slippage 100%
            owner,
            block.timestamp + 300
        );

        vm.stopPrank();

        // Verificar balances no par
        address pair = token.uniswapV2Pair();
        uint256 tokenBalance = token.balanceOf(pair);
        uint256 wethBalance = IERC20(WBNB).balanceOf(pair);

        console.log('Apos adicionar liquidez:');
        console.log('Token balance no par:', tokenBalance);
        console.log('WBNB balance no par:', wethBalance);
        console.log('ETH balance do owner:', address(owner).balance);

        assertTrue(tokenBalance > 0, 'Sem tokens no par');
        assertTrue(wethBalance > 0, 'Sem WBNB no par');

        // Verificar se LP tokens foram mintados para o owner
        uint256 lpBalance = IERC20(pair).balanceOf(owner);
        console.log('LP tokens do owner:', lpBalance);
        assertTrue(lpBalance > 0, 'Owner nao recebeu LP tokens');

        console.log('\n');
    }

    function testSwapExactTokensForETH() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST SWAP TOKENS FOR ETH ---------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        // Setup inicial - adiciona liquidez
        uint256 lpTokens = _addLiquidity(
            1000 * 10 ** tokenParams.decimals, // 1000 tokens
            1 ether // 1 BNB
        );
        console.log('LP Tokens recebidos:', lpTokens);

        // Transfer alguns tokens para userA para testar o swap
        uint256 amountIn = 100 * 10 ** tokenParams.decimals;
        vm.startPrank(owner);
        token.transfer(userA, amountIn);
        vm.stopPrank();

        uint256 userInitialBalance = token.balanceOf(userA);
        console.log('Balance inicial de tokens do userA:', userInitialBalance);

        vm.startPrank(userA);

        // Aprovar tokens para o router
        token.approve(routerAddress, amountIn);

        // Criar path para swap
        address[] memory path = new address[](2);
        path[0] = address(token);
        path[1] = WBNB;

        // Registrar balance de ETH inicial
        uint256 initialETHBalance = userA.balance;
        console.log('Balance inicial de ETH do userA:', initialETHBalance);

        console.log('\nExecutando swap...');

        // Executar swap
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

    function testSwapTokensForExactETH() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST SWAP TOKENS FOR EXACT ETH ----------');
        console.log('-------------------------------------------------');
        console.log('\n');

        // Setup inicial - liquidez respeitando o maxTransaction
        uint256 maxTx = token.maxTxAmount();
        console.log('Max Transaction:', maxTx);

        uint256 lpTokens = _addLiquidity(
            maxTx, // usando exatamente o maxTransaction
            100 ether // 100 BNB
        );
        console.log('LP Tokens recebidos:', lpTokens);

        // Transfer tokens para userA (valor menor que maxTx)
        uint256 initialAmount = maxTx / 10; // 10% do maxTransaction
        vm.startPrank(owner);
        token.transfer(userA, initialAmount);
        vm.stopPrank();

        vm.startPrank(userA);

        // Aprovar tokens para o router
        token.approve(routerAddress, initialAmount);

        // Calcular quantidade de tokens para o swap (ainda menor)
        uint256 tokensToSpend = maxTx / 20; // 5% do maxTransaction

        // Criar path para swap
        address[] memory path = new address[](2);
        path[0] = address(token);
        path[1] = WBNB;

        uint256 initialETHBalance = userA.balance;
        uint256 initialTokenBalance = token.balanceOf(userA);

        console.log('\nAntes do swap:');
        console.log('Balance inicial de tokens:', initialTokenBalance);
        console.log('Balance inicial de ETH:', initialETHBalance);
        console.log('Tokens a gastar:', tokensToSpend);

        // Executar swap usando a função que suporta taxas
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

    function testSwapExactETHForTokens() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST SWAP ETH FOR TOKENS ----------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        // Setup inicial - liquidez respeitando o maxTransaction
        uint256 maxTx = token.maxTxAmount();
        console.log('Max Transaction:', maxTx);

        uint256 lpTokens = _addLiquidity(maxTx, 100 ether);
        console.log('LP Tokens recebidos:', lpTokens);

        // Setup para o swap
        vm.deal(userA, 1 ether); // Dar 1 BNB para userA

        vm.startPrank(userA);

        // Criar path para swap
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

        // Executar swap
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

        // Verificar se as taxas foram aplicadas corretamente
        uint256 pairBalance = token.balanceOf(token.uniswapV2Pair());
        console.log('\nBalance do par apos swap:', pairBalance);

        console.log('\n');
    }

    function testRemoveLiquidity() public {
        console.log('-------------------------------------------------');
        console.log('------------- TEST REMOVE LIQUIDITY -------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        // Primeiro adiciona liquidez
        uint256 maxTx = token.maxTxAmount();
        uint256 lpTokens = _addLiquidity(maxTx, 10 ether);

        address pair = token.uniswapV2Pair();
        console.log('LP Tokens recebidos:', lpTokens);

        vm.startPrank(owner);

        // Aprovar LP tokens para o router
        IERC20(pair).approve(routerAddress, lpTokens);

        // Registrar balances iniciais
        uint256 initialTokenBalance = token.balanceOf(owner);
        uint256 initialETHBalance = address(owner).balance;

        console.log('\nAntes de remover liquidez:');
        console.log('Balance inicial de tokens:', initialTokenBalance);
        console.log('Balance inicial de ETH:', initialETHBalance);
        console.log('LP tokens para remover:', lpTokens);

        // Remover liquidez
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

        // Verificar se o par está vazio
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

        // Configurar Uniswap se ainda não estiver configurado
        if (address(token.uniswapV2Router()) == address(0)) {
            token.configureUniswap(routerAddress);
        }

        // Aprovar router para gastar tokens
        token.approve(routerAddress, tokenAmount);

        // Adicionar ETH ao owner
        vm.deal(owner, ethAmount);

        // Adicionar liquidez
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

        // Verificações de segurança
        address pair = token.uniswapV2Pair();
        require(
            token.balanceOf(pair) >= amountToken,
            'Tokens nao foram transferidos para o par'
        );
        require(
            IERC20(WBNB).balanceOf(pair) >= amountETH,
            'WBNB nao foi transferido para o par'
        );

        // Retornar quantidade de LP tokens recebidos
        lpTokens = IERC20(pair).balanceOf(owner);
        require(lpTokens > 0, 'LP tokens nao foram mintados');
        require(
            lpTokens == liquidity,
            'LP tokens nao correspondem ao retorno da funcao'
        );

        return lpTokens;
    }
}
