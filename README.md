# JMIX Specification

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

| File / Folder   | Description                                           |
|-----------------|-------------------------------------------------------|
| `/spec/`        | Markdown source files for each section                |
| `/schemas/`     | JSON Schema definitions (Draft 2020-12)               |
| `/examples/`    | Sample `manifest.json`, audit logs, payloads          |
| `package.json`  | AJV-based validation scripts                          |
| `Makefile`      | Convenience targets for install and validation        |
| `licence.md`    | Licence terms for the specification                   |
| `README.md`     | This file                                             |
| `security.md`   | Outlines the security model and how to secure an envelope |

---

## Getting Started

To start using JMIX:

1. Explore the [Envelope Structure](./spec/envelope.md)
2. Review the [Manifest Format](./spec/envelope/manifest.md)
3. Browse [Examples](./examples/)

If you're implementing support for JMIX in your application, start with the `manifest.json` schema and sample envelopes.

## Schemas and Validation

The JMIX JSON Schemas live in `schemas/` and target JSON Schema Draft 2020-12. Validation is wired up using AJV.

Validate all examples:

```sh
npm install
npm run validate
```

Or with Make:

```sh
make install
make validate
```

Validate a single example:

```sh
npm run validate:manifest
npm run validate:metadata
npm run validate:files
npm run validate:audit
```

Notes:
- Formats like `uuid` and `date-time` are supported via ajv-formats.
- Schemas validate the JSON structure; they do not enforce the filesystem layout (e.g., existence of `payload/` directories). A composed top-level envelope schema may be added in future to describe directory-level constraints.

---

## Contributing

This specification is managed by Aurabox and contributions are currently **by request only**. If you have a suggestion or question, please [open an issue](https://github.com/aurabox/jmix/issues) or email us at `hello@aurabox.cloud`.

---

## Licence

The JMIX specification is licensed under the **Creative Commons Attribution-NoDerivatives 4.0 International (CC BY-ND 4.0)** licence.

You may use, share, and redistribute the specification freely. You **may not** modify or publish derivative versions without written permission.

---

© 2025 Aurabox Pty Ltd. All rights reserved.
