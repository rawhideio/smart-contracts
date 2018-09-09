var NFT = artifacts.require("./NFT.sol");
var Dai = artifacts.require("./Dai.sol");

// JavaScript export
module.exports = function(deployer) {
    // Deployer is the Truffle wrapper for deploying
    // contracts to the network

    // Deploy the contract to the network
    //
    deployer.deploy(Dai)
        // Wait until the storage contract is deployed
        .then(() => Dai.deployed())
        // Deploy the InfoManager contract, while passing the address of the
        // Storage contract
        .then(() => deployer.deploy(NFT, Dai.address));
}
