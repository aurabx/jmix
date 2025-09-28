# Contributing to JMIX

This specification is managed by Aurabox and contributions are currently **by request only**. If you have a suggestion or question, please [open an issue](https://github.com/aurabox/jmix/issues) or email us at `hello@aurabox.cloud`.

## Documentation Development

### Local Preview

To preview the documentation locally:

```sh
npm install
npm run docs:serve
```

Then visit [http://localhost:3000](http://localhost:3000)

### Making Changes

1. All documentation is in the `/docs` directory
2. The main specification content is in `/docs/spec/`
3. The homepage is `/docs/README.md`
4. Navigation is controlled by `/docs/_sidebar.md`

### Development Guidelines

Following the project's coding standards:

- **Temporary files**: Output to `./tmp` directory within the working folder (not system `/tmp`)
- **Schema path**: The schema directory path is configurable and can be set to custom locations like `../jmix`
- **Samples**: The project includes a `/samples` directory for use in tests

### Validation

Before submitting changes, ensure:

```sh
# Validate all JSON schemas and examples
npm run validate

# Validate specific components
npm run validate:manifest
npm run validate:metadata
npm run validate:files
npm run validate:audit
```

### Build Process

Documentation is automatically deployed to GitHub Pages on pushes to the `main` branch via GitHub Actions.

The deployment workflow:
1. Installs dependencies (`npm ci`)
2. Validates schemas (`npm run validate`)
3. Deploys the `/docs` directory to GitHub Pages

## License

By contributing to this project, you agree that your contributions will be licensed under the same [CC BY-ND 4.0](licence.md) license that covers the project.