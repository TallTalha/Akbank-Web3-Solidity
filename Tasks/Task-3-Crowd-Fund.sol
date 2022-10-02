// SPDX-License-Identifier: MIT
// compiler version must be greater than or equal to 0.8.13 and less than 0.9.0
pragma solidity ^0.8.13;
//@dev https://app.patika.dev/JessFlexx , https://github.com/TallTalha

//In this contract, users will be able to create campaigns.They will be able to post when their campaign will start, 
//when their campaign will end, and how much tokens they want to collect so that their campaign can reach its goal.

import "https://github.com/OpenZeppelin/openzeppelin-contracts/blob/v4.0.0/contracts/token/ERC20/ERC20.sol";

contract crowdFund{

    struct Campaign{
        address creator;
        uint256 goal;
        uint pleged; //Vault of campaign
        uint32 startAt;//Timestamps are stored in uint32 type. Notice that here:
        uint32 endAt; //Uint32 refers to about 100 years from now. So these two time stamps are sufficient.
        bool claimed; //Returns whether the campaign owner has claimed the tokens.
    }

//Emit&event is used to logging. The information is recorded on the blockchain.
    event Launch(uint _id, address indexed creator, uint256 _goal, uint32 _startAt, uint32 _endAt);
    event Cancel(uint _id);
    event Pledge(uint indexed _id, address indexed sender,uint256 _amount); //indexed id->because many users will be able to pledge to the same campaign
    event Unpledge(uint indexed _id, address indexed sender,uint256 _amount);
    event Claim(uint _id);
    event Refund(uint indexed _id, address indexed taker, uint _amount);
    
//The greater the diversity of tokens, the higher the probability of vulnerabilities.
//We only support one token per contract to minimize risk, we will store the token in ierc20.
    
    IERC20 public immutable token; //immutable:It can be determined later, it does not change after it is determined.
    uint public count; //Generates campaign identities/IDs.
    
    mapping (uint => Campaign) public campaigns; //It allows you to set an ID for each campaign.
//If ordering is important, array can be used instead of mapping.

    mapping (uint=> mapping(address => uint )) pledgeAmount;
// ↑defines↑(campaign ID => (creator => total pledge amount))

//Determines the token.
    constructor(address _token){
        token = IERC20(_token);
    }


//Launchs the campaign based on the inputs. The token is set in the constructor block.
    function launch(uint256 _goal,uint32 _startAt,uint32 _endAt) external {
        require(_startAt >= block.timestamp,"The start time can be set now or until later.");
        require(_startAt < _endAt,"The end time can be set later than the start time.");
        require(_endAt <= block.timestamp + 90 days,"The end time can be set up to 90 days from now.");
        
        count +=1;
        campaigns[count] = Campaign(msg.sender, _goal, 0, _startAt, _endAt, false);
        //id and inputs are assigned to the campaign.
        
        emit Launch(count, msg.sender, _goal, _startAt, _endAt);
        //Emit&event is used to logging. The information is recorded on the blockchain.
    }

//Cancel the campaign
    function cancel(uint _id) external{
        Campaign storage campaign = campaigns[_id]; //Storage cheaper than memory when the information on the blockcahin.
                                                    //There is no need to create a new copy for this function.
        require(msg.sender == campaign.creator,"You are not authorized to cancel this campaign.");//Checks the creator
        require(block.timestamp < campaign.startAt,"The campaign cannot be canceled because it is active."); //Checks the campaign activity.
        
        delete campaigns[_id]; //Deletes the campaign
        emit Cancel(_id); //Logging campaign ID information.
    }


//Users can send tokens to the campaign while the campaign is active. pledge => committed/promised tokens.
    function pledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        
        require(campaign.startAt <= block.timestamp,"The campaign not started." );
        require(campaign.endAt >= block.timestamp,"The campaign ended." );
        //The "requires" checks -> is the campaign active ?

        require(_amount > 0,"Zero units cannot be transferred."); //To avoid mistakes

        //To prevent Re-Entry Attack, state variables are changed in advance, then the transfer is performed.
        //The importance of this attack is explained at the bottom of the code.
        
        campaign.pleged += _amount; //if requirements are met -> campaign vault will be increased by the specified value(_amount).
        pledgeAmount[_id][msg.sender] += _amount; 
        //In order to be able to return it later, the address of the sender, the ID of the campaign and the amount sent are recorded.
        
        bool transfered = token.transferFrom(msg.sender, address(this), _amount); //Transfer realized. returns true/false.
        
        emit Pledge(_id, msg.sender,_amount);
        if(!transfered) revert("The transfer could not be performed.");
                           
    }

