// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from 'forge-std/Test.sol';
import {console} from 'forge-std/console.sol';
import {IERC20} from '@openzeppelin/contracts/token/ERC20/IERC20.sol';
// import {Caramelo} from '../contracts/Caramelo.sol';
import {Token} from '../contracts/Token.sol';
import {IUniswapV2Router02, IUniswapV2Factory} from '../contracts/interfaces/UniswapV2Interfaces.sol';

/** 
 @dev _maxTxAmount - liberar para certos address
 @dev mudar decimals pra 9
 */

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
            'Caramelo', // tokenName
            'CML', // tokenSymbol
            1_000_000, // _totalSupply
            5, // _taxFee
            5, // _liquidityFee
            3, // _burnFee
            10_000 ether, // _maxTxAmount
            1_000 ether, // _numTokensSellToAddToLiquidity
            routerAddress // PancakeSwap Router
        );

        require(
            token.isExcludedFromFee(owner),
            'Owner nao esta excluido das taxas!'
        );
        vm.stopPrank(); // Finalizando o contexto do owner
    }

    function testTotalSupply() public view {
        uint256 expectedSupply = 1_000_000 * 10 ** token.decimals();
        uint256 actualSupply = token.totalSupply();

        console.log('Total Supply Inicial:', actualSupply);

        require(
            actualSupply == expectedSupply,
            'Total Supply nao corresponde ao esperado!'
        );
    }

    function testTransferWithReflection() public {
        address fictUserA;
        uint256 privateKeyFictUserA;

        address fictUserB;
        uint256 privateKeyFictUserB;

        address fictUserC;
        uint256 privateKeyFictUserC;

        uint256 transferAmount = 1_000 * 10 ** token.decimals(); // 1,000 tokens

        (fictUserA, privateKeyFictUserA) = makeAddrAndKey('fictUserA');
        (fictUserB, privateKeyFictUserB) = makeAddrAndKey('fictUserB');
        (fictUserC, privateKeyFictUserC) = makeAddrAndKey('fictUserC');

        console.log('-----------------------------------------');
        console.log('-------------  Test sem Taxas --------------');
        console.log('-----------------------------------------');
        console.log('\n');

        // Transferindo tokens para fictUserA
        vm.startPrank(owner);
        token.transfer(fictUserA, transferAmount);
        vm.stopPrank();

        require(
            token.balanceOf(fictUserA) == transferAmount,
            'Balance fictUserA nao corresponde a todo valor transferido!'
        );
        console.log('Balance fictUserA:', token.balanceOf(fictUserA));

        uint256 contractBalance = token.balanceOf(address(token));
        console.log('Balance contrato:', contractBalance);
        require(contractBalance == 0, 'O contrato nao deveria ter balance!');

        uint256 finalSupply = token.totalSupply();

        console.log('Total Supply final:', finalSupply);
        require(
            finalSupply == 1_000_000 * 10 ** token.decimals(),
            'Total Supply final nao deveria ser diferente de 1_000_000 000 000!'
        );
        console.log('-----------------------------------------------');

        console.log('\n');
        console.log('-----------------------------------------');
        console.log('--------- Test Transfer com taxas --------------');
        console.log('-----------------------------------------');
        console.log('\n');

        // Transfer fictUserA -> fictUserB
        vm.startPrank(fictUserA);
        token.transfer(fictUserB, transferAmount);
        vm.stopPrank();

        // Transfer 1 token para fictUserC para reflection
        vm.startPrank(owner);
        token.transfer(fictUserC, 1 * 10 ** token.decimals());
        vm.stopPrank();

        uint256 taxFee = token.taxFee(); // 5%
        uint256 liquidityFee = token.liquidityFee(); // 5%
        uint256 burnFee = token.burnFee(); // 3%

        console.log('Tax Fee (holders):', taxFee);
        console.log('Liquidity Fee:', liquidityFee);
        console.log('Burn Fee:', burnFee);

        uint256 totalFee = taxFee + liquidityFee + burnFee;
        console.log('Total Fee:', totalFee);

        uint256 userBBalance = token.balanceOf(fictUserB);
        uint256 expectedUserBBalance = transferAmount -
            (transferAmount * totalFee) /
            100;
        console.log('Balance fictUserB:', userBBalance);
        console.log('Expected Balance fictUserB:', expectedUserBBalance);

        require(
            userBBalance == expectedUserBBalance,
            'Balance fictUserB nao corresponde ao esperado!'
        );

        // Validar redução de supply pela taxa de queima
        uint256 totalSupplyUpdated = token.totalSupply();
        uint256 expectedSupplyAfterBurn = 1_000_000 *
            10 ** token.decimals() -
            (transferAmount * burnFee) /
            100;

        console.log('Total Supply Atual:', totalSupplyUpdated);
        console.log('Expected Supply After Burn:', expectedSupplyAfterBurn);

        require(
            totalSupplyUpdated == expectedSupplyAfterBurn,
            'Total Supply nao corresponde ao esperado apos queima!'
        );

        console.log('\n');
        console.log('-----------------------------------------');
        console.log('--------- Validando saldo de holders --------------');
        console.log('-----------------------------------------');
        console.log('\n');

        uint256 fictUserABalance = token.balanceOf(fictUserA);
        uint256 fictUserBBalance = token.balanceOf(fictUserB);
        uint256 fictUserCBalance = token.balanceOf(fictUserC);

        console.log('Balance fictUserA:', fictUserABalance);
        console.log('Balance fictUserB:', fictUserBBalance);
        console.log('Balance fictUserC:', fictUserCBalance);
        /** 

        Balance fictUserA: 50002
        Balance fictUserB: 870
        Balance fictUserC: 1
         */
    }

    function addLiquidityHelper(
        uint256 tokenAmount,
        uint256 ethAmount
    ) internal {
        vm.deal(owner, ethAmount);

        vm.startPrank(owner);
        token.approve(routerAddress, tokenAmount);
        uint256 allowance = token.allowance(owner, routerAddress);

        require(
            allowance >= tokenAmount,
            'Aprovacao insuficiente para o Router'
        );
        vm.stopPrank();

        vm.startPrank(owner);
        IUniswapV2Router02(routerAddress).addLiquidityETH{value: ethAmount}(
            address(token),
            tokenAmount,
            0,
            0,
            owner,
            block.timestamp + 300
        );
        vm.stopPrank();

        address pair = token.uniswapV2Pair();
        uint256 lpBalance = IERC20(pair).balanceOf(owner);
        require(lpBalance > 0, 'Liquidez nao foi adicionada com sucesso!');
    }
}
