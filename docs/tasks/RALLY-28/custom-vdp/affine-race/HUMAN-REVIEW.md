# Moving visual review

Two fresh profiles are stopped on Oryx. Each runs the exact900-frame complete
race fixture, shows moving traffic and the scrolling panorama/HUD, then returns
to MOS. Sound is forced off. The Author launches the visible session; automated
qualification used both SDL dummy drivers and never opened a window.

From an Oryx desktop terminal, run either profile (sequentially):

```bash
cd ~/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-affreview01-cached-affine
./flexe-agon-emulator
```

```bash
cd ~/Agon/mystuff/AgonArcade/.emulator/rally28-hz60-affreview01-prepared-bitmap
./flexe-agon-emulator
```

1. Check that traffic approaches/recedes, changes view/reflection and does not
   acquire trails, wrong sizes/colors or displaced anchors.
2. Check signs near the road edge, skyline repair, panorama scrolling and HUD.
3. Check clean return to MOS. Review-run timing is separate from the preserved
   headless forward/reverse benchmark. The driver is finite and unpaced.

Matched automatic captures at completed frames300 and301 are100% pixel-identical
between rebuilt affine and prepared bitmaps. This supports the inspection but
is not the Author's moving visual acceptance. See CAPTURE-COMPARISON.json and
captures/previews/. No firmware flashing or hardware operation is needed.
