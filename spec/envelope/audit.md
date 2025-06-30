# The audit file

The `audit.json` file is an optional but recommended component of a JMIX envelope. It records the actual movement of an envelope through healthcare systems and services by maintaining a verifiable, append-only audit trail of audit events.

Unlike manifest.json, which is immutable and signed by the originator, audit.json is mutable, designed to capture real-world transit steps such as when the package was sent, forwarded, or received, and by whom.
Each audit step may be optionally signed by the responsible party, providing a chain-of-custody mechanism without invalidating the original envelope.

## Semantics and Behaviour

- `audit` is append-only. Existing entries must never be modified or deleted.
- `created` should always be the first entry.
- `sent`, `forwarded`, `received`, etc. should be added by compliant systems or proxies as the envelope moves.
- Systems may optionally require that all non-local steps include valid assertion blocks to prove authenticity.
- There is no requirement to include audit at all unless the audit chain is being tracked.


## Example

```
{
  "audit": [
    {
      "event": "created",
      "by": {
        "id": "org:clinic-a",
        "name": "Radiology Clinic A"
      },
      "timestamp": "2025-06-01T10:00:00Z"
    },
    {
      "event": "sent",
      "to": {
        "id": "org:runbeam.edge.01",
        "name": "Runbeam Relay Node"
      },
      "timestamp": "2025-06-01T10:02:00Z",
      "assertion": {
        "signing_key": {
          "alg": "Ed25519",
          "public_key": "<base64>",
          "fingerprint": "SHA256:abcd..."
        },
        "signature": "<base64sig>",
        "signed_fields": [
          "event",
          "to.id",
          "timestamp"
        ]
      }
    }
  ]
}
```

## Properties

| Name   | Flags   | Cardinality | Notes                                                                                   |
|--------|---------|-------------|-----------------------------------------------------------------------------------------|
| `audit`| R, L[E] | 0..1         | An ordered, append-only list of audit steps representing actual events performed on the envelope. |

- **R**: Required  
- **L**: List  
- **E**: Element

### `audit` Entry Structure

Each audit entry represents a single, append-only event in the envelope lifecycle.

| Name        | Flags | Cardinality | Notes                                                                                                                                           |
|-------------|-------|-------------|-------------------------------------------------------------------------------------------------------------------------------------------------|
| `event`     | S, R  | 1..1         | The action taken, such as:<br>- `"created"`<br>- `"sent"`<br>- `"forwarded"`<br>- `"received"`<br>- `"stored"`                                  |
| `by`        | E     | 1..1         | The entity (person, system, or organisation) performing the action.                                                                             |
| `to`        | E     | 0..1         | The recipient entity of the package.                                                                                                            |
| `timestamp` | S, R  | 1..1         | ISO 8601 formatted timestamp (UTC) indicating when the action occurred.                                                                         |
| `assertion` | E     | 0..1         | A signed proof by the responsible party asserting the authenticity of this step. Follows the [Entity Assertions](#entity-assertions-optional-but-recommended) structure. |

- **S**: String  
- **E**: Element  
- **R**: Required  

