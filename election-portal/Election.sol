pragma solidity ^0.4.18;

contract Election {
    struct Candidate {
        string name;
        uint voteCount;
    }
    
    struct Voter {
        bool authorized;
        bool voted;
        uint vote;
    }
    
    address public owner;
    string public electionName;
    
    mapping(address => Voter) public voters;
    Candidate[] public candidates;
    uint public totalVotes;
    
    modifier ownerOnly() {
        require(msg.sender == owner);
        _;
    }
    
    function Election(string _name) public {
        owner = msg.sender;
        electionName = _name;
    }
    
    function getTotalVotes() public view returns(uint) {
        return totalVotes;
    }
    
    function addCandidates(string _name) ownerOnly public {
        candidates.push(Candidate(_name, 0));
    }
    
    function getLastCandidate(uint _index) public view returns(string) {
        return candidates[_index].name;
    }
    
    function getVoteCount(uint _index) public view returns(uint) {
        return candidates[_index].voteCount;
    }
    
    function getNumCandidate() public view returns(uint) {
        return candidates.length;
    }
    
    function authorize(address _person) ownerOnly public {
        voters[_person].authorized = true;
    }
    
    function vote(uint _voteIndex) public {
        require(!voters[msg.sender].voted);
        require(voters[msg.sender].authorized);
        
        voters[msg.sender].vote = _voteIndex;
        voters[msg.sender].voted = true;
        
        candidates[_voteIndex].voteCount += 1;
        totalVotes += 1;
    }
    
    function end() ownerOnly public {
        //for(uint i=0; i < candidates.length; i++) {
            //emit ElectionResult(candidates[i].name, candidates[i].voteCount);
        //}
        selfdestruct(owner);
    }
}