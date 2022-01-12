require("@nomiclabs/hardhat-waffle");
require("dotenv").config();

const PROJECT_ID = process.env.PROJECT_ID;
const ACCOUNT = process.env.ACCOUNT;
/**
 * @type import('hardhat/config').HardhatUserConfig
 */
module.exports = {
  solidity: "0.8.4",
  networks:{
    rinkeby:{
      url: `https://rinkeby.infura.io/v3/${PROJECT_ID}`,
      accounts: [ACCOUNT]
    }
  }
};
