// SPDX-License-Identifier: GPL-3.0
pragma solidity >=0.5 <=0.9.0;

contract TwitterContract {
    event AddTweet(address author, uint Id);
    event DeleteTweet(uint Id);
    event UpdateTweet(uint Id,string desc);
    struct Tweet {
        uint id;
        address author;
        string description;
        bool isDeleted;
    }

    Tweet[] private tweets;

    mapping(uint256 => address) OwnerTweets;

    function addTweet(string memory _description, bool isDeleted) public {
        require(bytes(_description).length<=280);
        uint Id = tweets.length;
        tweets.push(Tweet(Id, msg.sender, _description, isDeleted));
        OwnerTweets[Id] = msg.sender;
        emit AddTweet(msg.sender, Id);
    }

   function ReadAllTweets() public view returns (Tweet[] memory) {
        Tweet[] memory temp = new Tweet[](tweets.length);
        uint c = 0;
        for(uint i=0; i<tweets.length; i++) {
            if(tweets[i].isDeleted == false) {
                temp[c] = tweets[i];
                c++;
            }
        }

        Tweet[] memory result = new Tweet[](c);
        for(uint i=0; i<c; i++) {
            result[i] = temp[i];
        }
        return result;
    }
    
    function ReadMyTweets() public view returns (Tweet[] memory) {
        Tweet[] memory temp = new Tweet[](tweets.length);
        uint c = 0;
        for(uint i=0; i<tweets.length; i++) {
            if(OwnerTweets[i] == msg.sender && tweets[i].isDeleted == false) {
                temp[c] = tweets[i];
                c++;
            }
        }

        Tweet[] memory result = new Tweet[](c);
        for(uint i=0; i<c; i++) {
            result[i] = temp[i];
        }
        return result;
    }

    function updateTweet(uint Id,string memory desc) public{
        require(bytes(desc).length<=280);
        if(OwnerTweets[Id]==msg.sender)
        {
            tweets[Id].description=desc;
            emit UpdateTweet(Id, desc);
        }
    }

    function deleteTweet(uint Id) public {
        if(OwnerTweets[Id] == msg.sender) {
            tweets[Id].isDeleted = true;
            emit DeleteTweet(Id);
        }
    }

}