// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from 'forge-std/Test.sol';
import {console} from 'forge-std/console.sol';
import {IUniswapV2Router02, IUniswapV2Factory, IUniswapV2Pair} from '../contracts/interfaces/UniswapV2Interfaces.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {Ownable} from '@openzeppelin/contracts/access/Ownable.sol';

import {Caramelo} from '../contracts/Caramelo.sol';
import {TokenomicsAlreadyInitialized, ZeroAddress, InvalidAmount, AlreadyExcluded, NotExcluded, FeesExceeded, ContractLocked, SwapProtocolAlreadyConfigured, MaxTransactionExceeded, InsufficientBalance, InvalidTaxFee, InvalidLiquidityFee, InvalidBurnFee, ApprovalFailed, NumTokensSellToAddToLiquidityFailed, UpgradesAreFrozen, InvalidImplementation, TokenBalanceZero, TransferAmountExceedsMax, OwnerNotExcludedFromFee, TotalSupplyNotMatch, BurnExceedsTotalSupply} from '../contracts/utils/CarameloErrors.sol';

contract CarameloTest is Test {
    Caramelo public carameloContract;
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

    struct TokenomicsConfig {
        address wallet;
        uint256 percentage;
    }

    /// @dev Tokenomics configuration
    TokenomicsConfig[6] public tokenomics;

    TokenParams public tokenParams =
        TokenParams({
            name: 'Caramelo',
            symbol: 'TKN',
            initialSupply: 1_000_000_000_000, // 1 bilhão of tokens
            decimals: 9, // 6 decimals
            taxFee: 5000, // 5% (5000/100000)
            liquidityFee: 5000, // 5% (5000/100000)
            maxTokensTXAmount: 500_000_000, // 500,000,000 tokens
            numTokensSellToAddToLiquidity: 500_000_000 // 500,000,000
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
        /// ---------------------------------------------------------------------------
        /// @dev labeling the wallets for better readability
        /// ---------------------------------------------------------------------------
        vm.label(0x5CffE6546affdCEEa5Fc02838Ad7B1aAec3Fc00A, 'ONG Wallet');
        vm.label(
            0x51B8470fE0DA250B5893Ee5B26574FEb32282F2b,
            'Marketing Wallet'
        );
        vm.label(0x24f515276052D412f659aa28a6DD7f39a52F6aD7, 'Team One Wallet');
        vm.label(
            0xd3A2bd9cFB11067fa80Aca88bED48fa7CF0e2dcC,
            'Team Second Wallet'
        );
        vm.label(
            0x05b0cF5Efa12dc9bd83558b4787120a9297D9246,
            'Developer Wallet'
        );
        /// ---------------------------------------------------------------------------

        vm.stopPrank();

        /// @dev validate if owner is excluded from fee
        if (!carameloContract.isAccountExcludedFromFree(owner)) {
            revert OwnerNotExcludedFromFee();
        }
    }

    /// @dev test the total supply
    function testTotalSupply() public view {
        console.log('-----------------------------------------');
        console.log('-------------  Test Total Supply --------------');
        console.log('-----------------------------------------');
        console.log('\n');

        uint256 actualSupply = carameloContract.totalSupply();
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

    /// @dev test the tokenomics distribution
    function testTokenomicsDistribution() external {
        console.log('-------------------------------------------------');
        console.log('--------- TEST TOKENOMICS DISTRIBUTION ----------');
        console.log('-------------------------------------------------');

        uint256 totalSupply = carameloContract.totalSupply();

        /// @dev calculate the amount of tokens for each wallet based on the percentage
        uint256 communityAmount = (totalSupply * 50) / 100;
        uint256 ongsAmount = (totalSupply * 15) / 100;
        uint256 marketingAmount = (totalSupply * 10) / 100;
        uint256 teamOneAmount = (totalSupply * 10) / 100;
        uint256 teamSecondAmount = (totalSupply * 10) / 100;
        uint256 developerAmount = (totalSupply * 5) / 100;

        vm.startPrank(owner);
        /// @dev initialize tokenomics and transfer %
        carameloContract.initializeTokenomics();
        vm.stopPrank();

        /// @dev check if the community wallet balance is correct owner
        assertEq(
            carameloContract.balanceOf(owner),
            communityAmount,
            'Community wallet balance mismatch'
        );

        /// @dev check if the ONG wallet balance is correct
        assertEq(
            carameloContract.balanceOf(
                0x5CffE6546affdCEEa5Fc02838Ad7B1aAec3Fc00A
            ),
            ongsAmount,
            'ONG wallet balance mismatch'
        );

        /// @dev check if the Marketing wallet balance is correct
        assertEq(
            carameloContract.balanceOf(
                0x51B8470fE0DA250B5893Ee5B26574FEb32282F2b
            ),
            marketingAmount,
            'Marketing wallet balance mismatch'
        );

        /// @dev check if the Team One wallet balance is correct
        assertEq(
            carameloContract.balanceOf(
                0x24f515276052D412f659aa28a6DD7f39a52F6aD7
            ),
            teamOneAmount,
            'Team One wallet balance mismatch'
        );

        /// @dev check if the Team Second wallet balance is correct
        assertEq(
            carameloContract.balanceOf(
                0xd3A2bd9cFB11067fa80Aca88bED48fa7CF0e2dcC
            ),
            teamSecondAmount,
            'Team Second wallet balance mismatch'
        );

        /// @dev check if the Developer wallet balance is correct
        assertEq(
            carameloContract.balanceOf(
                0x05b0cF5Efa12dc9bd83558b4787120a9297D9246
            ),
            developerAmount,
            'Developer wallet balance mismatch'
        );

        console.log('All tokenomics wallets have the correct balances.');
    }

    function testTokenomicsDistributionAfterInitialization() external {
        console.log(
            '----------------------------------------------------------------------------'
        );
        console.log(
            '-------------  Test Tokenomics Error after initialization--------------'
        );
        console.log(
            '----------------------------------------------------------------------------'
        );
        console.log('\n');

        vm.startPrank(owner);
        carameloContract.initializeTokenomics();
        vm.stopPrank();

        vm.startPrank(owner);
        vm.expectRevert(
            abi.encodeWithSelector(
                TokenomicsAlreadyInitialized.selector,
                'Tokenomics already initialized!'
            )
        );
        carameloContract.initializeTokenomics();
        vm.stopPrank();

        console.log('-------------------------------------------------');
        console.log('\n');
    }

    /// @dev test the transfer without fees
    function testTransferWithoutFees() public {
        console.log('-------------------------------------------------');
        console.log('---------- TEST TRANSFER WITHOUT FEES -----------');
        console.log('-------------------------------------------------');
        console.log('\n');

        address excludedUser = makeAddr('excludedUser');
        uint256 transferAmount = 1000 * 10 ** tokenParams.decimals; // 1000 tokens

        /// @dev exclude user from fees
        vm.startPrank(owner);
        carameloContract.excludeFromFee(excludedUser);
        vm.stopPrank();

        console.log('--> Verificando se user esta excluido das taxas');
        assertTrue(
            carameloContract.isAccountExcludedFromFree(excludedUser),
            'Usuario nao esta excluido das taxas'
        );
        assertTrue(
            carameloContract.isAccountExcludedFromFree(owner),
            'Owner nao esta excluido das taxas'
        );

        /// @dev transfer tokens from owner to excluded user
        console.log(
            '--> Transferindo',
            transferAmount,
            'tokens do owner para usuario excluido'
        );
        vm.startPrank(owner);
        carameloContract.transfer(excludedUser, transferAmount);
        vm.stopPrank();

        /// @dev check if the received amount is exactly the transferred amount (without fees)
        uint256 excludedUserBalance = carameloContract.balanceOf(excludedUser);
        console.log('--> Balance do usuario excluido:', excludedUserBalance);
        assertEq(
            excludedUserBalance,
            transferAmount,
            'Valor recebido nao coteamSecondAmountrresponde ao transferido'
        );

        /// @dev transfer tokens from excluded user to another excluded address (owner)
        console.log('--> Transferindo tokens de volta para o owner');
        vm.startPrank(excludedUser);
        carameloContract.transfer(owner, transferAmount);
        vm.stopPrank();

        /// @dev check if the received amount is exactly the transferred amount
        uint256 ownerFinalBalance = carameloContract.balanceOf(owner);
        console.log('--> Balance final do owner:', ownerFinalBalance);

        /// @dev check if there was no change in the total supply (no burning should occur)
        uint256 finalSupply = carameloContract.totalSupply();
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

    /// @dev test the transfer with fees
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
        carameloContract.transfer(normalUser, transferAmount);
        vm.stopPrank();

        uint256 initialBalance = carameloContract.balanceOf(normalUser);
        console.log('Balance inicial do usuario:', initialBalance);

        // Calcular taxas esperadas
        /// @dev // 30% off taxFee
        uint256 burnFee = (transferAmount * carameloContract.taxFee() * 30000) /
            (100000 * 100000); // 30% of taxFee
        /// @dev // 70% of taxFee
        uint256 reflectFee = (transferAmount *
            carameloContract.taxFee() *
            70000) / (100000 * 100000); // 70% of taxFee
        uint256 liquidityFee = (transferAmount *
            carameloContract.liquidityFee()) / 100000;
        uint256 totalFee = burnFee + reflectFee + liquidityFee;
        uint256 expectedReceivedAmount = transferAmount - totalFee;

        console.log('Taxa de queima:', burnFee);
        console.log('Taxa de reflexao:', reflectFee);
        console.log('Taxa de liquidez:', liquidityFee);
        console.log('Valor a transferir:', transferAmount);
        console.log('Valor esperado apos taxas:', expectedReceivedAmount);

        // Realizar a transferência com taxas
        vm.startPrank(normalUser);
        carameloContract.transfer(recipient, transferAmount);
        vm.stopPrank();

        // Verificar o valor recebido
        uint256 recipientBalance = carameloContract.balanceOf(recipient);
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

        // Verificar o supply total após a queima
        uint256 initialSupply = tokenParams.initialSupply *
            10 ** tokenParams.decimals;
        uint256 expectedSupplyAfterBurn = initialSupply - burnFee;
        uint256 actualSupply = carameloContract.totalSupply();

        console.log('Supply esperado apos queima:', expectedSupplyAfterBurn);
        console.log('Supply atual:', actualSupply);

        assertEq(
            actualSupply,
            expectedSupplyAfterBurn,
            'Supply total nao bate com a expectativa apos queima'
        );

        console.log('\n');
    }

    /// @dev test the transferFrom function
    function testTransferFrom() public {
        console.log('-------------------------------------------------');
        console.log('------------- TEST TRANSFER FROM ----------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        address spender = makeAddr('spender');
        uint256 amount = 1000 * 10 ** tokenParams.decimals;

        /// @dev check initial balance of owner
        uint256 ownerBalance = carameloContract.balanceOf(owner);
        console.log('Balance inicial do owner:', ownerBalance);

        vm.startPrank(owner);

        /// @dev approve spender
        carameloContract.approve(spender, amount);

        /// @dev check allowance
        uint256 allowance = carameloContract.allowance(owner, spender);
        console.log('Allowance para spender:', allowance);
        assertEq(allowance, amount, 'Allowance incorreta');

        vm.stopPrank();

        /// @dev try to transferFrom as spender
        vm.startPrank(spender);
        carameloContract.transferFrom(owner, spender, amount);
        vm.stopPrank();

        /// @dev check final balances
        uint256 ownerBalanceAfter = carameloContract.balanceOf(owner);
        uint256 spenderBalance = carameloContract.balanceOf(spender);

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

    /// @dev test the transfer between excluded and non-excluded accounts
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
        carameloContract.excludeFromFee(excludedUser);
        carameloContract.transfer(excludedUser, transferAmount);
        vm.stopPrank();

        console.log('--> Initial setup:');
        console.log(
            '    Excluded user balance:',
            carameloContract.balanceOf(excludedUser)
        );
        console.log(
            '    Normal user balance:',
            carameloContract.balanceOf(normalUser)
        );

        /// @dev transfer from excluded to non-excluded (should not apply fees)
        console.log('\n--> Transferindo de usuario excluido para normal');
        vm.startPrank(excludedUser);
        carameloContract.transfer(normalUser, transferAmount);
        vm.stopPrank();

        /// @dev there should be no fees since the sender is excluded
        uint256 expectedAmount = transferAmount;

        console.log('    Valor transferido:', transferAmount);
        console.log('    Valor esperado (sem taxas):', expectedAmount);

        uint256 actualBalance = carameloContract.balanceOf(normalUser);
        console.log('    Valor recebido:', actualBalance);

        assertEq(
            actualBalance,
            expectedAmount,
            'Valor recebido incorreto - nao deveria ter taxas'
        );

        /// @dev now test transfer from non-excluded to any address (should apply fees)
        console.log('\n--> Transferindo de usuario normal para excluido');
        uint256 smallerAmount = 100 * 10 ** tokenParams.decimals;

        uint256 excludedBalanceBefore = carameloContract.balanceOf(
            excludedUser
        );

        vm.startPrank(normalUser);
        carameloContract.transfer(excludedUser, smallerAmount);
        vm.stopPrank();

        /// @dev calculate expected fees for transfer from normal user using FEE_DIVISOR
        uint256 taxFee = (smallerAmount * carameloContract.taxFee()) / 100000;
        uint256 burnFee = (taxFee * 30000) / 100000;
        uint256 reflectFee = taxFee - burnFee;
        uint256 liquidityFee = (smallerAmount *
            carameloContract.liquidityFee()) / 100000;
        uint256 totalFee = burnFee + reflectFee + liquidityFee;
        uint256 expectedAmountBack = smallerAmount - totalFee;

        uint256 actualReceived = carameloContract.balanceOf(excludedUser) -
            excludedBalanceBefore;

        console.log('    Tax Fee:', carameloContract.taxFee());
        console.log('    Liquidity Fee:', carameloContract.liquidityFee());
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

    /// @dev test the reflection mechanism
    function testReflectionMechanism() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST REFLECTION MECHANISM ---------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        /// @dev Transfer tokens to userA
        uint256 transferAmount = 1000 * 10 ** tokenParams.decimals; // 1000 tokens
        vm.startPrank(owner);
        carameloContract.transfer(userA, transferAmount); // Transferir 1000 tokens para userA
        vm.stopPrank();

        /// @dev Register initial balances
        uint256 initialUserABalance = carameloContract.balanceOf(userA);
        uint256 initialUserBBalance = carameloContract.balanceOf(userB);

        console.log('Balance inicial userA:', initialUserABalance);
        console.log('Balance inicial userB:', initialUserBBalance);

        /// @dev userA transfers tokens to userB (with fees)
        uint256 transferAmount2 = 100 * 10 ** tokenParams.decimals; // Transfer 100 tokens

        vm.startPrank(userA);
        carameloContract.transfer(userB, transferAmount2); // Transferência de userA para userB
        vm.stopPrank();

        /// @dev Calculate applied fees
        uint256 liquidityFee = (transferAmount2 *
            carameloContract.liquidityFee()) / 100; // 5% for liquidity
        uint256 taxFee = (transferAmount2 * carameloContract.taxFee()) / 100; // 5% for taxFee
        uint256 burnFee = (taxFee * 30) / 100; // 30% of taxFee for burning
        uint256 reflectionFee = (taxFee * 70) / 100; // 70% of taxFee for reflection
        uint256 totalFee = liquidityFee + burnFee + reflectionFee; // Total fees

        /// @dev Calculate reflection received by userA
        uint256 totalSupplyExcludingFees = carameloContract.totalSupply() -
            burnFee;
        uint256 userAReflectionShare = (initialUserABalance *
            10 ** tokenParams.decimals) / totalSupplyExcludingFees;
        uint256 reflectionReceivedByUserA = (reflectionFee *
            userAReflectionShare) / 10 ** tokenParams.decimals;

        /// @dev Calculate expected balances
        uint256 expectedUserABalance = initialUserABalance -
            transferAmount2 +
            reflectionReceivedByUserA;
        uint256 expectedUserBBalance = carameloContract.balanceOf(userB);

        uint256 updatedUserABalance = carameloContract.balanceOf(userA);
        uint256 updatedUserBBalance = carameloContract.balanceOf(userB);

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

        /// @dev Validate userA balance
        assertEq(
            updatedUserABalance,
            expectedUserABalance,
            'Balance do userA nao bate apos reflection'
        );

        /// @dev Validate userB balance
        assertEq(
            updatedUserBBalance,
            expectedUserBBalance,
            'Balance do userB nao bate apos reflection'
        );

        console.log('Reflection process correct.');
    }

    /// @dev Test Swap and Liquidity
    function testSwapAndLiquifyEnabled() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST SWAP AND LIQUIFY ENABLED ----------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);

        /// @dev check initial state
        bool initialState = carameloContract.swapAndLiquifyEnabled();
        console.log('Estado inicial do swap:', initialState);

        /// @dev if disabled, enable first
        if (!initialState) {
            carameloContract.setSwapAndLiquifyEnabled(true);
            assertTrue(
                carameloContract.swapAndLiquifyEnabled(),
                'Deveria estar habilitado'
            );
        }

        /// @dev now disable
        carameloContract.setSwapAndLiquifyEnabled(false);
        assertFalse(
            carameloContract.swapAndLiquifyEnabled(),
            'Deveria estar desabilitado'
        );

        /// @dev enable again
        carameloContract.setSwapAndLiquifyEnabled(true);
        assertTrue(
            carameloContract.swapAndLiquifyEnabled(),
            'Deveria estar habilitado'
        );

        vm.stopPrank();

        console.log(
            'Estado final do swap:',
            carameloContract.swapAndLiquifyEnabled()
        );
        console.log('\n');
    }

    function testFeeLimits() public {
        console.log('-------------------------------------------------');
        console.log('-------------- TEST FEE LIMITS ------------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        vm.startPrank(owner);

        /// @dev Testar tentativa de configurar taxas que excedem 100%
        uint256 invalidTaxFee = 60000; // 60% usando FEE_DIVISOR
        uint256 invalidLiquidityFee = 50000; // 50% usando FEE_DIVISOR

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
        carameloContract.setFees(invalidTaxFee, invalidLiquidityFee);

        /// @dev Testar valores válidos dentro do limite
        uint256 validTaxFee = 30000; // 30% usando FEE_DIVISOR
        uint256 validLiquidityFee = 20000; // 20% usando FEE_DIVISOR

        console.log('Setando taxas validas no limite:');
        console.log('Tax Fee:', validTaxFee);
        console.log('Liquidity Fee:', validLiquidityFee);
        console.log('Total:', validTaxFee + validLiquidityFee);

        carameloContract.setFees(validTaxFee, validLiquidityFee);

        assertEq(
            carameloContract.taxFee(),
            validTaxFee,
            'Tax Fee nao foi atualizada'
        );
        assertEq(
            carameloContract.liquidityFee(),
            validLiquidityFee,
            'Liquidity Fee nao foi atualizada'
        );

        vm.stopPrank();
        console.log('\n');
    }

    function testBurnExceedsTotalSupplyError() public {
        console.log('-------------------------------------------------');
        console.log('------------- TEST BURN EXCEEDS TOTAL SUPPLY --------');
        console.log('-------------------------------------------------');
        console.log('\n');

        uint256 initialSupply = carameloContract.totalSupply();
        console.log('Supply inicial:', initialSupply);

        uint256 burnAmount = initialSupply + 1;
        vm.expectRevert(
            abi.encodeWithSelector(
                BurnExceedsTotalSupply.selector,
                burnAmount,
                initialSupply
            )
        );
        vm.startPrank(owner);
        carameloContract.burn(burnAmount);

        vm.stopPrank();
        console.log('\n');
    }

    /// @dev test burn mechanism
    function testBurnMechanism() public {
        console.log('-------------------------------------------------');
        console.log('------------- TEST BURN MECHANISM ---------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        uint256 initialSupply = carameloContract.totalSupply();
        console.log('Supply inicial:', initialSupply);

        /// @dev Primeiro, transferir para uma conta não excluída (userA)
        uint256 transferAmount = 1000 * 10 ** tokenParams.decimals;
        vm.startPrank(owner);
        carameloContract.transfer(userA, transferAmount * 2); // Transferir o dobro para ter saldo suficiente
        vm.stopPrank();

        /// @dev Agora, realizar a transferência que deve disparar a queima (userA -> userB)
        vm.startPrank(userA);
        uint256 expectedBurn = (transferAmount *
            carameloContract.taxFee() *
            30000) / (100000 * 100000);

        console.log('Valor a transferir:', transferAmount);
        console.log('Queima esperada:', expectedBurn);

        carameloContract.transfer(userB, transferAmount);
        vm.stopPrank();

        uint256 finalSupply = carameloContract.totalSupply();
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

        carameloContract.configureSwapProtocol(routerAddress);

        carameloContract.transfer(
            userA,
            carameloContract.maxTxAmount() + 1000000000
        );
        vm.stopPrank();

        vm.startPrank(userA);
        /// @dev test transfer exceeding maxTxAmount
        uint256 amountExceedingMax = carameloContract.maxTxAmount() + 1;
        vm.expectRevert(TransferAmountExceedsMax.selector);
        carameloContract.transfer(userB, amountExceedingMax);
        vm.stopPrank();
    }

    /// @dev test numTokensSellToAddToLiquidity
    function testNumTokensSellToAddToLiquidity() public {
        console.log('-------------------------------------------------');
        console.log('------ TEST NUM TOKENS SELL TO ADD LIQUIDITY ----');
        console.log('-------------------------------------------------');
        console.log('\n');

        uint256 currentAmount = carameloContract
            .numTokensSellToAddToLiquidity();
        uint256 maxTx = carameloContract.maxTxAmount();

        /// @dev test with valid value (less than maxTxAmount)
        uint256 newValidAmount = maxTx / 2;

        console.log('Valor atual:', currentAmount);
        console.log('MaxTxAmount:', maxTx);
        console.log('Novo valor valido:', newValidAmount);

        vm.startPrank(owner);

        /// @dev test with valid value (less than maxTxAmount)
        carameloContract.setNumTokensSellToAddToLiquidity(
            newValidAmount / 10 ** tokenParams.decimals
        );
        assertEq(
            carameloContract.numTokensSellToAddToLiquidity(),
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
        carameloContract.setNumTokensSellToAddToLiquidity(
            invalidAmount / 10 ** tokenParams.decimals
        );

        vm.stopPrank();

        console.log(
            'Valor final:',
            carameloContract.numTokensSellToAddToLiquidity()
        );
        console.log('\n');
    }

    /// @dev test update uniswapV2Router
    function testUpdateUniswapV2Router() public {
        console.log('-------------------------------------------------');
        console.log('-------- TEST UPDATE UNISWAP V2 ROUTER ----------');
        console.log('-------------------------------------------------');
        console.log('\n');

        address currentRouter = address(carameloContract.uniswapV2Router());
        address newRouter = makeAddr('newRouter');

        console.log('Router atual:', currentRouter);
        console.log('Novo router:', newRouter);

        vm.startPrank(owner);

        /// @dev test with valid address
        carameloContract.updateUniswapV2Router(newRouter);
        assertEq(
            address(carameloContract.uniswapV2Router()),
            newRouter,
            'Router nao foi atualizado'
        );

        /// @dev test with zero address
        vm.expectRevert(ZeroAddress.selector);
        carameloContract.updateUniswapV2Router(address(0));

        vm.stopPrank();

        console.log(
            'Router apos update:',
            address(carameloContract.uniswapV2Router())
        );
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
            carameloContract.isAccountExcludedFromFree(testUser)
        );

        vm.startPrank(owner);

        /// @dev test inclusion in non-excluded account (should revert)
        vm.expectRevert(NotExcluded.selector);
        carameloContract.includeInFee(testUser);

        /// @dev test exclusion from fee
        carameloContract.excludeFromFee(testUser);
        assertTrue(
            carameloContract.isAccountExcludedFromFree(testUser),
            'Usuario nao foi excluido das taxas'
        );
        console.log(
            'Status apos exclusao:',
            carameloContract.isAccountExcludedFromFree(testUser)
        );

        /// @dev test attempt to exclude again (should revert)
        vm.expectRevert(AlreadyExcluded.selector);
        carameloContract.excludeFromFee(testUser);

        /// @dev test inclusion
        carameloContract.includeInFee(testUser);
        assertFalse(
            carameloContract.isAccountExcludedFromFree(testUser),
            'Usuario nao foi incluido nas taxas'
        );
        console.log(
            'Status apos inclusao:',
            carameloContract.isAccountExcludedFromFree(testUser)
        );

        /// @dev test attempt to include again (should revert)
        vm.expectRevert(NotExcluded.selector);
        carameloContract.includeInFee(testUser);

        vm.stopPrank();
        console.log('\n');
    }

    /// @dev test set fees
    function testSetFees() public {
        console.log('-------------------------------------------------');
        console.log('-------------- TEST SET FEES --------------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        uint256 currentTaxFee = carameloContract.taxFee();
        uint256 currentLiquidityFee = carameloContract.liquidityFee();
        console.log('Taxas atuais:');
        console.log('- Tax Fee:', currentTaxFee);
        console.log('- Liquidity Fee:', currentLiquidityFee);

        vm.startPrank(owner);

        /// @dev Testar valores válidos
        uint256 newTaxFee = 3000; // 3%
        uint256 newLiquidityFee = 4000; // 4%

        console.log('\nNovas taxas:');
        console.log('- Tax Fee:', newTaxFee);
        console.log('- Liquidity Fee:', newLiquidityFee);

        carameloContract.setFees(newTaxFee, newLiquidityFee);

        assertEq(
            carameloContract.taxFee(),
            newTaxFee,
            'Tax Fee nao foi atualizada'
        );
        assertEq(
            carameloContract.liquidityFee(),
            newLiquidityFee,
            'Liquidity Fee nao foi atualizada'
        );

        /// @dev Testar valores inválidos (total > 100%)
        uint256 invalidTaxFee = 50000;
        uint256 invalidLiquidityFee = 51000; // Total seria 101%
        vm.expectRevert(
            abi.encodeWithSelector(
                FeesExceeded.selector,
                invalidTaxFee + invalidLiquidityFee
            )
        );
        carameloContract.setFees(invalidTaxFee, invalidLiquidityFee);

        vm.stopPrank();

        /// @dev Testar usuário não autorizado
        vm.startPrank(userA);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableUnauthorizedAccount.selector,
                userA
            )
        );
        carameloContract.setFees(1, 1);
        vm.stopPrank();

        console.log('\nTaxas finais:');
        console.log('- Tax Fee:', carameloContract.taxFee());
        console.log('- Liquidity Fee:', carameloContract.liquidityFee());
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
        carameloContract.configureSwapProtocol(routerAddress);

        /// @dev Get maxTxAmount to ensure we don't exceed it
        uint256 maxTx = carameloContract.maxTxAmount();

        /// @dev setup to add liquidity - use amount less than maxTxAmount
        uint256 tokenAmount = maxTx / 2; // Use half of maxTxAmount to be safe
        uint256 ethAmount = 1 ether;

        /// @dev check initial balance of owner
        uint256 ownerBalance = carameloContract.balanceOf(owner);
        console.log('\nBalance inicial do owner:', ownerBalance);
        console.log('Max transaction amount:', maxTx);
        console.log('Caramelo amount para liquidez:', tokenAmount);
        console.log('ETH amount para liquidez:', ethAmount);

        /// @dev approve router to spend tokens
        carameloContract.approve(routerAddress, tokenAmount);

        /// @dev check allowance
        uint256 allowance = carameloContract.allowance(owner, routerAddress);
        console.log('Allowance para o router:', allowance);

        /// @dev give ETH to owner
        vm.deal(owner, ethAmount);
        console.log('ETH balance do owner:', address(owner).balance);

        console.log('\nAdicionando liquidez...');

        /// @dev add liquidity
        IUniswapV2Router02(routerAddress).addLiquidityETH{value: ethAmount}(
            address(carameloContract),
            tokenAmount,
            0, // slippage 100%
            0, // slippage 100%
            owner,
            block.timestamp + 300
        );

        vm.stopPrank();

        /// @dev check balances in the pair
        address pair = carameloContract.uniswapV2Pair();
        uint256 tokenBalance = carameloContract.balanceOf(pair);
        uint256 WBNBBalance = IERC20(WBNB).balanceOf(pair);

        console.log('Apos adicionar liquidez:');
        console.log('Caramelo balance no par:', tokenBalance);
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
        carameloContract.transfer(userA, amountIn);
        vm.stopPrank();

        uint256 userInitialBalance = carameloContract.balanceOf(userA);
        console.log('Balance inicial de tokens do userA:', userInitialBalance);

        vm.startPrank(userA);

        /// @dev approve tokens for the router
        carameloContract.approve(routerAddress, amountIn);

        /// @dev create path for swap
        address[] memory path = new address[](2);
        path[0] = address(carameloContract);
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
        uint256 finalTokenBalance = carameloContract.balanceOf(userA);
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
        uint256 maxTx = carameloContract.maxTxAmount();
        console.log('Max Transaction:', maxTx);

        uint256 lpTokens = _addLiquidity(
            maxTx, // usando exatamente o maxTransaction
            100 ether // 100 BNB
        );
        console.log('LP Tokens recebidos:', lpTokens);

        /// @dev transfer tokens to userA (value less than maxTx)
        uint256 initialAmount = maxTx / 10; // 10% of maxTransaction
        vm.startPrank(owner);
        carameloContract.transfer(userA, initialAmount);
        vm.stopPrank();

        vm.startPrank(userA);

        /// @dev approve tokens for the router
        carameloContract.approve(routerAddress, initialAmount);

        /// @dev calculate amount of tokens to spend (still less than maxTx)
        uint256 tokensToSpend = maxTx / 20; // 5% of maxTransaction

        /// @dev create path for swap
        address[] memory path = new address[](2);
        path[0] = address(carameloContract);
        path[1] = WBNB;

        uint256 initialETHBalance = userA.balance;
        uint256 initialTokenBalance = carameloContract.balanceOf(userA);

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

        uint256 finalTokenBalance = carameloContract.balanceOf(userA);
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
        uint256 maxTx = carameloContract.maxTxAmount();
        console.log('Max Transaction:', maxTx);

        uint256 lpTokens = _addLiquidity(maxTx, 100 ether);
        console.log('LP Tokens recebidos:', lpTokens);

        /// @dev setup for the swap
        vm.deal(userA, 1 ether); // Give 1 BNB to userA

        vm.startPrank(userA);

        /// @dev create path for swap
        address[] memory path = new address[](2);
        path[0] = WBNB;
        path[1] = address(carameloContract);

        uint256 initialETHBalance = userA.balance;
        uint256 initialTokenBalance = carameloContract.balanceOf(userA);
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

        uint256 finalTokenBalance = carameloContract.balanceOf(userA);
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
        uint256 pairBalance = carameloContract.balanceOf(
            carameloContract.uniswapV2Pair()
        );
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
        uint256 maxTx = carameloContract.maxTxAmount();
        uint256 lpTokens = _addLiquidity(maxTx, 10 ether);

        address pair = carameloContract.uniswapV2Pair();
        console.log('LP Tokens recebidos:', lpTokens);

        vm.startPrank(owner);

        /// @dev approve LP tokens for the router
        IERC20(pair).approve(routerAddress, lpTokens);

        /// @dev register initial balances
        uint256 initialTokenBalance = carameloContract.balanceOf(owner);
        uint256 initialETHBalance = address(owner).balance;

        console.log('\nAntes de remover liquidez:');
        console.log('Balance inicial de tokens:', initialTokenBalance);
        console.log('Balance inicial de ETH:', initialETHBalance);
        console.log('LP tokens para remover:', lpTokens);

        /// @dev remove liquidity
        (uint256 amountToken, uint256 amountETH) = IUniswapV2Router02(
            routerAddress
        ).removeLiquidityETH(
                address(carameloContract),
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
        console.log(
            'Balance final de tokens:',
            carameloContract.balanceOf(owner)
        );
        console.log('Balance final de ETH:', address(owner).balance);

        /// @dev check if the pair is empty
        uint256 pairTokenBalance = carameloContract.balanceOf(pair);
        uint256 pairETHBalance = IERC20(WBNB).balanceOf(pair);

        console.log('\nBalances do par:');
        console.log('Tokens restantes no par:', pairTokenBalance);
        console.log('ETH restante no par:', pairETHBalance);

        assertTrue(
            carameloContract.balanceOf(owner) > initialTokenBalance,
            'Tokens nao foram recebidos'
        );
        assertTrue(
            address(owner).balance > initialETHBalance,
            'ETH nao foi recebido'
        );

        console.log('\n');
    }
    // ---------------------------------------------------------------------------

    /// @dev test reflection balance of complete
    function testReflectionBalanceOfComplete() public {
        vm.startPrank(owner);

        /// @dev test with zero address
        vm.expectRevert('Zero address');
        carameloContract.reflectionBalanceOf(address(0));

        /// @dev test with valid address before any transfer
        uint256 initialReflection = carameloContract.reflectionBalanceOf(owner);
        assertGt(initialReflection, 0, 'Initial reflection should be positive');

        /// @dev test after transfer with fees
        carameloContract.transfer(userA, 1000);
        uint256 reflectionAfterTransfer = carameloContract.reflectionBalanceOf(
            userA
        );
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
        carameloContract.transferFrom(owner, userB, 100);
        vm.stopPrank();

        /// @dev Setup for the next tests
        vm.startPrank(owner);
        carameloContract.approve(userA, 50);
        vm.stopPrank();

        /// @dev Second test: insufficient approval
        vm.startPrank(userA);
        vm.expectRevert(
            abi.encodeWithSelector(InsufficientBalance.selector, 50, 100)
        );
        carameloContract.transferFrom(owner, userB, 100);
        vm.stopPrank();

        /// @dev Setup for the final test
        vm.startPrank(owner);
        carameloContract.approve(userA, 200);
        vm.stopPrank();

        /// @dev Third test: sufficient approval
        vm.startPrank(userA);
        carameloContract.transferFrom(owner, userB, 100);
        vm.stopPrank();

        /// @dev Final checks
        assertEq(
            carameloContract.allowance(owner, userA),
            100,
            'Allowance not properly decreased'
        );
    }

    /// @dev test updateUniswapV2RouterComplete
    function testUpdateUniswapV2RouterComplete() public {
        vm.startPrank(owner);

        /// @dev Test with zero address
        vm.expectRevert(abi.encodeWithSelector(ZeroAddress.selector));
        carameloContract.updateUniswapV2Router(address(0));

        /// @dev Test update to new router
        address newRouter = makeAddr('newRouter');
        carameloContract.updateUniswapV2Router(newRouter);
        assertEq(
            address(carameloContract.uniswapV2Router()),
            newRouter,
            'Router not updated'
        );

        /// @dev Test multiple updates
        address newerRouter = makeAddr('newerRouter');
        carameloContract.updateUniswapV2Router(newerRouter);
        assertEq(
            address(carameloContract.uniswapV2Router()),
            newerRouter,
            'Router not updated again'
        );

        vm.stopPrank();
    }

    function testSetNumTokensSellToAddToLiquidityComplete() public {
        vm.startPrank(owner);

        uint256 maxTx = carameloContract.maxTxAmount();

        /// @dev test with value greater than maxTxAmount
        uint256 tooLarge = maxTx / (10 ** carameloContract.decimals()) + 1;
        vm.expectRevert(
            abi.encodeWithSelector(
                NumTokensSellToAddToLiquidityFailed.selector,
                tooLarge * 10 ** carameloContract.decimals(),
                maxTx
            )
        );
        carameloContract.setNumTokensSellToAddToLiquidity(tooLarge);

        /// @dev test with valid amount
        uint256 validAmount = maxTx / (10 ** carameloContract.decimals()) / 2;
        carameloContract.setNumTokensSellToAddToLiquidity(validAmount);
        assertEq(
            carameloContract.numTokensSellToAddToLiquidity(),
            validAmount * 10 ** carameloContract.decimals(),
            'Value not updated correctly'
        );

        /// @dev test with minimum value
        carameloContract.setNumTokensSellToAddToLiquidity(1);
        assertEq(
            carameloContract.numTokensSellToAddToLiquidity(),
            1 * 10 ** carameloContract.decimals(),
            'Minimum value not set correctly'
        );

        vm.stopPrank();
    }

    /// @dev test approve edge cases
    function testApproveEdgeCases() public {
        vm.startPrank(owner);

        /// @dev test with zero address
        vm.expectRevert(abi.encodeWithSelector(ZeroAddress.selector));
        carameloContract.approve(address(0), 100);

        /// @dev test with zero value
        carameloContract.approve(userA, 0);
        assertEq(
            carameloContract.allowance(owner, userA),
            0,
            'Allowance should be zero'
        );

        /// @dev test with maximum value
        carameloContract.approve(userA, type(uint256).max);
        assertEq(
            carameloContract.allowance(owner, userA),
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
        (bool success, ) = address(carameloContract).call{value: 1 ether}('');
        assertTrue(success, 'Should accept ETH');
        assertEq(
            address(carameloContract).balance,
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
        carameloContract.configureSwapProtocol(routerAddress);
        carameloContract.setSwapAndLiquifyEnabled(true);

        /// @dev test with zero balance
        uint256 balanceBefore = carameloContract.balanceOf(
            address(carameloContract)
        );
        require(balanceBefore == 0, 'Contract should have zero balance');

        /// @dev transfer should not trigger swap
        carameloContract.transfer(userA, 100);

        /// @dev verify that nothing changed
        assertEq(
            carameloContract.balanceOf(address(carameloContract)),
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

        carameloContract.configureSwapProtocol(routerAddress);
        carameloContract.transfer(
            userA,
            carameloContract.maxTxAmount() + 1000000000
        );
        vm.stopPrank();

        vm.startPrank(userA);
        // Testar transferência que excede o maxTxAmount
        uint256 amountExceedingMax = carameloContract.maxTxAmount() + 1;
        vm.expectRevert(TransferAmountExceedsMax.selector);
        carameloContract.transfer(userB, amountExceedingMax);
        vm.stopPrank();
    }

    /// @dev test transfer with maximum fees
    function testTransferWithMaximumFees() public {
        vm.startPrank(owner);

        /// @dev Configurar taxas máximas
        carameloContract.setFees(49000, 49000); // Total 98%

        /// @dev Realizar transferência com taxas máximas
        uint256 amount = 1000 * 10 ** carameloContract.decimals();
        uint256 initialBalance = carameloContract.balanceOf(userA);

        /// @dev Incluir o owner nas taxas para testar taxas máximas
        carameloContract.includeInFee(owner);
        carameloContract.transfer(userA, amount);

        /// @dev Verificar se o valor recebido é aproximadamente 1% do valor enviado
        uint256 burnFee = (amount * carameloContract.taxFee() * 30000) /
            (100000 * 100000);
        uint256 reflectFee = (amount * carameloContract.taxFee() * 70000) /
            (100000 * 100000);
        uint256 liquidityFee = (amount * carameloContract.liquidityFee()) /
            100000;
        uint256 totalFee = burnFee + reflectFee + liquidityFee;
        uint256 expectedAmount = amount - totalFee;

        uint256 actualBalance = carameloContract.balanceOf(userA) -
            initialBalance;

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
        carameloContract.configureSwapProtocol(routerAddress);
        carameloContract.setSwapAndLiquifyEnabled(true);

        /// @dev Set minimum value to trigger swap
        carameloContract.setNumTokensSellToAddToLiquidity(1);

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
        uint256 minAmount = carameloContract.numTokensSellToAddToLiquidity();
        carameloContract.transfer(address(carameloContract), minAmount);

        /// @dev Verify if swap was triggered
        assertTrue(
            carameloContract.swapAndLiquifyEnabled(),
            'Swap should remain enabled'
        );

        vm.stopPrank();
    }

    function testReflectionWithZeroFees() public {
        vm.startPrank(owner);

        // Configurar todas as taxas como zero
        carameloContract.setFees(0, 0);

        // Transferir tokens
        uint256 amount = 1000;
        uint256 initialReflection = carameloContract.reflectionBalanceOf(userA);
        carameloContract.transfer(userA, amount);

        // Verificar se não houve reflexão
        assertEq(
            carameloContract.reflectionBalanceOf(userA),
            initialReflection + amount,
            'Reflection should equal transfer amount with zero fees'
        );

        vm.stopPrank();
    }

    /// @dev test ownership transfer
    function testOwnershipTransfer() public {
        vm.startPrank(owner);

        /// @dev Testing ownership transfer
        carameloContract.transferOwnership(userA);
        assertEq(carameloContract.owner(), userA, 'Ownership not transferred');

        /// @dev Testing transfer to zero address
        vm.startPrank(userA);
        vm.expectRevert(
            abi.encodeWithSelector(
                Ownable.OwnableInvalidOwner.selector,
                address(0)
            )
        );
        carameloContract.transferOwnership(address(0));

        /// @dev Testing renounceOwnership
        carameloContract.renounceOwnership();
        assertEq(
            carameloContract.owner(),
            address(0),
            'Ownership not renounced'
        );

        vm.stopPrank();
    }

    /// @dev test isSwapAndLiquifyEnabled
    function testIsSwapAndLiquifyEnabled() public {
        vm.startPrank(owner);

        /// @dev Testing initial state
        assertFalse(
            carameloContract.isSwapAndLiquifyEnabled(),
            'Should be disabled initially'
        );

        /// @dev Testing after enabling
        carameloContract.setSwapAndLiquifyEnabled(true);
        assertTrue(
            carameloContract.isSwapAndLiquifyEnabled(),
            'Should be enabled'
        );

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

        carameloContract.configureSwapProtocol(routerAddress);
        carameloContract.setSwapAndLiquifyEnabled(true);

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
        vm.stopPrank();
    }

    function testSwapExecute() external {
        console.log('-------------------------------------------------');
        console.log('------------- TEST SWAP PancakeSwap (BUY) -------------');
        console.log('-------------------------------------------------');
        console.log('\n');
        /// ------------------------------------------------------------------------------------------------
        /// @notice INITIAL SETUP TO TEST SWAP
        /// ------------------------------------------------------------------------------------------------
        uint256 initialCarameloBalance = carameloContract.balanceOf(userA);
        uint256 initialUserABalance = userA.balance;
        console.log('Inicial Caramelo balance of userA:', initialCarameloBalance);
        console.log('Inicial BNB balance of userA:', initialUserABalance);
        /// @dev inicializar tokenomics
        vm.startPrank(owner);
        carameloContract.initializeTokenomics();
        vm.stopPrank();
    
        /// @dev validar o saldo do owner após tokenomics
        uint256 fiftyPercentageSupplyOfTokensAmount = carameloContract.balanceOf(owner); // 50% do total supply
        uint256 expectedTokenAmount = 500000000000000000; // Esperado
        assertEq(fiftyPercentageSupplyOfTokensAmount, expectedTokenAmount, 'Token amount should be 500000000000000000');
        console.log("Token amount community wallet apos initialize tokenomics:", fiftyPercentageSupplyOfTokensAmount);
        /// ------------------------------------------------------------------------------------------------

        /// ------------------------------------------------------------------------------------------------
        /// @notice ADD LIQUIDITY
        /// ------------------------------------------------------------------------------------------------
        /// @dev add 50 ethers to pool 
        vm.deal(owner, 50 ether);
    
        /// @dev adicionar liquidez ao pool
        uint256 lpTokens = _addLiquidity(fiftyPercentageSupplyOfTokensAmount, 50 ether);
        console.log("LP tokens recebidos:", lpTokens);
    
        /// @dev validar que o par foi criado
        address pair = carameloContract.uniswapV2Pair();
        require(pair != address(0), "Pair should be created");
    
        /// @dev obter reservas do par
        (uint112 reserveToken, uint112 reserveETH, ) = IUniswapV2Pair(pair).getReserves();
        console.log("Reserve token:", reserveToken); // 500000000000 tokens
        console.log("Reserve ETH:", reserveETH); // 50000000000000000 em wei = 0.05 ethers
        /// @custom:info maxTXAmount = 500_000_000 tokens
        /// @custom:info maxETHForMaxTxAmount = 0.05 ethers
        /// ------------------------------------------------------------------------------------------------

        /// ------------------------------------------------------------------------------------------------
        /// @notice BUY TOKENS
        /// ------------------------------------------------------------------------------------------------
        /// @dev calcular valor máximo de ETH permitido com base no maxTxAmount
        uint256 maxTxAmount = carameloContract.maxTxAmount();
        uint256 maxETHForMaxTxAmount = (maxTxAmount * reserveETH) / reserveToken;
        console.log("ETH necessario para maxTxAmount:", maxETHForMaxTxAmount);
    
        /// @dev adicionar 0.1 ETH ao userA para simular a compra
        vm.deal(userA, maxETHForMaxTxAmount);
    
        /// @dev realizar compra de tokens usando ETH
        vm.startPrank(userA);
    
        /// @dev construir o caminho para o swap
        address[] memory path = new address[](2);
        path[0] = IUniswapV2Router02(routerAddress).WETH(); // Início do caminho: WETH
        path[1] = address(carameloContract); // Fim do caminho: Token Caramelo
    
        /// @dev realizar swap
        IUniswapV2Router02(routerAddress).swapExactETHForTokensSupportingFeeOnTransferTokens{
            value: maxETHForMaxTxAmount
        }(
            0, // Aceitar qualquer quantidade mínima de tokens
            path, // Caminho para o swap (WETH -> Caramelo)
            userA, // Endereço que receberá os tokens
            block.timestamp + 300 // Deadline para a transação
        );
    
        vm.stopPrank();
    
        /// @dev verificar saldo final de Caramelo para userA
        uint256 carameloBalance = carameloContract.balanceOf(userA);
        console.log("Caramelo balance de userA:", carameloBalance);
        /// ------------------------------------------------------------------------------------------------\
        console.log('-------------------------------------------------');
        console.log('------------- TEST SWAP PancakeSwap (SELL) -------------');
        console.log('-------------------------------------------------');
        console.log('\n');
        /// ------------------------------------------------------------------------------------------------
        /// @notice SELL TOKENS
        /// ------------------------------------------------------------------------------------------------
        /// @dev verificar se o saldo de tokens é maior que zero
        require(carameloBalance > 0, "UserA deveria ter recebido tokens Caramelo");


        uint256 amountToSell = carameloBalance * 90 / 100; // sell 90% of the tokens
        
        address[] memory pathSell = new address[](2);
        pathSell[0] = address(carameloContract);
        pathSell[1] = IUniswapV2Router02(routerAddress).WETH();
        /// @dev try to sell all tokens
        vm.startPrank(userA);
        carameloContract.approve(routerAddress, amountToSell);
        IUniswapV2Router02(routerAddress).swapExactTokensForETHSupportingFeeOnTransferTokens(
            amountToSell,
            0,
            pathSell,
            userA,
            block.timestamp + 300
        );
        vm.stopPrank();
        
        uint256 BNBUserABalance = userA.balance;
        console.log("BNB balance of userA:", BNBUserABalance);
        console.log('\n');
    }
    

    /// @dev auxiliar functionks
    function _addLiquidity(
        uint256 tokenAmount,
        uint256 ethAmount
    ) internal returns (uint256 lpTokens) {
        vm.startPrank(owner);

        /// @dev configure Uniswap if it's not already configured
        if (address(carameloContract.uniswapV2Router()) == address(0)) {
            carameloContract.configureSwapProtocol(routerAddress);
        }

        /// @dev approve router to spend tokens
        carameloContract.approve(routerAddress, tokenAmount);

        /// @dev give ETH to owner
        vm.deal(owner, ethAmount);

        /// @dev add liquidity
        (
            uint256 amountToken,
            uint256 amountETH,
            uint256 liquidity
        ) = IUniswapV2Router02(routerAddress).addLiquidityETH{value: ethAmount}(
                address(carameloContract),
                tokenAmount,
                0, // slippage 100%
                0, // slippage 100%
                owner,
                block.timestamp + 300
            );

        vm.stopPrank();

        /// @dev security checks
        address pair = carameloContract.uniswapV2Pair();
        require(
            carameloContract.balanceOf(pair) >= amountToken,
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
