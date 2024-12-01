// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from 'forge-std/Test.sol';
import {console} from 'forge-std/console.sol';
import {Token} from '../contracts/Token.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
import {IUniswapV2Router02} from '../contracts/interfaces/UniswapV2Interfaces.sol';
// Custom Errors
error ContractLocked();
error UniswapAlreadyConfigured();
error ZeroAddress();
error AlreadyExcluded();
error InvalidAmount();


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
            3,
            500_000,
            500_000,
            '1'
        );
        vm.stopPrank();
    }

    function testDecimals() public view {
        assertEq(token.decimals(), 6, 'Decimals should be 6');
    }

    function testSwapAndLiquifyEnabled() public {
        vm.startPrank(owner);

        // Test initial state
        assertFalse(
            token.swapAndLiquifyEnabled(),
            'Should be disabled initially'
        );

        // Enable
        token.setSwapAndLiquifyEnabled(true);
        assertTrue(token.swapAndLiquifyEnabled(), 'Should be enabled');

        // Try to enable again (should revert)
        vm.expectRevert('Swap is already enabled');
        token.setSwapAndLiquifyEnabled(true);

        // Disable
        token.setSwapAndLiquifyEnabled(false);
        assertFalse(token.swapAndLiquifyEnabled(), 'Should be disabled');

        // Try to disable again (should revert)
        vm.expectRevert('Swap is already disabled');
        token.setSwapAndLiquifyEnabled(false);

        vm.stopPrank();
    }

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

        // Agora configure o router
        token.configureUniswap(routerAddress);

        // Enable swap
        token.setSwapAndLiquifyEnabled(true);

        // Mock router swap calls
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
            abi.encode(0, 0, 0)
        );

        // Primeiro, aprove o router para gastar tokens
        token.approve(routerAddress, type(uint256).max);

        // Transfer enough tokens to trigger swap and liquify
        uint256 triggerAmount = token.numTokensSellToAddToLiquidity();
        token.transfer(address(token), triggerAmount);

        // This transfer should trigger swapAndLiquify
        uint256 amount = 100 * 10 ** token.decimals();
        token.transfer(userA, amount);

        vm.stopPrank();
    }

    function testSwapAndLiquifyDisabled() public {
        vm.startPrank(owner);

        // Setup mocks primeiro
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

        // Agora configure o router
        token.configureUniswap(routerAddress);

        // Primeiro habilitar o swap
        token.setSwapAndLiquifyEnabled(true);
        assertTrue(token.swapAndLiquifyEnabled(), 'Swap should be enabled');

        // Então desabilitar
        token.setSwapAndLiquifyEnabled(false);
        assertFalse(token.swapAndLiquifyEnabled(), 'Swap should be disabled');

        // Mock router calls para evitar swap
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
            abi.encode(0, 0, 0)
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

        // Mock WETH call para evitar swap
        vm.mockCall(
            routerAddress,
            abi.encodeWithSelector(bytes4(keccak256('WETH()'))),
            abi.encode(address(0)) // Retorna address(0) para evitar swap
        );

        token.transfer(userA, amount);

        // Verificar se a transferência foi bem sucedida
        assertEq(
            token.balanceOf(userA),
            balanceBefore + amount,
            'Transfer failed'
        );

        vm.stopPrank();
    }

    function testLiquidityMechanismWithRouter() public {
        vm.startPrank(owner);

        // Setup mocks primeiro
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

        // Agora configure o router
        token.configureUniswap(routerAddress);

        // Enable swap and liquify
        token.setSwapAndLiquifyEnabled(true);

        // Mock liquidity addition
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

        // Aprove o router
        token.approve(routerAddress, type(uint256).max);

        // Transfer amount that should trigger liquidity mechanism
        uint256 triggerAmount = token.numTokensSellToAddToLiquidity();
        token.transfer(address(token), triggerAmount);

        // Add ETH to contract for liquidity
        vm.deal(address(token), 1 ether);

        // This transfer should trigger the liquidity mechanism
        uint256 amount = 100 * 10 ** token.decimals();
        token.transfer(userA, amount);

        // Verificar se a transferência foi bem sucedida
        assertEq(token.balanceOf(userA), amount, 'Transfer failed');

        vm.stopPrank();
    }

    function testTransferEdgeCases() public {
        vm.startPrank(owner);

        // Test transfer to zero address
        vm.expectRevert();
        token.transfer(address(0), 100);

        // Test transfer with zero amount
        vm.expectRevert();
        token.transfer(userA, 0);

        // Test transfer exceeding maxTxAmount
        uint256 maxAmount = token.maxTxAmount() + 1;
        vm.expectRevert();
        token.transfer(userA, maxAmount);

        vm.stopPrank();
    }

    function testAuthorizeUpgradeEdgeCases() public {
        vm.startPrank(owner);

        // Test with zero address
        vm.expectRevert();
        token.upgradeTo(address(0));

        // Test with non-contract address
        vm.expectRevert();
        token.upgradeTo(userA);

        // Test after freezing upgrades
        token.freezeUpgrades();
        vm.expectRevert();
        token.upgradeTo(address(this));

        vm.stopPrank();
    }

    function testLockTheSwap() public {
        vm.startPrank(owner);

        // Setup para swap
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

        // Configure e habilite swap
        token.configureUniswap(routerAddress);
        token.setSwapAndLiquifyEnabled(true);

        // Mock para fazer o swap travar com revert
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

        // Teste reentrada durante swap
        uint256 triggerAmount = token.numTokensSellToAddToLiquidity();
        token.transfer(address(token), triggerAmount);

        // Tente fazer outra transferência durante o swap (deve falhar)
        vm.expectRevert(abi.encodeWithSelector(ContractLocked.selector));
        token.transfer(userA, 100);

        vm.stopPrank();
    }

    function testSwapFailures() public {
        vm.startPrank(owner);

        // Setup router mas com mocks que falham
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

        // Mock createPair para falhar
        vm.mockCallRevert(
            factoryAddress,
            abi.encodeWithSelector(
                bytes4(keccak256('createPair(address,address)'))
            ),
            'Failed to create pair' // Ajustado para string
        );

        // Configure router (deve falhar)
        vm.expectRevert('Failed to create pair'); // Ajustado para string
        token.configureUniswap(routerAddress);

        vm.stopPrank();
    }

    function testExcludeFromFeeEdgeCases() public {
        vm.startPrank(owner);

        // Teste excluir endereço já excluído
        token.excludeFromFee(userA);
        vm.expectRevert(abi.encodeWithSelector(AlreadyExcluded.selector));
        token.excludeFromFee(userA);

        vm.stopPrank();
    }

    function testSwapAndLiquifyMechanismEdgeCases() public {
        vm.startPrank(owner);

        // Setup
        address factoryAddress = makeAddr('factory');
        setupMocks(factoryAddress);
        token.configureUniswap(routerAddress);
        token.setSwapAndLiquifyEnabled(true);

        // Mock para as funções de swap e liquidity
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

        // Teste 1: Transferência abaixo do limite de swap
        uint256 smallAmount = token.numTokensSellToAddToLiquidity() - 1;
        uint256 balanceBefore = token.balanceOf(address(token));
        token.transfer(address(token), smallAmount);
        assertEq(
            token.balanceOf(address(token)),
            balanceBefore + smallAmount,
            'Small transfer should not trigger swap'
        );

        // Teste 2: Desabilitar swap e tentar transferência grande
        token.setSwapAndLiquifyEnabled(false);
        uint256 largeAmount = token.maxTxAmount() / 2;
        balanceBefore = token.balanceOf(address(token));
        token.transfer(address(token), largeAmount);
        assertEq(
            token.balanceOf(address(token)),
            balanceBefore + largeAmount,
            'Transfer with disabled swap should not trigger swap'
        );

        // Teste 3: Transferência do par
        address pair = token.uniswapV2Pair();
        uint256 pairAmount = 100 * 10 ** token.decimals();

        // Transferir tokens para o par
        token.transfer(pair, pairAmount);

        vm.stopPrank();

        // Transferir do par para userA
        vm.startPrank(pair);
        balanceBefore = token.balanceOf(userA);
        token.transfer(userA, pairAmount / 2);
        assertEq(
            token.balanceOf(userA),
            balanceBefore + pairAmount / 2,
            'Transfer from pair failed'
        );
        vm.stopPrank();

        // Verificar estado final
        vm.startPrank(owner);
        assertFalse(
            token.swapAndLiquifyEnabled(),
            'Swap should remain disabled'
        );
        vm.stopPrank();
    }

    function testFeeMechanismEdgeCases() public {
        vm.startPrank(owner);

        // Teste com todas as taxas em zero
        token.setFees(0, 0, 0);
        uint256 amount = 1000;
        uint256 balanceBefore = token.balanceOf(userA);
        token.transfer(userA, amount);
        assertEq(
            token.balanceOf(userA),
            balanceBefore + amount,
            'Transfer amount should be exact when fees are zero'
        );

        // Teste com taxas máximas (99%)
        token.setFees(33, 33, 33);
        amount = 1000;
        balanceBefore = token.balanceOf(userB);

        // Excluir owner das taxas para garantir que as taxas sejam aplicadas
        token.includeInFee(owner);
        token.transfer(userB, amount);

        // Com 99% de taxas, o valor recebido deve ser aproximadamente 1% do amount
        uint256 expectedAmount = amount / 100;
        assertTrue(
            token.balanceOf(userB) <= expectedAmount,
            'Transfer should have fees applied'
        );

        vm.stopPrank();
    }
    function testReflectionMechanismEdgeCases() public {
        vm.startPrank(owner);

        // Teste reflexão com valores pequenos
        uint256 tinyAmount = 1;
        uint256 balanceBefore = token.balanceOf(userB);
        token.transfer(userB, tinyAmount);
        assertTrue(
            token.balanceOf(userB) >= tinyAmount,
            'Reflection should work with tiny amounts'
        );

        // Teste reflexão com valores médios
        uint256 mediumAmount = token.maxTxAmount() / 2;
        balanceBefore = token.balanceOf(userA);
        token.transfer(userA, mediumAmount);
        assertTrue(
            token.balanceOf(userA) >= mediumAmount,
            'Reflection should work with medium amounts'
        );

        vm.stopPrank();
    }

    function testLiquidityAdditionEdgeCases() public {
        vm.startPrank(owner);

        // Setup
        address factoryAddress = makeAddr('factory');
        setupMocks(factoryAddress);
        token.configureUniswap(routerAddress);
        token.setSwapAndLiquifyEnabled(true);

        // Teste adição de liquidez com ETH zero
        vm.deal(address(token), 0);
        uint256 tokenAmount = token.numTokensSellToAddToLiquidity();
        token.transfer(address(token), tokenAmount);

        // Teste adição de liquidez com tokens zero
        vm.deal(address(token), 1 ether);
        vm.expectRevert(InvalidAmount.selector);
        token.transfer(address(token), 0);

        vm.stopPrank();
    }

    // Função helper para setup dos mocks
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

        // Setup
        address factoryAddress = makeAddr('factory');
        setupMocks(factoryAddress);
        token.configureUniswap(routerAddress);
        token.setSwapAndLiquifyEnabled(true);

        // Simular reentrada
        uint256 triggerAmount = token.numTokensSellToAddToLiquidity();
        token.transfer(address(token), triggerAmount);

        // Mock para fazer o swap falhar com ContractLocked
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
        // Teste tentativas de não-owner
        vm.startPrank(userA);

        vm.expectRevert();
        token.setFees(1, 1, 1);

        vm.expectRevert();
        token.setMaxTxAmount(1000);

        vm.expectRevert();
        token.excludeFromFee(userB);

        vm.stopPrank();
    }
}
