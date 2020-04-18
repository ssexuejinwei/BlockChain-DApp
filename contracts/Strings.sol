pragma solidity >=0.4.21 <0.7.0;

contract Strings {
    function equal (string memory s1, string memory s2 ) public pure returns(bool) {
        if(keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2))) {
            return true;
        }
        else {
            return false;
        }
    }

    // function append( string memory s1, string memory s2) public pure returns (string memory) {
    //     return abi.encodePacked(s1,s2);
    // }
}