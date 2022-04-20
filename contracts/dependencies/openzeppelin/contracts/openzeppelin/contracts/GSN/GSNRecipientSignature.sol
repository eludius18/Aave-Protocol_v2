// SPDX-License-Identifier: MIT

pragma solidity ^0.6.0;

import './GSNRecipient.sol';
import '../cryptography/ECDSA.sol';

/**
 * @dev A xref:ROOT:gsn-strategies.adoc#gsn-strategies[GSN strategy] that allows relayed transactions through when they are
 * accompanied by the signature of a trusted signer. The intent is for this signature to be generated by a server that
 * performs validations off-chain. Note that nothing is charged to the user in this scheme. Thus, the server should make
 * sure to account for this in their economic and threat model.
 */
contract GSNRecipientSignature is GSNRecipient {
  using ECDSA for bytes32;

  address private _trustedSigner;

  enum GSNRecipientSignatureErrorCodes {INVALID_SIGNER}

  /**
   * @dev Sets the trusted signer that is going to be producing signatures to approve relayed calls.
   */
  constructor(address trustedSigner) public {
    require(
      trustedSigner != address(0),
      'GSNRecipientSignature: trusted signer is the zero address'
    );
    _trustedSigner = trustedSigner;
  }

  /**
   * @dev Ensures that only transactions with a trusted signature can be relayed through the GSN.
   */
  function acceptRelayedCall(
    address relay,
    address from,
    bytes memory encodedFunction,
    uint256 transactionFee,
    uint256 gasPrice,
    uint256 gasLimit,
    uint256 nonce,
    bytes memory approvalData,
    uint256
  ) public view virtual override returns (uint256, bytes memory) {
    bytes memory blob =
      abi.encodePacked(
        relay,
        from,
        encodedFunction,
        transactionFee,
        gasPrice,
        gasLimit,
        nonce, // Prevents replays on RelayHub
        getHubAddr(), // Prevents replays in multiple RelayHubs
        address(this) // Prevents replays in multiple recipients
      );
    if (keccak256(blob).toEthSignedMessageHash().recover(approvalData) == _trustedSigner) {
      return _approveRelayedCall();
    } else {
      return _rejectRelayedCall(uint256(GSNRecipientSignatureErrorCodes.INVALID_SIGNER));
    }
  }

  function _preRelayedCall(bytes memory) internal virtual override returns (bytes32) {}

  function _postRelayedCall(
    bytes memory,
    bool,
    uint256,
    bytes32
  ) internal virtual override {}
}
