pragma solidity 0.5.10;

contract IOracle {
    function isCETH(address asset) public view returns (bool);
    function getPrice(address asset) public view returns (uint256);
}