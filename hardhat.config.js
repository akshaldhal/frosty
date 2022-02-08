/* hardhat.config.js */
require("@nomiclabs/hardhat-waffle");

const fs = require("fs")
const privateKey = fs.readFileSync(".secret").toString()
module.exports = {
  networks:{
    hardhat:{
      chainId: 1337
    },
    ethmainnet: {
      url: 'https://main-light.eth.linkpool.io/',
      accounts: [privateKey]
    },
    ethrinkeby: {
      url: 'https://rinkeby-light.eth.linkpool.io/',
      accounts: [privateKey]
    },
    goerli: {
      url: "rpc",
      account: [privateKey]
    }
  },
  solidity: "0.8.4",
};
