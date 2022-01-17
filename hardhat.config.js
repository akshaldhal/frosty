/* hardhat.config.js */
require("@nomiclabs/hardhat-waffle");

const fs = require("fs")
const privateKey = fs.readFileSync(".secret").toString()
module.exports = {
  networks:{
    hardhat:{
      chainId: 1337
    },
    mumbai: {
      url: 'https://rpc-mumbai.matic.today',
      accounts: [privateKey]
    },
    mainnet: {
      url: 'https://polygon-rpc.com/',
      accounts: [privateKey]
    },
    ethmainnet: {
      url: 'https://main-light.eth.linkpool.io/',
      accounts: [privateKey]
    },
    ethrinkeby: {
      url: 'https://rinkeby-light.eth.linkpool.io/',
      accounts: [privateKey]
    }
  },
  solidity: "0.8.4",
};
