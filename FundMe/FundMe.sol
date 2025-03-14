// SPDX-License-Identifier: MIT
pragma solidity 0.8.24;

import {AggregatorV3Interface} from "@chainlink/contracts/src/v0.8/shared/interfaces/AggregatorV3Interface.sol";

library PriceConverter {

    function getPrice() internal view returns (uint256){
        // address of the contract: 0x694AA1769357215DE4FAC081bf1f309aDC325306
        // ABI
        AggregatorV3Interface priceFeed = AggregatorV3Interface(0x6D41d1dc818112880b40e26BD6FD347E41008eDA);
        (, int256 price,,,) = priceFeed.latestRoundData();
        // price of eth in terms of usd
        return uint256(price * 1e10);

    }

    function getConversionRate(uint256 ethAmount) internal view returns(uint256) {
        uint256 ethPrice = getPrice();
        uint256 ethAmountInUsd = (ethPrice * ethAmount) / 1e18;
        return ethAmountInUsd;
    }

    function getVersion() internal view returns (uint256) {
        return AggregatorV3Interface(0x6D41d1dc818112880b40e26BD6FD347E41008eDA).version();
    }

}


error NotOwner();

contract FundMe {

    using PriceConverter for uint256;

    uint256 public minimumUsd = 5e18;

    address[] public funders;
    mapping( address => uint256) public addressToAmountFunded;

    address public owner;

    constructor () {
        owner = msg.sender;
    }

    function fund() public payable {

        require( msg.value.getConversionRate() >= minimumUsd, "didn't send enough ETH");
        // require( getConversionRate(msg.value) >= minimumUsd, "didn't send enough ETH");
        funders.push(msg.sender);
        addressToAmountFunded[msg.sender] += msg.value;
    }

    function withdraw() public onlyOwner { 

        for(uint256 funderIndex = 0; funderIndex < funders.length; funderIndex++) {
            address funder = funders[funderIndex];
            addressToAmountFunded[funder] = 0;
        }
        // resetting the array
        funders = new address[](0);
        
        // withdraw the funds
        
        // transfer (2300 gas, throws error)
        // send (2300 gas, returns bool)
        // call (forward all gas or set gas, returns bool)
        
        // payable(msg.sender).transfer(address(this).balance);

        // bool success = payable(msg.sender).send(address(this).balance);
        // require(success, "Send failed");

        (bool callSuccess, ) = payable(msg.sender).call{ value: address(this).balance}("");
        require( callSuccess, "Call failed");


    }

    modifier onlyOwner() {
        // require(msg.sender == owner, "Only owner can withdraw");
        if(msg.sender != owner) {
            revert NotOwner();
        }

        _; // then have whatever else is in the function
    }

    // handles ETH transfer with no data
    receive() external payable { 
        fund();
    }

    // handles ETH transfer with data
    fallback() external payable {
        fund();
    }

}

