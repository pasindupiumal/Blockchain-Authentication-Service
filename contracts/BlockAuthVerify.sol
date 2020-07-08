pragma solidity ^0.5.16;

contract BlockAuthVerify {

    address payable owner;
    mapping ( address => string ) usernames;
    mapping ( string => address ) reverse_usernames;
    mapping ( string => string ) block_auth_urls;
    mapping ( string => string ) public_keys;
    mapping ( string => string ) data;

    event NewUserAdded(address from, string username, bool success);
    event NewVerification(address from, string username, string verificationType, bool success);
    event UserDataUpdated(address from, string username, bool success);

    struct Verification {

        string verifier;
        string verified_value;
    }

    struct ListOfVerifications {

        Verification[] verifications;
    }

    mapping ( string => mapping ( string => ListOfVerifications )) external_verifications;

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

    function getUserVerificationCount(string memory username, string memory verification_type) public view returns (uint256) {
        return external_verifications[username][verification_type].verifications.length;
    }

    function getUserVerifierByIndex(string memory username, string memory verification_type, uint256 index) public view returns (string memory) {
        if(index < getUserVerificationCount(username, verification_type)){
            return external_verifications[username][verification_type].verifications[index].verifier;
        }

        return "";
    }

    function getUserVerifiedValueByIndex(string memory username, string memory verification_type, uint256 index) public view returns (string memory) {
        if(index < getUserVerificationCount(username, verification_type)){
            return external_verifications[username][verification_type].verifications[index].verified_value;
        }

        return "";
    }

    function putUserVerification(string memory username, string memory verification_type, string memory verification_value) public returns (bool) {
        if ( keccak256(abi.encodePacked(getUsername(msg.sender))) != keccak256(abi.encodePacked(""))){
            external_verifications[username][verification_type].verifications.push(Verification({verifier: getUsername(msg.sender), verified_value: verification_value}));
            emit NewVerification(msg.sender, username, verification_type, true);
            return true;
        }

        emit NewVerification(msg.sender, username, verification_type, false);
        return false;
    }

    function putUserVerification(string memory username, string memory verification_type, string memory verification_value, uint256 index) public returns (bool){
        if( keccak256(abi.encodePacked(getUsername(msg.sender))) != keccak256(abi.encodePacked(""))){
            if(keccak256(abi.encodePacked(external_verifications[username][verification_type].verifications[index].verifier)) == keccak256(abi.encodePacked(getUsername(msg.sender)))){
                external_verifications[username][verification_type].verifications[index].verified_value = verification_value;
                emit NewVerification(msg.sender, username, verification_type, true);
                return true;
            }
        }

        emit NewVerification(msg.sender, username, verification_value, false);
        return false;
    }

    function setEncryptionData(string memory encryptedData) public returns (bool) {
        if(keccak256(abi.encodePacked(msg.sender)) != keccak256(abi.encodePacked(""))){
            data[getUsername(msg.sender)] = encryptedData;
            emit UserDataUpdated(msg.sender, getUsername(msg.sender), true);
            return true;
        }

        emit UserDataUpdated(msg.sender, getUsername(msg.sender), false);
        return false;
    }

    function getEncryptedData(string memory username) public view returns (string memory) {
        return data[username];
    }




}