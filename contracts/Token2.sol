/*
    needs:
    random minting
    timer for designated date
    only one can be claimed per person
    whitelist for ppl to mint a week before
    connectable to opensea
    meetadata needs to have types included
*/

//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;

// We import this library to be able to use console.log
import "hardhat/console.sol";

//Trying to import ERC 2771 Functions for use
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";
import "@openzeppelin/contracts/utils/Counters.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Pausable.sol";
import "@openzeppelin/contracts/token/ERC721/extensions/ERC721Enumerable.sol";
import "@openzeppelin/contracts/access/AccessControlEnumerable.sol";
import "@openzeppelin/contracts/access/Ownable.sol";
import "@openzeppelin/contracts/utils/Context.sol";

//node_modules\@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol

//bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
//bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

contract CustomTokyoFizz is
    ERC721,
    AccessControl,
    ERC721Enumerable,
    ERC721Pausable
{
    uint256 constant limit = 3000;
    //uint256 const waitlistLimit = 200;
    //mapping for whilelist - should be checked by reading blockchain so no gas used ehre
    mapping(address => bool) public whitelisted;

    //every time someone mints we incriment this to reflect the current token we are on for minting
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdTracker;
    string private _baseTokenURI;

    //creating a new ERC 721 object here
    constructor(
        string memory name,
        string memory symbol,
        //ipfs hash for token
        string memory baseTokenURI
    ) ERC721(name, symbol) {
        //ipfs hash for the collection meta data itself
        _baseTokenURI = baseTokenURI;
        _setupRole("DEFAULT_ADMIN_ROLE", _msgSender());
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function baseURI() public view returns (string memory) {
        return baseURI;
    }

    function setBaseURI(string memory baseTokenURI) public virtual {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
        _baseTokenURI = baseTokenURI;
    }

    // look at timestamps and make them accurate based on the right time for minting
    function mint(uint256 amount) public payable {
        require(amount > 50000000, "amount is not .05 ETH");
        require(
            _tokenIdTracker.current() < limit && msg.sender.balanceOf() < 1,
            "CustomTokyoFizz: This address already posseses a Token"
        );
        require(
            block.timestamp(now) > block.timestamp(1620815400),
            "CustomTokyoFizz: Please wait until the correct time to mint"
        );
        _mint(msg.sender, _tokenIdTracker.current());
        _tokenIdTracker.increment();
        msg.sender.transfer(amount);
    }

    function mint(address to) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
        require(
            _tokenIdTracker.current() < limit,
            "CustomTokyoFizz: limit exceeded"
        );
        _safeMint(to, _tokenIdTracker.current());
        _tokenIdTracker.increment();
    }

    //might not need this if the first 200 are just created to be special
    function whitelistMint(uint256 amount) internal {
        require(amount > 50000000, "amount is not .05 ETH");
        require(
            block.timestamp(now) > block.timestamp(1620815400),
            "CustomTokyoFizz: Please wait until the Whitelist mint date to mint"
        );
        require(
            whitelisted[msg.sender],
            "CustomTokyoFizz: Please check if this adress is on the Whitelist"
        );
        _mint(msg.sender, _tokenIdTracker.current());
        _tokenIdTracker.increment();
        msg.sender.transfer(amount);
    }

    //things to add: waitlist and dates for minting w/ meta data
    function appendWhiteList(address a) public {
        whitelisted[a] = true;
    }

    function newAdmin(address a) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
        _grantRole(DEFAULT_ADMIN_ROLE, a);
    }

    function pause() public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
        _pause();
    }

    function unpause() public {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
        _unpause();
    }

    function transferBalence(uint256 amount) public payable {
        require(hasRole(DEFAULT_ADMIN_ROLE, msg.sender));
        address(this).transfer(amount * address(this).balance);
    }
}
