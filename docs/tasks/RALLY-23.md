# RALLY-23 — Batched C simulation and learned driving on the Pi

Status: Deferred to next week by the Author, 2026-09-13. Task registration only;
do not begin implementation as part of tonight's driving/full-game work.

## Requested outcome

Build a genuine machine-learning driving application around a headless C port
of the game's simulation. Run thousands of independent simulation instances
on the Pi in batches and learn a policy rather than hand-writing another
feedback controller. Thousands of environments is a population/throughput goal,
not an assumption of thousands of simultaneously executing CPU threads.

## Future work

1. Separate deterministic physics, traffic, race rules and contact observations
   from graphics, audio, MOS, VDP, networking and real-time waits. Port the needed
   core to C; preserve explicit widths, rounding, overflow behavior and the
   original physics/steering update boundaries.
2. Expose bounded reset/step/observation/reward/termination APIs for independent
   environments, seeds and tracks. Use batched state storage and an appropriate
   worker/vectorization strategy for the actual Pi. Measure environments per
   second, memory and reproducibility before choosing training scale.
3. Prove state-by-state agreement against the maintained game and retained
   telemetry. Model render-dependent held-key steering, input/observation delay,
   telemetry availability, grip and road/kerb/grass behavior explicitly. A faster
   simulation must not silently produce a different driving task.
4. Define training rewards and validation that favor clean completed laps and
   legal passes, exposing contacts, off-road excursions and stalled/unsafe policy
   behavior. Split training/held-out tracks, traffic configurations and grip
   levels; retain seeds, learning curves, checkpoints and evaluation telemetry.
5. Train an actual learned policy, with the existing hand-built controller as a
   measured baseline. Choose the training method/framework when work starts;
   this intake does not claim one is selected or installed on the Pi.
6. Restrict transferable policy observations/actions to the real telemetry and
   ordinary controls. Test trained policies headlessly, then on physical Agon
   with bounded runs, stale-input release and physical keyboard takeover intact.

## Boundaries

This is separate from RALLY-21's offline deterministic opponent-route generator
and tonight's BENCH-001 controller tuning. Preserve those artifacts as baselines.
The Pi currently owns hardware reset and bench tools; establish resource/isolation
requirements before consuming its CPU/RAM with training. No Pi workload,
installation, firmware change or training run is authorized by this intake alone.
