pragma solidity ^0.4.8;

contract Sorter{

    uint[10][10] public mainValues;
    address[] bidderAddresses;

    struct bidderStruct {
        uint index;
    }
    
    mapping(address => bidderStruct) private bidderStructs;
 
    function set(uint[10][10] _mainValues, address[] _bidderAddresses) {
        mainValues = _mainValues;
        bidderAddresses = _bidderAddresses; 
    }
    
    function set_bidderStructs() {
        for (uint id = 0; id < bidderAddresses.length ; id++){
            bidderStructs[bidderAddresses[id]].index = id;
        }
    }

    function sort() public returns(address[]) {
        
        set_bidderStructs();
        address[] storage data = bidderAddresses;
        if (data.length >= 2){
            quickSort(data, 0, int(data.length - 1));
        }

        return data;
    }
    
    function quickSort(address[] arr, int left, int right) internal {
        int i = left;
        int j = right;
        if(i==j) return;
        uint pivot = bidderStructs[arr[uint(left + (right - left) / 2)]].index;
        while (i <= j) {
            while (mainValues[bidderStructs[arr[uint(i)]].index][pivot] == 2) i++;
            while (mainValues[pivot][bidderStructs[arr[uint(i)]].index] == 2) j--;
            if (i <= j) {
                (arr[uint(i)], arr[uint(j)]) = (arr[uint(j)], arr[uint(i)]);
                i++;
                j--;
            }
        }
        if (left < j)
            quickSort(arr, left, j);
        if (i < right)
            quickSort(arr, i, right);
        
    }
    
}

contract Auction{
    
    address public auctioneerAddress;
    uint q;
    uint[] M;
    bool auctioneerRegistered;
    // constructor function
    // constructor(uint _q, uint[] _M) public {
    //     auctioneerAddress = msg.sender;
    //     q = _q;
    //     M = _M;
    //     auctioneerRegistered = true;
    // }

    modifier onlyBy(address _account) {
        require(msg.sender == _account);
        _;
    }

    modifier onlyBefore(uint _time) {
        require(now < _time);
        _;
    }

    modifier onlyAfter(uint _time) {
        require(now > _time);
        _;
    }

    constructor() public {
        auctioneerAddress = msg.sender;
        // q = _q;
        // M = _M;
        auctioneerRegistered = true;
    }
    function sendParams(uint _q, uint[] _M) public onlyBy(auctioneerAddress) returns (bool) {
        q = _q;
        M = _M;
        return true;
    }    
    
    // Parameters of auction
    uint public numNotaries = 0;
    uint public numBidders = 0;
    
    function auctioneerExists () public view returns (address) {
        return auctioneerAddress;
    }
    
    //  Notary registration work
    struct notaryStruct {
        uint index;
        uint bidderIndex;
        uint[] retArray;
    }
    
    mapping(address => notaryStruct) public notaryStructs;
    address[] public notaryAddresses;
    event LogNewNotary (address indexed notaryAddress, uint index, uint bidderIndex);
    
    //  checking whether the notary is already registered or not
    function isNotary(address notaryAddress) public constant returns(bool) {
        if(notaryAddresses.length == 0) return false;
        return (notaryAddresses[notaryStructs[notaryAddress].index] == notaryAddress);
    }
    
    //  registering notaries
    function registerNotaries(address notaryAddress) public returns (bool){
        if(isNotary(notaryAddress) == false){
            notaryAddresses.push(notaryAddress);
            notaryStructs[notaryAddress].index = notaryAddresses.length - 1;
            notaryStructs[notaryAddress].bidderIndex = 0;
            emit LogNewNotary(notaryAddress, notaryAddresses.length, notaryStructs[notaryAddress].bidderIndex);
            return true;
        } 
        else{
            return false;
        }
        
    }

    function notariesLength () public view returns (uint) {
        return notaryAddresses.length;
    }
    
    // Structure for a bid where (u, v) are
    // the random representation of the ith item
    // such that x = (u+v)modq
    // And, where valuation_u, valuation_v are the 
    // random representation of valuation wi
    struct Bid {
        uint[] preferredItems;
        uint[] valuation;
    }
    
    struct bidderStruct {
        uint index;
    }
    
    mapping(address => bidderStruct) private bidderStructs;
    
    address[] public bidderAddresses;
    mapping(address => Bid) private bids;
    
    //  registering bidders
    event LogNewBidder   (address indexed bidderAddress, uint index);
    
    //  checking whether the bidder is already registered or not
    function isBidder(address bidderAddress) public constant returns(bool) {
        if(bidderAddresses.length == 0) return false;
        return (bidderAddresses[bidderStructs[bidderAddress].index] == bidderAddress);
    }
    
    //  registering bidders
    function registerBidders(address bidderAddress, uint[] preferredItems, uint[2] valuation) public returns (bool){
        if(isBidder(bidderAddress) == false){
            bidderStructs[bidderAddress].index = bidderAddresses.push(bidderAddress) - 1;
            bids[bidderAddress].preferredItems = preferredItems;
            bids[bidderAddress].valuation = valuation;
            
            emit LogNewBidder(
                bidderAddress, 
                bidderStructs[bidderAddress].index);
            return true;
        } 
        else{
            return false;
        }
    }

    
}
