// SPDX-License-Identifier: MIT
pragma solidity ^0.8.20;

import {Test} from 'forge-std/Test.sol';
import {console} from 'forge-std/console.sol';
import {Token} from '../contracts/Token.sol';
import {ERC1967Proxy} from '@openzeppelin/contracts/proxy/ERC1967/ERC1967Proxy.sol';

/**
 * @dev This contract is a test suite for the upgradeable Token contract.
 * It includes tests for the initial implementation of the Token contract,
 * as well as tests for the upgraded version (TokenV2).
 *
 * The test suite uses the Forge testing framework and includes the following components:
 *
 * - Token: The initial implementation of the Token contract.
 * - TokenV2: The upgraded implementation of the Token contract with additional functionality.
 * - ERC1967Proxy: The proxy contract used to delegate calls to the implementation contracts.
 * - InvalidImplementationContract: A contract used to test invalid upgrade scenarios.
 *
 * The test suite verifies the following:
 *
 * - Deployment and initialization of the Token contract.
 * - Upgrading the Token contract to TokenV2.
 * - Ensuring the state and functionality are preserved after the upgrade.
 * - Testing new functionality introduced in TokenV2.
 * - Handling of invalid upgrade attempts.
 *
 * The test suite also includes various utility functions and event checks to ensure the correctness of the upgrade process.
 */

error InvalidImplementation();
error UpgradesAreFrozen();

/// @dev TokenV2 contract
contract TokenV2 is Token {
    /// @dev new variable to demonstrate the update
    uint256 public newVariable;

    // Novo evento para demonstrar a atualização
    event NewVariableSet(uint256 value);

    // Nova função para demonstrar a atualização
    function setNewVariable(uint256 _value) external onlyOwner {
        newVariable = _value;
        emit NewVariableSet(_value);
    }

    // Nova função para demonstrar a atualização da versão
    function getVersion() external pure returns (string memory) {
        return 'V2';
    }
}

contract RevertingContract {
    function proxiableUUID() external pure {
        revert();
    }
}

/// @dev invalid contract for tests
contract InvalidImplementationContract {
    function proxiableUUID() external pure returns (bytes32) {
        return bytes32(0x0);
    }
}

