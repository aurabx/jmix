# JMIX Envelope Security Guidance

This document outlines the encryption model, identity verification mechanisms, and operational security recommendations for the **JMIX (JSON Medical Imaging Exchange)** Envelope format.

It provides practical implementation guidance to ensure secure, verifiable exchange of medical imaging data using JMIX, supporting both peer-to-peer and directory-enhanced workflows.

---

## 1. Security Overview

JMIX Envelopes enable secure, portable exchange of medical imaging and associated metadata. The security model:

* Provides **end-to-end encryption** with forward secrecy
* Supports **cryptographically verifiable sender and requester identity**
* Enables **non-repudiation** of envelope origin
* Allows for **optional use of trusted directories** (e.g., Aurabox) for enhanced verification, without creating technical dependencies

The design ensures that imaging data can be safely exchanged across organisational boundaries, including direct peer-to-peer scenarios.

---

## 2. Cryptographic Foundations

JMIX employs modern, standardised cryptography:

| Purpose             | Algorithm / Approach                   |
| ------------------- | -------------------------------------- |
| Payload Encryption  | AES-256-GCM (authenticated encryption) |
| Key Exchange        | Ephemeral ECDH over Curve25519         |
| Key Derivation      | HKDF with SHA-256                      |
| Identity Signatures | Ed25519 Digital Signatures             |

### Forward Secrecy

Each envelope uses a unique, ephemeral sender key for encryption. Compromise of long-term keys does not expose previously exchanged envelopes.

---

## 3. Envelope Security Structure

JMIX envelopes contain the following security-relevant components:

### 3.1. Encryption Block

The `encryption` block describes how the payload was encrypted:

```json
"encryption": {
  "algorithm": "AES-256-GCM",
  "ephemeral_public_key": "<base64>",
  "iv": "<base64>",
  "auth_tag": "<base64>"
}
```

This ensures the payload cannot be decrypted or tampered with by unauthorised parties.

### 3.2 Payload Hash

The payload hash calculation ensures the integrity of a JMIX payload. It works differently depending on whether the payload is encrypted or unencrypted:

**Encrypted Payload**

1. If the envelope is encrypted, the system looks for a single file named payload.encrypted in the envelope root.
1. If this file is missing, an exception is raised.
1. The SHA-256 hash of this file is calculated and returned in the form:

```sha256:<hash>```

**Unencrypted Payload**

If the payload is not encrypted, the payload must exist as a directory. If the directory does not exist, an exception is raised.

1. The system recursively walks the directory, processing each entry (file or subdirectory).
1. For each directory: record its relative path.
1. For each file: record its relative path, file size, and SHA-256 hash.
1. All entries are sorted alphabetically by path for consistency.

A manifest string is created by concatenating each entry’s metadata (one per line).

The SHA-256 hash of the manifest is calculated and returned in the form:

```sha256:<hash>```

This ensures that any change in file content, size, or structure results in a different payload hash, making it a reliable integrity check.

### 3.3. Sender Assertion (Recommended)

The `sender_assertion` provides cryptographically verifiable information about the envelope sender:

* Contains sender's claimed identity
* Binds that identity to the specific envelope using a digital signature
* Supports optional third-party attestation (e.g., Aurabox)

This enables:

* Trust decisions in peer-to-peer or offline environments
* Defence against identity spoofing
* Forensic proof of envelope origin

### 3.4. Requester Assertion (Optional)

When applicable, a `requester_assertion` allows the sender to cryptographically prove the identity of the party requesting the data, enabling policy-driven decisions on whether to fulfil the request.

---

## 4. Key Management and Discovery

Recipients must maintain a stable, long-term asymmetric keypair for decryption. Public keys may be shared:

* Out-of-band (e.g., QR code, secure email)
* Via trusted directories such as Aurabox
* By referencing key identifiers within the envelope

**Recipients are responsible for protecting private keys.**

Key rotation and revocation policies should be defined at the organisational level.

---

## 5. Modes of Operation

JMIX supports three interoperable exchange models:

| Mode                   | Description                                                                                               |
| ---------------------- | --------------------------------------------------------------------------------------------------------- |
| **Pure Peer-to-Peer**  | Direct exchange of envelopes without external services                                                    |
| **P2P with Directory** | Optional use of a directory (e.g., Aurabox) for identity resolution, key discovery, or consent validation |
| **Asymmetric P2P**     | One party uses a directory, the other operates independently                                              |

Use of directories enhances trust and usability but is not technically required for decryption.

---

## 6. Security Recommendations

### 6.1. Minimum Requirements

- Always encrypt the envelope payload for transfers beyond a single, controlled system
- Use sender assertions for identity proof wherever possible
- Distribute recipient public keys securely
- Validate all signatures before processing envelope contents
- Maintain audit trails (see `audit.json` in the JMIX specification)

### 6.2. Optional but Recommended

- Use directory attestations for sender/requester identities
- Implement key rotation and revocation mechanisms
- Validate `expires_at` timestamps on assertions where present
- Enforce mutual TLS for transport channels

---

## 7. Threat Mitigations

| Threat                          | Mitigation                                          |
| ------------------------------- | --------------------------------------------------- |
| Payload Tampering               | AES-GCM authentication tag, payload hashes          |
| Identity Spoofing               | Sender/requester assertions, Ed25519 signatures     |
| Eavesdropping                   | Ephemeral ECDH key exchange, AES-256 encryption     |
| Replay Attacks                  | Envelope identifiers, timestamps, short-lived keys  |
| Directory Compromise (Optional) | Does not prevent decryption; affects trust metadata |

---

## 8. Security Considerations for Implementers

* Cryptographic operations must be performed using reputable, standards-compliant libraries
* Private keys must never be embedded in envelopes or transmitted
* Ephemeral keys should be securely generated for every envelope
* Assertion signature validation must include canonicalisation of signed fields
* Directory integrations should not introduce mandatory dependencies for decryption

---

## 9. Conclusion

The JMIX envelope format provides a flexible, decentralised, and verifiable model for secure medical imaging exchange. When implemented correctly, it enables:

* Private, peer-to-peer imaging exchange
* Optional directory-driven governance
* Strong identity assurance
* Confidentiality, integrity, and non-repudiation

For technical details, refer to:

* [JMIX Envelope Specification](./README.md)
