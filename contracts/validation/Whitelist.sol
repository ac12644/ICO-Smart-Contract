pragma solidity ^0.4.23;
import "../CrowdSale.sol";
import "../ownership/Ownable.sol";

/**
 * @title WhitelistedCrowdsale
 * @dev Crowdsale in which only whitelisted users can contribute.
 */
contract WhitelistedCrowdsale is Crowdsale, Ownable {
    mapping(address => bool) public whitelist;

    /**
     * @dev Reverts if investor is not whitelisted. Can be used when extending this contract.
     */
    modifier isWhitelisted(address _investor) {
        require(whitelist[_investor]);
        _;
    }

    /**
     * @dev Adds single address to whitelist.
     * @param _investor Address to be added to the whitelist
     */
    function addToWhitelist(address _investor) external onlyOwner {
        whitelist[_investor] = true;
    }

    /**
     * @dev Adds list of addresses to whitelist. Not overloaded due to limitations with truffle testing.
     * @param _beneficiaries Addresses to be added to the whitelist
     */
    function addManyToWhitelist(address[] _beneficiaries) external onlyOwner {
        for (uint256 i = 0; i < _beneficiaries.length; i++) {
            whitelist[_beneficiaries[i]] = true;
        }
    }

    /**
     * @dev Removes single address from whitelist.
     * @param _investor Address to be removed to the whitelist
     */
    function removeFromWhitelist(address _investor) external onlyOwner {
        whitelist[_investor] = false;
    }

    /**
     * @dev Extend parent behavior requiring investor to be in whitelist.
     * @param _investor Token investor
     * @param _weiAmount Amount of wei contributed
     */
    function _preValidatePurchase(address _investor, uint256 _weiAmount)
        internal
        isWhitelisted(_investor)
    {
        super._preValidatePurchase(_investor, _weiAmount);
    }
}
