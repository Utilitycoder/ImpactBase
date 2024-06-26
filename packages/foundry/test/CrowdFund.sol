// SPDX-License-Identifier: MIT
pragma solidity >=0.8.0 <0.9.0;
import "forge-std/Test.sol";
import { CrowdFunding } from "contracts/CrowdFund.sol";

contract CrowdFundTest is Test {
    CrowdFunding crowdFund;

    function setUp() public {
        crowdFund = new CrowdFunding();
    }

    function testCreateCampaign() public {
        uint256 id = crowdFund.createCampaign(
            address(this),
            "Test Campaign",
            "This is a test campaign",
            100,
            block.timestamp + 100,
            "https://example.com/image.png"
        );

        assertEq(id, 0);
    }

    function testDonateToCampaign() public {
        uint256 id = crowdFund.createCampaign(
            address(this),
            "Test Campaign",
            "This is a test campaign",
            100,
            block.timestamp + 100,
            "https://example.com/image.png"
        );

        crowdFund.donateToCampaign{value: 10}(id);

        assertEq(crowdFund.getTotalAmountDonated(id), 10);
    }

    function testGetCampaigns() public {
        address owner1 = vm.addr(1);
        address owner2 = vm.addr(2);
        // Assuming the CrowdFund contract has a function to create campaigns
        crowdFund.createCampaign(
            owner1,
            "Title1",
            "Description1",
            1000,
            block.timestamp + 1 days,
            "image1"
        );

        crowdFund.createCampaign(
            owner2,
            "Title2",
            "Description2",
            2000,
            block.timestamp + 2 days,
            "image2"
        );

        CrowdFunding.Campaign[] memory campaigns = crowdFund.getCampaigns();

        assertEq(campaigns.length, 2);
        assertEq(campaigns[0].title, "Title1");
        assertEq(campaigns[1].title, "Title2");
    }
}