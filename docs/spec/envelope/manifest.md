# The Manifest

The `manifest.json` file contains information about the payload, operation, and other details relevant to the transfer of data. It is intended to provide information to the receiver and any intermediaries about the data without requiring the payload to be unencrypted or read. It should NOT contain Personally Identifiable Information.

The specification includes a number of fields where all elements are optional. If a field is provided with no elements, then it should be ignored by the handling system.

## Example

```
{
   "version":"1.0",
   "id":"6f57f5fa-1cd1-45be-a5c3-fb209be1e0ec",
   "timestamp":"2025-05-24T06:14:00Z",
   "sender":{
      "name":"Radiology Clinic A",
      "id":"org:au.gov.health.123456",
      "contact":"imaging@clinica.org.au",
      "assertion":{
         "signing_key":{
            "alg":"Ed25519",
            "public_key":"<base64>",
            "fingerprint":"SHA256:<hex>"
         },
         "key_reference":"aurabox://org/clinic-a#key-ed25519",
         "signed_fields":[
            "id",
            "name",
            "contact",
            "manifest_hash"
         ],
         "signature":"<base64sig>",
         "expires_at":"2025-07-07T00:00:00Z",
         "directory_attestation":{
            "provider":"aurabox",
            "attestation_signature":"<JWS>",
            "attestation_timestamp":"2025-06-07T14:01:00Z",
            "attestation_public_key":"<base64>"
         }
      }
   },
   "requester":{
      "name":"Dr John Smith",
      "id":"org:au.gov.health.55555",
      "contact":"smith@clinicb.org.au",
      "assertion":{
         "signing_key":{
            "alg":"Ed25519",
            "public_key":"<base64>",
            "fingerprint":"SHA256:<hex>"
         },
         "key_reference":"aurabox://org/clinic-b#key-ed25519",
         "signed_fields":[
            "id",
            "name",
            "contact"
         ],
         "signature":"<base64sig>",
         "expires_at":"2025-07-07T00:00:00Z",
         "directory_attestation":{
            "provider":"aurabox",
            "attestation_signature":"<JWS>",
            "attestation_timestamp":"2025-06-07T14:01:00Z",
            "attestation_public_key":"<base64>"
         }
      }
   },
   "receiver":[
      {
         "name":"Radiology Clinic B",
         "id":"org:au.gov.health.987654",
         "contact":{
            "system":"phone",
            "value":"+61049555555"
         },
         "assertion":{
            "signing_key":{
               "alg":"Ed25519",
               "public_key":"<base64>",
               "fingerprint":"SHA256:<hex>"
            },
            "key_reference":"aurabox://org/clinic-b#key-ed25519",
            "signed_fields":[
               "id",
               "name",
               "contact"
            ],
            "signature":"<base64sig>",
            "expires_at":"2025-07-07T00:00:00Z",
            "directory_attestation":{
               "provider":"aurabox",
               "attestation_signature":"<JWS>",
               "attestation_timestamp":"2025-06-07T14:01:00Z",
               "attestation_public_key":"<base64>"
            }
         }
      }
   ],
   "security":{
      "classification":"confidential",
      "payload_hash":"sha256:instances-directory",
      "signature":{
         "alg":"RS256",
         "sig":"MEUCIBnA...",
         "hash":"sha256:4f06faee..."
      },
      "encryption":{
         "algorithm":"AES-256-GCM",
         "ephemeral_public_key":"<base64>",
         "iv":"<base64>",
         "auth_tag":"<base64>"
      }
   },
   "extensions":{
      "custom_tags":[
         "teaching",
         "priority-review"
      ]
   }
}
```

## Properties

| Name       | Flags   | Cardinality | Notes                                                                                                                                                 |
|------------|---------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------------|
| `version`  | S, R    | 1..1        | Version of the JMIX specification used in this envelope.                                                                                              |
| `id`       | S, R    | 1..1        | A unique, immutable identifier for this envelope. This must be a UUID, but can be generated at the time the envelope is created. <br> The ID is unique to the envelope, not the study (i.e. the same study can appear in multiple envelopes with different IDs). |
| `timestamp`| S, R    | 1..1        | ISO 8601 UTC datetime of envelope creation.                                                                                                           |
| `extensions`| A, O   | 0..*        | A free-form object or dictionary of extra data, such as tags, annotations, or project-specific metadata.                                              |

