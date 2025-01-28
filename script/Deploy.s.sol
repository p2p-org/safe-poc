// SPDX-FileCopyrightText: 2024 P2P Validator <info@p2p.org>
// SPDX-License-Identifier: MIT

pragma solidity 0.8.27;

import "../src/@safe/ISafe_1_4_1.sol";
import "../src/@safe/proxies/SafeProxyFactory.sol";
import {Script} from "forge-std/Script.sol";

contract Deploy is Script {
    address public constant SafeProxyFactoryAddress = 0x4e1DCf7AD4e460CfD30791CCC4F9c8a4f820ec67;
    SafeProxyFactory public constant SafeProxyFactoryInstance = SafeProxyFactory(SafeProxyFactoryAddress);

    address public constant Safe_1_4_1_Address = 0x41675C099F32341bf84BFc5382aF534df5C7461a;

    address private clientAddress;
    uint256 private clientPrivateKey;

    address private p2pOperatorAddress;
    uint256 private p2pOperatorPrivateKey;

    address public ClientSafeInstance;

    function run() external returns (SafeProxy) {
        address[] memory _owners = new address[](5);
        _owners[0] = 0x1ccc08671Da62588AbB6c6CEbDfA2253A3A0F80C;
        _owners[1] = 0xa48e6Cc985e066b31aF5cBBE4D6a1Aa1657Dc075;
        _owners[2] = 0xdff3F5DBd6B6c929460dC48251F328035bb87D93;
        _owners[3] = 0x8a388c41c05b8C0ac7E8b5D58d3D1A0AB17d6Ad7;
        _owners[4] = 0x000000005504F0f5CF39b1eD609B892d23028E57;

        uint256 _threshold = 1;
        address to = address(0);
        bytes memory data = "";
        address fallbackHandler = address(0);
        address paymentToken = address(0);
        uint256 payment = 0;
        address payable paymentReceiver = payable(address(0));

        bytes memory initializer = abi.encodeCall(ISafe_1_4_1.setup, (
            _owners,
            _threshold,
            to,
            data,
            fallbackHandler,
            paymentToken,
            payment,
            paymentReceiver
        ));

        uint256 deployerKey = vm.envUint("PRIVATE_KEY");

        vm.startBroadcast(deployerKey);

        SafeProxy proxy = SafeProxyFactoryInstance.createProxyWithNonce(
            Safe_1_4_1_Address,
            initializer,
            0
        );

        vm.stopBroadcast();

        return (proxy);
    }
}
