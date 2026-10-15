# RALLY-28 — shared projection and buffered road candidates

The isolated standard-VDP prototype/host proof and matched boost-off CPU comparison are delivered. Fine/buffered reduces CPU-only wall time by79% versus dense and26.5%fewer application command bytes; coarse/buffered saves41.2%of those bytes. All five live axes and the physics-service attempt stall inside submission, so completed-frame FPS/target physics service remain unqualified. Fresh stopped review profiles are staged but **not ready for normal motion review**. [Current results](RESULTS.md), [consumer/range evidence](RANGES-AND-COVERAGE.md), [rejected v4codegen correction](CODEGEN-DEFECT.md), [portable undeployed inputs](PORTABLE.md).

This is a deterministic fixture, not the installed game. All pseudo3D geometry stays on eZ80. Stock VDP2.16.0, MOS3.0.2, original product/native fixtures and SDK remain preserved. Previous measurement/audit and released contract were pushed as119edcd/c811998; new work is uncommitted for review.

## Variants and ownership

`dense`, `lookup`, `lookup-buffer`, `coarse`, `coarse-buffer` share900frames/3,600 scripted ticks and the complete Fuji presentation: traffic/signs/player, scrolling panorama, title/HUD/panel and engine changes. The latter four reuse the recovered LookupRoad coefficient evaluator/map-line cache plus shared on-demand centres, integer depth/edge tables, camera tangents, sign stations and finish subdivisions. Coarse deliberately changes subdivision/object alignment; up to28pixel differences remain for Author motion selection.

`projection.hpp`, `shared_scene.hpp` and `buffered.hpp` implement the candidate. Both emitters hoist band endpoint centres and row pointers. Buffered commands only copy final eZ80 vertices into resident PLOT templates; an independent interpreter proves identical primitive bytes for the same geometry. One frame outstanding and a completion fence protect parameter lifetimes.

Build copies live product source into ignored `.work/include`, replacing renderer wiring and an unused entry point. The normal physics `input()`/`tick()` bodies are preserved and the physics object is identical across variants. Placement initialization avoids unsupported target global constructors; empty CRT tables are checked. Removing duplicate unused game assets leaves heap for Fuji's116,800-byte coefficient table. Generated source snapshots are under `evidence/generated`; v5 binaries/build receipts are labelled separately from earlier versions; rejected shared v4 source is preserved under `generated-v4`. Dense v4/v5 executables are identical.

## Modes, clocks and files

`mode.txt`:0CPU-only opaque sink;1real MOS/UART submission and completion;2independent actual-game physics-service diagnostic for shared candidates. The rendered scene always follows the same four scripted ticks/frame. Mode2 runs a **separate** actual-physics world against the nominal MOS reference, services bounded chunks between UART writes/while waiting and drains retained debt before the next render. It is not integrated gameplay and does not select a120Hz cadence. Dense mode2 is outside qualification.

The synchronous writer uses MOS RST18 in chunks of at most64bytes, retaining exact protocol bytes and real CTS behavior. PRT send spans include CPU, UART and CTS waits. Construction contains those sends; do not add overlapping intervals. Per-frame geometry/construction/send/wait, MOS submission/return/callback and physics progress/debt are recorded. Seven stock bytes after swap flush drawing and request a key-zero callback. One frame is outstanding.

MOS/PRT rates are nominal and disagree substantially. v4 creates `started.txt` and `ended.txt` outside PRT timing; the host observes them with monotonic time and50ms polling. This approximate wall window includes small entry/teardown/file-witness overhead. Host total also includes setup/output and must not be called rendering time. No physical timing follows from these emulator runs.

Guest creates `summary.txt`, `frames.csv`, optional `state.csv`, then `done.txt`; CSV saves occur after timer/callback teardown. PRT reload/control/routing/prior vector and prior keyboard callback are restored on completed runs. Retain failed cases and use a **fresh directory per run** because create-new outputs intentionally refuse replacement. Run/profile identities and outputs are hashed.

## Reproduction

On the development checkout:

```bash
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/candidates/build.py
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/candidates/qualify_host.py
```

