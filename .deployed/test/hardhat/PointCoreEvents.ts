import { expect } from 'chai';
import { ethers, upgrades } from 'hardhat';
import { CustomerManagementCore, PointCore } from '../../typechain';

describe('PointCore Events Ommiteds', function () {
  let pointCoreInstance: PointCore;
  let clientManager: CustomerManagementCore;
  let owner: any;
  let clientData: any;

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
      [proxyAddress, 'http://localhost:3000/api/metadata/'],
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

  it('Should emit event PointsAdded  on blockchain', async function () {
    const clientId = 1;
    const points = 100;

    // Adicione pontos ao cliente
    await pointCoreInstance.addPoints(clientId, points);

    // Verifique se o evento PointsAdded foi emitido corretamente
    const pointsAddedEvent = pointCoreInstance.filters.PointsAdded(
      undefined,
      undefined
    );

    const pointsAddedLogs = await pointCoreInstance.queryFilter(
      pointsAddedEvent
    );

    // Certifique-se de que um evento tenha sido emitido
    expect(pointsAddedLogs.length).to.equal(1);
    expect(pointsAddedLogs[0].args.clientId).to.equal(clientId);
    expect(pointsAddedLogs[0].args.points).to.equal(points);
  });

  it('Should emit event CustomerTitaniumMinted  correctly (when 1000 points are added) ', async function () {
    const clientId = 1; // O clientId aqui é um number

    // Mint a Titanium NFT for the client
    const txResponse = await pointCoreInstance.addPoints(clientId, 1000);
    await txResponse.wait();
    // Use queryFilter para encontrar os eventos CustomerTitaniumMinted
    const titaniumMintedEvents = await pointCoreInstance.queryFilter(
      pointCoreInstance.filters.CustomerTitaniumMinted()
    );

    // Verifique se algum evento foi encontrado
    if (titaniumMintedEvents.length === 0) {
      throw new Error('No CustomerTitaniumMinted events found');
    }

    // Encontre o evento específico para o clientId
    const event = titaniumMintedEvents.find(
      (e) => BigInt(e.args.clientId) === BigInt(clientId)
    );

    // Verifique se o evento está presente e faça as asserções
    if (event) {
      expect(BigInt(event.args.clientId)).to.equal(BigInt(clientId));
      expect(event.args.clientAddress).to.equal(owner.address);
    } else {
      throw new Error(
        'Expected CustomerTitaniumMinted event for clientId not found'
      );
    }
  });

  it('Should emit event CustomerGoldMinted correctly (when 500 points are added) ', async function () {
    const clientId = 1;

    // Mint a CUSTOMER_GOLD NFT for the client
    const txResponse = await pointCoreInstance.addPoints(clientId, 500);
    await txResponse.wait();
    // Use queryFilter para encontrar os eventos CustomerTitaniumMinted
    const customerMintedEvents = await pointCoreInstance.queryFilter(
      pointCoreInstance.filters.CustomerGoldMinted()
    );

    if (customerMintedEvents.length === 0) {
      throw new Error('No CustomerGoldMinted events found');
    }

    // Find event with matching clientId
    const event = customerMintedEvents.find(
      (e) => BigInt(e.args.clientId) === BigInt(clientId)
    );

    if (event) {
      expect(BigInt(event.args.clientId)).to.equal(BigInt(clientId));
      expect(event.args.clientAddress).to.equal(owner.address);
    } else {
      throw new Error(
        'Expected CustomerGoldMinted event for clientId not found'
      );
    }
  });

  it('Should emit event CustomerPremiumMinted correctly (when 200 points are added) ', async function () {
    const clientId = 1;

    // Mint a CUSTOMER_GOLD NFT for the client
    const txResponse = await pointCoreInstance.addPoints(clientId, 200);
    await txResponse.wait();
    // Use queryFilter para encontrar os eventos CustomerTitaniumMinted
    const customerMintedEvents = await pointCoreInstance.queryFilter(
      pointCoreInstance.filters.CustomerPremiumMinted()
    );

    if (customerMintedEvents.length === 0) {
      throw new Error('No CustomerPremiumMinted events found');
    }

    // Find event with matching clientId
    const event = customerMintedEvents.find(
      (e) => BigInt(e.args.clientId) === BigInt(clientId)
    );

    if (event) {
      expect(BigInt(event.args.clientId)).to.equal(BigInt(clientId));
      expect(event.args.clientAddress).to.equal(owner.address);
    } else {
      throw new Error(
        'Expected CustomerPremiumMinted event for clientId not found'
      );
    }
  });

  it('Should emit event ClientPointsChanged  on client level update', async function () {
    const clientId = 1;
    const points = 300; // Points added

    // Add points
    await pointCoreInstance.addPoints(clientId, points);

    const pointsChangedEvents = await pointCoreInstance.queryFilter(
      pointCoreInstance.filters.ClientPointsChanged()
    );

    const event = pointsChangedEvents.find(
      (e) => BigInt(e.args.clientId) === BigInt(clientId)
    );
    if (event) {
      expect(BigInt(event.args.clientId)).to.equal(BigInt(clientId));
      // verify that the points changed
      expect(BigInt(event.args.newPoints)).to.equal(BigInt(points));
    } else {
      throw new Error('Expected ClientPointsChanged event not found');
    }
  });

  it('Should emit CustomerGoldBurned event when a gold level client is upgraded', async function () {
    const clientId = 1;

    const pointsForGold = await pointCoreInstance.pointsForGold();
    const pointsForTitanium = await pointCoreInstance.pointsForTitanium();

    /// Add Customer Gold NFT TOKEN
    await pointCoreInstance.addPoints(clientId, Number(pointsForGold));

    const customerGoldMinted = await pointCoreInstance.queryFilter(
      pointCoreInstance.filters.CustomerGoldMinted()
    );
    const eventCustomerGoldMinted = customerGoldMinted.find(
      (e) => BigInt(e.args.clientId) === BigInt(clientId)
    );
    expect(BigInt(eventCustomerGoldMinted!.args.clientId)).to.equal(
      BigInt(clientId)
    );
    expect(eventCustomerGoldMinted!.args.clientAddress).to.equal(owner.address);
    /// ----x ----

    await pointCoreInstance.addPoints(clientId, pointsForTitanium);

    const goldBurnedEvents = await pointCoreInstance.queryFilter(
      pointCoreInstance.filters.CustomerGoldBurned()
    );

    // Find event with matching clientId if Burned
    const event = goldBurnedEvents.find(
      (e) => BigInt(e.args.clientId) === BigInt(clientId)
    );
    if (event) {
      expect(BigInt(event.args.clientId)).to.equal(BigInt(clientId));
      expect(event.args.clientAddress).to.equal(owner.address);
    } else {
      throw new Error('Expected CustomerGoldBurned event not found');
    }
  });

  it('Should emit CustomerPremiumBurned event when a premium level client is upgraded', async function () {
    const clientId = 1;

    const pointsForPremium = await pointCoreInstance.pointsForPremium();
    const pointsForGold = await pointCoreInstance.pointsForGold();

    await pointCoreInstance.addPoints(clientId, Number(pointsForPremium));

    const customerPremiumMinted = await pointCoreInstance.queryFilter(
      pointCoreInstance.filters.CustomerPremiumMinted()
    );
    const eventCustomerPremiumMinted = customerPremiumMinted.find(
      (e) => BigInt(e.args.clientId) === BigInt(clientId)
    );
    expect(BigInt(eventCustomerPremiumMinted!.args.clientId)).to.equal(
      BigInt(clientId)
    );
    expect(eventCustomerPremiumMinted!.args.clientAddress).to.equal(
      owner.address
    );

    // add more points to gold
    await pointCoreInstance.addPoints(clientId, Number(pointsForGold));

    const premiumBurnedEvents = await pointCoreInstance.queryFilter(
      pointCoreInstance.filters.CustomerPremiumBurned()
    );

    const event = premiumBurnedEvents.find(
      (e) => BigInt(e.args.clientId) === BigInt(clientId)
    );
    if (event) {
      expect(BigInt(event.args.clientId)).to.equal(BigInt(clientId));
      expect(event.args.clientAddress).to.equal(owner.address);
    } else {
      throw new Error('Expected CustomerPremiumBurned event not found');
    }
  });
});
