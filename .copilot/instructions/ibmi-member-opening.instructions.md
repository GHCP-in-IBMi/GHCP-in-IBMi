---
description: "Use when opening an IBM i source member in VS Code, including identifying its source type and invoking open-ibmi-member.ps1."
---

# Opening IBM i source members

- Use only `<USERPROFILE>\scripts\open-ibmi-member.ps1` to open an IBM i member.
- Make sure the library, source file, and member are known. Ask the user for any missing values; do not guess them.
- Retrieve the member's type by querying `QSYS2.SYSMEMBERSTAT` with `vscode-db2i-chat-sqlRunnerTool`. Use the returned type rather than inferring it from a filename or source file.
- Invoke the script from PowerShell using either form:

  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\scripts\open-ibmi-member.ps1" LIB/SRCF/MBR -Type TYPE
  ```

  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\scripts\open-ibmi-member.ps1" -Library LIB -SourceFile SRCF -Member MBR -Type TYPE
  ```

- Replace `LIB`, `SRCF`, `MBR`, and `TYPE` with the verified values. Do not open the member through a direct URI or another method.