// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.0;

import "../contracts/interfaces/IDiamondCut.sol";
import "../contracts/facets/DiamondCutFacet.sol";
import "../contracts/facets/DiamondLoupeFacet.sol";
import "../contracts/facets/OwnershipFacet.sol";
import "forge-std/Test.sol";
import "../contracts/Diamond.sol";
// import "../contracts/libraries/Erc20AppStorage .sol";
import "../contracts/facets/Erc20TokenFacet.sol";
import "../contracts/facets/StakingFacet.sol";
import "../contracts/facets/RewardToken.sol";



contract DiamondDeployer is Test, IDiamondCut {
    //contract types of facets to be deployed
    Diamond diamond;
    DiamondCutFacet dCutFacet;
    DiamondLoupeFacet dLoupe;
    OwnershipFacet ownerF;
    Erc20TokenFacet erc20Token;
    StakingFacet stakingFacet;
    RewardToken rewardToken;

    function setUp() public {
        //deploy facets
        dCutFacet = new DiamondCutFacet();
        diamond = new Diamond(address(this), address(dCutFacet));
        dLoupe = new DiamondLoupeFacet();
        ownerF = new OwnershipFacet();
        erc20Token = new Erc20TokenFacet();
        rewardToken = new RewardToken();
        stakingFacet = new StakingFacet();
   

        //upgrade diamond with facets

        //build cut struct
        FacetCut[] memory cut = new FacetCut[](4);

        cut[0] = (
            FacetCut({
                facetAddress: address(dLoupe),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("DiamondLoupeFacet")
            })
        );

        cut[1] = (
            FacetCut({
                facetAddress: address(ownerF),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("OwnershipFacet")
            })
        );
           cut[2] = (
            FacetCut({
                facetAddress: address(erc20Token),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("Erc20TokenFacet")
            })
        );
         cut[3] = (
            FacetCut({
                facetAddress: address(stakingFacet),
                action: FacetCutAction.Add,
                functionSelectors: generateSelectors("StakingFacet")
            })
        );

        //upgrade diamond
        IDiamondCut(address(diamond)).diamondCut(cut, address(0x0), "");

        //call a function
        DiamondLoupeFacet(address(diamond)).facetAddresses();
      
        // rewardToken.init();
    }

    function generateSelectors(
        string memory _facetName
    ) internal returns (bytes4[] memory selectors) {
        string[] memory cmd = new string[](3);
        cmd[0] = "node";
        cmd[1] = "scripts/genSelectors.js";
        cmd[2] = _facetName;
        bytes memory res = vm.ffi(cmd);
        selectors = abi.decode(res, (bytes4[]));
    }

    function diamondCut(
        FacetCut[] calldata _diamondCut,
        address _init,
        bytes calldata _calldata
    ) external override {}

    function testErc20TokenCreation() public{
        Erc20TokenFacet s = Erc20TokenFacet(address(diamond));
        s.init();
        
        assertEq(s.name(), "emaxtoken");
        assertEq(s.decimal(), 18);        
    }

    function testStakingContract() public {
        Erc20TokenFacet s = Erc20TokenFacet(address(diamond));
        s.init();
        RewardToken r = RewardToken(address(rewardToken));
        r.init();
        // address owner = 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496;
        
        StakingFacet _stakingFacet = StakingFacet(address(diamond));
        _stakingFacet.init(address(s), address(rewardToken));

        s.approve(address(_stakingFacet), 100000);


        _stakingFacet.stake(1000);
        uint totalAmountStaked = _stakingFacet.contractBalance();
         assertEq(totalAmountStaked, 1000);
    }

    function testUnstake() public {

          Erc20TokenFacet s = Erc20TokenFacet(address(diamond));
        s.init();
        RewardToken r = RewardToken(address(rewardToken));
        r.init();
        // address owner = 0x7FA9385bE102ac3EAc297483Dd6233D62b3e1496;
        
        StakingFacet _stakingFacet = StakingFacet(address(diamond));
        _stakingFacet.init(address(s), address(rewardToken));

        s.approve(address(_stakingFacet), 100000);
        r.transfer(address(_stakingFacet), 5000000);


        _stakingFacet.stake(1);
        uint totalAmountStaked = _stakingFacet.contractBalance();
         assertEq(totalAmountStaked, 1000);
         vm.warp(12222223733);
         _stakingFacet.unstaked();
        assertEq(totalAmountStaked, 1200);

         

    }

}
