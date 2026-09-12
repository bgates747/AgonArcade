# Radiotux file-transfer reconnaissance — 2026-09-12

Read-only repository/source investigation requested by the Author. RALLY-20
implementation remains paused. No builds, servers, hardware tests or firmware
changes were performed. Findings below are static inspection, not qualification.

## Repository inventory

GitHub's public repository list returned two repositories (second page empty):

- https://github.com/Radiotux/Agon-Software — the relevant work; main branch,
  commit `e265db1de57c49142420324945c666049dc1ec53`.
- https://github.com/Radiotux/Agon-Tools — main branch contains only LICENSE;
  no file-transfer implementation found there.

Agon-Software's local clone `/home/smith/Agon/Radiotux` is clean and already
matches remote main exactly. No duplicate clone or update was necessary.
The queried Agon-Software pull-request list was empty. This inventory does not
establish what exists in private repositories or unpublished local development.
The GET documentation identifies its author as `@rafd_electrotux`.

## Relevant implementations

### GET v2.2: PC to mainboard SD using ESP-AT

Read `get/README.TXT`, `get/src/get.c`, `get/agon_server.py`.
The Agon opens UART at 115200 and drives a separate ESP-AT Wi-Fi modem.
The PC runs a bespoke port-2000 server with a filename/size catalogue. The Agon
downloads a chosen file and writes it using foreground `fopen`/`fwrite`/`fclose`.
The server advances through 32768-byte chunks on successive connections;
the client buffers reception before writing SD data. This is an interesting
way to avoid receiving continuously while SD writes stall a receiver without
RTS/CTS. Documentation claims roughly 1.1–2.0 KB/s; not measured here.

It is an interactive pull/download tool, not a remotely accessible mainboard
filesystem service. No upload, directory mutation RPC, keyboard multiplexing,
durable activation or unattended recovery protocol was found in this path.

Static concerns before reuse:

- Server sessions use client IP and implicit offset, advanced before confirmed
  delivery. No explicit client chunk offset or post-write acknowledgement;
  retry after loss can skip data. Not an idempotent resume protocol.
- Client write counts and close results are not checked in the inspected
  download path. There is no end-to-end digest/readback verification.
- Header stripping and +IPD payload parsing interact awkwardly: the parser
  starts searching for a new +IPD marker after moving past HTTP headers inside
  the first payload. This deserves a binary fixture test before any claim of
  arbitrary-byte correctness; the README's 'bit-perfect' claim is not evidence.
- Busy-loop waits are not elapsed-time deadlines. Destination is opened with
  `wb` before successful transfer; no preserved old version/activation scheme.

### ZGET v1.2: PC to mainboard SD using Zimodem

Read `zget/Zget-Firmware.md`, `zget/The README (How to use Agon Zget)`,
`zget/src/zget.c`, `zget/agon_server.py`.
Uses ESP-01S/Zimodem 4.0.2 at 115200, `AT&G`, and a conventional Python HTTP
server on port 8080. Again this is Agon-initiated downloading to SD.

The receive code waits indefinitely for a metadata delimiter, then skips bytes
until a value greater than 32 appears. Consequently it cannot preserve arbitrary
leading binary bytes. It also prints 'OK' after the bounded receive loop without
requiring the expected total, and does not check `fwrite`/`fclose` success.
Do not use this unchanged for game binaries or describe it as integrity-verified.

### MINICOM: bidirectional serial file transfer

Read `minicom/src/{main,terminal,xmodem,ymodem}.c` and associated headers.
Contains send and receive paths using MOS file I/O, CRC/checksum, ACK/NAK and
retry machinery. This is the closest donor for bidirectional block-transfer
ideas. It is still an interactive terminal with direct UART ownership, not an
EMOS-multiplexed service.

Static concerns: XMODEM rejects a repeated prior block rather than handling a
lost ACK idempotently; its receive write result is unchecked. YMODEM acknowledges
a decoded block before its caller checks sequence or writes the file, and the
caller writes whole blocks without trimming the final one to advertised length.
Those acknowledgements do not prove durable or exact file storage. No runtime
interoperability claim is made here.

## Consequences for RALLY-20

The code supports the architectural direction: an eZ80 foreground program can
translate received data into mainboard SD file operations. It does not establish
that the existing EMOS hooks can carry the required bulk traffic. Its direct
`mos_uopen`/`mos_uputc`/`mos_ugetc_nb` ownership assumptions conflict with our
Extender keyboard path and must not be copied into a live bench application.

R20-02 still needs an owned, versioned transport contract first: explicit
transfer IDs/offsets, credit/backpressure, input coexistence, integrity checks,
bounded timeouts and acknowledgements with defined persistence semantics.
Consider receive-then-write chunks and standard block-transfer concepts as
donors; do not adopt these implementations as a qualified protocol stack.

GET explicitly declares GPL-3.0 in its source/manual; the repository-level
README's general 'Free Software' language is not a precise license grant for
every file. Record per-file licensing before copying code. Reading techniques
and documenting independent requirements does not require importing source.

This investigation found no separate public Radiotux network SD-share/server
repository. The relevant utilities were already cloned at the requested local
location. No changes were made to that upstream/reference checkout.