This uses tracked coefficient evidence, the existing AgonDev toolchain and repository capacity-fixture source. `qualify_host.py` runs both geometry/buffer models, all ten ordinary/ASan/UBSan full-scene serializers in fresh temporary directories and the independent partial-physics reference. `--targets-only` skips rebuilding unchanged host models.

Target profiles are prepared **on Oryx** after copying task source and matching `.work/{variant}/bin/candidate.bin`/`.work/data` inputs. `profile.py` uses the canonical setup helper, official stock firmware/MOS and hash-enforced copied Flexe binaries. `--adapter eof-fixed` selects accepted publicationbbd0343's108ec5b0… adapter; `--engine interp` selects its firmware interpreter. Use the same configuration for compared runs, run sequentially, and preserve old directories. Example with a fresh name:

```bash
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/candidates/profile.py rally28-lookup-buffer-next lookup-buffer --mode 1 --adapter eof-fixed --engine interp
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/candidates/run.py .emulator/rally28-lookup-buffer-next --timeout 420 --stall-seconds 60
```

Every unattended run **forces SDL_VIDEODRIVER=dummy and SDL_AUDIODRIVER=dummy**, requires/monitors Oryx CPU boost0, launches only the generated `./flexe-agon-emulator` and stops only its owned frontend. `stall_watch.py` is the final05 campaign's additional owned-profile inactivity watchdog. Never inherit real audio or run a visible window automatically. The final09campaign completed under one boot without suspension; all owned processes stopped and the Rally inhibitor released. Completed outputs are fsynced before success is printed. Fresh review profiles have been created/verified without launching; they are explicitly staged/unqualified. Their launcher refuses reused outputs/earlier traces and boost enabled before installing guest callbacks/timers. Headless tests remain separate from Author launch; no normal motion-review invitation is made while submission stalls remain.

Locally retrieve stopped profiles with `collect.py PROFILE VARIANT KIND`, then `verify.py --variant VARIANT --kind KIND`. The verifier checks complete setup/frame streams,900raw/delivered completions, state, timer/callback restoration, unchanged identities and backend errors, and creates a PNG from the captured framebuffer. It supports losslessly gzip-packed raw traces and falls back to tracked host census when ignored captures are absent. Reproduce the successful refined run with:

```bash
.venv/bin/python docs/tasks/RALLY-28/standard-vdp/candidates/verify.py --variant lookup-buffer --kind live-v3-interp
```

Versions: v1 exploratory; v2 endpoint/debt refinement; v3 bounded sender/service hook; v4 independent host witnesses (shared variants rejected for a generated comparison error); v5 corrected panorama call. `batch.py`/`batch_final.py` preserve the historical01/02 workflows; `batch_wall.py` records05, `batch_resume.py`06, and `batch_qualified.py`07, `batch_finish.py`08 and `batch_boostoff.py`the final09campaign. Their fixed names are consumed, so do not rerun them blindly. Runner also records host boot identity/suspension, rejects reused output directories and watches actual UART progress. Host-derived FPS is withheld when suspension exceeds100ms or continuity data is missing; raw correctness checks remain separate. Final wall comparison, target physics-service proof, human motion acceptance and product/scheduler integration remain open; see RESULTS.md before proceeding.

Failure analysis: `check_failure.py VARIANT KIND` checks the exact submitted prefix, complete request/reply counts and partial next-frame offset without presenting failed-window FPS. Successful `verify.py` retains full900-frame/state/clock/identity checks. `package.py` reproduces the deterministic portable archive and per-input manifest. Final source/binaries remain uncommitted for Author review; no additional heavy compile was needed in the boost-off resumption.

`physics_clock.py --name rally28-physics-clock-next` reuses the unchanged8,192-step actual-physics binary and observes its existing UART start/end markers through the common silent runner; no guest rebuild or new timed traffic. The saved exact binary is under `evidence/physics-wall-boostoff`; the earlier stopped baseline is a fallback. `verify_physics_clock.py` checks all420actual final fields, UART isolation, restored timer and independent host interval without assuming a MOS frequency. This result is334.69steps/s isolated, not integrated120Hzqualification.
