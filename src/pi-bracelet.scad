// Bracelet basic parameters
length = 160;    // Total length in mm
width = 12;      // Width of the band in mm
height = 1.5;    // Thickness/height of the band in mm
bevel_radius = 4; // Radius for the beveled/curved edges

// Improved closure system parameters
peg_diameter = 5;      // Increased diameter for more strength
peg_height = 2.6;      // Taller peg for better retention
peg_top_diameter = 6; // Flared top for secure fastening
peg_base_height = 1;   // Height of the reinforced base
hole_diameter = 5.2;   // Slightly larger than peg for good fit
num_holes = 4;         // Number of adjustment holes
hole_spacing = 7;      // Distance between hole centers
peg_offset = 5;        // Distance from end to peg

// Pi text parameters - replacing the cutout
pi_text = "3.1415926535897932...";     // First 17 digits of pi
text_size = 8;                      // Size of text (adjust to taste)
text_height = 0.7;                  // Depth of embossed text
text_offset_x = -7;                 // Horizontal offset (kept same as cutout)
text_offset_y = 0;                  // Vertical offset
text_width = 115;                   // Target width (same as previous cutout)

// Border parameters
border_thickness = 1;               // Thickness of top/bottom borders
border_depth = 0.5;                 // Depth of embossed borders

module rounded_band() {
    // Create the main band with rounded edges
    hull() {
        translate([bevel_radius, bevel_radius, 0])
        cylinder(r=bevel_radius, h=height, $fn=30);
        
        translate([length - bevel_radius, bevel_radius, 0])
        cylinder(r=bevel_radius, h=height, $fn=30);
        
        translate([bevel_radius, width - bevel_radius, 0])
        cylinder(r=bevel_radius, h=height, $fn=30);
        
        translate([length - bevel_radius, width - bevel_radius, 0])
        cylinder(r=bevel_radius, h=height, $fn=30);
    }
}

// Main bracelet body with text and borders
difference() {
    rounded_band();
    
    // Create adjustment holes on one end
    for (i = [0:num_holes-1]) {
        translate([length - peg_offset - (i * hole_spacing), width/2, -0.1])
        cylinder(d=hole_diameter, h=height+0.2, $fn=30);
    }
    
    // Add the pi text instead of the cutout
    translate([length/2 + text_offset_x, width/2 + text_offset_y, height - text_height])
    linear_extrude(height = text_height + 0.1)
    text(pi_text, size = text_size, halign = "center", valign = "center", $fn = 40);
    
    // Add top border
    translate([length/2 - text_width/2 + text_offset_x, width/2 + text_size/2 + border_thickness/2, height - border_depth])
    cube([text_width, border_thickness, border_depth + 0.1]);
    
    // Add bottom border
    translate([length/2 - text_width/2 + text_offset_x, width/2 - text_size/2 - border_thickness*1.5, height - border_depth])
    cube([text_width, border_thickness, border_depth + 0.1]);
}

// Add a single peg on the other end with reinforced base
translate([peg_offset, width/2, 0]) {
    // Reinforced base for the peg
    cylinder(d=peg_diameter + 2, h=peg_base_height, $fn=30);
    
    // Peg with flared top
    translate([0, 0, peg_base_height]) {
        // Main peg body
        cylinder(d1=peg_diameter, d2=peg_diameter, h=peg_height-0.8, $fn=30);
        
        // Flared top portion
        translate([0, 0, peg_height-0.8])
        cylinder(d1=peg_diameter, d2=peg_top_diameter, h=0.8, $fn=30);
    }
}