contract UpgradeTokenTest is Test {
    /// @dev event emited when upgrade is done
    event Upgraded(address indexed implementation);

    Token public implementation;
    TokenV2 public implementationV2;
    ERC1967Proxy public proxy;
    Token public proxyToken;
    TokenV2 public proxyTokenV2;

    address public owner;
    address public userA;
    address public userB;

    /// @dev token parameters
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
            initialSupply: 1_000_000,
            decimals: 6,
            taxFee: 5,
            liquidityFee: 5,
            maxTokensTXAmount: 500_000,
            numTokensSellToAddToLiquidity: 500_000,
            version: '1'
        });

    function setUp() public {
        owner = makeAddr('owner');
        userA = makeAddr('userA');
        userB = makeAddr('userB');

        /// @dev deploy V1 implementation
        implementation = new Token();

        /// @dev prepare initialization data
        bytes memory initData = abi.encodeWithSelector(
            Token.initialize.selector,
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

        /// @dev deploy proxy with V1 implementation
        vm.startPrank(owner);
        proxy = new ERC1967Proxy(address(implementation), initData);
        proxyToken = Token(payable(address(proxy)));
        vm.stopPrank();
    }

    function testInitialState() public view {
        console.log('Testing initial state...');

        assertEq(proxyToken.name(), tokenParams.name, 'Nome incorreto');
        assertEq(proxyToken.symbol(), tokenParams.symbol, 'Simbolo incorreto');
        assertEq(
            proxyToken.totalSupply(),
            tokenParams.initialSupply * 10 ** tokenParams.decimals,
            'Supply incorreto'
        );
        assertEq(
            proxyToken.contractVersion(),
            tokenParams.version,
            'Versao incorreta'
        );
    }

    function testUpgrade() public {
        console.log('-------------------------------------------------');
        console.log('---------------- TEST UPGRADE --------------------');
        console.log('-------------------------------------------------');
        console.log('\n');

        // Verificar se a inicialização foi bem sucedida
        assertEq(
            proxyToken.name(),
            tokenParams.name,
            'Nome do token incorreto'
        );
        assertEq(
            proxyToken.symbol(),
            tokenParams.symbol,
            'Simbolo do token incorreto'
        );

        console.log(
            'Versao inicial do contrato:',
            proxyToken.contractVersion()
        );

        // Instanciar a implementação V2
        implementationV2 = new TokenV2();

        // Fazer upgrade para V2
        vm.startPrank(owner);
        proxyToken.upgradeTo(address(implementationV2));
        proxyTokenV2 = TokenV2(payable(address(proxy)));
        vm.stopPrank();

        // Testar nova funcionalidade
        vm.startPrank(owner);
        proxyTokenV2.setNewVariable(42);
        vm.stopPrank();

        // Verificar se a nova variável foi definida
        assertEq(
            proxyTokenV2.newVariable(),
            42,
            'Nova variavel nao foi definida corretamente'
        );

        // Verificar se os dados antigos foram preservados
        assertEq(
            proxyTokenV2.name(),
            tokenParams.name,
            'Nome do token foi perdido apos upgrade'
        );
        assertEq(
            proxyTokenV2.symbol(),
            tokenParams.symbol,
            'Simbolo do token foi perdido apos upgrade'
        );

        console.log('Nova variavel apos upgrade:', proxyTokenV2.newVariable());

        // Testar restrição de acesso ao upgrade
        vm.startPrank(userA);
        vm.expectRevert('Ownable: caller is not the owner');
        proxyToken.upgradeTo(address(implementationV2));
        vm.stopPrank();

        console.log('\n');
    }

    function testUpgradeToV2() public {
        console.log('Testing upgrade to V2...');

        /// @dev deploy V2 implementation
        implementationV2 = new TokenV2();

        /// @dev upgrade to V2
        vm.startPrank(owner);
        proxyToken.upgradeTo(address(implementationV2));
        proxyTokenV2 = TokenV2(payable(address(proxy)));
        vm.stopPrank();

        /// @dev check if previous state is preserved
        assertEq(
            proxyTokenV2.name(),
            tokenParams.name,
            'Nome perdido apos upgrade'
        );
        assertEq(
            proxyTokenV2.symbol(),
            tokenParams.symbol,
            'Simbolo perdido apos upgrade'
        );
        assertEq(
            proxyTokenV2.totalSupply(),
            tokenParams.initialSupply * 10 ** tokenParams.decimals,
            'Supply alterado apos upgrade'
        );
    }

    function testNewFunctionalityAfterUpgrade() public {
        console.log('Testing new functionality after upgrade...');

        /// @dev upgrade to V2
        implementationV2 = new TokenV2();
        vm.startPrank(owner);
        proxyToken.upgradeTo(address(implementationV2));
        proxyTokenV2 = TokenV2(payable(address(proxy)));

        /// @dev test new functionality
        uint256 newValue = 42;
        proxyTokenV2.setNewVariable(newValue);
        vm.stopPrank();

        assertEq(
            proxyTokenV2.newVariable(),
            newValue,
            'Nova variavel nao foi setada corretamente'
        );
        assertEq(
            proxyTokenV2.getVersion(),
            'V2',
            'Versao incorreta apos upgrade'
        );
    }

    function testUpgradeAccessControl() public {
        console.log('Testing upgrade access control...');

        implementationV2 = new TokenV2();

        /// @dev test unauthorized access
        vm.startPrank(userA);
        vm.expectRevert('Ownable: caller is not the owner');
        proxyToken.upgradeTo(address(implementationV2));
        vm.stopPrank();

        /// @dev test authorized access
        vm.startPrank(owner);
        proxyToken.upgradeTo(address(implementationV2));
        vm.stopPrank();

        /// @dev check if upgrade is successful
        proxyTokenV2 = TokenV2(payable(address(proxy)));
        assertEq(proxyTokenV2.getVersion(), 'V2', 'Upgrade nao foi realizado');
    }

    function testCannotUpgradeToInvalidImplementation() public {
        console.log('Testing upgrade to invalid implementation...');

        /// @dev try to upgrade to an invalid address
        vm.startPrank(owner);
        vm.expectRevert();
        proxyToken.upgradeTo(address(0));
        vm.stopPrank();

        /// @dev try to upgrade to an invalid address
        address randomContract = makeAddr('random');
        vm.startPrank(owner);
        vm.expectRevert();
        proxyToken.upgradeTo(randomContract);
        vm.stopPrank();
    }

    function testUpgradeEvent() public {
        console.log('Testing upgrade event...');

        implementationV2 = new TokenV2();

        vm.startPrank(owner);
        vm.expectEmit(true, true, true, true);
        emit Upgraded(address(implementationV2));
        proxyToken.upgradeTo(address(implementationV2));
        vm.stopPrank();
    }

    function testStateAfterMultipleTransactions() public {
        console.log('Testing state after multiple transactions...');

        /// @dev transfer tokens to userA
        vm.startPrank(owner);
        proxyToken.transfer(userA, 1000 * 10 ** tokenParams.decimals);
        vm.stopPrank();

        /// @dev upgrade to V2
        implementationV2 = new TokenV2();
        vm.startPrank(owner);
        proxyToken.upgradeTo(address(implementationV2));
        proxyTokenV2 = TokenV2(payable(address(proxy)));
        vm.stopPrank();

        /// @dev check if balance is preserved
        assertEq(
            proxyTokenV2.balanceOf(userA),
            1000 * 10 ** tokenParams.decimals,
            'Balance alterado apos upgrade'
        );

        /// @dev calculate expected amount after fees
        uint256 transferAmount = 500 * 10 ** tokenParams.decimals;
        uint256 totalFee = tokenParams.taxFee + tokenParams.liquidityFee;
        uint256 expectedAmount = (transferAmount * (100 - totalFee)) / 100;


        /// @dev transfer tokens to userB
        vm.startPrank(userA);
        proxyTokenV2.transfer(userB, transferAmount);
        vm.stopPrank();

        /// @dev check if balance is correct after fees
        uint256 actualBalance = proxyTokenV2.balanceOf(userB);
        uint256 marginOfError = expectedAmount / 1000; // 0.1% de margem de erro

        // Log para debug
        console.log('Total fee:', totalFee, '%');
        console.log('Transfer amount:', transferAmount);
        console.log('Expected amount after fees:', expectedAmount);
        console.log('Actual balance:', actualBalance);
        console.log('Margin of error:', marginOfError);

        // Verificar se o valor está dentro da margem de erro
        bool isWithinMargin = actualBalance >= expectedAmount - marginOfError &&
            actualBalance <= expectedAmount + marginOfError;

        assertTrue(
            isWithinMargin,
            string(
                abi.encodePacked(
                    'Transferencia apos upgrade falhou. Recebido: ',
                    vm.toString(actualBalance),
                    ', Esperado: ',
                    vm.toString(expectedAmount),
                    ' +/- ',
                    vm.toString(marginOfError)
                )
            )
        );
    }

    function testFreezeUpgrades() public {
        console.log('Testing freeze upgrades...');

        implementationV2 = new TokenV2();

        vm.startPrank(owner);
        /// @dev freeze upgrades
        proxyToken.freezeUpgrades();

        /// @dev try to upgrade should fail
        vm.expectRevert(UpgradesAreFrozen.selector);
        proxyToken.upgradeTo(address(implementationV2));
        vm.stopPrank();
    }

    function testUpgradeToInvalidContract() public {
        console.log('Testing upgrade to invalid contract...');

        /// @dev try to upgrade to an invalid contract
        vm.startPrank(owner);
        vm.expectRevert(InvalidImplementation.selector);
        proxyToken.upgradeTo(address(0x1));
        vm.stopPrank();

        /// @dev try to upgrade to an invalid contract
        InvalidImplementationContract invalidImpl = new InvalidImplementationContract();
        vm.startPrank(owner);
        vm.expectRevert(InvalidImplementation.selector);
        proxyToken.upgradeTo(address(invalidImpl));
        vm.stopPrank();
    }

    function testGetImplementation() public {
        console.log('Testing get implementation...');

        address currentImpl = proxyToken.getImplementation();
        assertEq(
            currentImpl,
            address(implementation),
            'Wrong implementation address'
        );

        /// @dev upgrade to V2
        implementationV2 = new TokenV2();
        vm.startPrank(owner);
        proxyToken.upgradeTo(address(implementationV2));
        vm.stopPrank();

        address newImpl = proxyToken.getImplementation();
        assertEq(
            newImpl,
            address(implementationV2),
            'Implementation not updated'
        );
    }

    function testUpgradeWithState() public {
        console.log('Testing upgrade with state preservation...');

        /// @dev set initial state
        vm.startPrank(owner);
        proxyToken.setFees(3, 3); // Definir novas taxas
        uint256 initialTaxFee = proxyToken.taxFee();

        /// @dev upgrade to V2
        implementationV2 = new TokenV2();
        proxyToken.upgradeTo(address(implementationV2));
        proxyTokenV2 = TokenV2(payable(address(proxy)));

        /// @dev check if state is preserved
        assertEq(
            proxyTokenV2.taxFee(),
            initialTaxFee,
            'Tax fee not preserved after upgrade'
        );

        /// @dev test new functionality with existing state
        proxyTokenV2.setNewVariable(42);
        assertEq(
            proxyTokenV2.newVariable(),
            42,
            'New variable not set correctly'
        );
        assertEq(
            proxyTokenV2.taxFee(),
            initialTaxFee,
            'State changed after using new function'
        );
        vm.stopPrank();
    }

    function testUpgradeEventDetails() public {
        console.log('Testing upgrade event details...');

        implementationV2 = new TokenV2();

        vm.startPrank(owner);
        vm.expectEmit(true, true, true, true);
        emit Upgraded(address(implementationV2));

        /// @dev capture state before upgrade
        uint256 totalSupplyBefore = proxyToken.totalSupply();
        uint256 ownerBalanceBefore = proxyToken.balanceOf(owner);

        proxyToken.upgradeTo(address(implementationV2));
        proxyTokenV2 = TokenV2(payable(address(proxy)));

        /// @dev check if critical state is preserved
        assertEq(
            proxyTokenV2.totalSupply(),
            totalSupplyBefore,
            'Total supply changed'
        );
        assertEq(
            proxyTokenV2.balanceOf(owner),
            ownerBalanceBefore,
            'Balance changed'
        );
        vm.stopPrank();
    }
    function testAuthorizeUpgradeComplete() public {
        vm.startPrank(owner);

        // 1. Teste com endereço zero
        vm.expectRevert(InvalidImplementation.selector);
        proxyToken.upgradeTo(address(0));

        // 2. Teste com endereço não-contrato
        vm.expectRevert(InvalidImplementation.selector);
        proxyToken.upgradeTo(makeAddr('not-a-contract'));

        // 3. Teste com implementação que retorna UUID errado
        address invalidImpl = address(new InvalidImplementationContract());
        vm.expectRevert(InvalidImplementation.selector);
        proxyToken.upgradeTo(invalidImpl);

        // 4. Teste com contrato que reverte
        address reverting = address(new RevertingContract());
        vm.expectRevert(InvalidImplementation.selector);
        proxyToken.upgradeTo(reverting);

        // 5. Teste congelamento de upgrades
        proxyToken.freezeUpgrades();

        // 6. Criar nova implementação válida
        Token newImpl = new Token();

        // 7. Tentar upgrade após congelar (deve falhar com UpgradesAreFrozen)
        vm.expectRevert(UpgradesAreFrozen.selector);
        proxyToken.upgradeTo(address(newImpl));

        vm.stopPrank();
    }
}
