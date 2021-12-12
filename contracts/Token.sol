//SPDX-License-Identifier: UNLICENSED

// Solidity files have to start with this pragma.
// It will be used by the Solidity compiler to validate its version.
pragma solidity ^0.8.0;

// We import this library to be able to use console.log
import "hardhat/console.sol";

//Trying to import ERC 2771 Functions for use
import "@openzeppelin/contracts/token/ERC721/ERC721.sol";

//Trying to import the preset contract and take functions
import "@openzeppelin/contracts/token/ERC721/presets/ERC721PresetMinterPauserAutoId.sol";

// This is the main building block for smart contracts.
abstract contract Token is ERC721PresetMinterPauserAutoId {
    /*
    *Taken out due to needing overide with the preset contract
    // Some string type variables to identify the token.
    string public name = "My Hardhat Token";
    string public symbol = "MHT";

    // The fixed amount of tokens stored in an unsigned integer type variable.
    uint256 public totalSupply = 3000;

    //Minter Adress
    bytes32 public constant MINTER_ROLE = keccak256("MINTER_ROLE");

    */



    //Enum with all possible types
    enum types {
        type1,
        type2,
        type3,
        type4
    }

    //mapping for whilelist - should be checked by reading blockchain so no gas used ehre
    mapping(address => bool) public whitelisted;

    // An address type variable is used to store ethereum accounts.
    address public owner;

    // Counter for current supply
    uint256 public currentSupply = totalSupply();

    // A mapping is a key/value map. Here we store each account balance.
    mapping(address => uint256) balances;

    //URI mapping
     mapping (uint256 => string) public tokenURI;

    /**
     * Contract initialization.
     *
     * The `constructor` is executed only once when the contract is created.
     * The `public` modifier makes a function callable from outside the contract.
     */
    constructor() {
        // The totalSupply is assigned to transaction sender, which is the account
        // that is deploying the contract.
        balances[msg.sender] = totalSupply();
        owner = msg.sender;
    }

    /**
     * A function to transfer tokens.
     *
     * The `external` modifier makes a function *only* callable from outside
     * the contract.
     */
    function transfer(address to, uint256 amount) external {
        // Check if the transaction sender has enough tokens.
        // If `require`'s first argument evaluates to `false` then the
        // transaction will revert.
        require(balances[msg.sender] >= amount, "Not enough tokens");

        // We can print messages and values using console.log
        console.log(
            "Transferring from %s to %s %s tokens",
            msg.sender,
            to,
            amount
        );

        // Transfer the amount.
        balances[msg.sender] -= amount;
        balances[to] += amount;
    }

    /**
     * Read only function to retrieve the token balance of a given account.
     *
     * The `view` modifier indicates that it doesn't modify the contract's
     * state, which allows us to call it without executing a transaction.
        
    function balanceOf(address account) external view returns (uint256) {
    return balances[account];
    }
     */

    function MintTo(address to,String uri) public virtual {
        //check if time have passed

        //check if time is past the start date
        
        if (whitelisted[to] && balanceOf(to) < 1 && block.timestamp(now) > block.timestamp(1620815400) && _tokenIdTracker < 200) {
            mint(to);
            
            //problem here with array size and deleting and changing values

        }
        el`se if (balanceOf(to) < 1 && block.timestamp(now) > block.timestamp(1639305000) &&  _tokenIdTracker < 3000) {
            mint(to);

            //problem here with array size and deleting and changing values

        }
        //Print that they only own one
        else balanceOf(to) >= 1 ? mint(to) : console.log("Owner Already owns one");
    }

}
