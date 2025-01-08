import { expect } from 'chai';
import { ethers, upgrades } from 'hardhat';
import { CustomerManagementCore, PointCore } from '../../typechain';

describe('PointCore', function () {
  let pointCoreInstance: PointCore;
  let clientManager: CustomerManagementCore;
  let owner: any;
  let clientData: any;

  const CUSTOMER_TITANIUM_NFT_ID = 3;
  const CUSTOMER_GOLD_NFT_ID = 2;
  const CUSTOMER_PREMIUM_NFT_ID = 1;

  async function deployPointContractProxy() {
    // @ts-ignore
    const [owner] = await ethers.getSigners();

    // Deploy CustomerManagementCore
    const ClientManagerContract = await ethers.getContractFactory(
      'CustomerManagementCore'
    );
    clientManager = (await upgrades.deployProxy(ClientManagerContract, [], {
      initializer: 'initialize',
    })) as unknown as CustomerManagementCore;

    const proxyAddress = await clientManager.getAddress();

    const pointContract = await ethers.getContractFactory('PointCore');

    pointCoreInstance = (await upgrades.deployProxy(
      pointContract,
      [proxyAddress, process.env.METADATA_PROVIDER_URL],
      {
        initializer: 'initialize',
      }
    )) as unknown as PointCore;

    return { pointCoreInstance, clientManager, owner };
  }

  beforeEach(async function () {
    const {
      pointCoreInstance: newPointCore,
      clientManager: newClientManager,
      owner: newOwner,
    } = await deployPointContractProxy();

    pointCoreInstance = newPointCore;
    owner = newOwner;
    clientManager = newClientManager;

    clientData = {
      name: 'John Doe',
      age: 30,
      WalletAddress: owner.address,
      paymentStatus: 0,
      addressLocal: {
        City: 'Test City',
        Street: 'Test Street',
        PostalCode: 12345,
        HouseNumber: 67,
      },
    };

    await clientManager.registerClient(clientData);
  });

  it('Should register points to client by id', async function () {
    await pointCoreInstance.addPoints(1, 100);

    const points = await pointCoreInstance.getClientPoints(1);

    expect(points).to.equal(100);
  });

  it('Should revert when trying to add points to a non-existent client', async function () {
    // Suponha que o cliente com ID 999 não existe
    const nonExistentClientId = 999;
    const pointsToAdd = 100;

    await expect(
      pointCoreInstance.addPoints(nonExistentClientId, pointsToAdd)
    ).to.be.revertedWith('InvalidClientID on PointCore');
  });

  it('Should reset points when reaching the maximum level', async function () {
    // Add 1000 points to the client (max point)
    await pointCoreInstance.addPoints(1, 1000);

    // verify that the client has 0 points after reaching the maximum level
    const pointsAfterMaxLevel = await pointCoreInstance.getClientPoints(1);
    expect(pointsAfterMaxLevel).to.equal(0);
  });

  it('Should burn the previous level NFT when advancing to a new level', async function () {
    // Primeiro, adicione pontos suficientes para alcançar o nível Premium
    await pointCoreInstance.addPoints(1, 200);

    // Em seguida, adicione mais pontos para alcançar o nível Gold
    await pointCoreInstance.addPoints(1, 300); // Totalizando 500 pontos

    // Verifique se o NFT Premium foi queimado
    const previousLevelNftBalance = await pointCoreInstance.balanceOf(
      owner.address,
      1
    ); // Substitua 1 pelo ID do NFT Premium
    expect(previousLevelNftBalance).to.equal(0);

    // Verifique se o NFT Gold foi emitido
    const newLevelNftBalance = await pointCoreInstance.balanceOf(
      owner.address,
      2
    ); // Substitua 2 pelo ID do NFT Gold
    expect(newLevelNftBalance).to.equal(1);
  });

  it('Should mint a new NFT when reaching a new level', async function () {
    // Suponha que 200 pontos sejam suficientes para o nível Premium
    await pointCoreInstance.addPoints(1, 200);

    // Verifique se o NFT foi emitido corretamente
    const nftBalance = await pointCoreInstance.balanceOf(owner.address, 1);
    expect(nftBalance).to.equal(1);
  });

  it('Should allow changing point and test NFT thresholds for each level', async function () {
    // Alterar os limiares de pontos
    await pointCoreInstance.setPointThresholds(300, 600, 1200);

    // Adicionar pontos e verificar se os novos limiares estão funcionando
    await pointCoreInstance.addPoints(1, 300);
    const nftBalance = await pointCoreInstance.balanceOf(owner.address, 1); // Substitua 1 pelo ID do NFT Premium com novo limiar
    expect(nftBalance).to.equal(1);
  });

  it('Should correctly remove points from a client', async function () {
    // Adicionar e depois remover pontos
    await pointCoreInstance.addPoints(1, 200);
    await pointCoreInstance.removePoints(1, 100);

    // Verificar a pontuação atual
    const currentPoints = await pointCoreInstance.getClientPoints(1);
    expect(currentPoints).to.equal(100);
  });

  it('Should burn the max level NFT when points are reset', async function () {
    // Add 1000 points to the client to reach the max level
    await pointCoreInstance.addPoints(1, 1000);

    /// @dev add more points to reach the max level and burn the max level NFT
    await pointCoreInstance.addPoints(1, 4);
    // Verificar se o NFT do nível máximo foi queimado
    const nftBalance = await pointCoreInstance.balanceOf(owner.address, 3);
    expect(Number(nftBalance.toString())).to.equal(0);
  });

  it('Should return the balances of NFT', async function () {
    // Add 1000 points to the client to reach the max level
    await pointCoreInstance.addPoints(1, 1000);

    // Verificar se o NFT do nível mínimo foi emitido
    const nftBalance = await pointCoreInstance.balanceOf(owner.address, 3);
    expect(Number(nftBalance.toString())).to.equal(1);
  });

  it('Should return the balances of Batch NFTs from 4 clients', async function () {
    const clientOneToRegister = {
      ...clientData,
      name: 'Joana Doe',
      age: 11,
      WalletAddress: '0x1234567890123456789012345678901234567890',
    };
    const clientTwoToRegister = {
      ...clientData,
      name: 'Kalice Doe',
      age: 12,
      WalletAddress: '0x1234567890123456789012345678901234567891',
    };
    const clientThreeToRegister = {
      ...clientData,
      name: 'Luisa Doe',
      age: 13,
      WalletAddress: '0x1234567890123456789012345678901234567892',
    };
    const clientFourToRegister = {
      ...clientData,
      name: 'Maria Doe',
      age: 14,
      WalletAddress: '0x1234567890123456789012345678901234567893',
    };

    /// @dev register 4 clients with different age
    await clientManager.registerClient(clientOneToRegister);
    await clientManager.registerClient(clientTwoToRegister);
    await clientManager.registerClient(clientThreeToRegister);
    await clientManager.registerClient(clientFourToRegister);

    const userIDOne = 2;
    const userIDTwo = 3;
    const userIDThree = 4;
    const userIDFour = 5;

    const retrieveClientDataOne = await clientManager.getClientData(userIDOne);
    const retrieveClientDataTwo = await clientManager.getClientData(userIDTwo);
    const retrieveClientDataThree = await clientManager.getClientData(
      userIDThree
    );
    const retrieveClientDataFour = await clientManager.getClientData(
      userIDFour
    );

    expect(retrieveClientDataOne.name).to.equal(clientOneToRegister.name);
    expect(retrieveClientDataTwo.name).to.equal(clientTwoToRegister.name);
    expect(retrieveClientDataThree.name).to.equal(clientThreeToRegister.name);
    expect(retrieveClientDataFour.name).to.equal(clientFourToRegister.name);

    // // Add 1000 points to the client to reach the max level
    /**
     * @dev adiciona os pontos para os clientes
     * @param userIDOne ID do cliente
     * @param userIDTwo ID do cliente
     * @param userIDThree ID do cliente
     * @param userIDFour ID do cliente
     * @param points quantidade de pontos
     */
    await pointCoreInstance.addPoints(userIDOne, 250);
    await pointCoreInstance.addPoints(userIDTwo, 600);
    await pointCoreInstance.addPoints(userIDThree, 800);
    await pointCoreInstance.addPoints(userIDFour, 1250);

    const customerPremiumNftBalances = await pointCoreInstance.balanceOfBatch(
      [
        clientOneToRegister.WalletAddress,
        clientTwoToRegister.WalletAddress,
        clientThreeToRegister.WalletAddress,
        clientFourToRegister.WalletAddress,
      ],
      [
        CUSTOMER_PREMIUM_NFT_ID,
        CUSTOMER_PREMIUM_NFT_ID,
        CUSTOMER_PREMIUM_NFT_ID,
        CUSTOMER_PREMIUM_NFT_ID,
      ]
    );
    const customerGoldNftBalances = await pointCoreInstance.balanceOfBatch(
      [
        clientOneToRegister.WalletAddress,
        clientTwoToRegister.WalletAddress,
        clientThreeToRegister.WalletAddress,
        clientFourToRegister.WalletAddress,
      ],
      [
        CUSTOMER_GOLD_NFT_ID,
        CUSTOMER_GOLD_NFT_ID,
        CUSTOMER_GOLD_NFT_ID,
        CUSTOMER_GOLD_NFT_ID,
      ]
    );
    const customerTitaniumNftBalances = await pointCoreInstance.balanceOfBatch(
      [
        clientOneToRegister.WalletAddress,
        clientTwoToRegister.WalletAddress,
        clientThreeToRegister.WalletAddress,
        clientFourToRegister.WalletAddress,
      ],
      [
        CUSTOMER_TITANIUM_NFT_ID,
        CUSTOMER_TITANIUM_NFT_ID,
        CUSTOMER_TITANIUM_NFT_ID,
        CUSTOMER_TITANIUM_NFT_ID,
      ]
    );

    /// @dev espera que apenas o cliente 1 possua o NFT da insignia CUSTOMER_PREMIUM
    expect(customerPremiumNftBalances[0]).to.equal(1);

    /// @dev espera que apenas o cliente 2 e 3 possua o NFT da insignia CUSTOMER_GOLD
    expect(customerGoldNftBalances[1]).to.equal(1);
    expect(customerGoldNftBalances[2]).to.equal(1);

    /// @dev espera que apenas o cliente 4 possua o NFT da insignia CUSTOMER_TITANIUM
    expect(customerTitaniumNftBalances[3]).to.equal(1);
  });
});
