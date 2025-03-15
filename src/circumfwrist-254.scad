// Bracelet basic parameters
length = 256;    // Total length in mm
width = 12;      // Width of the band in mm
height = 1.5;    // Thickness/height of the band in mm
bevel_radius = 4; // Radius for the beveled/curved edges

// Improved closure system parameters
peg_diameter = 5;      // Increased diameter for more strength
peg_height = 2.6;      // Taller peg for better retention
peg_top_diameter = 6; // Flared top for secure fastening
peg_base_height = 1;   // Height of the reinforced base
hole_diameter = 5.2;   // Slightly larger than peg for good fit
num_holes = 6;         // Number of adjustment holes
hole_spacing = 7;      // Distance between hole centers
peg_offset = 5;        // Distance from end to peg

// Calculate the available space between peg and the hole area
hole_area_width = (num_holes - 1) * hole_spacing;  // Width of the area containing all holes
last_hole_position = length - peg_offset - (num_holes - 1) * hole_spacing;  // Position of the last hole
peg_position = peg_offset;  // Position of the peg

// Define the safe area for the rectangle
safe_start = peg_position + peg_diameter + 2;  // Safe distance after the peg
safe_end = last_hole_position - hole_diameter/2 - 2;  // Safe distance before the last hole
available_space = safe_end - safe_start;  // Available space for the rectangle

// Center rectangular cutout parameters
rect_width_percentage = 0.99;  // Width as percentage of available space (0.0-1.0)
rect_width = available_space * rect_width_percentage;  // Width calculated automatically
rect_height = 8;      // Height of the rectangular cutout
rect_bevel = 4;       // Bevel radius for the rectangular cutout
rect_offset_y = 0;    // Vertical offset from center (positive = up)

// Calculate the center position between peg and holes area
rect_center = safe_start + (available_space / 2);
rect_offset_x = rect_center - (length/2);  // Offset from bracelet center

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

// Rounded rectangle cutout module
module rounded_rect_cutout(width, height, radius, thick) {
    hull() {
        translate([radius, radius, -0.1])
        cylinder(r=radius, h=thick+0.2, $fn=30);
        
        translate([width - radius, radius, -0.1])
        cylinder(r=radius, h=thick+0.2, $fn=30);
        
        translate([radius, height - radius, -0.1])
        cylinder(r=radius, h=thick+0.2, $fn=30);
        
        translate([width - radius, height - radius, -0.1])
        cylinder(r=radius, h=thick+0.2, $fn=30);
    }
}

// Main bracelet body with cutouts
difference() {
    rounded_band();
    
    // Create adjustment holes on one end
    for (i = [0:num_holes-1]) {
        translate([length - peg_offset - (i * hole_spacing), width/2, -0.1])
        cylinder(d=hole_diameter, h=height+0.2, $fn=30);
    }
    
    // Add center rectangular cutout
    // Position it in the center between peg and first hole
    translate([length/2 - rect_width/2 + rect_offset_x, width/2 - rect_height/2 + rect_offset_y, 0])
    rounded_rect_cutout(rect_width, rect_height, rect_bevel, height);
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

// Add some debug text to verify dimensions
echo("Total length:", length);
echo("Peg position:", peg_offset);
echo("First hole position:", length - peg_offset);
echo("Last hole position:", last_hole_position);
echo("Safe start position:", safe_start);
echo("Safe end position:", safe_end);
echo("Available space:", available_space);
echo("Rectangle width:", rect_width);
echo("Rectangle center position:", rect_center);