# What the post-swap reply proves

For this mode136 fixture, the checked native READ16 after stock `VDU23,0,&C3`
fences completed raster work and the display-page exchange. It is stronger than
command submission or renderer-helper readiness. It does not acknowledge an
entire physical scanout or presentation by the emulator's host window.

The pinned source provides this ordered chain:

1. Mode136 selects `changeResolution(64, QVGA_320x240_60Hz, true)` in
   `video/agon_screen.h:401`, explicitly enabling double buffering.
2. `video/vdu_sys.h` dispatches C3 directly to `switchBuffer()`.
   `agon_screen.h:484` calls `canvas->swapBuffers()` in a double-buffered mode.
3. `Canvas::swapBuffers()` in `src/canvas.cpp:647` submits a `SwapBuffers`
   primitive carrying the current task handle, then waits for primitive execution.
4. More decisively, `BitmappedDisplayController::addPrimitive()` in
   `src/displaycontroller.cpp:525` queues that swap and, when double buffered,
   blocks in `ulTaskNotifyTake(true, portMAX_DELAY)`. Normal non-swap drawing
   primitives in this mode instead call `execPrimitive()` synchronously.
5. The swap executor at `displaycontroller.cpp:927` calls the controller's
   `swapBuffers()` before notifying the waiting task. `VGABaseController` exchanges
   drawing/visible viewport pointers, with the paletted controller updating its
   scanline pointers. Its primitive task is released by the VGA vertical-sync
   path. The caller cannot continue merely because the command was parsed.
6. Only after the swap call returns can the same VDU stream parse the following
   native query and emit its VDPL reply. The native READ16 handler itself just
   reads two buffer bytes; it is not an independent Canvas flush operation.

`primitivesExecutionWait()` alone tests queue occupancy, which should not be
misrepresented as a general proof that an already dequeued primitive has finished.
The explicit double-buffered swap task notification supplies the decisive
completion guarantee here.

The firmware is pinned to binary SHA256 `8da2ebfdfa3b5b00f4a1929ad4885c838845b160f570259792ef370b69d4f473`.
The preserved Stage-B build log pairs it with ELF SHA256
`b41e4cb37bd44633d14b2e6eea615cbbbdd29a1d4b49c3258b4f49f2e215e567`.
Stock VDP source is pinned to `1056ee38ec1cc68ed327bd32ee47d04b1c30597c`;
vdp-gl is pinned to `ac2dd5986daf496c43ae8e7fe41836274aec54a0`.
The examined mode/swap header, Canvas and display-controller files are byte
identical to those commits and to the earlier preserved `STOCK-PATH.json`
identities. The copied ELF is byte identical to that Stage-B identity. Read-only disassembly
confirms the exact compiled chain: Canvas calls `addPrimitive` at `0x400f6410`;
the swap path queues work and waits through `ulTaskGenericNotifyTake` at
`0x4011c975`; the executor exchanges controller pages at `0x4008599b`, then
notifies the caller at `0x400859f9` or `0x40085a26`. Ordinary double-buffered
primitives execute synchronously through the call at `0x4011c939`. The relevant
ELF excerpts and decoded indirect-call targets are preserved in
[FRAME-COMPLETION-DISASSEMBLY.txt](FRAME-COMPLETION-DISASSEMBLY.txt).

The guest timestamp follows receipt and validation of the post-swap query reply.
Its interval therefore includes eZ80 presentation, native physics/preparation,
command transfer/backpressure, raster execution, swap/VSync waiting and callback
transport. It is a complete-frame throughput measurement, not an isolated VDP
raster timer. Foreground pacing is absent; stock swap synchronization remains.
Flexe establishes the corresponding emulated framebuffer/page-completion order,
not physical ESP32 speed, monitor latency or host-window presentation completion.

This conclusion is scoped to mode136, the pinned stock Canvas paths, the serialized
fixture VDU stream and its post-swap query. Removing swap, changing buffering mode,
adding asynchronous drawing services or bypassing Canvas requires a new proof.
No emulator, hardware, build or timing experiment was run for this source review.
