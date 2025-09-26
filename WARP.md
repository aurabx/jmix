# WARP.md

This file provides guidance to WARP (warp.dev) when working with code in this repository.

Repository purpose
- This repo contains the JMIX (JSON Medical Imaging Exchange) specification: Markdown documents under spec/, normative examples under examples/, and additional guidance in security.md and licence.md. There is no application code or test suite.

Commonly used commands
- Navigate the spec
  ```sh path=null start=null
  ls -1 spec
  ls -1 spec/envelope
  ```
- Inspect important docs
  ```sh path=null start=null
  open spec/envelope.md           # macOS: overview of the JMIX envelope
  open spec/envelope/manifest.md  # manifest semantics
  open spec/envelope/metadata.md  # metadata semantics
  open spec/envelope/files.md     # files.json semantics
  open spec/envelope/audit.md     # audit trail semantics
  open security.md                # security model guidance
  ```
- Validate example JSON payloads syntactically
  ```sh path=null start=null
  jq -e . examples/*.json
  ```
Validation commands
- Install and validate with Node + AJV
  ```sh path=null start=null
  npm install
  npm run validate
  ```
- Or validate a single example
  ```sh path=null start=null
  npm run validate:manifest
  npm run validate:metadata
  npm run validate:files
  npm run validate:audit
  ```

High-level architecture and structure
- Envelope model
  JMIX defines a portable “envelope” that wraps medical imaging and metadata for secure, auditable exchange. Core elements:
  - manifest.json (immutable, non-PII): Transport- and operation-oriented metadata. May be signed (manifest.jws). Does not change in transit.
  - audit.json (append-only): Records envelope lifecycle events (created, sent, forwarded, received, etc.), optionally signed per step.
  - payload/ directory: The actual data being exchanged.
    - metadata.json: Patient, study/series, and routing/search metadata.
    - files.json: Conditional manifest of non-DICOM payload files (and optionally DICOM), including hash/size for validation.
    - dicom/: Raw DICOM instances when present.
    - files/: Non-DICOM attachments (e.g., PDF reports, JPG, NIfTI, text files).
    - preview/: Optional preview images keyed by SeriesUID for quick rendering/indexing.

  Reference layout
  ```text path=null start=null
  /<identifier>.JMIX/
  ├── manifest.json             # Required
  ├── manifest.jws              # Optional (JWS over manifest.json)
  ├── audit.json                # Required (append-only trail)
  └── payload/                  # Required
      ├── metadata.json         # Required
      ├── files.json            # Required when files/ present
      ├── dicom/                # Required for DICOM payloads
      ├── files/                # Required for non-DICOM payloads
      └── preview/              # Optional previews keyed by SeriesUID
  ```

- Security and trust (see security.md)
  - Payload confidentiality/integrity: AES-256-GCM with ephemeral ECDH (Curve25519) and HKDF-SHA256.
  - Identity and non-repudiation: Ed25519 signatures; optional manifest JWS; optional directory attestations.
  - Integrity affordances: payload_hash in manifest security block; optional per-file hashes in files.json.
  - Model supports pure peer-to-peer, peer-to-peer with directory, and asymmetric P2P modes without mandating a directory for decryption.

- Semantics highlights
  - Manifest: Transport metadata and cryptographic descriptors; excludes PII; includes optional security.jws/encryption blocks and optional extensions.
  - Assertions: Structured claims for sender/requester with signing_key, signed_fields, signature, and optional directory_attestation.
  - Metadata: Patient identifiers and name structure aligned to FHIR HumanName semantics; study/series summaries; optional report reference; extension keys (custom_tags, consent, deid) reserved but optional.
  - Audit: Strictly append-only list of lifecycle events with optional per-entry assertion.

What’s in README.md (essentials)
- JMIX purpose: vendor-neutral, JSON-native, designed for secure, portable exchange over APIs/queues/object storage and legacy transports; complements DICOM and modern tooling like FHIR/S3/Kafka/web APIs.
- Getting started: Begin with spec/envelope.md and spec/envelope/manifest.md, then review examples/.
- Contributions: Managed by Aurabox; contributions are by request; open issues for suggestions.
- Licence: CC BY-ND 4.0 (see licence.md).

Repository map (selected)
- spec/envelope.md: Envelope overview, directory layout, usage scenarios.
- spec/envelope/{manifest,metadata,files,audit}.md: Deep dives into each envelope component.
- examples/{manifest,files,metadata,audit}.json: Normative examples for implementers.
- security.md: Cryptographic model and operational guidance.
- licence.md: Licence terms.

Guidance for future instances of Warp
- Treat this as a specification/documentation repo. Focus on editing Markdown under spec/ and keeping examples consistent with the written semantics.
- When proposing changes, reference the affected spec section(s) and, if applicable, update the corresponding example JSON to match.
- If validation tooling is introduced later (e.g., JSON Schema under schemas/), prefer commands surfaced by repo scripts or Makefiles when they exist.