#### Flags:
- **S**: String  
- **R**: Required  
- **O**: Optional  
- **A**: Any/Arbitrary type  

### Sender, Requester and Receiver

The `sender`, `requester`, and `receiver` fields contain details of the entities involved in initiating and receiving the imaging transfer.

These fields serve as a **human-readable fallback** for systems that require identity information but do not perform cryptographic validation. They may also support contact tracing, routing, and logging.

- **Sender**: Required. The entity initiating the envelope.
- **Requester**: Optional. The original requestor of the imaging transfer (e.g. a referring physician).
- **Receiver**: Required. One or more intended recipients of the envelope. This is always an array.

> IDs **SHOULD** follow standard identifiers such as URNs, OIDs, or globally resolvable namespaces (e.g., FHIR identifiers or government-issued HPI-O values).

#### Example

```json
"sender": {
  "name": "Radiology Clinic A",
  "id": "org:au.gov.health.123456",
  "assertion": {
    ...
  }
},
"requester": {
  "name": "John Smith",
  "id": "org:au.gov.health.44444",
  "contact": {
    "system": "email",
    "value": "imaging@clinica.org.au"
  },
  "assertion": {
    ...
  }
},
"receiver": [
  {
    "name": "Radiology Clinic B",
    "id": "org:au.gov.health.987654",
    "contact": {
      "system": "phone",
      "value": "+61049555555"
    }
  }
]
```

#### Properties

