---
name: ibmi-source-to-markdown
description: "Use when an IBM i program, source member, or source snapshot (RPGLE, SQLRPGLE, CLLE, CLP, DDS, PF, LF, DSPF, PRTF, SQL, or COBOL) is attached."
---

# Convert IBM i source to Markdown

Convert the attached IBM i program, source member, source snapshot into a plain Markdown file in the corresponding dedicated source-file folder under `<USERPROFILE>\docs\ibmi\`, named `<MBR>.<TYPE>.md` (for example, `<SRCF>\<MBR>.<TYPE>.md`).

## Procedure

1. Confirm the snapshot and destination can be identified from the provided context. If the member name, source file, type, or destination folder is unclear, ask the user before writing; do not guess.
2. Read the attached snapshot. Retain its exact lines in working context; do not reopen or reread it.
3. Generate the Markdown file as raw source lines, with no prose, labels, code fences, or other wrapper text. Remove blank lines and lines that consist only of comments according to the identified source language. Preserve all remaining lines exactly and in their original order, including indentation, and spacing. If the language or comment syntax is uncertain, ask before removing any lines.
4. Write the output to the identified destination. Overwrite an existing output only as part of this requested conversion.
5. Read the written Markdown file back and count its lines. If it contains zero lines, remove the converted file from the target location and report failure, stating that the output contained zero lines and was removed. Do not proceed as if conversion succeeded.
6. For a non-empty output, verify it is readable and has no accidental wrapper text, such as code fences or explanatory prose.
7. Compare the read-back lines against the snapshot's executable lines after only the permitted blank-line and comment-only-line removal. Require an exact, ordered, line-for-line match; do not normalize whitespace, alter executable content.
8. Pass the retained snapshot lines, generated/read-back Markdown lines, destination, and validation results to a higher-capability model for independent review of the conversion and checks. If such a reviewer is unavailable, or either the reviewer or any validation check cannot confirm success, report failure and identify the specific failed or unverified check.
9. Report success only when every validation check passes and the independent review confirms the exact match. Otherwise, report failure and the specific check(s) that failed.