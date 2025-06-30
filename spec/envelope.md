# The JMIX Envelope

## Format

A **JMIX envelope** is a payload containing a metadata file and related medical imaging.

## File Structure

The envelope consists of the following components:

- [`manifest.json`](/spec/envelope/manifest.md)
  Contains information about the payload and operation, but no Personally Identifiable Information (PII). This file does **not** change in transit. **(Required)**

- `manifest.jws`  
  A JSON Web Signature file verifying the integrity and origin of the manifest. **(Optional)**

- [`audit.json`](/spec/envelope/audit.md)  
  Tracks events/actions performed on the envelope in transit. **(Required)**

- `payload/`
  Directory containing the core data and metadata:
  - [`metadata.json`](/spec/envelope/metadata.md) 
    Contains all relevant information about the study and operation. **(Required)**
  - [`files.json`](/spec/envelope/files.md)
    A list of all files in the payload. Required **only** when the `files/` directory is present. **(Conditional)**
  - `dicom/`  
    Contains one or more DICOM instances. **(Required for DICOM-based envelopes)**
  - `files/`  
    Contains any additional non-DICOM files (e.g., PDFs). **(Required for non-DICOM content)**
  - `preview/`  
    Optional preview images keyed by `SeriesUID`. **(Optional)**

## Directory Layout

```
/<identifier>.JMIX/
├── manifest.json             # Required
├── manifest.jws              # Optional
├── audit.json                # Required
├── payload              	 # Required
│   ├── metadata.json       	 # Required
│   ├── files.json            # Required when the files directory is present
│   ├── dicom/          	 # Required for DICOM files
│   │   ├── <InstanceUID>.dcm
│   │   ├── …
│   ├── files/          	 # Required for non-DICOM
│   │   ├── <file-id>.extension
│   │   ├── ...
│   ├── preview/            	 # Optional
│   │   ├── <SeriesUID>.jpg
│   │   ├── ...
```

## The Payload

The payload contains all the actual medical data being transported in this envelope. The payload can be sent “as is”, especially if the connection is internal or via some other secure channel, however it is designed to be sent encrypted. When encrypted, the corresponding `encryption` block should be present in the manifest.

# The dicom directory

Directory of raw, unmodified DICOM files. It is assumed that the files in this directory are the complete set of imaging required for this payload, however no guarantees are made about completeness.

If the files.json file (see below) is present and specifies files in this directory, this can be used to validate the set, however the result of a mismatch is up to the receiving system. Since this is just a file format and not a protocol, there is no inherent mechanism to reject in the case of a mismatch.

## The Preview Directory

JPEG/PNG representations of key series, for fast rendering and indexing. Files in this directory are NOT required to be listed in files.json.

- Filenames: <SeriesUID>.jpg
- May be generated on proxy or upstream PACS

## Compliance Notes

JMIX is not a replacement for DICOM. It wraps and describes DICOM content in transit.

JMIX is designed to be privacy-aware, making data minimisation and consent visible and machine-actionable.

Compatible with APP 5 and 6 requirements (Australia), HIPAA (US), and GDPR (EU) when implemented correctly.

## Relationship with FHIR

JMIX is designed to be complementary to FHIR based services, however it is not directly compatible. JMIX-based resources can be mapped into FHIR using a basic mapping, if required. This is documented in the JMIX-FHIR Compatibility Guidelines.

## Usage Scnearios

| Scenario                  | Envelope Format                                           |
|---------------------------|----------------------------------------------------------|
| Streaming between JMIX nodes | `multipart/mixed` or streamed JSON + binary chunks      |
| Upload to Aurabox via TUS | `.zip` archive of envelope                               |
| Long-term archival        | `.tar.gz` envelope with `metadata.json`                  |
| Edge query + preview      | Just `metadata.json` and `preview/`  