| Name        | Flags | Cardinality | Notes                                                                                                                                                  |
|-------------|-------|-------------|--------------------------------------------------------------------------------------------------------------------------------------------------------|
| `name`      | S, O  | 0..1        | Human-readable name of the entity (e.g. organisation or person).                                                                                       |
| `id`        | S, R  | 0..1        | Globally unique identifier for the entity (e.g. HPI-O, HPI-I, or FHIR `Practitioner.identifier`).                                                      |
| `contact`   | S, R  | 0..1        | Preferred contact method. Can be structured as <code>{ "system": "email", "value": "name@example.com" }</code> using [`ContactPoint.system`](https://build.fhir.org/valueset-contact-point-system.html). |
| `assertion` | E     | 0..1        | A structured cryptographic claim about the entity. See `Entity Assertions`.                                                                            |


### Entity Assertions (optional but recommended)

The assertion blocks are structured claims about the sender and requester of a JMIX envelope. They enable cryptographic verification of the sender’s identity, independent of transport, and optionally include a directory attestation to enhance trust.

This block is particularly important in decentralised environments, where there is no persistent identity provider. It allows recipients to verify that the envelope was sent by a specific, authenticated party and ensures the integrity of that sender’s identity claim.

#### Example

```json
{
  "assertion": {
    "signing_key": {
      "alg": "Ed25519",
      "public_key": "<base64>",
      "fingerprint": "SHA256:<hex>"
    },
    "key_reference": "aurabox://org/clinic-a#key-ed25519",
    "signed_fields": [
      "sender.id",
      "sender.name",
      "signatures.manifest.kid",
      "manifest_hash"
    ],
    "signature": "<base64sig>",
    "expires_at": "2025-07-07T00:00:00Z",
    "directory_attestation": {
      "provider": "aurabox",
      "attestation_signature": "<JWS>",
      "attestation_timestamp": "2025-06-07T14:01:00Z",
      "attestation_public_key": "<base64>"
    }
  }
}
```

#### Properties

| Name                 | Flags    | Cardinality | Notes                                                                                                                                                                                                                                                                                        |
|----------------------|----------|--------------|----------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `signing_key`        | E, R     | 1..1         | The public key and fingerprint used to verify the signature.                                                                                                                                                                                                                                 |
| `key_reference`      | S, R     | 1..1         | A URI identifying the signing key within a known key registry or directory (e.g. organisation-scoped key), as a URI, e.g. `aurabox://org/clinic-a#key-ed25519`. Enables downstream consumers to fetch metadata or trust policies associated with the key.                                   |
| `signed_fields`      | L[S], R  | 1..1         | JSON pointers or dot-paths to fields in the envelope that are covered by the signature. Each field must exist in the envelope and be included in the deterministic canonicalisation process (e.g. JSON Canonical Form or JCS). This allows partial signing of only sensitive or identity-related fields. |
| `signature`          | S, R     | 1..1         | A base64-encoded Ed25519 detached signature. It signs the canonicalised `signed_fields` and their associated values. <br><br>**Signature verification requires:**<br>- The `signed_fields` list<br>- Values from the corresponding fields<br>- Canonical encoding<br>- `signing_key.public_key` |
| `expires_at`         | S        | 0..1         | Optional expiration timestamp for the signature assertion. After this time, the assertion is no longer considered valid. ISO 8601 UTC datetime.                                                                                                                                            |
| `directory_attestation` | E    | 0..1         | Optional third-party trust attestation, typically from a directory authority (e.g. Aurabox).                                                                                                                                                                                                |


#### `signing_key` Properties

| Name         | Flags | Cardinality | Notes                                                                                       |
|--------------|-------|-------------|---------------------------------------------------------------------------------------------|
| `alg`        | S, R  | 1..1        | Algorithm used for signature verification. Currently only `"Ed25519"` is supported.        |
| `public_key` | S, R  | 1..1        | The raw Ed25519 public key in base64 encoding.                                              |
| `fingerprint`| S, R  | 1..1        | SHA-256 fingerprint of the public key, formatted as `SHA256:<hex>` for identification.      |

#### `directory_attestation` Properties

| Name                   | Flags | Cardinality | Notes                                                                                                                  |
|------------------------|-------|-------------|------------------------------------------------------------------------------------------------------------------------|
| `provider`             | S, R  | 1..1         | Identifier for the attesting authority (e.g. `"aurabox"`).                                                             |
| `attestation_signature`| S, R  | 1..1         | A JSON Web Signature (JWS) over the key metadata and optionally the envelope metadata.                                 |
| `attestation_timestamp`| S, R  | 1..1         | Time at which the attestation was generated. ISO 8601 UTC datetime.                                                   |
| `attestation_public_key`| S, R | 1..1         | The public key used by the directory to verify the attestation signature.                                             |

### Security

The `security` block provides metadata and cryptographic protections to ensure the **confidentiality**, **integrity**, and **authenticity** of the JMIX envelope contents. It supports both encrypted and plaintext workflows by combining digital signatures, hashing, and optional encryption.

#### Example

```json
"security": {
  "classification": "confidential",
  "payload_hash": "sha256:<hex-digest>",
  "jws": {
    "jws_file": "manifest.jws"
  },
  "encryption": {
    "algorithm": "AES-256-GCM",
    "ephemeral_public_key": "<base64>",
    "iv": "<base64>",
    "auth_tag": "<base64>"
  }
}
```

#### Properties

| Name           | Flags | Cardinality | Notes                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                               |
|----------------|--------|--------------|---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| `classification` | S, O  | 0..1         | Indicates the overall data sensitivity. <br><br>**Permitted values:**<br>- `"confidential"` – standard for identified clinical imaging<br>- `"sensitive"` – e.g. re-identifiable, genetic, or culturally restricted datasets<br>- `"de-identified"` – all direct identifiers have been removed or masked                                                                                                                                                                                                                                                                                                                                                                                                                                                            |
| `payload_hash`   | S, O  | 0..1         | A SHA-256 hash of the payload directory. Ensures the integrity of the payload directory when the payload is unencrypted. <br/>See Security guidance for information on how to calculate the hash.                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |
| `jws`            | E, O  | 0..1         | Describes the digital signature applied to `manifest.json` using the JSON Web Signature (JWS) standard. Provides strong integrity and authenticity guarantees for the envelope manifest. <br><br>**Details:**<br>- Only valid property: a file key with a relative path to the JWS file (typically `manifest.jws`)<br>- Ensures that `manifest.json` was created by a trusted party and has not been altered<br>- Enables recipients to verify the signature using the signer’s public key<br>- Decouples the signature from the payload for compatibility with external JWS tools<br><br>**JWS file must conform to:**<br>- Base64url-encoded protected header<br>- Base64url-encoded payload (the manifest)<br>- One or more base64url-encoded digital signatures |
| `encryption`     | S, O  | 0..1         | Provides confidentiality and tamper-resistance for the `/payload` directory. <br><br>**Fields:**<br>- `algorithm`: Always `"AES-256-GCM"`<br>- `ephemeral_public_key`: Sender’s one-time ECDH key (base64)<br>- `iv`: 12-byte nonce (base64)<br>- `auth_tag`: 16-byte authentication tag (base64)                                                                                                                                                                                                                                                                                                                                                                                                                                                                   |

