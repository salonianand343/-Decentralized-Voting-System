// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

contract VotingSystem {
    // Structure for a candidate
    struct Candidate {
        uint id;
        string name;
        uint voteCount;
    }

    // Mapping to store candidates by ID
    mapping(uint => Candidate) public candidates;
    // Mapping to track voters
    mapping(address => bool) public voters;
    
    uint public candidatesCount;
    uint public totalVotes;
    
    address public owner;
    bool public votingOpen;
    
    // Event to notify when a new vote is cast
    event Voted(address indexed voter, uint candidateId);
    // Event to notify when a new candidate is added
    event CandidateAdded(uint candidateId, string name);

    // Modifier to restrict access to the owner only
    modifier onlyOwner() {
        require(msg.sender == owner, "You are not the owner");
        _;
    }

    // Modifier to check if voting is open
    modifier isVotingOpen() {
        require(votingOpen, "Voting is not open yet.");
        _;
    }

    // Modifier to check if the voter hasn't voted yet
    modifier hasNotVoted() {
        require(!voters[msg.sender], "You have already voted.");
        _;
    }

    constructor() {
        owner = msg.sender;
        votingOpen = false;  // Voting starts closed by default
    }

    // Function to add a new candidate
    function addCandidate(string memory _name) public onlyOwner {
        candidatesCount++;
        candidates[candidatesCount] = Candidate(candidatesCount, _name, 0);
        emit CandidateAdded(candidatesCount, _name);
    }

    // Function to start the voting process
    function startVoting() public onlyOwner {
        votingOpen = true;
    }

    // Function to stop the voting process
    function stopVoting() public onlyOwner {
        votingOpen = false;
    }

    // Function for a user to vote
    function vote(uint _candidateId) public isVotingOpen hasNotVoted {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate.");
        
        voters[msg.sender] = true;
        candidates[_candidateId].voteCount++;
        totalVotes++;

        emit Voted(msg.sender, _candidateId);
    }

    // Function to get the number of votes for a candidate
    function getVotes(uint _candidateId) public view returns (uint) {
        require(_candidateId > 0 && _candidateId <= candidatesCount, "Invalid candidate.");
        return candidates[_candidateId].voteCount;
    }

    // Function to get the total number of votes
    function getTotalVotes() public view returns (uint) {
        return totalVotes;
    }
}
