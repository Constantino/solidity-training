// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { SimpleStorage } from "contracts/SimpleStorage.sol";

contract AddFiveStorage is SimpleStorage {

    // function sayHello() public pure returns(string memory) {
    //     return "Hello";
    // }

    function store(uint256 _newNumber) override public {
        myFavoriteNumber = _newNumber + 5;
    }

}