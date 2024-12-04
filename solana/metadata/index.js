const {
    Metaplex,
    keypairIdentity,
  } = require("@metaplex-foundation/js");
  const { Connection, Keypair, PublicKey } = require("@solana/web3.js");
  
  (async () => {
    try {
      // Configurar a conexão com a Devnet
      const connection = new Connection("https://api.devnet.solana.com", "confirmed");
  
      // Reconstruir a wallet a partir da chave secreta
      const secretKey = new Uint8Array([
        97, 162, 238, 145, 84, 248, 206, 228, 244, 69, 241, 188, 50, 6, 69, 115, 44, 173, 103, 115,
        113, 170, 71, 122, 230, 78, 24, 181, 222, 191, 148, 147, 129, 22, 179, 124, 119, 43, 8, 192,
        219, 219, 40, 59, 167, 193, 198, 251, 118, 133, 231, 144, 193, 1, 114, 231, 5, 95, 160, 181,
        215, 154, 137, 6
      ]);
      const wallet = Keypair.fromSecretKey(secretKey);
  
      // Inicializar o Metaplex com a identidade da wallet
      const metaplex = Metaplex.make(connection).use(keypairIdentity(wallet));
  
      // Endereço do Mint do Token SPL
      const mintAddress = new PublicKey("9fUWjkopc66Q6JmnwgjiqFMS3TFDpr34MWiNcgqBZyMF");
  
      // Upload dos metadados para a rede
      const { uri } = await metaplex.nfts().uploadMetadata({
        name: "Meu Token Personalizado", // Nome do token
        symbol: "MTK", // Símbolo do token
        description: "Este é um token personalizado criado na Devnet.",
        image: "https://example.com/token-image.png", // Substitua por uma URL de imagem válida
        attributes: [
          { trait_type: "Categoria", value: "Exemplo" },
          { trait_type: "Rede", value: "Devnet" },
        ],
      });
  
      console.log("Metadados carregados com URI:", uri);
  
      const metadata = await metaplex.nfts().create({
        uri, 
        name: "Meu Token Personalizado",
        symbol: "MTK",
        sellerFeeBasisPoints: 500,
        mintAddress,
        updateAuthority: wallet.publicKey, 
      });
  
      console.log("Metadados associados com sucesso!");
      console.log(metadata);
    } catch (error) {
      console.error("Erro ao configurar os metadados:", error);
    }
  })();
  