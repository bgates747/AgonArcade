# Accepted pre-Golem production deployment

This evidence records the 2026-09-12 deployment of the stripped production
binary `e14e5c0f155a4f035e925b1da5971e8f7202fe47c7147e24a5726ef937d4fe5f`.
The Author subsequently confirmed playable hardware behavior and authorized
freezing the source, helpers and evidence. Pending-review fields in original
JSON records are deployment-time observations, not current acceptance status.
No sustained physical frame rate is claimed.

The maintained standalone source snapshot is now `rally-production/` at the
repository root. Its rebuild matches the deployed binary byte for byte.
The original build/deploy helpers are one-shot historical procedures with
specific paths and fail-closed preconditions, not general deployment commands.
Do not rerun them to recreate this already completed deployment.

Ignored logs, local firmware backups and generated profiles remain on this
machine. Root `.work/stock-vdp-2.16.0/` includes the original full flash backup
and official release artifacts; task `.work/` contains the build/card backup.
These are retained locally, not included in this evidence commit.
