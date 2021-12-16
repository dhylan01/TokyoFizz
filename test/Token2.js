const { expect } = require("chai");
const {ethers} = require("ethers");

describe("Custom TokyoFizz", function() {
    it("Deploy and mint", async function() {
        const[owner] = ethers.await.getSigners();
        const Custom721 = await ethers.getContractFactory("Custom721");
        const custom721 = await Custom721.deploy(
            "Custom 721",
            "C721",
            "ipfs://SOME_HASH"
        );
        await custom721.deployed();

        expect(await custom721.baseURI()).to.equal("ipfs://SOME_HASH");

        const mintTx = await custom721.mint(2000000);
        await mintTx.wait();

        expect(await custom721.balanceOf(owner.address)).to.equal(1);
    })
});