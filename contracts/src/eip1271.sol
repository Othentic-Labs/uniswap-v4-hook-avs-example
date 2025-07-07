// SPDX-License-Identifier: MIT
pragma solidity ^0.8.0;

interface IERC1271 {
    function isValidSignature(bytes32 hash, bytes memory signature) external view returns (bytes4 magicValue);
}

contract My1271Module is IERC1271 {
    bytes4 internal constant MAGICVALUE = 0x1626ba7e;
    address public safe;

    constructor(address _safe) {
        safe = _safe;
    }

    function isValidSignature(bytes32 _hash, bytes memory _signature) public view override returns (bytes4) {
        // Forward to the Safe itself
        (bool success, bytes memory result) = safe.staticcall(
            abi.encodeWithSignature("isValidSignature(bytes32,bytes)", _hash, _signature)
        );
        if (success && result.length == 32 && abi.decode(result, (bytes4)) == MAGICVALUE) {
            return MAGICVALUE;
        }
        return 0xffffffff;
    }
}