//If users change their mind, they can get back their committed/promised tokens.
    function unpledge(uint _id, uint _amount) external {
        Campaign storage campaign = campaigns[_id];
        require(campaign.endAt >= block.timestamp,"The campaign ended." );
        //If the campaign is over, the token cannot be refunded.
        
//To prevent Re-Entry Attack, state variables are changed in advance, then the transfer is performed.
//The importance of this attack is explained at the bottom of the code.
        
        campaign.pleged -= _amount; //Campaign vault decreased
        pledgeAmount[_id][msg.sender] -= _amount; //Sender's tokens in the campaign have decreased.
        bool transfered = token.transfer(msg.sender, _amount);
        
        emit Unpledge(_id,msg.sender,_amount); //The information is recorded on the blockchain.
        if(!transfered) revert("The transfer could not be performed.");

    }
//Users will be able to call these two functions pledge and unpledge while "the campaign is still going".

//If the campaign end and reaches its token target or more, campaign creator can claim tokens with the "claim"function.
    function claim(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        
        require(msg.sender == campaign.creator,"You are not authorized to claim."); //Checks campaign creator
        require(block.timestamp > campaign.endAt,"The campaign not ended.");//Checks that, Is the campaign over?
        require(campaign.pleged >= campaign.goal, "The campaign failed to reach its goal. You cannot claim tokens." ); //Checks that, Did the campaign reach its goal?
        
        require(campaign.claimed == false ,"The tokens already claimed."); //Checks that, Is the campaign vault claimed?
         
        campaign.claimed = true; //Indicates that the tokens in the campaign vault have been collected.
          
        bool trasfered = token.transfer(campaign.creator, campaign.pleged);
        
        emit Claim(_id); //Logging campaign ID information.
        if(!trasfered) revert("The transfer could not be performed."); 
    }

//If the token amount "does not reach" its target "when the campaign ends", the users can request the refund of their tokens with the "refund" function.
    function refund(uint _id) external {
        Campaign storage campaign = campaigns[_id];
        
        require(pledgeAmount[_id][msg.sender] > 0,"You have not transferred any token to the campaign."); //Checks that, has the user sent coins to the campaign?
        require(block.timestamp > campaign.endAt,"The campaign not ended, you should use unpledge option.");//Checks that, Is the campaign over?
        require(campaign.pleged < campaign.goal, "The campaign succeeded to reach its goal. You can't refund tokens" ); //Checks that, is campaign reached goal
        
        uint bal = pledgeAmount[_id][msg.sender]; //The user's token amount is assigned to the temporary variable.
        pledgeAmount[_id][msg.sender] = 0; //Zero is assigned because all of them will be drawn.
        
        token.transfer(msg.sender, bal); //The user's token transfer realized.

        emit Refund(_id,msg.sender,bal);
    }

    /*
    ##### Hack Solidity: Reentrancy Attack ####
    When the contract fails to update its state before sending funds, the attacker can continuously call the withdraw function to drain the contract’s funds.
     A famous real-world Reentrancy attack is the DAO attack which caused a loss of 60 million US dollars.

    -----> Therefore, state variables are changed up front, then the transfer is performed. <-----
    */


}