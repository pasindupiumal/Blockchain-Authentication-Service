const BlockAuth = artifacts.require("./BlockAuth.sol");

module.exports = function(deployer) {
  deployer.deploy(BlockAuth);
};
