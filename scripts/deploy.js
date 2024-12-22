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
  const tokenName = "Caramelo Coin";
  const tokenSymbol = "CARAMELO";
  const totalSupply = ethers.parseUnits("420000000000000000", 6); // 420 Quadrilhao com 6 decimais
  const taxFee = 5;
  const liquidityFee = 5;
  const maxTxAmount = ethers.parseUnits("126000000000000000", 6); //126.000.000.000.000.000 30% de total supply 
  const numTokensSellToAddToLiquidity = ethers.parseUnits("3780000000000000", 6); // 3% de 126.000.000.000.000.000 | 3,78 trilhões de tokens)

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
  const ratePhase1 = ethers.parseUnits("4200000000000", 6); // 4.200.000.000.000 tokens por 1 BNB | 50% 
  const ratePhase2 = ethers.parseUnits("2520000000000", 6); // 2.520.000.000.000 tokens por 1 BNB | 30% 
  const ratePhase3 = ethers.parseUnits("1680000000000", 6); // 1.680.000.000.000 tokens por 1 BNB | 20% 
  
  const tokensAvailable = ethers.parseUnits("84000000000000000", 6); // 84 quadrilhões 20% de total supply
  const maxTokensBuy = ethers.parseUnits("16800000000000000", 6); // 16,8 quadrilhões 20% de tokensAvailable

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