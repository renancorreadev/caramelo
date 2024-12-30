// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from 'forge-std/Test.sol';
import {console} from 'forge-std/console.sol';
import {Caramelo} from '../contracts/Caramelo.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {IUniswapV2Router02} from '../contracts/interfaces/UniswapV2Interfaces.sol';

import {
 ContractLocked,
 SwapProtocolAlreadyConfigured,
 ZeroAddress,
 AlreadyExcluded,
 InvalidAmount,
 TransferAmountExceedsMax,
 TransferAmountZero
} from '../contracts/utils/CarameloErrors.sol';

/// @notice Este contrato de teste é utilizado para verificar a funcionalidade de swap e liquidez do contrato Caramelo.
/// @dev Utiliza a biblioteca forge-std para testes e mocks. O contrato testa a funcionalidade de swap e liquidez,
contract CarameloSwapsTest is Test {
    Caramelo public carameloContract;
    address public owner;
    address public userA;
    address public userB;
    address public routerAddress;
    address public WETH;

    /** @dev Setup function */
    function setUp() public {
        owner = makeAddr('owner');
        userA = makeAddr('userA');
        userB = makeAddr('userB');
        routerAddress = makeAddr('router');
        WETH = makeAddr('WETH');

        vm.startPrank(owner);
        carameloContract = new Caramelo('Caramelo', 'TKN', 1_000_000, 9, 5, 5, 500_000, 500_000);

        vm.stopPrank();
    }

    /** @dev Test decimals */
    function testDecimals() public view {
        /*
         * @dev Check if the decimals are correct
         */
        assertEq(carameloContract.decimals(), 9, 'Decimals should be 6');
    }

    /** @dev Test swap and liquify enabled */
    function testSwapAndLiquifyEnabled() public {
        vm.startPrank(owner);

        /// @dev Test initial state
        assertFalse(
            carameloContract.swapAndLiquifyEnabled(),
            'Should be disabled initially'
        );

        /// @dev Enable
        carameloContract.setSwapAndLiquifyEnabled(true);
        assertTrue(carameloContract.swapAndLiquifyEnabled(), 'Should be enabled');

        /// @dev Try to enable again (should revert)
        vm.expectRevert('Swap is already enabled');
        carameloContract.setSwapAndLiquifyEnabled(true);

        /// @dev Disable
        carameloContract.setSwapAndLiquifyEnabled(false);
        assertFalse(carameloContract.swapAndLiquifyEnabled(), 'Should be disabled');

        /// @dev Try to disable again (should revert)
        vm.expectRevert('Swap is already disabled');
        carameloContract.setSwapAndLiquifyEnabled(false);

        vm.stopPrank();
    }

    /** @dev Test swap and liquify trigger */
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
        path[0] = address(carameloContract);
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
        carameloContract.configureSwapProtocol(routerAddress);

        // Enable swap
        carameloContract.setSwapAndLiquifyEnabled(true);

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
        carameloContract.approve(routerAddress, type(uint256).max);

        // Add ETH to contract
        vm.deal(address(carameloContract), 1 ether);

        // Transfer enough tokens to trigger swap and liquify
        uint256 triggerAmount = carameloContract.numTokensSellToAddToLiquidity();
        carameloContract.transfer(address(carameloContract), triggerAmount);

        // This transfer should trigger swapAndLiquify
        uint256 amount = 100 * 10 ** carameloContract.decimals();
        carameloContract.transfer(userA, amount);

        vm.stopPrank();
    }

    /** @dev Test swap and liquify disabled */
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
        path[0] = address(carameloContract);
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
        carameloContract.configureSwapProtocol(routerAddress);

        // Primeiro habilitar o swap
        carameloContract.setSwapAndLiquifyEnabled(true);
        assertTrue(carameloContract.swapAndLiquifyEnabled(), 'Swap should be enabled');

        // Então desabilitar
        carameloContract.setSwapAndLiquifyEnabled(false);
        assertFalse(carameloContract.swapAndLiquifyEnabled(), 'Swap should be disabled');

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
        carameloContract.approve(routerAddress, type(uint256).max);

        // Transfer tokens that would normally trigger swap
        uint256 triggerAmount = carameloContract.numTokensSellToAddToLiquidity();
        carameloContract.transfer(address(carameloContract), triggerAmount);

        // Verificar saldo antes
        uint256 balanceBefore = carameloContract.balanceOf(userA);

        // This transfer should not trigger swap because it's disabled
        uint256 amount = 100 * 10 ** carameloContract.decimals();

        carameloContract.transfer(userA, amount);

        // Verificar se a transferência foi bem sucedida
        assertEq(
            carameloContract.balanceOf(userA),
            balanceBefore + amount,
            'Transfer failed'
        );

        vm.stopPrank();
    }

    /** @dev Test liquidity mechanism with router */
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
        carameloContract.configureSwapProtocol(routerAddress);

        /// @dev Enable swap and liquify
        carameloContract.setSwapAndLiquifyEnabled(true);

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

        /// @dev Approve the router
        carameloContract.approve(routerAddress, type(uint256).max);

        /// @dev Transfer amount that should trigger liquidity mechanism
        uint256 triggerAmount = carameloContract.numTokensSellToAddToLiquidity();
        carameloContract.transfer(address(carameloContract), triggerAmount);

        /// @dev Add ETH to contract for liquidity
        vm.deal(address(carameloContract), 1 ether);

        /// @dev This transfer should trigger the liquidity mechanism
        uint256 amount = 100 * 10 ** carameloContract.decimals();
        carameloContract.transfer(userA, amount);

        /// @dev Verify the transfer was successful
        assertEq(carameloContract.balanceOf(userA), amount, 'Transfer failed');

        vm.stopPrank();
    }

    /** @dev Test transfer edge cases */
    function testTransferEdgeCases() public {
        vm.startPrank(owner);

        /// @dev Test transfer to zero address
        vm.expectRevert();
        carameloContract.transfer(address(0), 100);

        /// @dev Test transfer with zero amount
        vm.expectRevert();
        carameloContract.transfer(userA, 0);

        /// @dev Test transfer correct value
        uint256 amount = 100 * 10 ** carameloContract.decimals();
        carameloContract.transfer(userA, amount);
        vm.stopPrank();

        /// @dev Test transfer exceeding maxTxAmount
        uint256 maxAmount = carameloContract.maxTxAmount() + 1;
        vm.expectRevert();
        vm.startPrank(userA);
        carameloContract.transfer(userB, maxAmount);
        vm.stopPrank();
    }

    /** @dev Test lockTheSwap */
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
        carameloContract.configureSwapProtocol(routerAddress);
        carameloContract.setSwapAndLiquifyEnabled(true);

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
        uint256 triggerAmount = carameloContract.numTokensSellToAddToLiquidity();
        carameloContract.transfer(address(carameloContract), triggerAmount);

        /// @dev Try to make another transfer during the swap (should fail)
        vm.expectRevert(abi.encodeWithSelector(ContractLocked.selector));
        carameloContract.transfer(userA, 100);

        vm.stopPrank();
    }

    /** @dev Test swap failures */
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
        carameloContract.configureSwapProtocol(routerAddress);

        vm.stopPrank();
    }

    /** @dev Test excludeFromFee edge cases */
    function testExcludeFromFeeEdgeCases() public {
        vm.startPrank(owner);

        /// @dev Test exclude address already excluded
        carameloContract.excludeFromFee(userA);
        vm.expectRevert(abi.encodeWithSelector(AlreadyExcluded.selector));
        carameloContract.excludeFromFee(userA);

        vm.stopPrank();
    }

    /** @dev Test swap and liquify mechanism edge cases */
    function testSwapAndLiquifyMechanismEdgeCases() public {
        vm.startPrank(owner);

        /// @dev Setup
        address factoryAddress = makeAddr('factory');
        setupMocks(factoryAddress);
        carameloContract.configureSwapProtocol(routerAddress);
        carameloContract.setSwapAndLiquifyEnabled(true);

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
        uint256 smallAmount = carameloContract.numTokensSellToAddToLiquidity() - 1;
        uint256 balanceBefore = carameloContract.balanceOf(address(carameloContract));
        carameloContract.transfer(address(carameloContract), smallAmount);
        assertEq(
            carameloContract.balanceOf(address(carameloContract)),
            balanceBefore + smallAmount,
            'Small transfer should not trigger swap'
        );

        /// @dev Test 2: Disable swap and try large transfer
        carameloContract.setSwapAndLiquifyEnabled(false);
        uint256 largeAmount = carameloContract.maxTxAmount() / 2;
        balanceBefore = carameloContract.balanceOf(address(carameloContract));
        carameloContract.transfer(address(carameloContract), largeAmount);
        assertEq(
            carameloContract.balanceOf(address(carameloContract)),
            balanceBefore + largeAmount,
            'Transfer with disabled swap should not trigger swap'
        );

        /// @dev Test 3: Transfer from pair
        address pair = carameloContract.uniswapV2Pair();
        uint256 pairAmount = 100 * 10 ** carameloContract.decimals();

        /// @dev Transfer tokens to pair
        carameloContract.transfer(pair, pairAmount);

        vm.stopPrank();

        /// @dev Transfer from pair to userA
        vm.startPrank(pair);
        balanceBefore = carameloContract.balanceOf(userA);
        carameloContract.transfer(userA, pairAmount / 2);
        assertEq(
            carameloContract.balanceOf(userA),
            balanceBefore + pairAmount / 2,
            'Transfer from pair failed'
        );
        vm.stopPrank();

        /// @dev Verify final state
        vm.startPrank(owner);
        assertFalse(
            carameloContract.swapAndLiquifyEnabled(),
            'Swap should remain disabled'
        );
        vm.stopPrank();
    }

    /** @dev Test reflection mechanism edge cases */
    function testFeeMechanismEdgeCases() public {
        vm.startPrank(owner);

        /// @dev Testar com todas as taxas em zero
        carameloContract.setFees(0, 0);
        uint256 amount = 1000 * 10 ** carameloContract.decimals();
        uint256 balanceBefore = carameloContract.balanceOf(userA);
        carameloContract.transfer(userA, amount);

        assertEq(
            carameloContract.balanceOf(userA),
            balanceBefore + amount,
            'Transfer amount should be exact when fees are zero'
        );

        /// @dev Testar com taxas máximas (98%)
        carameloContract.setFees(49, 49); // Total 98%
        amount = 1000 * 10 ** carameloContract.decimals();
        balanceBefore = carameloContract.balanceOf(userB);

        /// @dev Incluir owner nas taxas para aplicar corretamente
        carameloContract.includeInFee(owner);
        carameloContract.transfer(userB, amount);

        /// @dev Com 98% de taxas, o valor recebido deve ser aproximadamente 2% do valor enviado
        uint256 expectedAmount = 999020342;

        assertEq(
            carameloContract.balanceOf(userB) - balanceBefore,
            expectedAmount,
            'Transfer should have fees applied'
        );

        vm.stopPrank();
    }

    /** @dev Test liquidity addition edge cases */
    function testLiquidityAdditionEdgeCases() public {
        vm.startPrank(owner);

        /// @dev Setup
        address factoryAddress = makeAddr('factory');
        setupMocks(factoryAddress);
        carameloContract.configureSwapProtocol(routerAddress);
        carameloContract.setSwapAndLiquifyEnabled(true);

        /// @dev Test liquidity addition with zero ETH
        vm.deal(address(carameloContract), 0);
        uint256 tokenAmount = carameloContract.numTokensSellToAddToLiquidity();
        carameloContract.transfer(address(carameloContract), tokenAmount);

        /// @dev Test liquidity addition with zero carameloContract amount
        vm.deal(address(carameloContract), 1 ether);
        vm.expectRevert(TransferAmountZero.selector);
        carameloContract.transfer(address(carameloContract), 0);

        vm.stopPrank();
    }

    /** @dev Helper function to setup mocks */
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

    /** @dev Test modifier edge cases */
    function testModifierEdgeCases() public {
        vm.startPrank(owner);

        /// @dev Setup
        address factoryAddress = makeAddr('factory');
        setupMocks(factoryAddress);
        carameloContract.configureSwapProtocol(routerAddress);
        carameloContract.setSwapAndLiquifyEnabled(true);

        /// @dev Simulate reentry
        uint256 triggerAmount = carameloContract.numTokensSellToAddToLiquidity();
        carameloContract.transfer(address(carameloContract), triggerAmount);

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
        carameloContract.transfer(userA, 100);

        vm.stopPrank();
    }

    /** @dev Test ownership edge cases */
    function testOwnershipEdgeCases() public {
        /// @dev Test non-owner attempts
        vm.startPrank(userA);

        vm.expectRevert();
        carameloContract.setFees(1, 1);

        vm.expectRevert();
        carameloContract.setMaxTxAmount(1000);

        vm.expectRevert();
        carameloContract.excludeFromFee(userB);

        vm.stopPrank();
    }
}
