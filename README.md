# Disclaimer

This project was fully made by Claude and I haven't gotten around to printing and trying it out yet. Use at your own risk. No idea how well this works.


# iPhone XR + Rii Mini BT Keyboard + Power Bank Clamshell

Phone rides in **landscape** (like a laptop screen), and the lid is now
the same width as the keyboard base — so closing it covers the whole
keyboard, not just the center.

## Before you print — measure your actual parts

The model's defaults are best-effort public specs, not a measurement of
your specific units:

| Part | Default assumed | Source |
|---|---|---|
| iPhone XR | 150.9 x 75.7 x 8.1 mm | Apple spec — reliable, don't change |
| Rii keyboard | 151 x 59 x 12.5 mm | Rii X1-BT listing — **verify with calipers** |
| Power bank | ≤130 x 58 x 10 mm | Spec to shop for — **verify once bought** |

Open `enclosure.scad` in OpenSCAD, edit the `kb_l/kb_w/kb_t` and
`pb_l/pb_w/pb_t` variables at the top to match your actual parts, then
re-render. Everything else (pocket sizes, overall footprint, hinge
position, cable groove) recomputes automatically — the phone's long
edge (150.9mm) and the keyboard's width (151mm) are almost identical,
which is what lets the lid match the base's full width.

## Power bank — what to shop for

Buy the power bank *after* confirming the keyboard's real footprint, and
pick one that:
- Fits under the keyboard: length ≤ your keyboard's length, width ≤ your
  keyboard's width (or resize `base_y` if it's wider).
- Is slim — 8-12mm thick keeps the base from getting too chunky.
- Has a **wired USB output** (USB-A or USB-C), not just Qi wireless. The
  iPhone XR has Qi charging but no MagSafe alignment magnets (MagSafe
  arrived a year after the XR), so a wireless pad tucked inside a case
  would charge unreliably at best. A short **right-angle Lightning
  cable** run through the internal cable channel is the reliable path.
- 5,000-10,000 mAh is plenty for topping up an XR many times over.

## Printing

- Both `base.stl` and `lid.stl` print flat, no supports needed for the
  main bodies. The hinge knuckles are round bosses on the top edge —
  print with the part flat as oriented in the STL; if your slicer flags
  the knuckle overhangs, add supports just under them (small, cheap).
- `cover.stl` is the removable battery-bay bottom panel — same
  orientation, no supports.
- PLA or PETG both work. PETG is a bit more forgiving for the hinge
  knuckles and the phone cradle's lip if you use one (see `lip_w`).
- Suggested settings: 3-4 perimeters, 20%+ infill, 0.2mm layers.

## Hardware you'll need

- A 4mm rod for the hinge pin — a length of 4mm filament (PLA/ABS rod
  stock), a 4mm brass/steel rod, or an M4 bolt with the head trimmed,
  cut to the width of the hinge span (~157mm — now the FULL width, not
  just under the phone) plus a couple mm.
- 4x small disc magnets, 6mm x 2mm (cheap on Amazon/AliExpress) — two
  per half, for the latch. Superglue them into the printed pockets with
  opposite poles facing each other (test polarity before gluing).
- A short right-angle Lightning cable (as short as you can find/cut) to
  carry power from the bank to the phone through the cable groove.

## Assembly order

1. Glue/friction-fit the keyboard into the base's top pocket.
2. Slide the power bank into the bottom pocket, route its output cable
   up through the cable channel, out the hinge-edge gap near the left
   end (under knuckle gap at local X 0-25mm).
3. Snap `cover.stl` onto the bottom (it has a friction-fit ridge) —
   leave it removable so you can recharge or swap the bank later.
4. Glue in the 4 latch magnets (2 in the base, 2 in the lid), matching
   polarity so they attract when closed.
5. Feed the 4mm pin through the interleaved knuckles (2 on the base, 2
   on the lid, spanning the full width) to join the halves.
6. Route the cable up the open groove along the lid's LEFT wall (this
   is deliberately an open channel, not a hidden internal one — it's
   far more reliable to print, and the cable just lays in it) to the
   Lightning port, plug into the phone, and snap the phone into the
   lid's cradle (flex it in over the lip — increase `lip_w` for a more
   secure hold, or set it to 0 for a friction-only fit).

## Design notes — why landscape changed the geometry

- **Orientation:** the phone lies in landscape (long edge along the
  hinge axis), like a laptop screen, rather than standing in portrait.
- **Full-width coverage:** the phone's long edge (150.9mm) is almost
  exactly the keyboard's width (151mm), so the lid is now built to the
  same width as the base (`shared_x` in the script). Closed, it's a
  single continuous slab — no exposed keyboard on either side, unlike
  an earlier portrait version where the narrower lid left both ends of
  the keyboard uncovered.
- **Port location moved:** in portrait, the Lightning port conveniently
  sits right at the hinge edge. In landscape, rotating the phone 90°
  moves the port to the **left side wall** of the lid instead. The
  cable now crosses the hinge near the left end (a dedicated gap in the
  knuckle layout, at local X 0-25mm) and runs down an **open groove**
  on the inside of the left wall to reach the port — deliberately left
  open to the outside rather than a hidden channel, since the phone
  fills almost the entire pocket floor and there's no room to bury a
  channel beside it.
- **Camera cutout and button slot** positions are computed from the
  phone's normal portrait-held dimensions (`cam_offset_from_top`,
  `cam_offset_from_side`) and rotated into the landscape layout
  automatically — edit those two offsets, not the geometry math, if
  your phone's camera sits differently.
- The keyboard sits in an open-top pocket (keys stay exposed); the power
  bank sits in a separate pocket directly underneath, accessed from the
  bottom via the removable cover.
- Render modes in the .scad file: change `render_mode` to `"base"`,
  `"lid"`, `"cover"`, `"closed"` (folded shut preview), or `"assembly"`
  (open preview) and re-render/export.
