#!/bin/bash
forge verify-contract --chain-id 97 --watch \
--compiler-version "v0.8.2+commit.661d1103" \
0xb60CDB1Cba0245B9db7188F0CEe4979EB8a52fe7 contracts/Token.sol:Token


forge verify-contract --chain-id 97 --watch \
--compiler-version "v0.8.22" \
0x8C4293F4612dC1CA8ee3bb8922d21f8cD332522A \
contracts/CarameloPreSale.sol:CarameloPreSale \
--constructor-args $(cast abi-encode \
"constructor(address,uint256,uint256,uint256,uint256)" \
"0x367e257B64457B0C558735766f42f17B110D7709" \
"1000" "800" "600" "300000000000000")