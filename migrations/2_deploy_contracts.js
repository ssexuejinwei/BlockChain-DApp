const SimpleStorage = artifacts.require("SimpleStorage");
const TutorialToken = artifacts.require("TutorialToken");
const ComplexStorage = artifacts.require("ComplexStorage");
const ProvEvent = artifacts.require("ProvEvent");
const ProvAgent = artifacts.require("ProvAgent");
const ProvObject = artifacts.require("ProvObject");
module.exports = function(deployer) {
  deployer.deploy(SimpleStorage);
  deployer.deploy(TutorialToken);
  deployer.deploy(ComplexStorage);
  deployer.deploy(ProvEvent);
  deployer.deploy(ProvAgent);
  deployer.deploy(ProvObject);
};
