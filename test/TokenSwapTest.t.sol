// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from 'forge-std/Test.sol';
import {console} from 'forge-std/console.sol';
import {Token} from '../contracts/Token.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {IUniswapV2Router02} from '../contracts/interfaces/UniswapV2Interfaces.sol';

/// @notice Este contrato de teste é utilizado para verificar a funcionalidade de swap e liquidez do contrato Token.
/// @dev Utiliza a biblioteca forge-std para testes e mocks. O contrato testa a funcionalidade de swap e liquidez,
/// incluindo a configuração do Uniswap, habilitação de swap e liquidez, e verificação de transações.
/// @custom:error ContractLocked Indica que o contrato está bloqueado.
/// @custom:error UniswapAlreadyConfigured Indica que o Uniswap já foi configurado.
/// @custom:error ZeroAddress Indica que um endereço zero foi fornecido.
/// @custom:error AlreadyExcluded Indica que o endereço já está excluído.
/// @custom:error InvalidAmount Indica que um valor inválido foi fornecido.

// Custom Errors
error ContractLocked();
error UniswapAlreadyConfigured();
error ZeroAddress();
error AlreadyExcluded();
error InvalidAmount();
error TransferAmountExceedsMax();
error TransferAmountZero();

contract TokenSwapTest is Test {
    Token public token;
    address public owner;
    address public userA;
    address public userB;
    address public routerAddress;
    address public WETH;

    function setUp() public {
        owner = makeAddr('owner');
        userA = makeAddr('userA');
        userB = makeAddr('userB');
        routerAddress = makeAddr('router');
        WETH = makeAddr('WETH');

        vm.startPrank(owner);
        token = new Token();
        token.initialize(
            'Token',
            'TKN',
            1_000_000,
            6,
            5,
            5,
            500_000,
            500_000,
            '1'
        );
        vm.stopPrank();
    }

    /// @dev Test decimals
    function testDecimals() public view {
        assertEq(token.decimals(), 6, 'Decimals should be 6');
    }

    /// @dev Test swap and liquify enabled
    function testSwapAndLiquifyEnabled() public {
        vm.startPrank(owner);

        /// @dev Test initial state
        assertFalse(
            token.swapAndLiquifyEnabled(),
            'Should be disabled initially'
        );

        /// @dev Enable
        token.setSwapAndLiquifyEnabled(true);
        assertTrue(token.swapAndLiquifyEnabled(), 'Should be enabled');

        /// @dev Try to enable again (should revert)
        vm.expectRevert('Swap is already enabled');
        token.setSwapAndLiquifyEnabled(true);

        /// @dev Disable
        token.setSwapAndLiquifyEnabled(false);
        assertFalse(token.swapAndLiquifyEnabled(), 'Should be disabled');

        /// @dev Try to disable again (should revert)
        vm.expectRevert('Swap is already disabled');
        token.setSwapAndLiquifyEnabled(false);

        vm.stopPrank();
    }

    /// @dev Test swap and liquify trigger
    function testSwapAndLiquifyTrigger() public {
        vm.startPrank(owner);

        // Setup mocks ANTES de configurar o router
        address factoryAddress = makeAddr('factory');

        // Mock factory call
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('factory()'))),
            abi.encode(factoryAddress)
        );

        // Mock WETH address
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('WETH()'))),
            abi.encode(WETH)
        );

        // Mock createPair
        address pairAddress = makeAddr('pair');
        vm.mockCall(
            factoryAddress,
            abi.encodeWithSelector(
                bytes4(keccak256('createPair(address,address)'))
            ),
            abi.encode(pairAddress)
        );

        // Mock para getAmountsOut
        address[] memory path = new address[](2);
        path[0] = address(token);
        path[1] = WETH;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 1000;
        amounts[1] = 500;
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(
                bytes4(keccak256('getAmountsOut(uint256,address[])'))
            ),
            abi.encode(amounts)
        );

        // Agora configure o router
        token.configureUniswap(routerAddress);

        // Enable swap
        token.setSwapAndLiquifyEnabled(true);

        // Mock router swap calls com valores válidos
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(
                bytes4(
                    keccak256(
                        'swapExactTokensForETHSupportingFeeOnTransferTokens(uint256,uint256,address[],address,uint256)'
                    )
                )
            ),
            abi.encode(amounts)
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
            abi.encode(1000, 500, 100) // tokenAmount, ethAmount, liquidity
        );

        // Primeiro, aprove o router para gastar tokens
        token.approve(routerAddress, type(uint256).max);

        // Add ETH to contract
        vm.deal(address(token), 1 ether);

        // Transfer enough tokens to trigger swap and liquify
        uint256 triggerAmount = token.numTokensSellToAddToLiquidity();
        token.transfer(address(token), triggerAmount);

        // This transfer should trigger swapAndLiquify
        uint256 amount = 100 * 10 ** token.decimals();
        token.transfer(userA, amount);

        vm.stopPrank();
    }

    /// @dev Test swap and liquify disabled
    function testSwapAndLiquifyDisabled() public {
        vm.startPrank(owner);

        /// @dev Setup mocks primeiro
        address factoryAddress = makeAddr('factory');
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('factory()'))),
            abi.encode(factoryAddress)
        );

        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('WETH()'))),
            abi.encode(WETH)
        );

        address pairAddress = makeAddr('pair');
        vm.mockCall(
            factoryAddress,
            abi.encodeWithSelector(
                bytes4(keccak256('createPair(address,address)'))
            ),
            abi.encode(pairAddress)
        );

        // Mock para getAmountsOut
        address[] memory path = new address[](2);
        path[0] = address(token);
        path[1] = WETH;
        uint256[] memory amounts = new uint256[](2);
        amounts[0] = 1000;
        amounts[1] = 500;
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(
                bytes4(keccak256('getAmountsOut(uint256,address[])'))
            ),
            abi.encode(amounts)
        );

        // Agora configure o router
        token.configureUniswap(routerAddress);

        // Primeiro habilitar o swap
        token.setSwapAndLiquifyEnabled(true);
        assertTrue(token.swapAndLiquifyEnabled(), 'Swap should be enabled');

        // Então desabilitar
        token.setSwapAndLiquifyEnabled(false);
        assertFalse(token.swapAndLiquifyEnabled(), 'Swap should be disabled');

        // Mock router calls com valores válidos
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(
                bytes4(
                    keccak256(
                        'swapExactTokensForETHSupportingFeeOnTransferTokens(uint256,uint256,address[],address,uint256)'
                    )
                )
            ),
            abi.encode(amounts)
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
            abi.encode(1000, 500, 100) // tokenAmount, ethAmount, liquidity
        );

        // Primeiro, aprove o router
        token.approve(routerAddress, type(uint256).max);

        // Transfer tokens that would normally trigger swap
        uint256 triggerAmount = token.numTokensSellToAddToLiquidity();
        token.transfer(address(token), triggerAmount);

        // Verificar saldo antes
        uint256 balanceBefore = token.balanceOf(userA);

        // This transfer should not trigger swap because it's disabled
        uint256 amount = 100 * 10 ** token.decimals();

        token.transfer(userA, amount);

        // Verificar se a transferência foi bem sucedida
        assertEq(
            token.balanceOf(userA),
            balanceBefore + amount,
            'Transfer failed'
        );

        vm.stopPrank();
    }

    /// @dev Test liquidity mechanism with router
    function testLiquidityMechanismWithRouter() public {
        vm.startPrank(owner);

        /// @dev Setup mocks primeiro
        address factoryAddress = makeAddr('factory');
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('factory()'))),
            abi.encode(factoryAddress)
        );

        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('WETH()'))),
            abi.encode(WETH)
        );

        address pairAddress = makeAddr('pair');
        vm.mockCall(
            factoryAddress,
            abi.encodeWithSelector(
                bytes4(keccak256('createPair(address,address)'))
            ),
            abi.encode(pairAddress)
        );

        /// @dev Now configure the router
        token.configureUniswap(routerAddress);

        /// @dev Enable swap and liquify
        token.setSwapAndLiquifyEnabled(true);

        /// @dev Mock liquidity addition
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
            abi.encode(1000, 1 ether, 500) // Mock return values
        );

        /// @dev Aprove the router
        token.approve(routerAddress, type(uint256).max);

        /// @dev Transfer amount that should trigger liquidity mechanism
        uint256 triggerAmount = token.numTokensSellToAddToLiquidity();
        token.transfer(address(token), triggerAmount);

        /// @dev Add ETH to contract for liquidity
        vm.deal(address(token), 1 ether);

        /// @dev This transfer should trigger the liquidity mechanism
        uint256 amount = 100 * 10 ** token.decimals();
        token.transfer(userA, amount);

        /// @dev Verify the transfer was successful
        assertEq(token.balanceOf(userA), amount, 'Transfer failed');

        vm.stopPrank();
    }

    function testTransferEdgeCases() public {
        vm.startPrank(owner);

        /// @dev Test transfer to zero address
        vm.expectRevert();
        token.transfer(address(0), 100);

        /// @dev Test transfer with zero amount
        vm.expectRevert();
        token.transfer(userA, 0);

        /// @dev Test transfer exceeding maxTxAmount
        uint256 maxAmount = token.maxTxAmount() + 1;
        vm.expectRevert();
        token.transfer(userA, maxAmount);

        vm.stopPrank();
    }

    /// @dev Test authorize upgrade edge cases
    function testAuthorizeUpgradeEdgeCases() public {
        vm.startPrank(owner);

        /// @dev Test with zero address
        vm.expectRevert();
        token.upgradeTo(address(0));

        /// @dev Test with non-contract address
        vm.expectRevert();
        token.upgradeTo(userA);

        /// @dev Test after freezing upgrades
        token.freezeUpgrades();
        vm.expectRevert();
        token.upgradeTo(address(this));

        vm.stopPrank();
    }

    /// @dev Test lockTheSwap
    function testLockTheSwap() public {
        vm.startPrank(owner);

        /// @dev Setup for swap
        address factoryAddress = makeAddr('factory');
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('factory()'))),
            abi.encode(factoryAddress)
        );

        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('WETH()'))),
            abi.encode(WETH)
        );

        address pairAddress = makeAddr('pair');
        vm.mockCall(
            factoryAddress,
            abi.encodeWithSelector(
                bytes4(keccak256('createPair(address,address)'))
            ),
            abi.encode(pairAddress)
        );

        /// @dev Configure and enable swap
        token.configureUniswap(routerAddress);
        token.setSwapAndLiquifyEnabled(true);

        /// @dev Mock to make the swap lock with revert
        vm.mockCallRevert(
            routerAddress,
            abi.encodeWithSelector(
                bytes4(
                    keccak256(
                        'swapExactTokensForETHSupportingFeeOnTransferTokens(uint256,uint256,address[],address,uint256)'
                    )
                )
            ),
            abi.encodeWithSelector(ContractLocked.selector)
        );

        /// @dev Test reentry during swap
        uint256 triggerAmount = token.numTokensSellToAddToLiquidity();
        token.transfer(address(token), triggerAmount);

        /// @dev Try to make another transfer during the swap (should fail)
        vm.expectRevert(abi.encodeWithSelector(ContractLocked.selector));
        token.transfer(userA, 100);

        vm.stopPrank();
    }

    function testSwapFailures() public {
        vm.startPrank(owner);

        /// @dev Setup router but with mocks that fail
        address factoryAddress = makeAddr('factory');
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('factory()'))),
            abi.encode(factoryAddress)
        );

        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('WETH()'))),
            abi.encode(WETH)
        );

        /// @dev Mock createPair to fail
        vm.mockCallRevert(
            factoryAddress,
            abi.encodeWithSelector(
                bytes4(keccak256('createPair(address,address)'))
            ),
            'Failed to create pair'
        );

        /// @dev Configure router (should fail)
        vm.expectRevert('Failed to create pair');
        token.configureUniswap(routerAddress);

        vm.stopPrank();
    }

    function testExcludeFromFeeEdgeCases() public {
        vm.startPrank(owner);

        /// @dev Test exclude address already excluded
        token.excludeFromFee(userA);
        vm.expectRevert(abi.encodeWithSelector(AlreadyExcluded.selector));
        token.excludeFromFee(userA);

        vm.stopPrank();
    }

    function testSwapAndLiquifyMechanismEdgeCases() public {
        vm.startPrank(owner);

        /// @dev Setup
        address factoryAddress = makeAddr('factory');
        setupMocks(factoryAddress);
        token.configureUniswap(routerAddress);
        token.setSwapAndLiquifyEnabled(true);

        /// @dev Mock for swap and liquidity functions
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(
                IUniswapV2Router02
                    .swapExactTokensForETHSupportingFeeOnTransferTokens
                    .selector
            ),
            abi.encode()
        );

        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(IUniswapV2Router02.addLiquidityETH.selector),
            abi.encode(1000, 1 ether, 500)
        );

        /// @dev Test 1: Transfer below swap limit
        uint256 smallAmount = token.numTokensSellToAddToLiquidity() - 1;
        uint256 balanceBefore = token.balanceOf(address(token));
        token.transfer(address(token), smallAmount);
        assertEq(
            token.balanceOf(address(token)),
            balanceBefore + smallAmount,
            'Small transfer should not trigger swap'
        );

        /// @dev Test 2: Disable swap and try large transfer
        token.setSwapAndLiquifyEnabled(false);
        uint256 largeAmount = token.maxTxAmount() / 2;
        balanceBefore = token.balanceOf(address(token));
        token.transfer(address(token), largeAmount);
        assertEq(
            token.balanceOf(address(token)),
            balanceBefore + largeAmount,
            'Transfer with disabled swap should not trigger swap'
        );

        /// @dev Test 3: Transfer from pair
        address pair = token.uniswapV2Pair();
        uint256 pairAmount = 100 * 10 ** token.decimals();

        /// @dev Transfer tokens to pair
        token.transfer(pair, pairAmount);

        vm.stopPrank();

        /// @dev Transfer from pair to userA
        vm.startPrank(pair);
        balanceBefore = token.balanceOf(userA);
        token.transfer(userA, pairAmount / 2);
        assertEq(
            token.balanceOf(userA),
            balanceBefore + pairAmount / 2,
            'Transfer from pair failed'
        );
        vm.stopPrank();

        /// @dev Verify final state
        vm.startPrank(owner);
        assertFalse(
            token.swapAndLiquifyEnabled(),
            'Swap should remain disabled'
        );
        vm.stopPrank();
    }

    /// @dev Test reflection mechanism edge cases
    function testFeeMechanismEdgeCases() public {
        vm.startPrank(owner);

        /// @dev Testar com todas as taxas em zero
        token.setFees(0, 0);
        uint256 amount = 1000 * 10 ** token.decimals();
        uint256 balanceBefore = token.balanceOf(userA);
        token.transfer(userA, amount);

        assertEq(
            token.balanceOf(userA),
            balanceBefore + amount,
            'Transfer amount should be exact when fees are zero'
        );

        /// @dev Testar com taxas máximas (98%)
        token.setFees(49, 49); // Total 98%
        amount = 1000 * 10 ** token.decimals();
        balanceBefore = token.balanceOf(userB);

        /// @dev Incluir owner nas taxas para aplicar corretamente
        token.includeInFee(owner);
        token.transfer(userB, amount);

        /// @dev Com 98% de taxas, o valor recebido deve ser aproximadamente 2% do valor enviado
        uint256 expectedAmount = 20006862;

        assertEq(
            token.balanceOf(userB) - balanceBefore,
            expectedAmount,
            'Transfer should have fees applied'
        );

        vm.stopPrank();
    }

    /// @dev Test liquidity addition edge cases
    function testLiquidityAdditionEdgeCases() public {
        vm.startPrank(owner);

        /// @dev Setup
        address factoryAddress = makeAddr('factory');
        setupMocks(factoryAddress);
        token.configureUniswap(routerAddress);
        token.setSwapAndLiquifyEnabled(true);

        /// @dev Test liquidity addition with zero ETH
        vm.deal(address(token), 0);
        uint256 tokenAmount = token.numTokensSellToAddToLiquidity();
        token.transfer(address(token), tokenAmount);

        /// @dev Test liquidity addition with zero token amount
        vm.deal(address(token), 1 ether);
        vm.expectRevert(TransferAmountZero.selector);
        token.transfer(address(token), 0);

        vm.stopPrank();
    }

    /// @dev Helper function to setup mocks
    function setupMocks(address factoryAddress) private {
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('factory()'))),
            abi.encode(factoryAddress)
        );

        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('WETH()'))),
            abi.encode(WETH)
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

    function testModifierEdgeCases() public {
        vm.startPrank(owner);

        /// @dev Setup
        address factoryAddress = makeAddr('factory');
        setupMocks(factoryAddress);
        token.configureUniswap(routerAddress);
        token.setSwapAndLiquifyEnabled(true);

        /// @dev Simulate reentry
        uint256 triggerAmount = token.numTokensSellToAddToLiquidity();
        token.transfer(address(token), triggerAmount);

        /// @dev Mock to make the swap fail with ContractLocked
        vm.mockCallRevert(
            routerAddress,
            abi.encodeWithSelector(
                IUniswapV2Router02
                    .swapExactTokensForETHSupportingFeeOnTransferTokens
                    .selector
            ),
            abi.encodeWithSelector(ContractLocked.selector)
        );

        vm.expectRevert(abi.encodeWithSelector(ContractLocked.selector));
        token.transfer(userA, 100);

        vm.stopPrank();
    }
    function testOwnershipEdgeCases() public {
        /// @dev Test non-owner attempts
        vm.startPrank(userA);

        vm.expectRevert();
        token.setFees(1, 1);

        vm.expectRevert();
        token.setMaxTxAmount(1000);

        vm.expectRevert();
        token.excludeFromFee(userB);

        vm.stopPrank();
    }
}
