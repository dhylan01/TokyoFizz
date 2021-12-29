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
        
        //console.log("sdsfs", await customTokyoFizz.baseURI());
        expect(await customTokyoFizz.baseURI()).to.equal("ipfs://SOME_HASH");
        const addy = owner.address;
        customTokyoFizz.appendWhitelist(addy);
        await customTokyoFizz.whitelist(addy);
        //expect(customTokyoFizz.whitelist[addy]).to.equal(true);
        const waitTx = await customTokyoFizz.whitelistMint({value: ethers.utils.parseEther("0.05")});
        await waitTx.wait();
        const waitTx2 = await customTokyoFizz.whitelistMint({value: ethers.utils.parseEther("0.05")});
        await waitTx2.wait();
        /*
        const mintTx = await customTokyoFizz.mint({value: ethers.utils.parseEther("0.05")});
        await mintTx.wait();
            */
        
        expect(await customTokyoFizz.balanceOf(owner.address)).to.equal(2);
        

        
    })
});

/*
//deploying to hardhat and testing
npx hardhat node
npx hardhat run --network localhost scripts/deploy.js
npx hardhat console --network localhost
const CustomTokyoFizz = await ethers.getContractFactory("CustomTokyoFizz")
const token = await CustomTokyoFizz.attach("address when deployed in console")
*/
