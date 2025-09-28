# JMIX Specification

**JMIX (JSON Medical Imaging Exchange)** is an open, structured specification for the secure, portable, and auditable exchange of medical imaging and related metadata.

## 📚 Documentation

The complete JMIX specification and documentation is available at:

**[https://aurabx.github.io/jmix/](https://aurabx.github.io/jmix/)**

Alternatively, browse the documentation in the [`/docs`](./docs) directory.

## 🚀 Quick Start

### Local Development

To serve the documentation locally:

```sh
npm install
npm run docs:serve
```

Then visit [http://localhost:3000](http://localhost:3000)

### Validation

Validate the JSON schemas and examples:

```sh
npm run validate
```

## 📁 Repository Structure

| Directory   | Description                                           |
|-------------|-------------------------------------------------------|
| `/docs/`    | Documentation site (Docsify)                         |
| `/schemas/` | JSON Schema definitions (Draft 2020-12)               |
| `/examples/`| Sample `manifest.json`, audit logs, payloads          |

## 📄 License

The JMIX specification is licensed under the [CC BY-ND 4.0](https://creativecommons.org/licenses/by-nd/4.0/) licence.

---

© 2025 Aurabox Pty Ltd. All rights reserved.
