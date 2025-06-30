# The dicom directory

Directory of raw, unmodified DICOM files. It is assumed that the files in this directory are the complete set of imaging required for this payload, however no guarantees are made about completeness.

If the files.json file (see below) is present and specifies files in this directory, this can be used to validate the set, however the result of a mismatch is up to the receiving system. Since this is just a file format and not a protocol, there is no inherent mechanism to reject in the case of a mismatch.