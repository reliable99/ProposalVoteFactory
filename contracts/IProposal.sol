// SPDX-License-Identifier: SEE LICENSE IN LICENSE
pragma solidity ^0.8.27;

interface IProposalVote {
    function createProposal(
        string memory _title,
        string memory _desc,
        uint16 _quorum
    ) external;

    function voteOnProposal(uint8 _index) external;

    function getProposal(
        uint8 _index
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
        );
}