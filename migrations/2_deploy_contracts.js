const BlockAuth = artifacts.require("./BlockAuth.sol");
const BlockAuthVerify = artifacts.require("./BlockAuthVerify.sol");

module.exports = function(deployer) {
  deployer.deploy(BlockAuth);
};


module.exports = function(deployer) {
  deployer.deploy(BlockAuthVerify);
};
