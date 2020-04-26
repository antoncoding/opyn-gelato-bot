pragma solidity ^0.5.0;

contract GelatoCoreEnums {

    enum CanExecuteResults {
        ExecutionClaimAlreadyExecutedOrCancelled,
        ExecutionClaimNonExistant,
        ExecutionClaimExpired,
        WrongCalldata,  // also returns if a not-selected executor calls fn
        ConditionNotOk,
        UnhandledConditionError,
        Executable
    }

    enum StandardReason { Ok, NotOk, UnhandledError }
}