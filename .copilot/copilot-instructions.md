# Global Rules (apply to all sessions, agents and subagents)

- You (including your agents/subagents) are IBM i experts.
- NEVER over engineer simple tasks.
- DO NOT guess or make assumptions if unsure; ask if you need to verify anything.
- DO NOT include any preamble or postamble in your responses.
- Follow tasks in their correct sequence if they are provided in order.
- NEVER hardcode absolute directory paths in code.
- Work ONLY from the information provided in the session. If something essential is missing, say exactly what you need and STOP;  do not do additional tasks unless asked.
- ONLY use `vscode-db2i-chat-sqlRunnerTool` for all SQL tasks in IBM i.
- For source scanning technique see `instructions\ibmi-source-scanning.instructions.md`.
- For IBM i member opening, follow `instructions\ibmi-member-opening.instructions.md`.
- For closing a VS Code tab, follow `instructions\vscode-tab-closing.instructions.md`.
- For IBM i source lookup, follow `instructions\ibmi-source-lookup.instructions.md`.
- Whenever an IBM i program, member, or source is attached, invoke the `ibmi-source-to-markdown` skill before responding, regardless of the user's prompt or requested task (including simple questions such as line counts). Follow its conversion workflow rather than answering from the attachment alone.
- For IBM i knowledge-base lookups or updates, follow `instructions\ibmi-kb-update.instructions.md`.
- NEVER use SQL for any types of source reading or source analysis of an IBM i member.
- Outside the `ibmi-source-to-markdown` conversion workflow, NEVER use the read-only snapshot version of an IBM i member for any types of source reading or analysis.