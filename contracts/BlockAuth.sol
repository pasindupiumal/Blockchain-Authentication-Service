pragma solidity ^0.5.16;

contract BlockAuth {

    address payable owner;
    mapping ( address => string ) usernames;
    mapping ( string => address ) reverse_usernames;
    mapping ( string => string ) block_auth_urls;
    mapping ( string => string ) public_keys;

    event NewUserAdded(address from, string username, bool success);

    constructor() public {

        owner = msg.sender;
    }

    function killBlockAuth() public {

        if(msg.sender == owner){
            selfdestruct(owner);
        }
    }

    function addNewUser(string memory username, string memory block_auth_url, string memory public_key) public returns (bool) {

        if (reverse_usernames[username] == 0x0000000000000000000000000000000000000000){

            usernames[msg.sender] = username;
            reverse_usernames[username] = msg.sender;
            block_auth_urls[username] = block_auth_url;
            public_keys[username] = public_key;

            emit NewUserAdded(msg.sender, username, true);
            return true;
        }

        emit NewUserAdded(msg.sender, username, false);
        return false;
    }


    function getUsername(address user_address) public view returns (string memory) {
        return usernames[user_address];
    }

    function getAddress(string memory username) public view returns (address) {
        return reverse_usernames[username];
    }

    function getBlockAuthUrl(string memory username) public view returns (string memory) {
        return block_auth_urls[username];
    }

    function getBlockAuthPublicKey(string memory username) public view returns (string memory) {
        return public_keys[username];
    }


}