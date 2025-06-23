use <threads.scad>;  // DKProjects threadlib
$fn = 100;

// Thread parameters
minor_diameter = 35; // mm, minor diameter (root diameter) of the external thread
major_diameter = 37; // mm, major diameter (crest diameter) of the external thread
thread_pitch = 4;    // mm, thread pitch (distance between threads)
thread_turns = 1.5;  // number of thread turns (positive: right-hand, negative: left-hand)
threaded_length = thread_pitch * thread_turns; // mm, total length of the threaded section

// Body parameters
shank_length = 10;   // mm, length of the unthreaded shank (below the thread)
head_height = 1;     // mm, height of the head/collar (above the thread)

// Adaptor disk parameters
jar_band_diameter = 69.5; // mm, inner diameter of mason jar band
flange_thickness = 1;     // mm, thickness of the adaptor flange

// Through hole parameters
through_hole_diameter = minor_diameter - 10; // mm, diameter of the through hole (adjust as needed)

total_height = flange_thickness + shank_length + threaded_length + head_height;

// Combined adaptor: flange + shank + threaded section + head, with through hole

difference() {
    union() {
        // Adaptor flange (disk)
        cylinder(d=jar_band_diameter, h=flange_thickness);
        // Shank, threaded section, and head stacked on top of flange
        translate([0,0,flange_thickness]) {
            // Unthreaded shank
            cylinder(d=minor_diameter, h=shank_length);
            // Threaded section
            translate([0,0,shank_length])
                metric_thread(diameter = major_diameter, pitch = thread_pitch, length = threaded_length);
            // Head/collar
            translate([0,0,shank_length+threaded_length])
                cylinder(d=minor_diameter, h=head_height);
        }
    }
    // Through hole, offset slightly below and above to avoid coplanar artifacts
    translate([0,0,-0.1])
        cylinder(d=through_hole_diameter, h=total_height+2);
}
