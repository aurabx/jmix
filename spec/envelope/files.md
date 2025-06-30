# The files Directory

A directory of other files, including a report, other imaging types (e.g. JPG, NIFTI etc), or related files. All files in the files directory MUST be listed in the files.json file (unlike the studies directory).

## The files.json file

The files.json file is an optional file that contains a list of files in the studies and files directories.

Its use for the dicom directory is optional. It is assumed that the DICOM files in the dicom directory will eventually be parsed as-is, so the presence of file information in the files.json file is purely for validation purposes.

However, if the payload contains a files directory that is not empty, it MUST provide references in the manifest to files in this directory.
Each entry should have the same three keys, though the second two are optional.

## Properties

| Name       | Flags | Cardinality | Notes                                                    |
|------------|-------|--------------|----------------------------------------------------------|
| file       | S, R  | 1..1         | The path to the file in the payload, from the `/payload` root. |
| hash       | S, O  | 0..1         | The SHA-256 hash of the file.                           |
| size_bytes | S, O  | 0..1         | The file size in bytes.                                 |

**Legend**

- S: String  
- R: Required  
- O: Optional  

