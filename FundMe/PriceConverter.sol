// SPDX-License-Identifier: MIT

pragma solidity 0.8.28;

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