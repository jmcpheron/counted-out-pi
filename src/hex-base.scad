// Bracelet connector parameters
// Using the same parameters from original bracelet for compatibility

// Base parameters from original design
width = 12;      // Width of the band in mm 
height = 1.5;    // Thickness/height of the band in mm
bevel_radius = 2; // Radius for the beveled/curved edges

// Peg parameters (further reduced for better fit between PLA pegs and TPU holes)
peg_diameter = 4.4;    // Further reduced diameter (original was 5, then 4.8, then 4.6)
peg_height = 2.6;      // Kept the same height
peg_top_diameter = 5.2; // Further reduced flare (original was 6, then 5.7, then 5.4)
peg_base_height = 1;   // Height of the reinforced base

// Dual peg spacing (matching the hole spacing from original)
hole_spacing = 7;      // Distance between peg centers
connector_length = hole_spacing + peg_diameter + 6; // Length of the connector piece

// Create a proper hexagonal connector base
module hexagonal_connector() {
    center_x = connector_length / 2;
    center_y = width / 2;
    
    // Size of the hexagon (distance from center to mid-edge)
    hex_size = min(connector_length/2, width/2) * 0.95;
    
    hull() {
        // Create six rounded corners for the hexagon
        for (i = [0:5]) {
            angle = i * 60;
            // Calculate corner position
            x = center_x + hex_size * cos(angle);
            y = center_y + hex_size * sin(angle);
            
            translate([x, y, 0])
                cylinder(r=bevel_radius, h=height, $fn=30);
        }
    }
}

// Create the hexagonal base connector
hexagonal_connector();

// Add first peg - position unchanged from original
translate([connector_length/2 - hole_spacing/2, width/2, 0]) {
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

// Add second peg - position unchanged from original
translate([connector_length/2 + hole_spacing/2, width/2, 0]) {
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
echo("Connector length:", connector_length);
echo("Peg spacing:", hole_spacing);
echo("First peg position:", connector_length/2 - hole_spacing/2);
echo("Second peg position:", connector_length/2 + hole_spacing/2);