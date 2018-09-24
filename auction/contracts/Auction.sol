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


    
}
