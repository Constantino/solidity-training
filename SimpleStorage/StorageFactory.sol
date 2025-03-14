// SPDX-License-Identifier: MIT
pragma solidity ^0.8.28;

import { SimpleStorage } from "./SimpleStorage.sol";

contract StorageFactory {

    SimpleStorage[] public listOfSimpleStorageContracts;

    function createSimpleStorageContract() public {
        SimpleStorage newSimpleStorageContract = new SimpleStorage();

        listOfSimpleStorageContracts.push( newSimpleStorageContract );
    }

    function sfStore( uint256 _simpleStorageIndex, uint256 _newSimpleStorageNumber) public {
        // SimpleStorage mySimpleStorage = listOfSimpleStorageContract[_simpleStorageIndex];
        return SimpleStorage( listOfSimpleStorageContracts[_simpleStorageIndex] ).store( _newSimpleStorageNumber );

    }

    function sfGet( uint256 _simpleStorageIndex) public view returns(uint256) {
        return SimpleStorage( listOfSimpleStorageContracts[_simpleStorageIndex] ).retrieve();
    }
}