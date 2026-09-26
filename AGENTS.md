# Repository agent guide

## Repository workflow and completion

This Node 18+ repository combines token launches, generated assets, social posting, page deployment, and monitoring. No lockfile is tracked. Read selected scripts before invoking package commands: pre-flight, generate-assets, deploy-token, post-tweets, deploy-page, monitor, and autonomous-launch have operational effects. The test script only prints a message and exits successfully; it is not coverage.

Use `node --check` for changed JavaScript and `bash -n` for shell, then synthetic pure-logic fixtures where possible. Preflight/autonomous runs are not harmless unit tests. Token transactions, provider spending, messages, and publication require explicit authorization for their effects. Keep wallets/credentials out of source and logs.

Continue the authorized change through relevant validation and repair of failures it causes; preserve unrelated work. Report checks actually run, commands only inspected, and exact missing prerequisites. Ask only when a material decision, missing authorization, or required input blocks progress; continue independent reversible work. Existing mandatory contribution and validation gates still apply.
