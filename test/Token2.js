const { expect } = require("chai");
const {hardhat} = require("hardhat");

describe("Custom TokyoFizz", function() {
    it("Deploy and mint", async function() {
        const[owner] = await ethers.getSigners();
        const CustomTokyoFizz = await ethers.getContractFactory("CustomTokyoFizz");
        const customTokyoFizz = await CustomTokyoFizz.deploy(
            "Token2",
            "TokFizz",
            "ipfs://SOME_HASH"
        );
        await customTokyoFizz.deployed();

        expect(await customTokyoFizz.baseURI()).to.equal("ipfs://SOME_HASH");
        customTokyoFizz.appedWhiteList(owner);
        const mintTx = await customTokyoFizz.mint(2000000);
        await mintTx.wait();

        expect(await customTokyoFizz.balanceOf(owner.address)).to.equal(1);
    })
});