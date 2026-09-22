// =====================================================================
// iPhone XR + Rii Mini Bluetooth Keyboard + Power Bank — Clamshell Case
// =====================================================================
// LAYOUT LOGIC (read this before changing numbers):
//   X axis = the hinge axis (runs left-right when the case is in use).
//   Y axis = "depth", running away from the hinge.
//   Z axis = thickness/height.
//
//   The BASE is sized to the KEYBOARD, oriented so the keyboard's long
//   (151mm) edge runs along X — i.e. the keys read left-to-right the
//   normal way. The keyboard sits in an open-top pocket (keys exposed);
//   directly underneath it, accessed from the bottom of the base through
//   a removable cover, is a second pocket sized to the power bank.
//
//   The LID holds the iPhone XR in LANDSCAPE (long edge along X, like a
//   laptop screen) rather than portrait. Because the phone's long edge
//   (150.9mm) is almost exactly the keyboard's width (151mm), the lid is
//   made the SAME width as the base (shared_x) — so closing it actually
//   covers the whole keyboard, not just the center third the way a
//   portrait-phone lid would.
//
//   Landscape means the phone's features land on different edges than
//   in the portrait version: the Lightning port (bottom-center in
//   portrait) ends up centered on the LEFT side wall of the lid, not at
//   the hinge edge. So the charging cable crosses the hinge near the
//   left end (a dedicated gap in the knuckles) and runs down an open
//   groove along the inside of the left wall to reach the port — rather
//   than a single hinge-edge notch like a portrait layout would use.
//
// ALL numbers below marked "VERIFY" are best-effort defaults from public
// spec sheets / typical parts, NOT a measurement of your actual items.
// Measure your real keyboard and power bank with calipers and edit the
// variables before printing — getting these right matters far more than
// anything else in this file.
// =====================================================================

// ---------- RENDER SELECTION ----------
render_mode = "assembly"; // ["assembly","closed","base","lid","cover"]

$fn = 64;

// ---------- iPhone XR (public spec — reliable, no need to verify) ----------
// phone_l = the phone's LONG edge, phone_w = its SHORT edge. In this
// landscape layout, phone_l runs along X (the hinge axis) and phone_w
// runs along Y (depth) — the reverse of a portrait phone-case pocket.
phone_l = 150.9;
phone_w = 75.7;
phone_t = 8.1;
phone_r = 8;          // outer corner radius

// Camera bump position, given in the phone's OWN portrait terms (as if
// you were holding it normally): offset from the short "top" edge (the
// camera end) and from one long "side" edge. The script rotates this
// into the landscape lid automatically — you shouldn't need to touch
// the rotation math below, just these two offsets if your phone differs.
cam_offset_from_top  = 8;   // distance from the camera-end short edge
cam_offset_from_side = 8;   // distance from one long edge
cam_size = 32;               // square cutout, generous so it clears the bump

// Lightning port: treated as centered on the bottom short edge (true for
// the XR). If yours isn't centered, edit port_y_fraction (0 = one long
// edge, 1 = the other).
port_y_fraction = 0.5;

// ---------- Rii mini Bluetooth keyboard ----------
// DEFAULT = Rii X1-BT dimensions (151 x 59 x 12.5 mm). VERIFY.
kb_l = 151;
kb_w = 59;
kb_t = 12.5;
kb_r = 6;

// ---------- Power bank (spec to shop for — see chat for guidance) --------
// Pick a bank no bigger than this footprint so it tucks under the
// keyboard. VERIFY once you've bought one and re-measure.
pb_l = 130;
pb_w = 58;
pb_t = 10;
pb_r = 4;
pb_port_w = 12;       // cutout for the bank's own USB-C charge port
pb_port_h = 6;

// ---------- Build parameters ----------
wall   = 2.2;    // outer wall thickness (~5-6 perimeters at 0.4mm nozzle)
clr    = 0.6;    // per-side clearance around each snug-fit pocket
shelf  = 2.0;    // floor separating keyboard pocket from battery pocket
lid_back_t = 1.5;   // lid's solid back-panel thickness
lip_w  = 1.2;       // lid's cradle lip (inward overhang, all 4 sides).
                     // Set to 0 for a pure friction-fit cradle if you'd
                     // rather not flex the phone in over a lip.

