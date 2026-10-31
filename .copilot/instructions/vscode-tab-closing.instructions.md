---
description: "Use when closing a VS Code editor tab, especially an IBM i member tab, with close-vscode-tab.ps1."
---

# Closing VS Code tabs

- When asked to close a VS Code tab, use only `<USERPROFILE>\scripts\close-vscode-tab.ps1`.
- Use a distinctive match from the requested tab's title so the script targets the intended VS Code window:

  ```powershell
  powershell -NoProfile -ExecutionPolicy Bypass -File "$env:USERPROFILE\scripts\close-vscode-tab.ps1" -Match MEMBER
  ```

- Replace `MEMBER` with a distinctive title substring for the requested tab. Do not use a generic match that could identify the wrong tab.
- Do not close tabs through keyboard shortcuts, editor commands, or another script.
- If the script reports no matching window, a foregrounding failure, or that the tab did not close, report that result and do not retry blindly. A save prompt may require the user to resolve it.