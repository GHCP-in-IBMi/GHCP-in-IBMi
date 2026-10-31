---
name: ibmi-source-scanning
description: "Use when reading, scanning, or grepping IBM i source members via SQL (QSYS2.IFS_READ), scanning all members of a source file, or interpreting DDS column positions."
---

# IBM i Source Scanning via SQL

Run all SQL through `vscode-db2i-chat-sqlRunnerTool`.

## Read a source member as rows

```sql
SELECT LINE_NUMBER, LINE
FROM TABLE(QSYS2.IFS_READ(
     PATH_NAME=>'/QSYS.LIB/<LIB>.LIB/<SRCFILE>.FILE/<MBR>.MBR',
     END_OF_LINE=>'LF', MAXIMUM_LINE_LENGTH=>240, IGNORE_ERRORS=>'YES'))
```

- All three named parameters matter.
- `IFS_READ_UTF8` is forbidden: it silently truncates (e.g. ACT605RI returned 2 of 1,442 lines).
- `IFS_READ_BINARY` is also wrong (601 of 1,442 lines).
- Sanity-check any scan against `QSYS2.SYSPARTITIONSTAT.NUMBER_ROWS` per member.
- Works on QCLSRC, QRPGLESRC, QDDSSRC, QSQLSRC, etc. LINE is the raw SRCDTA (position 1 = source column 1).

## Scan all members of a source file in one query

```sql
FROM (SELECT SYSTEM_TABLE_MEMBER MEMBER FROM QSYS2.SYSPARTITIONSTAT
      WHERE SYSTEM_TABLE_SCHEMA='<LIB>' AND SYSTEM_TABLE_NAME='<SRCFILE>'
        AND SYSTEM_TABLE_MEMBER LIKE '<PREFIX>%') m,
LATERAL (SELECT LINE_NUMBER, LINE FROM TABLE(QSYS2.IFS_READ(
     PATH_NAME=>'/QSYS.LIB/<LIB>.LIB/<SRCFILE>.FILE/'||RTRIM(m.MEMBER)||'.MBR',
     END_OF_LINE=>'LF', MAXIMUM_LINE_LENGTH=>240, IGNORE_ERRORS=>'YES'))) s
```

- Aggregate per member with `LISTAGG(...) WITHIN GROUP`; use `REGEXP_INSTR` for word-boundary matches.

## DDS column layout in an IFS_READ line

- For traditional fixed-format DDS source, positions are counted from the start of the raw `LINE` returned by `IFS_READ` (position 1 = source column 1). Position 6 is the form-type position (commonly `A`); `*` in position 7 comments out the line; position 17 identifies the entry type (`R` denotes a record format); positions 19-28 contain the name.
- Apply this layout only to fixed-format DDS source, not to RPG/SQL source, free-format syntax, or arbitrary IFS content. For DDS fields, use `TEXT('...')` and `COLHDG('...')` where present to understand field meaning.