# The Payload

The payload contains all the actual medical data being transported in this envelope. The payload can be sent “as is”, especially if the connection is internal or via some other secure channel, however it is designed to be sent encrypted. When encrypted, the corresponding `encryption` block should be present in the manifest.

## The Metadata File

This JSON file captures high-level metadata for routing, indexing, and search.

### Example

```
{
   "version":"1.0",
   "id":"6f57f5fa-1cd1-45be-a5c3-fb209be1e0ec",
   "timestamp":"2025-05-24T06:14:00Z",
   "patient":{
      "id":"urn:uuid:a3e9be77-45b0-4eeb-a3db-9182e6b7ea2f",
      "name": {
      "family":"Doe",
      "given":[
         "Jane"
      ],
      "prefix":"Ms",
      "suffix":"",
      "text":"Jane Doe"
   },
      "dob":"1975-02-14",
      "sex":"F",
      "identifiers":[
         {
            "system":"http://ns.electronichealth.net.au/id/ihi/1.0",
            "value":"8003608166690503"
         },
         {
            "system":"urn:oid:1.2.36.146.595.217.0.1",
            "value":"MRN123456"
         }
      ],
      "verification":{
         "verified_by":"myhealthid.au",
         "verified_on":"2025-05-22"
      }
   },
   "report":{
      "file":"files/report.pdf",
   },
   "studies":{
      "study_description":"CT Chest, Abdomen & Pelvis",
      "study_uid":"1.2.840.113619.2.312.4120.7934893.202505221200",
      "series":[
         {
            "series_uid":"1.2.3.4.5.6.789",
            "body_part":"Chest",
            "modality":"CT",
            "instance_count":120
         }
      ]
   },
   "extensions":{}
}

```

The specification includes a number of fields where all elements are optional. If a field is provided with no elements, then it should be ignored by the handling system.

### Properties

| Name       | Flags | Cardinality | Notes                                                                                                                                 |
|------------|-------|--------------|---------------------------------------------------------------------------------------------------------------------------------------|
| version    | S, R  | 1..1         | JMIX specification version.                                                                                                          |
| id         | S, R  | 1..1         | Unique identifier for the envelope (UUID).                                                                                           |
| timestamp  | S, R  | 1..1         | ISO 8601 timestamp (UTC) of envelope creation.                                                                                       |
| patient    | E, R  | 1..1         | Describes the patient (identified or pseudonymised). May contain verification metadata to ensure validated linkage.                  |
| report     | E     | 0..1         | Structured reference to external report artefact.                                                                                    |
| studies    | E     | 0..1         | Study and series-level DICOM metadata.                                                                                               |
| extensions | E     | 0..1         | Non-standard custom extension metadata.                                                                                              |

- S: String  
- R: Required  
- E: Element  

#### patient properties

