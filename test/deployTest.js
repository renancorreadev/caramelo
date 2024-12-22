/* eslint-disable @typescript-eslint/no-var-requires */
const { ethers } = require('hardhat');

describe('Gas Report for Deploy', function () {
  it('Should deploy contracts and report gas usage', async function () {
    const [deployer] = await ethers.getSigners();

    console.log('Deploying contracts with account:', deployer.address);

    const Caramelo = await ethers.getContractFactory('Caramelo');
    const caramelo = await Caramelo.deploy(
      'Caramelo',
      'CAR',
      ethers.parseUnits('1000000000000000', 6),
      6,
      5,
      5,
      ethers.parseUnits('50000000000000', 6),
      ethers.parseUnits('200000000000000', 6)
    );
    await caramelo.waitForDeployment();
    console.log('Caramelo deployed at:', caramelo.target);

    const CarameloPreSale = await ethers.getContractFactory('CarameloPreSale');
    const carameloPreSale = await CarameloPreSale.deploy(
      await caramelo.getAddress(),
      ethers.parseUnits('100000000', 6),
      ethers.parseUnits('60000000', 6),
      ethers.parseUnits('50000000', 6),
      ethers.parseUnits('84000000000', 6),
      ethers.parseUnits('4200000000', 6)
    );
    await carameloPreSale.waitForDeployment();
    console.log('PreSale deployed at:', carameloPreSale.target);
  });
});