pin_d      = 4.0;    // hinge pin diameter (4mm filament rod / M4 rod)
pin_clr    = 0.35;   // radial clearance added to the pin bore
knuckle_r  = 5.0;    // hinge knuckle outer radius

magnet_d = 6.2;    // 6mm x 2mm disc magnet, +0.2 clearance
magnet_h = 2.2;

// ---------- Derived dimensions ----------
// shared_x is the hinge-axis width used by BOTH halves, so the lid fully
// covers the base when closed. Driven by whichever is wider: the
// keyboard or the phone's long edge (currently the keyboard, by 0.1mm).
shared_x = max(kb_l, phone_l) + 2*(wall+clr);
base_x = shared_x;
lid_x  = shared_x;

base_y = max(kb_w, pb_w) + 2*(wall+clr);
base_z = wall + (pb_t+clr) + shelf + (kb_t+clr);

lid_y = phone_w + 2*(wall+clr);   // the phone's SHORT edge is now the depth
lid_wall_h = phone_t + 1.0;       // cradle side-wall height (phone sits slightly proud)
lid_z = lid_back_t + lid_wall_h;

// Phone's centering offset inside the lid footprint (near-zero in X,
// since shared_x is driven almost exactly by the phone's own length).
phone_x_off = (lid_x - phone_l) / 2;
phone_y_off = (lid_y - phone_w) / 2;

// Landscape feature positions, rotated from the phone's own portrait
// terms (see comments above): x_local = distance-from-camera-end,
// y_local = distance-from-one-long-edge.
cam_x_in_lid = phone_x_off + (phone_l - cam_offset_from_top - cam_size/2);
cam_y_in_lid = phone_y_off + (cam_offset_from_side + cam_size/2);
port_x_in_lid = phone_x_off;                       // sits right at the left wall
port_y_in_lid = phone_y_off + phone_w*port_y_fraction;

hinge_span = shared_x;   // knuckles now span the FULL shared width
hinge_x0   = 0;          // no centering offset needed — base and lid match

// Explicit, hand-placed knuckle layout in LOCAL 0..hinge_span coordinates.
// The cable gap sits near the LEFT end, under the port/groove position,
// rather than centered — landscape moves the port to the side wall.
k_lid_1  = [30, 50];     // lid knuckle
k_base_1 = [55, 75];     // base knuckle
k_base_2 = [100, 120];   // base knuckle
k_lid_2  = [125, 145];   // lid knuckle
                          // 0..25 is the CABLE GAP (near the port's side)
hinge_cable_x = 12.5;    // center of the cable gap, for the base's channel

// =====================================================================
// Helpers
// =====================================================================
// A plain rectangular box, centered in X/Y, from z=0 to z=h.
// (An earlier hull()-of-cylinders / offset()-rounded version was tried for
// softer edges, but both produce a mesh that goes non-manifold wherever a
// hinge knuckle cylinder meets the box near its corner edge — confirmed by
// bisecting the model and by minimal repro cases. Plain sharp edges render
// and print reliably; round them by hand afterward if you want, or apply
// your slicer's edge-chamfer feature.)
module rounded_box(l, w, h, r=0) {
    translate([-l/2, -w/2, -h/2])
        cube([l, w, h]);
}

// One knuckle segment: axis along X, spanning local x=[x0,x1] at (y,z)
module knuckle_seg(x0, x1, y, z) {
    len = x1 - x0;
    translate([x0 + len/2, y, z])
        rotate([0, 90, 0])
            cylinder(r=knuckle_r, h=len, center=true);
}

module pin_bore_seg(x0, x1, y, z) {
    len = x1 - x0;
    translate([x0 - 2, y, z])
        rotate([0, 90, 0])
            cylinder(r=pin_d/2 + pin_clr, h=len + 4, center=false);
}

