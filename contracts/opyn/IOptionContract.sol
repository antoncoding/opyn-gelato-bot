pragma solidity 0.5.10;

import "../libs/IERC20.sol";
import "../libs/SafeMath.sol";

/**
 * @title Opyn's Options Contract
 * @author Opyn
 */
contract IOptionsContract is IERC20 {
    using SafeMath for uint256;

    // Keeps track of the weighted collateral and weighted debt for each vault.
    struct Vault {
        uint256 collateral;
        uint256 oTokensIssued;
        uint256 underlying;
        bool owned;
    }

    /**
     * @notice Checks if a `owner` has already created a Vault
     * @param owner The address of the supposed owner
     * @return true or false
     */
    function hasVault(address payable owner) public view returns (bool);


    /**
     * @notice If the collateral type is ETH, anyone can call this function any time before
     * expiry to increase the amount of collateral in a Vault. Will fail if ETH is not the
     * collateral asset.
     * Remember that adding ETH collateral even if no oTokens have been created can put the owner at a
     * risk of losing the collateral if an exercise event happens.
     * Ensure that you issue and immediately sell oTokens to allow the owner to earn premiums.
     * (Either call the createAndSell function in the oToken contract or batch the
     * addERC20Collateral, issueOTokens and sell transactions and ensure they happen atomically to protect
     * the end user).
     * @param vaultOwner the index of the Vault to which collateral will be added.
     */
    function addETHCollateral(address payable vaultOwner)
        public
        payable
        returns (uint256);
    
    /**
     * @notice If the collateral type is any ERC20, anyone can call this function any time before
     * expiry to increase the amount of collateral in a Vault. Can only transfer in the collateral asset.
     * Will fail if ETH is the collateral asset.
     * The user has to allow the contract to handle their ERC20 tokens on his behalf before these
     * functions are called.
     * Remember that adding ERC20 collateral even if no oTokens have been created can put the owner at a
     * risk of losing the collateral. Ensure that you issue and immediately sell the oTokens!
     * (Either call the createAndSell function in the oToken contract or batch the
     * addERC20Collateral, issueOTokens and sell transactions and ensure they happen atomically to protect
     * the end user).
     * @param vaultOwner the index of the Vault to which collateral will be added.
     * @param amt the amount of collateral to be transferred in.
     */
    function addERC20Collateral(address payable vaultOwner, uint256 amt)
        public
        returns (uint256);

    /**
     * @notice Returns true if the oToken contract has expired
     */
    function hasExpired() public view returns (bool);
    /**
     * @notice after expiry, each vault holder can get back their proportional share of collateral
     * from vaults that they own.
     * @dev The owner gets all of their collateral back if no exercise event took their collateral.
     */
    function redeemVaultBalance() public;

    /**
     * This function returns the maximum amount of collateral liquidatable if the given vault is unsafe
     * @param vaultOwner The index of the vault to be liquidated
     */
    function maxOTokensLiquidatable(address payable vaultOwner)
        public
        view
        returns (uint256);

    /**
     * @notice This function can be called by anyone who notices a vault is undercollateralized.
     * The caller gets a reward for reducing the amount of oTokens in circulation.
     * @dev Liquidator comes with _oTokens. They get _oTokens * strikePrice * (incentive + fee)
     * amount of collateral out. They can liquidate a max of liquidationFactor * vault.collateral out
     * in one function call i.e. partial liquidations.
     * @param vaultOwner The index of the vault to be liquidated
     * @param oTokensToLiquidate The number of oTokens being taken out of circulation
     */
    function liquidate(address payable vaultOwner, uint256 oTokensToLiquidate) public;

    /**
     * @notice checks if a vault is unsafe. If so, it can be liquidated
     * @param vaultOwner The number of the vault to check
     * @return true or false
     */
    function isUnsafe(address payable vaultOwner) public view returns (bool);

    
    /**
     * @notice This function gets the price ETH (wei) to asset price.
     * @param asset The address of the asset to get the price of
     */
    function getPrice(address asset) internal view returns (uint256);
}
