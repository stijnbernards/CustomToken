pragma solidity ^0.4.4;

import "./token/GameToken.sol";
import "../node_modules/zeppelin-solidity/contracts/math/SafeMath.sol";
import "../node_modules/zeppelin-solidity/contracts/ownership/Ownable.sol";

contract AirDrop is Ownable {
    using SafeMath for uint256;

    /**
    * @dev The AirdropCampaign struct used for airdrops
    */
    struct AirDropCampaign {
        bool created;
        address tokenHolder;
        uint participantCount;
        uint256 maxParticipants;
        uint256 amount;
        mapping(uint => address) participants;
    }

    event TokenDrop(address sender, address receiver, uint256 amount);

    uint public airDropCounter = 0;
    GameToken private token;
    mapping(uint256 => AirDropCampaign) airDrops;

    /**
    * @dev Airdrop Constructor
    *
    * @param _token The Custom token address
    */
    function AirDrop(
        GameToken _token
    ) public 
    {
        token = _token;
    }

    /**
    * @dev Create a new airdrop
    *
    * @param _tokenHolder The main tokenHolder wallet
    * @param _maxParticipants The max amount of airDrop participants
    * @param _amount The amount to distribute
    */
    function createAirDrop(
        address _tokenHolder,
        uint256 _maxParticipants,
        uint256 _amount
    ) public onlyOwner returns (uint airDropID)
    {
        airDropID = airDropCounter;

        airDrops[airDropID] = AirDropCampaign({
            tokenHolder: _tokenHolder,
            maxParticipants: _maxParticipants,
            amount: _amount,
            participantCount: 0,
            created: true
        });

        airDropCounter++;
    }

    /**
    * @dev Add an address to the airdrop
    * 
    * @param _airDropID The airDrop
    * @param _participant The participants address to add.
    */
    function addParticipantToAirDrop(
        uint _airDropID,
        address _participant
    ) public onlyOwner returns (uint participantID)
    {
        require(airDrops[_airDropID].created);

        participantID = airDrops[_airDropID].participantCount;

        airDrops[_airDropID].participants[participantID] = _participant;

        airDrops[_airDropID].participantCount++;
    }

    /**
    * @dev Distribute tokens
    *
    * @param _airDropID The AirDrop to distribute
    */
    function distribute(
        uint _airDropID
    ) public onlyOwner
    {
        for (uint i = 0; i < airDropCounter; i++) {
            TokenDrop(airDrops[_airDropID].tokenHolder, airDrops[_airDropID].participants[i], airDrops[_airDropID].amount);

            token.transferFrom(airDrops[_airDropID].tokenHolder, airDrops[_airDropID].participants[i], airDrops[_airDropID].amount);
        }
    }
}