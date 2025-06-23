// SPDX-License-Identifier: MIT
pragma solidity ^0.8.17;

contract ClaimDAO {
    enum ClaimStatus { Open, Resolved, Rejected }

    struct Claim {
        address claimant;
        string evidenceURI;
        ClaimStatus status;
        uint256 upvotes;
        uint256 downvotes;
        mapping(address => bool) voted;
    }

    uint256 public claimCount;
    mapping(uint256 => Claim) public claims;

    event ClaimSubmitted(uint256 claimId, address claimant, string evidenceURI);
    event Voted(uint256 claimId, address voter, bool inSupport);
    event ClaimResolved(uint256 claimId, ClaimStatus result);

    function submitClaim(string memory evidenceURI) external {
        Claim storage c = claims[claimCount];
        c.claimant = msg.sender;
        c.evidenceURI = evidenceURI;
        c.status = ClaimStatus.Open;

        emit ClaimSubmitted(claimCount, msg.sender, evidenceURI);
        claimCount++;
    }

    function voteOnClaim(uint256 claimId, bool support) external {
        Claim storage c = claims[claimId];
        require(c.status == ClaimStatus.Open, "Claim closed");
        require(!c.voted[msg.sender], "Already voted");

        if (support) {
            c.upvotes++;
        } else {
            c.downvotes++;
        }
        c.voted[msg.sender] = true;

        emit Voted(claimId, msg.sender, support);
    }

    function resolveClaim(uint256 claimId) external {
        Claim storage c = claims[claimId];
        require(c.status == ClaimStatus.Open, "Already resolved");

        if (c.upvotes > c.downvotes) {
            c.status = ClaimStatus.Resolved;
        } else {
            c.status = ClaimStatus.Rejected;
        }

        emit ClaimResolved(claimId, c.status);
    }

    function getClaim(uint256 claimId) external view returns (
        address,
        string memory,
        ClaimStatus,
        uint256,
        uint256
    ) {
        Claim storage c = claims[claimId];
        return (
            c.claimant,
            c.evidenceURI,
            c.status,
            c.upvotes,
            c.downvotes
        );
    }
} 
