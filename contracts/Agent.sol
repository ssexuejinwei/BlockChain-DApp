pragma solidity >=0.4.21 <0.7.0;
import "./Strings.sol";
pragma experimental ABIEncoderV2;

contract Agent {
    function setEvent(string memory _agentId,string memory _eventId)public;
    function setObject(string memory _agentId,string memory _objectHash)public;
    function setAgent(string memory _agentId,string memory _name,string memory _agentType)public;

    function getAgentExists(string memory _agentId)public view returns (bool);
    function getAgentObjectExists(string memory _agentId, string memory _objectHash)public view returns (bool);
    function getAgentEventExists(string memory _agentId, string memory _eventId)public view returns (bool);

    function getObject(string memory _agentId, uint256 _objectIndex ) public view returns (string memory, string memory);
    function getEvent(string memory _agentId, uint256 _eventIndex ) public view returns (string memory, string memory);
    function getAgentType(string memory _agentId) public view returns (string memory, string memory);
    function getAgentName(string memory _agentId) public view returns (string memory, string memory);
}


contract ProvAgent is Agent {
    Strings st;
    struct AgentData {
        string[] objects; //hash
        string[] events;
        string name;
        string agentType;
        bool isValid;
    }


    mapping(string => AgentData) private provAgents;

    string[] agents;

    event EventSet(string _agentId,string _eventId);
    event ObjectSet(string _agentId,string _objectHash);
    event AgentSet(string _agentId,string _name,string _agentType);

    function setEvent(string memory _agentId,string memory _eventId)public {
        if (getAgentEventExists(_agentId, _eventId)) {
            revert("the event is already exists");
        }
        provAgents[_agentId].events.push(_eventId);
        emit EventSet(_agentId, _eventId);
    }

    function setObject(string memory _agentId,string memory _objectHash)public{
        if (getAgentObjectExists(_agentId, _objectHash)) {
            revert("the object is already exists");
        }
        provAgents[_agentId].objects.push(_objectHash);
        emit ObjectSet(_agentId,_objectHash);

    }
    function setAgent(string memory _agentId,string memory _name,string memory _agentType)public{
        if (getAgentExists(_agentId)) {
            revert("the agent is already exists");
        }
        provAgents[_agentId].isValid = true;
        provAgents[_agentId].name = _name;
        provAgents[_agentId].agentType = _agentType;
        emit AgentSet(_agentId,_name,_agentType);

    }

    function getAgentExists(string memory _agentId)public view returns (bool){
        return provAgents[_agentId].isValid;
    }
    function getAgentObjectExists(string memory _agentId, string memory _objectHash)public view returns (bool){
        string[] memory array = provAgents[_agentId].objects;
        bool flag = false;
        for (uint index = 0; index < array.length; index++) {
            if(equal(_objectHash,array[index])) {
                flag = true;
                break;
            }
        }
        return flag;
    }
    function getAgentEventExists(string memory _agentId, string memory _eventId)public view returns (bool){
        string[] memory array = provAgents[_agentId].events;
        bool flag = false;
        for (uint index = 0; index < array.length; index++) {
            if(equal(_eventId,array[index])) {
                flag = true;
                break;
            }
        }
        return flag;
    }

    function getObject(string memory _agentId, uint256 _objectIndex ) public view returns (string memory, string memory){
        return (_agentId,provAgents[_agentId].objects[_objectIndex]);

    }
    function getEvent(string memory _agentId, uint256 _eventIndex ) public view returns (string memory, string memory){
        return (_agentId,provAgents[_agentId].events[_eventIndex]);
    }

    function getAgent(string memory _agentId) public view returns (AgentData memory){
        return provAgents[_agentId];
    }
    function getAgentType(string memory _agentId) public view returns (string memory, string memory){
        return (_agentId,provAgents[_agentId].agentType);
    }

    function getAgentName(string memory _agentId) public view returns (string memory, string memory){
        return (_agentId,provAgents[_agentId].name);
    }

    function equal(string memory s1, string memory s2)public pure returns(bool){
        return (keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2)));
    }
}