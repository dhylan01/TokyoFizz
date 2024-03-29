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
import "@openzeppelin/contracts/utils/Strings.sol";

//node_modules\@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol

//bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");
//bytes32 public constant PAUSER_ROLE = keccak256("PAUSER_ROLE");

contract CustomTokyoFizz is
    ERC721,
    AccessControlEnumerable,
    ERC721Enumerable,
    ERC721Pausable
{
    bytes32 public constant WHITELISTED_ROLE = keccak256("WHITELISTED_ROLE");
    using Strings for uint256;
    uint256 constant limit = 2999;
    uint8 holderLimit = 2;
    uint256 releaseDate;
    //uint256 const waitlistLimit = 200;
    //mapping for whilelist - should be checked by reading blockchain so no gas used ehre
    //mapping(address => bool) public whitelist;

    //every time someone mints we incriment this to reflect the current token we are on for minting
    using Counters for Counters.Counter;
    Counters.Counter private _tokenIdTracker;
    string private _baseTokenURI;
    //bytes32 public constant DEFAULT_ADMIN_ROLE = keccak256("DEFAULT_ADMIN_ROLE");
    address public owner;

    //creating a new ERC 721 object here
    constructor(
        string memory name,
        string memory symbol,
        //ipfs hash for token
        string memory baseTokenURI
    ) ERC721(name, symbol) {
        //ipfs hash for the collection meta data itself
        _baseTokenURI = baseTokenURI;
        owner = _msgSender();
        _setupRole(DEFAULT_ADMIN_ROLE, _msgSender());
        _setupRole(WHITELISTED_ROLE, _msgSender());
        releaseDate = block.timestamp + 7 days;
    }

    function _baseURI() internal view virtual override returns (string memory) {
        return _baseTokenURI;
    }

    function baseURI() public view returns (string memory) {
        return _baseTokenURI;
    }

    function tokenURI(uint256 tokenId)
        public
        view
        virtual
        override
        returns (string memory)
    {
        require(
            _exists(tokenId),
            "ERC721Metadata: URI query for nonexistent token"
        );

        string memory currentBaseURI = _baseURI();
        return
            bytes(currentBaseURI).length > 0
                ? string(
                    abi.encodePacked(
                        currentBaseURI,
                        tokenId.toString(),
                        ".json"
                    )
                )
                : "";
    }

    /**
     * @dev See {IERC165-supportsInterface}.
     */
    function supportsInterface(bytes4 interfaceId)
        public
        view
        virtual
        override(AccessControlEnumerable, ERC721, ERC721Enumerable)
        returns (bool)
    {
        return super.supportsInterface(interfaceId);
    }

    function setBaseURI(string memory baseTokenURI) public virtual {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()));
        _baseTokenURI = baseTokenURI;
    }

    function _beforeTokenTransfer(
        address from,
        address to,
        uint256 tokenId
    ) internal virtual override(ERC721, ERC721Enumerable, ERC721Pausable) {
        super._beforeTokenTransfer(from, to, tokenId);
    }

    // look at timestamps and make them accurate based on the right time for minting
    function mint() public payable {
        require(msg.value >= 50000000000000000, "amount is not .05 ETH");
        if (block.timestamp < releaseDate) {
            require(
                hasRole(WHITELISTED_ROLE, _msgSender()),
                "This account is not whitelisted and cannot mint at this time"
            );
        }
        require(
            _tokenIdTracker.current() < limit,
            "CustomTokyoFizz: The amount minted is at its limit " // + Strings.toString(_tokenIdTracker.current())
        );
        require(
            balanceOf(_msgSender()) < holderLimit,
            "CustomTokyoFizz: This address surpassed the current limit of tokens"
        );
        /*
        require(
            block.timestamp > releaseDate,
            "CustomTokyoFizz: Please wait until the correct time to mint"
        );
        */
        _mint(_msgSender(), _tokenIdTracker.current());
        _tokenIdTracker.increment();
        payable(owner).transfer(msg.value);
    }

    /*
    function mint(address to) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()));
        require(
            _tokenIdTracker.current() < limit,
            "CustomTokyoFizz: limit exceeded"
        );
        _safeMint(to, _tokenIdTracker.current());
        _tokenIdTracker.increment();
    }
    */
    //might not need this if the first 200 are just created to be special
    /*
    function whitelistMint() public payable {
        require(msg.value >= 50000000000000000, "amount is not .05 ETH");
        require(
            block.timestamp > 620815400,
            "CustomTokyoFizz: Please wait until the Whitelist mint date to mint"
        );
        require(
            whitelist[_msgSender()],
            "CustomTokyoFizz: Please check if this adress is on the Whitelist"
        );
        _mint(_msgSender(), _tokenIdTracker.current());
        _tokenIdTracker.increment();
        payable(owner).transfer(msg.value);
        //_msgSender().transfer(amount);
    }

    //things to add: waitlist and dates for minting w/ meta data
    /*
    function appendWhitelist(address a) public {
        whitelist[a] = true;
    }
    */
    function addToWhiteList(address a) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()));
        _grantRole(WHITELISTED_ROLE, a);
    }

    function newAdmin(address a) public {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()));
        _grantRole(DEFAULT_ADMIN_ROLE, a);
    }

    function pause() public {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()));
        _pause();
    }

    function unpause() public {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()));
        _unpause();
    }

    function transferBalance() public payable {
        require(hasRole(DEFAULT_ADMIN_ROLE, _msgSender()));
        payable(_msgSender()).transfer(address(this).balance);
    }
}