// =====================================================================
// BASE (keyboard tray + battery pocket + hinge knuckles + magnets)
// Local frame: X:[0,base_x]  Y:[0,base_y]  Z:[0,base_z]
// Hinge edge is Y = base_y (the back edge). Front/latch edge is Y = 0.
// =====================================================================
module base_part() {
    difference() {
        union() {
            translate([base_x/2, base_y/2, base_z/2])
                rounded_box(base_x, base_y, base_z, 4);

            // hinge knuckles (both on the base's own frame; hinge_x0 is 0
            // now that base_x == lid_x, kept for symmetry with lid code)
            knuckle_seg(hinge_x0 + k_base_1[0], hinge_x0 + k_base_1[1], base_y, base_z);
            knuckle_seg(hinge_x0 + k_base_2[0], hinge_x0 + k_base_2[1], base_y, base_z);
        }

        // keyboard pocket, open at the TOP (keys exposed), floor = shelf.
        // Spans z:[base_z-(kb_t+clr), base_z+1] — floor at the shelf, 1mm
        // overshoot above the top face for a clean through-cut.
        translate([base_x/2, base_y/2, base_z - (kb_t+clr)/2 + 0.5])
            rounded_box(kb_l+2*clr, kb_w+2*clr, kb_t+clr+1, kb_r+clr);

        // battery pocket, open at the BOTTOM (removable cover), under the
        // shelf. Spans z:[-0.5, wall+(pb_t+clr)] — 0.5mm overshoot below
        // the bottom face, floor at the underside of the shelf.
        translate([base_x/2, base_y/2, (wall + (pb_t+clr) - 0.5)/2])
            rounded_box(pb_l+2*clr, pb_w+2*clr, wall + (pb_t+clr) + 0.5, pb_r+clr);

        // reach the power bank's own charge port from the front edge (Y=0)
        translate([base_x/2, -0.5, wall + (pb_t+clr)/2])
            cube([pb_port_w, wall+1, pb_port_h], center=true);

        // cable channel: battery pocket -> alongside keyboard -> hinge edge,
        // positioned under the knuckle cable gap (near the left end, to
        // line up with the lid's port groove on the other side of the hinge)
        translate([hinge_x0 + hinge_cable_x, base_y/2, base_z - (kb_t+clr) - shelf/2])
            cube([10, base_y + 2, 5], center=true);

        // continuous pin bore through this base's two knuckle segments only
        pin_bore_seg(hinge_x0 + k_base_1[0], hinge_x0 + k_base_1[1], base_y, base_z);
        pin_bore_seg(hinge_x0 + k_base_2[0], hinge_x0 + k_base_2[1], base_y, base_z);

        // magnet pockets on the front edge (opposite the hinge), for the latch
        for (side = [-1, 1])
            translate([base_x/2 + side*(base_x/2 - 10), 4, base_z-0.01])
                cylinder(d=magnet_d, h=magnet_h+0.01);
    }
}

// =====================================================================
// LID (phone cradle, LANDSCAPE, + hinge knuckles + magnets)
// Local frame: X:[0,lid_x]  Y:[0,lid_y]  Z:[0,lid_z]
// Hinge edge is Y = 0 (matches the base's Y=base_y edge when assembled,
// with base_z aligned to lid's z=0 — the seam where the two meet).
// =====================================================================
module lid_part() {
    difference() {
        union() {
            // solid back panel + cradle side walls, as ONE continuous prism
            // (stacking two separate same-profile hull() shapes here would
            // leave coincident internal faces at the seam and confuse the
            // slicer/mesh-repair step, so the full lid_z height is built
            // as a single rounded_box rather than two glued-together ones)
            translate([lid_x/2, lid_y/2, lid_z/2])
                rounded_box(lid_x, lid_y, lid_z, phone_r*0.6);

            // hinge knuckles
            knuckle_seg(k_lid_1[0], k_lid_1[1], 0, 0);
            knuckle_seg(k_lid_2[0], k_lid_2[1], 0, 0);
        }

        // hollow out the ring's interior above the lip line, leaving lip_w
        // on all 4 sides for the top ~lip strip; cut runs from just above
        // the back panel up through the top (open), never below lid_back_t
        translate([lid_x/2, lid_y/2, lid_back_t + (lid_wall_h+1)/2])
            rounded_box(lid_x - 2*wall - 2*lip_w, lid_y - 2*wall - 2*lip_w,
                         lid_wall_h + 1, phone_r*0.4);

        // the actual phone pocket (landscape: X-size=phone_l, Y-size=phone_w).
        // Full lid_wall_h depth, floor flush with the back panel.
        translate([lid_x/2, lid_y/2, lid_back_t + (lid_wall_h+1)/2])
            rounded_box(phone_l+2*clr, phone_w+2*clr, lid_wall_h+1, phone_r);

        // camera bump cutout (back panel), rotated into landscape position
        translate([cam_x_in_lid, cam_y_in_lid, -0.5])
            cube([cam_size, cam_size, lid_back_t+1], center=true);

        // button access: one generous forgiving slot on the front (Y=lid_y)
        // wall — the only long edge still reachable once the phone is
        // docked (the other long edge is against the hinge).
        translate([lid_x*0.4, lid_y, lid_back_t + lid_wall_h/2])
            cube([50, 4, lid_wall_h+1], center=true);

        // Lightning port + cable groove: an open channel along the INSIDE
        // face of the left (X=0) wall, running from the hinge edge (Y=0)
        // down to the port position, then through the wall into the pocket.
        // Left open on the outside face rather than a hidden internal
        // channel — far more reliable to print, and the cable just lays
        // in the groove.
        translate([-0.5, (port_y_in_lid+4)/2, lid_back_t + phone_t/2 + 0.5])
            cube([port_x_in_lid + 4, port_y_in_lid + 4, phone_t + 2], center=true);

        // pin bore through this lid's knuckle segments only
        pin_bore_seg(k_lid_1[0], k_lid_1[1], 0, 0);
        pin_bore_seg(k_lid_2[0], k_lid_2[1], 0, 0);

        // magnet pockets on the far edge (meets the base's magnets when closed)
        for (side = [-1, 1])
            translate([lid_x/2 + side*(lid_x/2 - 10), lid_y-4, -0.01])
                cylinder(d=magnet_d, h=magnet_h+0.01);
    }
}

