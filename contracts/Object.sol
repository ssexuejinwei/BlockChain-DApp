pragma solidity >=0.4.21 <0.7.0;
pragma experimental ABIEncoderV2;

import "./Strings.sol";

contract Object {
    function setPropertyType(string memory _propType)public;
    function setProperties(string memory _objectHash, string memory _propType,string memory _propValue)public;
    function setObject(string memory _objectHash,string memory _category,string memory _format)public;
    function setEvent(string memory _objectHash,string memory _eventId)public;
    function setAgent(string memory _objectHash,string memory _agentId)public;

    function getPropertyTypeExists(string memory _propType)public view returns (bool);
    function getObjectPropertiesExists(string memory _objectHash,string memory _propType,string memory _propValue)public view returns (bool);
    function getObjectExists(string memory _objectHash)public view returns (bool);
    function getObjectEventExists(string memory _objectHash, string memory _eventId)public view returns (bool);
    function getObjectAgentExists(string memory _objectHash, string memory _agentId)public view returns (bool);

    function getNumEvents(string memory _objectHash) public view returns (uint256);
    function getNumAgents(string memory _objectHash) public view returns (uint256);

    function getEvent(string memory _objectHash, uint256 _eventIndex) public view returns (string memory, string memory);
    function getAgent(string memory _objectHash, uint256 _agentIndex) public view returns (string memory, string memory);
}


contract ProvObject is Object {
    Strings st;
    struct ObjectProperties {
        string propType;
        string propValue;
    }

    struct ObjectData {
        ObjectProperties[] properties;
        string category;
        string format;
        string[] events; //id
        string[] agents; //id
        bool isValid; //shi fou yi cun zai
    }

    string[] propTypes;
    string[] objects;

    mapping(string => ObjectData) private provObjects;

    event ObjectSet(string _objectHash, string _category, string _format);
    event ObjectSetPropertyType(string  _propType);
    event ObjectSetProperties(string _objectHash, string _propType, string _propValue);
    event ObjectSetEvent(string _objectHash, string _eventId);
    event ObjectSetAgent(string _objectHash, string _agentId);

    function setPropertyType(string memory _propType) public {
        if (getPropertyTypeExists(_propType)){
            revert("the propertyType is already exists");
        }
        propTypes.push(_propType);
        emit ObjectSetPropertyType(_propType);


    }

    function setProperties(string memory _objectHash,string memory _propType,string memory _propValue )public {
        if (getObjectPropertiesExists(_objectHash,_propType, _propValue)) {
            revert("the properties is already exists");
        }
        ObjectProperties memory i;
        i.propType = _propType;
        i.propValue = _propValue;
        provObjects[_objectHash].properties.push(i);
        emit ObjectSetProperties(_objectHash,_propType,_propValue);
    }

    function setObject(string memory _objectHash,string memory _category,string memory _format) public {
        if (getObjectExists(_objectHash)) {
            revert("the object is already exists");
        }
        provObjects[_objectHash].isValid = true;
        provObjects[_objectHash].category = _category;
        provObjects[_objectHash].format = _format;
        emit ObjectSet(_objectHash,_category,_format);
    }

    function setEvent(string memory _objectHash,string memory _eventId) public {
        if (getObjectEventExists(_objectHash, _eventId)) {
            revert("the event is already exists");
        }
        provObjects[_objectHash].events.push(_eventId);
        emit ObjectSetEvent(_objectHash,_eventId);
    }

    function setAgent(string memory _objectHash,string memory _agentId )public {
        if (getObjectAgentExists(_objectHash, _agentId)) {
            revert("the agent is already exists");
        }
        provObjects[_objectHash].events.push(_agentId);
        emit ObjectSetAgent(_objectHash,_agentId);
    }

    function getPropertyTypeExists(string memory _propType)public view returns (bool){
        bool flag = false;
        for (uint index = 0; index < propTypes.length; index++) {
            if(st.equal(_propType,propTypes[index])) {
                flag = true;
                break;
            }
        }
        return flag;
    }
    function getObjectPropertiesExists(string memory _objectHash,string memory _propType,string memory _propValue)public view returns (bool){
        bool flag = false;
        for (uint index = 0; index < provObjects[_objectHash].properties.length; index++) {
            ObjectProperties memory i = provObjects[_objectHash].properties[index];
            if(st.equal(i.propType,_propType) && st.equal(i.propValue,_propValue)) {
                flag = true;
                break;
            }
        }
        return flag;
    }

    function getObjectExists(string memory _objectHash)public view returns (bool) {
        return provObjects[_objectHash].isValid;
    }

    function getObjectEventExists(string memory _objectHash, string memory _eventId)public view returns (bool) {
        bool objectExists = provObjects[_objectHash].isValid;
        bool eventExists = false;
        for (uint index = 0; index < provObjects[_objectHash].events.length; index++) {
            if (st.equal(_eventId,provObjects[_objectHash].events[index]))
            // if (keccak256(abi.encodePacked(_eventId)) == keccak256(abi.encodePacked(provObjects[_objectHash].events[index])))
            {
                eventExists = true;
                break;
            }
        }
        return objectExists&&eventExists;
    }

    function getObjectAgentExists(string memory _objectHash, string memory _agentId)public view returns (bool) {
        bool objectExists = provObjects[_objectHash].isValid;
        bool agentExists = false;
        for (uint index = 0; index < provObjects[_objectHash].events.length; index++) {
            if (keccak256(abi.encodePacked(_agentId)) == keccak256(abi.encodePacked(provObjects[_objectHash].events[index])))
            {
                agentExists = true;
                break;
            }
        }
        return objectExists&&agentExists;
    }

    function getNumEvents(string memory _objectHash) public view returns (uint256) {
        return provObjects[_objectHash].events.length;
    }

    function getNumAgents(string memory _objectHash) public view returns (uint256) {
        return provObjects[_objectHash].agents.length;
    }

    function getObject(string memory _objectHash) public view returns (ObjectData memory) {
        return provObjects[_objectHash];
    }
    function getEvent(string memory _objectHash, uint256 _eventIndex) public view returns (string memory, string memory) {
        return (_objectHash, provObjects[_objectHash].events[_eventIndex]);
    }

    function getAgent(string memory _objectHash, uint256 _agentIndex) public view returns (string memory, string memory) {
        return (_objectHash, provObjects[_objectHash].agents[_agentIndex]);
    }
}