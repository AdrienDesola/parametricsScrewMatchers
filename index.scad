use <threads.scad>;  // DKProjects threadlib
$fn = 100;

in_diameter_minimal = 35; // mm, minimum diameter for the pepper grinder thread
in_diameter = 37; // mm, diameter of the pepper grinder thread
in_pitch = 4;
loop = 1.5; // 1 for right hand thread, -1 for left hand thread
in_height = in_pitch * loop; // Height of the thread

base_height = 10; // mm, height below the thread
collar_height = 1; // mm, height above the thread

// Parameters
outer_diameter = 69.5; // mm, mason jar band
thickness = 1;         // mm, disk thickness
center_hole = in_diameter_minimal; // for disk, not used now
hole_diameter = in_diameter_minimal - 2; // mm, central hole

total_height = thickness + base_height + in_height + collar_height;

// Combined adaptor: disk + screw + central hole

difference() {
    union() {
        // Flat adaptor disk
        cylinder(d=outer_diameter, h=thickness);
        // Screw (base, thread, collar) on top of disk
        translate([0,0,thickness]) {
            // Base
            cylinder(d=in_diameter_minimal, h=base_height);
            // Thread
            translate([0,0,base_height])
                metric_thread(diameter = in_diameter, pitch = in_pitch, length = in_height);
            // Collar
            translate([0,0,base_height+in_height])
                cylinder(d=in_diameter_minimal, h=collar_height);
        }
    }
    // Central hole through everything, start slightly below and extend above
    translate([0,0,-0.1])
        cylinder(d=in_diameter_minimal - 10, h=total_height+2);
}
