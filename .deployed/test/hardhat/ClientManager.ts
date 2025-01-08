/* eslint-disable @typescript-eslint/no-explicit-any */
import { expect } from 'chai';
import { ethers, upgrades } from 'hardhat';
import { CustomerManagementCore } from '../../typechain';

describe('CustomerManagementCore', function () {
  let clientManager: CustomerManagementCore;
  let owner: any;
  let clientData: any;

  async function deployClientManagerFixture() {
    // @ts-ignore
    const [owner] = await ethers.getSigners();

    const ClientManagerContract = await ethers.getContractFactory(
      process.env.CONTRACT_CLIENT_VERSION as string
    );

    clientManager = (await upgrades.deployProxy(ClientManagerContract, [], {
      initializer: 'initialize',
    })) as unknown as CustomerManagementCore;
    return { clientManager, owner };
  }

  beforeEach(async function () {
    const { clientManager: newClientManager, owner: newOwner } =
      await deployClientManagerFixture();
    clientManager = newClientManager;
    owner = newOwner;

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

  it('Should register and retrieve client data', async function () {
    const retrievedData = await clientManager.getClientData(1);
    expect(retrievedData.name).to.equal(clientData.name);
    expect(retrievedData.age).to.equal(clientData.age);
    expect(retrievedData.WalletAddress).to.equal(clientData.WalletAddress);
    expect(retrievedData.paymentStatus).to.equal(clientData.paymentStatus);
    expect(retrievedData.addressLocal.City).to.equal(
      clientData.addressLocal.City
    );
  });

  it('should retrieve client complete data with id', async function () {
    const retrievedData = await clientManager.getClientData(1);

    const formattedRetrievedData = {
      clientId: Number(retrievedData.clientId),
      name: retrievedData.name,
      age: Number(retrievedData.age),
      WalletAddress: retrievedData.WalletAddress,
      paymentStatus: Number(retrievedData.paymentStatus),
      addressLocal: {
        City: retrievedData.addressLocal.City,
        Street: retrievedData.addressLocal.Street,
        PostalCode: Number(retrievedData.addressLocal.PostalCode),
        HouseNumber: Number(retrievedData.addressLocal.HouseNumber),
      },
    };

    expect(retrievedData.clientId).to.deep.equal(
      formattedRetrievedData.clientId
    );
  });

  it('Should revert with EmptyParameter error if any parameter is empty', async function () {
    const invalidClientData = { ...clientData, name: '' };

    try {
      await clientManager.registerClient(invalidClientData);
      expect.fail('Transaction should have failed');
    } catch (error: any) {
      // verify if error has omited
      const expectedErrorMessage = 'EmptyParameter("It cannot be empty name")';
      expect(error.message).to.include(expectedErrorMessage);
    }
  });

  it('Should revert with EmptyParameter error if age is empty', async function () {
    const invalidClientData = { ...clientData, age: 0 };

    try {
      await clientManager.registerClient(invalidClientData);
      expect.fail('Transaction should have failed');
    } catch (error: any) {
      const expectedErrorMessage = 'EmptyParameter("It cannot be empty age")';
      expect(error.message).to.include(expectedErrorMessage);
    }
  });

  it('Should revert with EmptyParameter error if City is empty', async function () {
    const invalidClientData = {
      ...clientData,
      addressLocal: { ...clientData.addressLocal, City: '' },
    };

    try {
      await clientManager.registerClient(invalidClientData);
      expect.fail('Transaction should have failed');
    } catch (error: any) {
      const expectedErrorMessage = 'EmptyParameter("It cannot be empty City")';
      expect(error.message).to.include(expectedErrorMessage);
    }
  });

  it('Should revert with EmptyParameter error if Street is empty', async function () {
    const invalidClientData = {
      ...clientData,
      addressLocal: { ...clientData.addressLocal, Street: '' },
    };

    try {
      await clientManager.registerClient(invalidClientData);
      expect.fail('Transaction should have failed');
    } catch (error: any) {
      const expectedErrorMessage =
        'EmptyParameter("It cannot be empty Street")';
      expect(error.message).to.include(expectedErrorMessage);
    }
  });

  it('Should revert with EmptyParameter error if PostalCode is empty', async function () {
    const invalidClientData = {
      ...clientData,
      addressLocal: { ...clientData.addressLocal, PostalCode: 0 },
    };

    try {
      await clientManager.registerClient(invalidClientData);
      expect.fail('Transaction should have failed');
    } catch (error: any) {
      const expectedErrorMessage =
        'EmptyParameter("It cannot be empty PostalCode")';
      expect(error.message).to.include(expectedErrorMessage);
    }
  });

  it('Should revert with EmptyParameter error if HouseNumber is empty', async function () {
    const invalidClientData = {
      ...clientData,
      addressLocal: { ...clientData.addressLocal, HouseNumber: 0 },
    };

    try {
      await clientManager.registerClient(invalidClientData);
      expect.fail('Transaction should have failed');
    } catch (error: any) {
      const expectedErrorMessage =
        'EmptyParameter("It cannot be empty HouseNumber")';
      expect(error.message).to.include(expectedErrorMessage);
    }
  });

  it('Should retrieve client Id by name', async function () {
    const name = 'John Doe';
    const retrievedData = await clientManager.getClientsByName(name);

    expect(retrievedData.name).to.equal(name);
  });

  it('Should retrieve client Id by age', async function () {
    const age = 30;
    const retrievedData = await clientManager.getClientsByAge(age);

    expect(retrievedData.age).to.equal(age);
  });

  it('Should retrieve client Id by age', async function () {
    // @ts-ignore
    const [owner] = await ethers.getSigners();
    const retrievedData = await clientManager.getClientsByAddress(
      owner.address
    );

    expect(retrievedData.WalletAddress).to.equal(owner.address);
  });
});
