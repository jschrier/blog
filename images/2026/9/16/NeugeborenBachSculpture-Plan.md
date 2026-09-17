# Mathematica reconstruction of Neugeboren’s Bach sculpture

This document preserves the implementation plan approved for the project. The later design changes are recorded at the end. It is a plan, not a claim of physical fabrication or testing; see the bundled validation reports and README for the delivered results.

## Summary

Create a self-contained, executable `NeugeborenBachSculpture.nb` alongside the blog post. It will generate a faithful, fabricable reconstruction with two outputs:

- A watertight STL with an integrated base, sized for the Prusa MK3S+.
- Flat DXF/SVG patterns for three aluminum walls with wave-bend cutouts, mounting tabs, and a matching slotted aluminum base.

The notebook will include research notes, editable parameters, assembly previews, export commands, and verification results. Mathematica 15.0.1 is available locally and can run the validation.

## Reconstruction and notebook design

- Transcribe the three voices of BWV 853, measures 52–55, from the score reproduced in [Probst’s examples](https://mtosmt.org/issues/mto.20.26.4/probst_examples.pdf). Embed exact note pitches, rational onset times, durations, and source references so execution requires no downloads.
- Reconstruct the time–pitch ground plan and vertical wall profiles, checking them against the sculpture photographs. Preserve the documented relationship between pitch, depth, and height described in [Probst’s study](https://mtosmt.org/issues/mto.20.26.4/mto.20.26.4.probst.html).
- Distinguish documented musical structure from inferred proportions and fabrication adjustments. Describe the result as a reconstruction rather than a surveyed replica.
- Use one shared panel-and-fold representation for both outputs. Include voice identification, panel endpoints, top heights, fold axes, and signed fold angles.
- Expose named parameters in a single configuration association: overall size, pitch/time proportions, wall thickness, base dimensions, bend geometry, wave dimensions, tab dimensions, and slot clearance.
- Organize the notebook into research, musical data, geometry, printable model, metal fabrication, and verification/export sections. Include rotatable assembled views and labeled flat layouts.

## Fabrication outputs

### Printed model

- Default to a maximum assembled dimension of 180 mm, including the base, with 1.2 mm walls and a 3 mm base.
- Generate genuinely joined, closed solids with an integrated base and export STL in millimeter coordinates.
- Check against the MK3S+’s [250 × 210 × 210 mm build volume](https://www.prusa3d.com/product/original-prusa-i3-mk3s-10th-anniversary-edition-3d-printer/), preserving room for a brim.
- Include upright printing guidance for a 0.4 mm nozzle and identify any geometry that requires supports.

### Sheet-metal assembly

- Default to approximately 1 mm 5052 aluminum walls and a 3 mm aluminum base; both thicknesses remain editable.
- Develop each wall into a flat strip using panel lengths and explicit bend zones. Include adjustable effective bend allowance; perforated bends require coupon calibration rather than assuming conventional solid-sheet bend formulas are exact.
- Generate curved wave cutouts with retained webs, following [SendCutSend’s guidance](https://sendcutsend.com/blog/wave-bending-sheet-metal/). Start web and cutout widths at sheet thickness and keep reliefs clear of edges and tabs.
- Place mounting tabs on sufficiently wide straight panels, away from bend zones. Derive corresponding base slots from the assembled geometry, including material thickness and adjustable clearance.
- Use clearance-fit tabs with optional underside epoxy retention. Include bend and tab-fit coupons.
- Export individual cut-only DXF/SVG files plus a separate labeled assembly guide showing fold order, direction, angles, and part identifiers. Keep annotation lines out of cutting files.
- Report incompatible dimensions or crowded features explicitly instead of silently deleting musical details.

## Validation and acceptance

- Evaluate the notebook from a fresh kernel without external data dependencies.
- Verify note timing, voice separation, and correspondence between musical contours and reference photographs.
- Check STL closure, positive volume, connectivity, wall thickness, and printer bounds.
- Check flat contours for closure, duplicate edges, intersections, disconnected webs, and tab/bend interference.
- Numerically refold the developed patterns and verify that wall geometry and mounting tabs align with the assembled model and base slots.
- Reimport exported files to check dimensions and units; visually inspect assembled and flat previews.
- Clearly separate computational checks from physical validation: actual bend allowance, springback, and tab fit remain dependent on the supplied calibration coupons.

The blog post will remain unchanged. The deliverable will include the notebook and generated prototype fabrication files, with inferred dimensions and untested physical assumptions identified.

## Subsequent approved design changes

After the initial implementation, the requested changes were:

- Change both the printed and laser-cut bases to rounded rectangles with 10 mm corner radii.
- Deboss the underside of the printed base with the two-line inscription:

  Henri Nouveau (Heinrich Neugeboren) (1901-1959)  
  Hommage à J.S. Bach

The delivered revision uses a 0.6 mm recess in the 3 mm printed base. The original 2024 blog post remains unchanged; a separate September 16, 2026 post presents the results.
