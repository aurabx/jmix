# JMIX Specification

**Version**: 1.0 Beta 1
**Licence**: [CC BY-ND 4.0](https://creativecommons.org/licenses/by-nd/4.0/)  
**Maintained by**: Aurabox Pty Ltd  
**Authors**: [Christopher Skene](https://www.linkedin.com/in/xtfer/)

---

## What is JMIX?

**JMIX (JSON Medical Imaging Exchange)** is an open, structured specification for the secure, portable, and auditable exchange of medical imaging and related metadata. It addresses the limitations of traditional DICOM-based workflows in distributed, cloud-native, and privacy-sensitive environments.

JMIX is:

- A vendor-neutral packaging format for imaging payloads (e.g., DICOM, NIfTI, PDFs)
- JSON-native and human-readable
- Secure-by-design with support for encryption, digital signatures, and audit trails
- Designed to work over APIs, queues, cloud object storage, and legacy transports (e.g., HL7)

---

## Why JMIX?

Healthcare workflows increasingly require:

- Cross-organisation and cross-border imaging exchange  
- Consent-aware and privacy-compliant transport  
- Streaming, indexing, and introspection without parsing full DICOM files  
- Support for modern tooling, including FHIR, S3, Kafka, and Web APIs

JMIX makes this possible by defining a portable envelope with well-structured metadata and clear implementation semantics.

---

## Specification Contents

This repository contains:

| File / Folder            | Description                                  |
|--------------------------|----------------------------------------------|
| `/spec/`                 | Markdown source files for each section       |
| `/schemas/`              | JSON Schema definitions (WIP)                |
| `/examples/`             | Sample `manifest.json`, audit logs, payloads |
| `/tools/`                | Validation utilities (optional)              |
| `LICENSE.md`             | Licence terms for the specification          |
| `README.md`              | This file                                    |
| `security.md`            | Outlines the security model and how to secure an envelope |

---

## Getting Started

To start using JMIX:

1. Explore the [Envelope Structure](./spec/envelope.md)
2. Review the [Manifest Format](./spec/envelope//manifest.md)
. Browse [Examples](./examples/)

If you're implementing support for JMIX in your application, start with the `manifest.json` schema and sample envelopes.

---

## Contributing

This specification is managed by Aurabox and contributions are currently **by request only**. If you have a suggestion or question, please [open an issue](https://github.com/aurabox/jmix/issues) or email us at `hello@aurabox.cloud`.

---

## Licence

The JMIX specification is licensed under the **Creative Commons Attribution-NoDerivatives 4.0 International (CC BY-ND 4.0)** licence.

You may use, share, and redistribute the specification freely. You **may not** modify or publish derivative versions without written permission.

---

© 2025 Aurabox Pty Ltd. All rights reserved.
