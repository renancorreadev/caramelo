require("dotenv").config();
const { ethers } = require("hardhat");

async function main() {
  const [deployer] = await ethers.getSigners();

  console.log("Deploying contracts with account:", deployer.address);
  console.log(
    "Account balance:",
    (await deployer.provider.getBalance(deployer.address)).toString()
  );

  // Parâmetros para o contrato Caramelo
  const tokenName = "Caramelo";
  const tokenSymbol = "CAR";
  const totalSupply = ethers.parseUnits("1000000000000000", 6); // 1 trilhão com 6 decimais
  const taxFee = 5;
  const liquidityFee = 5;
  const maxTxAmount = ethers.parseUnits("50000000000000", 6); // 50 bilhões
  const numTokensSellToAddToLiquidity = ethers.parseUnits("200000000000000", 6);

  // Deploy do contrato Caramelo
  const Caramelo = await ethers.getContractFactory("Caramelo");
  const caramelo = await Caramelo.deploy(
    tokenName,
    tokenSymbol,
    totalSupply,
    6,
    taxFee,
    liquidityFee,
    maxTxAmount,
    numTokensSellToAddToLiquidity
  );
  await caramelo.waitForDeployment();

  console.log("Caramelo deployed at:", caramelo.target);

  // Parâmetros para o contrato PreSale
  const ratePhase1 = ethers.parseUnits("100000000", 6);
  const ratePhase2 = ethers.parseUnits("60000000", 6);
  const ratePhase3 = ethers.parseUnits("50000000", 6);
  const tokensAvailable = ethers.parseUnits("84000000000", 6);
  const maxTokensBuy = ethers.parseUnits("4200000000", 6);

  // Deploy do contrato CarameloPreSale
  const CarameloPreSale = await ethers.getContractFactory("CarameloPreSale");
  const carameloPreSale = await CarameloPreSale.deploy(
    await caramelo.getAddress(),
    ratePhase1,
    ratePhase2,
    ratePhase3,
    tokensAvailable,
    maxTokensBuy
  );
  await carameloPreSale.waitForDeployment();

  console.log("PreSale deployed at:", carameloPreSale.target);


  // 1. Excluindo PreSale das taxas
  console.log("1. Excluindo contrato PreSale das taxas...");
  const tx1 = await caramelo.excludeFromFee(carameloPreSale.target);
  await tx1.wait();
  console.log("Contrato PreSale excluído das taxas.");

  // 2. Transferindo tokens para o contrato PreSale
  console.log("2. Transferindo tokens para o contrato PreSale...");
  const tokensToTransfer = await carameloPreSale.tokensAvailable();
  const tx2 = await caramelo.transfer(carameloPreSale.target, tokensToTransfer);
  await tx2.wait();
  console.log("Tokens transferidos com sucesso para o contrato PreSale.");

  // 3. Inicializando a pré-venda
  console.log("3. Inicializando a pré-venda...");
  const tx3 = await carameloPreSale.initializePreSale();
  await tx3.wait();
  console.log("Pré-venda inicializada com sucesso!");
}

main()
  .then(() => process.exit(0))
  .catch((error) => {
    console.error("Erro no deploy:", error);
    process.exit(1);
  });

  /** 
   * 
   * Deploying contracts with account: 0x9965507D1a55bcC2695C58ba16FB37d819B0A4dc

        Caramelo deployed at: 0x1Eb835EB7BEEEE9E6bbFe08F16a2d2eF668204bd
        PreSale deployed at: 0x31A65C6d4EB07ad51E7afc890aC3b7bE84dF2Ead
        
        1. Excluindo contrato PreSale das taxas...
        Contrato PreSale excluído das taxas.
        2. Transferindo tokens para o contrato PreSale...
        Tokens transferidos com sucesso para o contrato PreSale.
        3. Inicializando a pré-venda...
        Pré-venda inicializada com sucesso!
   */