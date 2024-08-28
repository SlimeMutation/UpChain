require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();

const { ProxyAgent, setGlobalDispatcher } = require("undici");
const proxyAgent = new ProxyAgent("http://127.0.0.1:7890");
setGlobalDispatcher(proxyAgent);

/** @type import('hardhat/config').HardhatUserConfig */
module.exports = {
  solidity: "0.8.24",
  networks: {
    hardhat: {
      chainId: 31337
    },
    sepolia: {
      url: 'https://eth-sepolia.g.alchemy.com/v2/qeYtwko4GeiJFPfQu6cpGnRfe_fWQedH',
      accounts: [process.env.PRIVATE_KEY]
    },
  },
  etherscan: {
    apiKey: {
      sepolia: process.env.API_KEY
    }
  },
};