| Name         | Flags | Cardinality | Notes                                                                                                                                                                   |
|--------------|-------|--------------|-------------------------------------------------------------------------------------------------------------------------------------------------------------------------|
| id           | S, R  | 1..1         | Unique patient identifier (URN or UUID).                                                                                                                                |
| name         | E     | 0..1         | All elements are optional. Where a given element exists, its usage should match [FHIR HumanName](https://build.fhir.org/datatypes.html#HumanName).<br>Available keys:<br>- `family`: string<br>- `given`: string<br>- `prefix`: string<br>- `suffix`: string<br>- `text`: string |
| dob          | S     | 0..1         | A date of birth in the format `YYYY-MM-DD` (the DICOM date format).                                                                                                    |
| sex          | S     | 0..1         | The sex as expressed in the DICOM data, expressed as either `M`, `F` or `O` as per the DICOM spec.                                                                     |
| identifiers  | L[E]  | 0..n         | An array of identifiers. Each identifier must specify the relevant system it belongs to (`urn`) and a value. See *Identifier Properties*.                              |
| verification | E     | 0..1         | Optional metadata about how the identity was verified. See *Verification properties*.                                                                                   |

**Legend**

- S: String  
- R: Required  
- E: Element  
- L: List  

#### identifier properties

| Name   | Flags | Cardinality | Notes                                                                                                                                        |
|--------|-------|--------------|----------------------------------------------------------------------------------------------------------------------------------------------|
| system | S, R  | 1..1         | URI of the identifier system (e.g. IHI OID).<br><br>**Options:**<br><br>**Option 1: URL**<br>Use a system URL when:<br>- The identifier is part of a national, regional, or organisational registry<br>- The namespace is public and reasonably stable<br>- Interoperability is a goal<br>Example:<br>`"system": "https://aurabox.cloud/id/patient-mrn"`<br><br>**Option 2: `urn:ietf:rfc:3986` + OID**<br>Formal option using OIDs for local namespaces. Indicates the identifier is local to the organisation that owns the OID.<br>Example:<br>`"system": "urn:oid:1.2.36.1.2001.1003.0.8003620833333789"`<br><br>**Option 3: `urn:uuid:<your-org-id>`**<br>Valid if your system issues UUIDs locally. Usually only suitable for internal use.<br>Example:<br>`"system": "urn:uuid:3fa85f64-5717-4562-b3fc-2c963f66afa6"`<br><br>**Option 4: `urn:local:<system-name>`**<br>For intra-organisation systems, use a local URN.<br>Example:<br>`"system": "urn:local:hospital-mrn"`<br>You can also scope further:<br>`"system": "urn:local:example-hospital:department-id"` |
| value  | S, R  | 1..1         | Patient identifier value in the given system.                                                                                               |

**Legend**

- S: String  
- R: Required  

#### verification properties

| Name        | Flags | Cardinality | Notes                                                             |
|-------------|-------|--------------|-------------------------------------------------------------------|
| verified_by | S, R  | 0..1         | Source asserting identity (e.g. `"myhealthid.au"`).              |
| verified_on | S, R  | 0..1         | Date verification was performed (ISO 8601 format).               |

**Legend**

- S: String  
- R: Required  

#### report properties

This element describes the location of the report within the bundle. Reports stored in SR format are not required to be listed here.

| Name | Flags | Cardinality | Notes                                         |
|------|-------|--------------|-----------------------------------------------|
| file | S     | 0..1         | Relative path to the file within the bundle. |

**Legend**

- S: String  

#### studies properties

Describes any attached studies in the dicom directory. The contents of the dicom directory is assumed to be canonical, so this information should not be used to validate that data.

| Name              | Flags | Cardinality | Notes                                                |
|-------------------|-------|--------------|------------------------------------------------------|
| study_description | S     | 0..1         | The study description as taken from the first series. |
| study_uid         | S     | 0..1         | DICOM Study Instance UID.                            |
| series            | L     | 0..n         | Series metadata within the study.                    |

**Legend**

- S: String  
- L: List  

#### series properties

An optional array of series information. If provided, every series should be listed. A series may include any DICOM metadata present in the source, with the human readable name converted to snake_case.

The series element also supports an instance_count. Where this value differs from the actually provided instances or the values in manifest.json, it is up to the receiver to determine how to handle it. The security.instances hash is another way to resolve this.

| Name           | Flags | Cardinality | Notes                                                                 |
|----------------|-------|--------------|-----------------------------------------------------------------------|
| series_uid     | S, R  | 1..1         | DICOM Series Instance UID.                                            |
| modality       | S, R  | 1..1         | The modality.                                                         |
| body_part      | S     | 0..1         | Body part examined in the series.                                     |
| instance_count | S     | 0..1         | Number of SOP Instances in the series.                                |
| *other values* |       |              | While other values can be provided, there is no requirement for the receiving system to process them. They should be discarded without failing. |

**Legend**

- S: String  
- R: Required  

#### extensions properties

Defines userland or other extensions to the base. There is no requirement for the receiving system to know how to process these. The following keys are reserved:


| Name        | Flags | Cardinality | Notes                                                         |
|-------------|-------|--------------|---------------------------------------------------------------|
| custom_tags | E     | 0..n         | User-defined tags (e.g. `"teaching"`, etc).                   |
| consent     | E     | 0..n         | A consent definition.                                         |
| deid        | E     | 0..n         | Information about what information is redacted.               |

**Legend**

- E: Element  

##### consent extension (draft)

Describes whether consent is present and what scope it covers.

| Name     | Flags | Cardinality | Notes                                                                 |
|----------|-------|--------------|-----------------------------------------------------------------------|
| status   | S, R  | 1..1         | Consent state.<br>**Allowed values:** `granted`, `denied`, `unknown`. |
| scope    | S     | 0..n         | Permitted use cases (e.g. `"treatment"`, `"research"`). See below.   |
| method   | S     | 0..1         | Consent mechanism (e.g. `"digital-signature"`).                      |
| signed_on| S     | 0..1         | Timestamp of consent capture (ISO 8601 format).                      |

**Legend**

- S: String  
- R: Required  

Scope supports a limited list of options that can be mapped back to other coding systems as required.

| Internal Code | Display         | Mapped ActReason |
|----------------|-----------------|-------------------|
| treatment      | Clinical Care   | TREAT             |
| research       | Research        | HRESCH            |
| emergency      | Emergency Use   | ETREAT            |
| operations     | QA or Audit     | HOPERAT           |
| patient        | Patient Access  | PATRQT            |

##### deid extension

Supports a single optional key, keys, identifying which elements have been de-identified or redacted.

| Name | Flags | Cardinality | Notes                                               |
|------|-------|--------------|-----------------------------------------------------|
| keys | L, R  | 0..n         | DICOM tags removed or masked during export.        |

**Legend**

- L: List  
- R: Required  