// =====================================================================
// REMOVABLE BOTTOM COVER for the battery pocket
// =====================================================================
module cover_part() {
    cover_t = 2.0;
    snap_h  = 1.2;
    difference() {
        translate([base_x/2, base_y/2, cover_t/2])
            rounded_box(pb_l+2*clr+2*wall, pb_w+2*clr+2*wall, cover_t, pb_r+2);
        translate([base_x/2, -0.5, cover_t/2])
            cube([pb_port_w+2, wall+2, pb_port_h+2], center=true);
    }
    translate([base_x/2, base_y/2, cover_t + snap_h/2])
        rounded_box(pb_l+2*clr-1, pb_w+2*clr-1, snap_h, pb_r);
}

// =====================================================================
// VISUAL MOCKUPS (not printed — just for previewing what's inside)
// =====================================================================
show_contents = true;

module phone_mockup() {
    color([0.15, 0.55, 0.85])
        translate([lid_x/2, lid_y/2, lid_back_t + phone_t/2 + 0.3])
            cube([phone_l, phone_w, phone_t], center=true);
}

module keyboard_mockup() {
    color([0.12, 0.12, 0.14])
        translate([base_x/2, base_y/2, base_z - (kb_t+clr) + kb_t/2 + 0.3])
            cube([kb_l, kb_w, kb_t], center=true);
    // suggestion of key rows
    color([0.35, 0.35, 0.4])
        for (row = [0:3])
            translate([base_x/2, base_y/2 - kb_w/2 + 8 + row*11, base_z - (kb_t+clr) + kb_t + 0.31])
                cube([kb_l-10, 7, 0.4], center=true);
}

module powerbank_mockup() {
    color([0.6, 0.6, 0.62])
        translate([base_x/2, base_y/2, (wall+(pb_t+clr))/2 + wall/2])
            cube([pb_l, pb_w, pb_t], center=true);
}

// =====================================================================
// RENDER
// =====================================================================
if (render_mode == "base") {
    // NOTE: mockups are intentionally NOT shown here — this is the mode
    // used to export the real printable base.stl, and they must not end
    // up fused into it.
    base_part();
} else if (render_mode == "lid") {
    // same note as above — printable lid.stl, no mockup geometry.
    lid_part();
} else if (render_mode == "cover") {
    cover_part();
} else if (render_mode == "closed") {
    // folded shut: lid rotated 180 about the hinge, resting on the base
    base_part();
    if (show_contents) { keyboard_mockup(); powerbank_mockup(); }
    translate([hinge_x0, base_y, base_z])
        rotate([180, 0, 0])
            lid_part();
} else {
    // "assembly" preview: base flat, lid propped open, hinge seam
    // (base's top-back edge) aligned with the lid's own Y=0,Z=0 edge.
    base_part();
    if (show_contents) { keyboard_mockup(); powerbank_mockup(); }
    translate([hinge_x0, base_y, base_z])
        rotate([-115, 0, 0]) {
            lid_part();
            if (show_contents) phone_mockup();
        }
}
