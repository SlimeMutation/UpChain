require("@nomicfoundation/hardhat-toolbox");
require('dotenv').config();
require('hardhat-abi-exporter');

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
  abiExporter: {
    path: './deployments/abi',
    clear: true,
    flat: true,
    only: ['ERC2612', 'Bank', 'MyERC721'],
    spacing: 2,
    pretty: true,
  },
  etherscan: {
    apiKey: {
      sepolia: process.env.API_KEY
    }
  },
};
