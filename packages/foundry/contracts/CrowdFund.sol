// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.9;

contract CrowdFunding {
    /**
     * @dev Struct for a crowdfunding campaign
     */
    struct Campaign {
        address owner;
        string title;
        string description;
        uint256 target;
        uint256 deadline;
        uint256 amountCollected;
        string image;
        address[] donators;
        uint256[] donations;
    }

    error InvalidDeadline();

    /**
     * @dev Mapping of campaign IDs to campaigns
     */
    mapping(uint256 => Campaign) public campaigns;

    /**
     * @dev Number of campaigns created
     */
    uint256 public numberOfCampaigns = 0;

    /**
     * @dev Creates a new crowdfunding campaign
     * @param _owner The address of the campaign owner
     * @param _title The title of the campaign
     * @param _description The description of the campaign
     * @param _target The target amount of the campaign
     * @param _deadline The deadline of the campaign
     * @param _image The image of the campaign
     * @return The ID of the newly created campaign
     */
    function createCampaign(
        address _owner,
        string memory _title,
        string memory _description,
        uint256 _target,
        uint256 _deadline,
        string memory _image
    ) public returns (uint256) {
        // Create a new campaign
        Campaign storage campaign = campaigns[numberOfCampaigns]; // TODO: Check if this is correct

        if (campaign.deadline > block.timestamp) revert InvalidDeadline();

        campaign.owner = _owner;
        campaign.title = _title;
        campaign.description = _description;
        campaign.target = _target;
        campaign.deadline = _deadline;
        campaign.amountCollected = 0;
        campaign.image = _image;

        numberOfCampaigns++;

        return numberOfCampaigns - 1;
    }

    /**
     * @dev Returns an array of all campaigns
     * @return An array of all campaigns
     */
    function getCampaigns() public view returns (Campaign[] memory) {
        // 
        Campaign[] memory allCampaigns = new Campaign[](numberOfCampaigns);

        for (uint256 i = 0; i < numberOfCampaigns; i++) {
            Campaign storage item = campaigns[i];

            allCampaigns[i] = item;
        }

        return allCampaigns;
    }

    /**
     * @dev Allows a user to donate to a campaign
     * @param _id The ID of the campaign to donate to
     */
    function donateToCampaign(uint256 _id) public payable {
        uint256 amount = msg.value;

        Campaign storage campaign = campaigns[_id];

        campaign.donators.push(msg.sender);
        campaign.donations.push(amount);

        (bool sent,) = payable(campaign.owner).call{value: amount}("");

        if (sent) {
            campaign.amountCollected = campaign.amountCollected + amount;
        }
    }

    /**
     * @dev Get the donators and their donations for a campaign
     * @param _id The campaign ID
     * @return The donators and their donations
     */
    function getDonators(uint256 _id) public view returns (address[] memory, uint256[] memory) {
        return (campaigns[_id].donators, campaigns[_id].donations);
    }

    /**
     * @dev Get the total amount collected for a campaign
     * @param _id The campaign ID
     * @return The total amount collected
     */
    function getTotalAmountCollected(uint256 _id) public view returns (uint256) {
        return campaigns[_id].amountCollected;
    }

    /**
     * @dev Get the total amount donated to a campaign
     * @param _id The campaign ID
     * @return The total amount donated
     */
    function getTotalAmountDonated(uint256 _id) public view returns (uint256) {
        uint256 totalAmountDonated = 0;

        for (uint256 i = 0; i < campaigns[_id].donations.length; i++) {
            totalAmountDonated = totalAmountDonated + campaigns[_id].donations[i];
        }

        return totalAmountDonated;
    }

    /**
     * @dev Get the total number of donators for a campaign
     * @param _id The campaign ID
     * @return The total number of donators
     */
    function getTotalNumberOfDonators(uint256 _id) public view returns (uint256) {
        return campaigns[_id].donators.length;
    }

    /**
     * fallback function
     *
     */
    fallback() external payable {}

    receive() external payable {}
}
