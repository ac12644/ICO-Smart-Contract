pragma solidity ^0.4.23;
import "../math/SafeMath.sol";
import "../CrowdSale.sol";

contract additionalFeatues is Crowdsale {
    uint256 public openingTime;
    uint256 public closingTime;
    uint256 public cap;
    /**
     * @dev Reverts if not in crowdsale time range.
     */
    modifier onlyWhileOpen() {
        require(
            block.timestamp >= openingTime && block.timestamp <= closingTime
        );
        _;
    }

    /**
     * @dev Constructor, takes crowdsale opening and closing
      times.
     * @param _openingTime Crowdsale opening time
     * @param _closingTime Crowdsale closing time
     */
    constructor(
        uint256 _openingTime,
        uint256 _closingTime,
        uint256 _cap
    ) public {
        require(_openingTime >= block.timestamp);
        require(_closingTime >= _openingTime);
        require(_cap > 0);
        cap = _cap;
        openingTime = _openingTime;
        closingTime = _closingTime;
    }

    /**
     * @dev Checks whether the period in which the crowdsale is
     8 open has already elapsed.
     * @return Whether crowdsale period has elapsed
     */
    function hasClosed() public view returns (bool) {
        return block.timestamp > closingTime;
    }

    /**
     * @dev Checks whether the cap has been reached.
     * @return Whether the cap was reached
     */
    function capReached() public view returns (bool) {
        return weiRaised >= cap;
    }

    function _preValidatePurchase(address _beneficiary, uint256 _weiAmount)
        internal
    {
        super._preValidatePurchase(_beneficiary, _weiAmount);
        require(weiRaised.add(_weiAmount) <= cap);
    }
}
