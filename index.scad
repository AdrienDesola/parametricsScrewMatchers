use <threads.scad>;  // DKProjects threadlib
$fn = 100;

// Mason jar mouth type: select Regular or Wide
jar_mouth_type = "wide"; // [regular:Regular Mouth, wide:Wide Mouth]

// Standard mason jar band inner diameters (mm)
jar_band_diameter_regular = 70;
jar_band_diameter_wide = 86;
jar_band_offset = 5; // mm, offset for the band ledge

// Select band diameter based on mouth type
jar_band_diameter = (jar_mouth_type == "wide") ? jar_band_diameter_wide - jar_band_offset : jar_band_diameter_regular - jar_band_offset;

// Thread parameters
minor_diameter = 25; // mm, minor diameter (root diameter) of the external thread
major_diameter = 27; // mm, major diameter (crest diameter) of the external thread
thread_pitch = 4;    // mm, thread pitch (distance between threads)
thread_turns = 1.5;  // number of thread turns (positive: right-hand, negative: left-hand)
threaded_length = thread_pitch * thread_turns; // mm, total length of the threaded section

// Body parameters
shank_length = 1;   // mm, length of the unthreaded shank (below the thread)
head_height = 1;     // mm, height of the head/collar (above the thread)

// Adaptor disk parameters
flange_thickness = 1;           // mm, thickness of the adaptor flange
// Thickness of the centering/support disk
support_disk_thickness = 1; // [0.5:0.1:5]

// Through hole parameters
through_hole_diameter = minor_diameter - 4; // mm, diameter of the through hole (adjust as needed)

// Inner ledge diameter of the mason jar band (where the lid sits)
band_inner_ledge_diameter = jar_band_diameter - jar_band_offset; // mm, inner diameter of the band ledge

total_height = flange_thickness + shank_length + threaded_length + head_height;

// Use a square thread profile for better 3D printability
thread_profile_square = false; // [true:Square (3D print friendly), false:ISO Metric (V-thread)]

// Calculate thread height (h) and factor (h_fac2) for square or V-thread
h_fac2 = thread_profile_square ? 0.95 : 5.3/8;
thread_height = thread_profile_square ? thread_pitch/2 : thread_pitch / (2 * tan(30));
thread_root_diameter = major_diameter - 2 * thread_height * h_fac2;

// Combined adaptor: flange + shank + threaded section + head, with through hole

difference() {
    union() {
        // Adaptor flange (disk)
        cylinder(d=jar_band_diameter, h=flange_thickness);
        // Centering/support disk to fit inside the band ledge, placed above flange
        translate([0,0,flange_thickness])
            cylinder(d=band_inner_ledge_diameter, h=support_disk_thickness);
        // Shank, threaded section, and head stacked on top of support disk
        translate([0,0,flange_thickness+support_disk_thickness]) {
            // Unthreaded shank
            cylinder(d=thread_root_diameter, h=shank_length);
            // Threaded section (square thread for 3D printability)
            translate([0,0,shank_length])
                metric_thread(diameter = major_diameter, pitch = thread_pitch, length = threaded_length, square = thread_profile_square);
            // Head/collar
            translate([0,0,shank_length+threaded_length])
                cylinder(d=thread_root_diameter, h=head_height);
        }
    }
    // Through hole, offset slightly below and above to avoid coplanar artifacts
    translate([0,0,-1])
        cylinder(d=through_hole_diameter, h=total_height+support_disk_thickness+2);
}
