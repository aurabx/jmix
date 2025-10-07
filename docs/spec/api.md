# JMIX Endpoint API

This API enables upload and retrieval of complete JMIX envelopes, with strict conformance to the JMIX structure and semantics.

---
## Media Type

All responses and uploads **must support** the following content types via[ HTTP content negotiation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Content_negotiation):

* `application/zip`
* `application/gzip` (for `.tar.gz` archives)

If no `Accept` header is provided, the default response format is `application/zip`.

---

## GET Envelope

### 1a. Basic GET request

**Endpoint**: \
`GET /api/jmix/{id}`

**Description**: \
Retrieve a full JMIX envelope by its envelope UUID.

**Path Parameter**:

* `id`: The `manifest.json.id` of the JMIX envelope.

**Request Headers**:

* `Accept`: Optional. Specifies the desired archive format. \
  Supported values: \

    * `application/zip` → returns a `.zip` archive (default)
    * `application/gzip` or `application/x-gtar` → returns a `.tar.gz` archive

**Responses**:

* `200 OK`: \
  Returns a packaged JMIX envelope in the requested format. \
  The response will include:
    * `Content-Type: application/zip` or `application/gzip \
`
    * `Content-Disposition: attachment; filename="{id}.zip"` or `"{id}.tar.gz"`

The archive contains a JMIX envelope as defined in the JMIX specification

* `406 Not Acceptable`: \
  Returned if the `Accept` header requests an unsupported media type. \

* `404 Not Found`: \
  Returned if the envelope or associated study is not found.

### 1b. GET manifest

```
GET /api/jmix/{id}/manifest
```

Retrieve a JMIX manifest by its envelope UUID. This allows retrieving the transport information without requiring the entire data package.

#### **Path Parameter**

* `id`: The `manifest.json.id` of the JMIX envelope

#### **Response**

```
200 OK: Returns a .tar.gz archive of the JMIX envelope with the following structure:

Content-Type: application/vnd.aurabox.jmix+zip
Content-Disposition: attachment; filename="{id}.tar.gz"
```

The ZIP must contain a JMIX envelope as defined in the JMIX specification. \
\
`404 Not Found`: If envelope or study is not found.

### 1c. GET Envelope by Study Instance UID

```
GET /api/jmix?studyInstanceUid=xxx
```

Retrieve a full JMIX envelope by its envelope UUID. \

#### **Query Parameters **

* `study_uid`: Used to search for a JMIX envelope that includes the specified DICOM `StudyInstanceUID`. Returns the most recent if multiple exist.
* A JMIX endpoint may allow other query parameters, however this is not part of the specification

The response is the same as 1a. Basic GET \

---
## 2. POST Envelope

**Endpoint**: \
`POST /api/jmix`

**Description**: \
Store a new JMIX envelope uploaded as a single archive file.

**Headers**

* `Content-Type`: Required. Specifies the archive format used in the request body. \
  Supported values: \

    * `application/zip` → for `.zip` archive
    * `application/gzip` → for `.tar.gz` archive
    * *(Optionally, you may also support a custom type such as <code>application/vnd.aurabox.jmix+zip</code>)*

**Body**

The request body must contain a `.zip` or `.tar.gz` archive representing a full JMIX envelope directory.

The archive must:

* Contain a valid JMIX envelope structure.
* Include a top-level `manifest.json` file.
* Use the `manifest.json.id` value as the authoritative envelope ID. \

**Responses**

`201 Created \
`The envelope was accepted and stored successfully. \
\
**Example JSON response:**

* `400 Bad Request \
`Returned if:
    * The archive is malformed or unreadable.
    * `manifest.json` is missing or invalid.
    * Required JMIX validation fails.
* `409 Conflict \
`Returned if an envelope with the same `manifest.json.id` already exists and cannot be overwritten.

### Envelope Validation Rules (must enforce)

* `manifest.json` must be present and parseable
* `payload/metadata.json` must be valid JSON
* Envelope ID must be a UUID
* If `payload/files/` is present, `payload/files.json` is required
* If encryption metadata is present in `manifest.json.security`, decrypt logic must be available
* JWS signature is not required for acceptance, but may be stored and optionally verified