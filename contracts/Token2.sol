//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;

// We import this library to be able to use console.log
import "hardhat/console.sol";

//Trying to import ERC 2771 Functions for use
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

//every time someone mints we incriment this to reflect the current token we are on for minting
Counters.Counter internal _tokenIdTracker;

contract CustomTokyoFizz is ERC721 {
    uint256 constant limit = 3000;
    uint256 const waitlistLimit = 200;
    //mapping for whilelist - should be checked by reading blockchain so no gas used ehre
    mapping(address => bool) public whitelisted;
    
    //so we are creating a new ERC 721 object here?
    constructor {
        string memory name, 
        string memory symbol,
        string memory baseTokenURI
    } ERC721(name,symbol) {
        _baseTokenURI = baseTokenURI;\
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function baseURI() public view returns (string memory){
        //what is baseURI as opposed to baseTokenURI?
        return baseURI;
    }
    
    function setBaseURI(string memory baseTokenURI) public requires DEFAULT_ADMIN_ROLE{
        _baseTokenURI = baseTokenURI;
    }
    // look at timestamps and make them accurate based on the right time for minting
    function mint() internal{
        require(_tokenIdTracker < limit && msg.sender.balanceOf() < 1 &&block.timestamp(now) > block.timestamp(1620815400), "CustomTokyoFizz: unable to mint");
        _mint(msg.sender, _tokenIdTracker.current);
        _tokenIdTracker.increment;
    }

    function mint(address to) public requires DEFAULT_ADMIN_ROLE {
        require(_tokenIdTracker < limit, "CustomTokyoFizz: limit exceeded");
        _safeMint(to, _tokenIdTracker.current);
        _tokenIdTracker.increment;
    }

    
    //might not need this if the first 200 are just created to be special
    function whitelistMint() internal {
        require(block.timestamp(now) > block.timestamp(1620815400) && whitelisted[msg.sender], "CustomTokyoFizz: limit for waitList is over but please have another")
        mint();
    }
    //things to add: waitlist and dates for minting w/ meta data
    function appendWhiteList( address a){
        whitelisted[a] = true;
    }
}