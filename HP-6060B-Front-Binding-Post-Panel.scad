/*
 * HP 6060B/6063B Front Binding Post Modification Plate
 * 
 * This OpenSCAD file creates a model for a plate to use for mounting binding posts to the front panel of a Hewlett Packard, Agilent or Keysight 6060B or 6063B Electronic Load that does not currently have Option 020 (front panel posts) installed. This mod makes use of existing holes on the front panel assembly that are used for Option 020 on devices that have this option installed.
 * 
 * In addition to this plate, other parts are required to complete this modification. Drilling out of the front panel aluminum plate will also be required. Specifically, this plate is built to fit the retention flanges on the factory binding posts, HP P/N 1510-0134. See the readme file in the source repository for more details.
 *
 * https://github.com/fivesixzero/hp-6060b-front-binding-posts-mod
 */

// The default values here allow the panel to fit well enough within the front panel of my HP 6060B (S/N prefix 3436A) no glue or additional mounting hardware is required beyond simply tightening the post mounting bolts. Your specific panel may vary, however, so these variables can be tuned to fit your specific panel without too much trouble.

// This model was printed on a Prusa MINI+ with Prusament Clear PETG. The print gcode was sliced by Prusaslicer at "0.2mm QUALITY"/Prusament PETG default settings. Your printer or slicer settings are likely to cause slight tolerance shifts that may require additional tuning of these variables to enable a snug fit.

// Customizable Varaibles
/*[ Plate Properties]*/
plate_height = 84.025;
plate_width = 59;
plate_depth = 3;

/*[ Post Properties]*/
dia_main = 17.1; 
dia_p1 = 3.6;
dia_p2 = 2.6;

/*[ Post Center Offsets]*/
post_1_offset = -20; // Post 1's position above/below to center line 
post_2_offset = 15;  // Post 2's position above/below to center line

/* [ Symbol Properties]*/
symbol_size_ratio = 0.49; // Ratio of symbol size to binding post diameter
symbol_line_width = 1.5; // Width of symbol lines

/*[]*/
post_1_center = [post_1_offset, 0, -.5]; // Offsetting post positions on Z
post_2_center = [post_2_offset, 0, -.5]; // axis to assure full plate cutouts

module __customizer_limit__() {} // End Customizr vars

// Global Variables
$fs = 0.02;  // Set facet size to 0.02mm for relatively high arc resolution
$fa = 2.5;   // Set max facet angle to 2.5 degrees for relatively high arc resolution

h_post = plate_depth * 2; // Make sure that post cutouts are tall enough to fully intersect with plate

// Individual parts used to build plate and cutout
module plate(width, height, depth) {
    translate([-(width/2), -(height/2), 0]) cube([width, height, depth]);
}

module binding_post(d_main, d_p1, d_p2, h_main=10, h_p=5) {
    r_main = d_main * 0.5;
    cylinder(h_main, r_main, r_main);
    
    r_p1 = d_p1 * 0.5;
    translate([-(r_main), 0, 0]) cylinder(h_p, r_p1, r_p1);
    translate([(r_main), 0, 0]) cylinder(h_p, r_p1, r_p1);
    
    r_p2 = d_p2 * 0.5;
    translate([0, -(r_main), 0]) cylinder(h_p, r_p2, r_p2);
    translate([0, (r_main), 0]) cylinder(h_p, r_p2, r_p2);
}

module sym_positive(length, height=4, line_width=1.5) {
    union() {
        translate([-(length * 0.5), -(line_width * 0.5), 0]) cube([length, line_width, height]);
        translate([-(line_width * 0.5), -(length * 0.5), 0]) cube([line_width, length, height]);
    }
}

module sym_negative(length, height=4, line_width=1.5) {
    translate([-(length * 0.5), -(line_width * 0.5), 0]) cube([length, line_width, height]);
}

// Build the plate from the above parts
difference() {
    // Create flat plate
    color("grey")  plate(plate_height, plate_width, plate_depth);
    
    // Cut out binding post mounting holes
    translate(post_1_center) binding_post(dia_main, dia_p1, dia_p2, h_post, h_post);
    translate(post_2_center) binding_post(dia_main, dia_p1, dia_p2, h_post, h_post);
    
    // Cut out positive polarity symbols
    translate([post_1_offset, (dia_main + (dia_main/7)), -0.1]) rotate([0, 0, 90]) sym_negative(dia_main * symbol_size_ratio);
    translate([post_1_offset, -(dia_main + (dia_main/7)), -0.1]) rotate([0, 0, 90]) sym_negative(dia_main * symbol_size_ratio);
    
    // Cut out negative polarity symbols
    translate([post_2_offset, (dia_main + (dia_main/7)), -0.1]) sym_positive(dia_main * symbol_size_ratio);
    translate([post_2_offset, -(dia_main + (dia_main/7)), -0.1]) sym_positive(dia_main * symbol_size_ratio);
}

// Written by Erik Hess <erik@noisedamage.com> on 2021/06/21
//
// To the extent possible under law, the author(s) have dedicated all copyright and related and neighboring rights to this software to the public domain worldwide. This software is distributed without any warranty.
//
// You should have received a copy of the CC0 Public Domain Dedication along with this software.
// If not, see <http://creativecommons.org/publicdomain/zero/1.0/>.