# JMIX Endpoint API

This API enables upload and retrieval of complete JMIX envelopes, with strict conformance to the JMIX structure and semantics.

---
## Media Type

All responses and uploads **must support** the following content types via[ HTTP content negotiation](https://developer.mozilla.org/en-US/docs/Web/HTTP/Content_negotiation):

* `application/zip`

---

## GET Envelope

### 1a. Basic GET request

**Endpoint**: 
```
GET /api/jmix/{id}
```

You may also specify the studyInstanceUid query parameter to retrieve a specific study.

```
GET /api/jmix?studyInstanceUid=xxx
```

Other query parameters may be supported by the endpoint, but are not part of the specification.

**Description**: \
Retrieve a full JMIX envelope by its envelope UUID.

**Path Parameter**:

* `id`: The `id` of the JMIX envelope as specified in `manifest.json`.

**Responses**:

* `200 OK`: \
  Returns a packaged JMIX envelope in the requested format (zip).

The archive contains a JMIX envelope as defined in the JMIX specification

* `406 Not Acceptable`: \
  Returned if the `Accept` header requests an unsupported media type.
* `404 Not Found`: \
  Returned if the envelope or associated study is not found.

### 1b. GET manifest

```
GET /api/jmix/{id}/manifest
```

Retrieve a JMIX manifest by its envelope UUID. This allows retrieving the transport information without requiring the entire data package.

**Path Parameter**

* `id`: The `manifest.json.id` of the JMIX envelope

**Response**

`200 OK`: Returns a json manifest in JSON format.

---
## 2. POST Envelope

**Endpoint**: \
```
POST /api/jmix
```

**Description**: \
Store a new JMIX envelope uploaded as a single archive file.

**Headers**

* `Content-Type`: Required. Specifies the archive format used in the request body. \
  Supported values:
    * `application/zip` → for `.zip` archive
    * `application/gzip` → for `.tar.gz` archive

**Body**

The request body must contain a `.zip` or `.tar.gz` archive representing a full JMIX envelope directory.

The archive must:

* Contain a valid JMIX envelope structure.
* Include a top-level `manifest.json` file.
* Use the `manifest.json.id` value as the authoritative envelope ID.

**Responses**

`201 Created` The envelope was accepted and stored successfully.

**Example JSON response:**

* `400 Bad Request` \
Returned if:
    * The archive is malformed or unreadable.
    * `manifest.json` is missing or invalid.
    * Required JMIX validation fails.
* `409 Conflict` \
Returned if an envelope with the same `id` already exists and cannot be overwritten.

### Envelope Validation Rules (must enforce)

* `manifest.json` must be present and parseable
* `payload/metadata.json` must be valid JSON
* Envelope ID must be a UUID
* If `payload/files/` is present, `payload/files.json` is required
* If encryption metadata is present in `manifest.json.security`, decrypt logic must be available
* JWS signature is not required for acceptance, but may be stored and optionally verified

---
## 3. Prime envelope

**Endpoint**: \
```
GET /api/jmix/prime/<studyInstanceUid>
```

**Description**: \
Build a new JMIX envelope from a DICOM study. Returns only success or failure.

**Responses**

`201 Created` The study was found and was successfully primed.
`404 Not Found` The study was not found.
`500 Internal Server Error` An error occurred while priming the study.