const ProvEvent = artifacts.require("ProvEvent");
const ProvAgent = artifacts.require("ProvAgent");
const ProvObject = artifacts.require("ProvObject");
const Strings = artifacts.require("Strings");

module.exports = function(deployer) {
  deployer.deploy(ProvEvent);
  deployer.deploy(ProvAgent);
  deployer.deploy(ProvObject);
  deployer.deploy(Strings);
};
