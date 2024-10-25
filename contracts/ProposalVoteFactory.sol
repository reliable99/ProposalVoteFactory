// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.27;

import "./ProposalVote.sol";
import {IProposalVote} from "./IProposal.sol";

contract ProposalVoteFactory {
    struct DeployedContractInfo {
        address deployer;
        address deployedContract;
    }

    mapping(address => DeployedContractInfo[]) allUserDeployedContracts;
    DeployedContractInfo[] public allContracts;
    IProposalVote[] public proposalContracts;

    function deployProposalVote() external returns (address contractAddress_) {
        require(msg.sender != address(0), "Zero Address not allowed");

        ProposalVote newProposalVote = new ProposalVote();
        address _address = address(newProposalVote);

        contractAddress_ = _address;

        DeployedContractInfo memory _deployedContract;
        _deployedContract.deployer = msg.sender;
        _deployedContract.deployedContract = _address;

        allUserDeployedContracts[msg.sender].push(_deployedContract);
        allContracts.push(_deployedContract);
        proposalContracts.push(IProposalVote(_address)); 
    }

    function getAllDeployedContracts()
        external
        view
        returns (DeployedContractInfo[] memory)
    {
        return allContracts;
    }

    function getAllUserDeployedContracts()
        external
        view
        returns (DeployedContractInfo[] memory)
    {
        return allUserDeployedContracts[msg.sender];
    }

    // Create Proposal
    function createProposal(
        address _proposalVote,
        string memory _title,
        string memory _desc,
        uint16 _quorum
    ) external {
        require(
            _proposalVote != address(0),
            "Invalid ProposalVote contract address"
        );
        IProposalVote(_proposalVote).createProposal(_title, _desc, _quorum);
    }

    // Vote on Proposal
    function voteOnProposal(address _proposalVote, uint8 _index) external {
        require(
            _proposalVote != address(0),
            "Invalid ProposalVote contract address"
        );
        IProposalVote(_proposalVote).voteOnProposal(_index);
    }

    // Get a proposal Info
    function getProposalFromContract(
        uint contractIndex,
        uint8 proposalIndex
    )
        external
        view
        returns (
            string memory title_,
            string memory desc_,
            uint16 voteCount_,
            address[] memory voters_,
            uint16 quorum_,
            uint8 status_
        )
    {
        require(
            contractIndex < proposalContracts.length,
            "Invalid contract index"
        );
        return proposalContracts[contractIndex].getProposal(proposalIndex);
    }
}