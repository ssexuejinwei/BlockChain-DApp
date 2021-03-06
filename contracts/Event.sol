pragma solidity >=0.4.21 <0.7.0;
pragma experimental ABIEncoderV2;
import "./Strings.sol";

contract Event {
    function setEventType(string memory _eventId, string memory _eventType)public;
    function setEvent(string memory _eventId,string memory _agentId,
                    string memory _objectHash,string memory _time,string memory _eventType)public;

    function getEventExists(string memory _eventId)public view returns (bool);
    function getEventTypeExists(string memory _eventId, string memory _eventType)public view returns (bool);

    function getAgent(string memory _eventId) public view returns (string memory, string memory);
    function getObject(string memory _eventId) public view returns (string memory, string memory);
    function getEventType(string memory _eventId) public view returns (string memory, string memory);
    function getTime(string memory _eventId) public view returns (string memory, string memory);
}


contract ProvEvent is Event {
    Strings st;
    struct EventData {
        string objectHash;
        string EventType;
        string agentId;
        string time;
        bool isValid;
    }


    mapping(string => EventData) private provEvents;
    string[] events;
    event EventTypeSet(string _eventId, string _eventType);
    event EventSet(string _eventId, string _objectHash, string _time);

    function setEventType(string memory _eventId, string memory _eventType) public {
        if (getEventTypeExists(_eventId, _eventType)) {
            revert(" the event type is already exists");
        }
        provEvents[_eventId].EventType = _eventType;
        emit EventTypeSet(_eventId,_eventType);
    }

    function setEvent(string memory _eventId,string memory _agentId,
                        string memory _objectHash,string memory _time,string memory _eventType) public {
        if (getEventExists(_eventId)) {
            revert(" the event is already exists");
        }
        provEvents[_eventId].isValid = true;
        provEvents[_eventId].objectHash = _objectHash;
        provEvents[_eventId].agentId = _agentId;
        provEvents[_eventId].time = _time;
        provEvents[_eventId].EventType = _eventType;
        emit EventSet(_eventId,_objectHash,_time);

    }

    function getEventExists(string memory _eventId)public view returns (bool) {
        return  provEvents[_eventId].isValid;
    }

    function getEventTypeExists(string memory _eventId, string memory _eventType)public view returns (bool){
        return equal(_eventType,provEvents[_eventId].EventType);
    }

    function getAgent(string memory _eventId) public view returns (string memory,string memory) {
        return (_eventId,provEvents[_eventId].agentId);
    }

    function getEvent(string memory _eventId) public view returns (EventData memory){
        return provEvents[_eventId];
    }

    function getObject(string memory _eventId) public view returns (string memory, string memory){
        return (_eventId,provEvents[_eventId].objectHash);
    }
    function getEventType(string memory _eventId) public view returns (string memory, string memory){
        return (_eventId,provEvents[_eventId].EventType);
    }

    function getTime(string memory _eventId) public view returns (string memory, string memory) {
        return (_eventId,provEvents[_eventId].time);
    }

    function equal(string memory s1, string memory s2)public pure returns(bool){
        return (keccak256(abi.encodePacked(s1)) == keccak256(abi.encodePacked(s2)));
    }
}