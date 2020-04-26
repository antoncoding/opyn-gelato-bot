pragma solidity >0.5.0 <0.7.0;

import "./IGelatoCondition.sol";
import "../opyn/IOracle.sol";
import "../libs/SafeMath.sol";

contract ConditionOracleRate is IGelatoCondition {

    IOracle oracle;
    using SafeMath for uint256;
    
    constructor(IOracle _oracle) public {
      oracle = _oracle;
    }

    enum Reason {
        // StandardReason Fields
        Ok,  // 0: Standard Field for Fulfilled Conditions and No Errors
        NotOk,  // 1: Standard Field for Unfulfilled Conditions or Caught/Handled Errors
        UnhandledError,  // 2: Standard Field for Uncaught/Unhandled Errors

        // Custom fields
        RateConditionMet, // Ok: Fulfilled Conditions
        RateComditionNotMet // NotOk: Unfulfilled Conditions
    }

    // conditionSelector public state variable np due to this.actionSelector constant issue
    function conditionSelector() external pure returns(bytes4) {
        return this.reached.selector;
    }

    uint256 public constant conditionGas = 300000;

    function reached(
        address _token,
        uint256 _refRate,
        bool greater
    )
        external
        view
        returns(bool, uint8)  // executable?, reason
    {
        uint256 currentRate = oracle.getPrice(_token);
        
        if (greater) {  // greaterThan
            if (currentRate >= _refRate)
                return (true, uint8(Reason.RateConditionMet));
            else
                return (false, uint8(Reason.RateComditionNotMet));
        } else {  // smallerThan
            if (currentRate <= _refRate)
                return (true, uint8(Reason.RateConditionMet));
            else
                return(false, uint8(Reason.RateComditionNotMet));
        }
        
    }
}