// Turtle Basking Spot for Aquarium
// All dimensions are parameterized for customization

// ===== PARAMETERS =====
// Main platform dimensions
platform_length = 100;     // Length of the basking platform (mm)
platform_width = 150;       // Width of the basking platform (mm)
platform_thickness = 5;    // Thickness of the platform (mm)

// Wall dimensions
wall_height = 20;          // Height of the back wall (mm)
wall_thickness = 5;        // Thickness of the wall (mm)
upper_wall_height = 50;    // Height of the upper wall above the hook (mm)

// Glass hook dimensions
hook_drop = 20;            // How far the hook drops down behind the glass (mm)
hook_thickness = 5;        // Thickness of the hook (mm)
glass_thickness = 4;       // Thickness of aquarium glass (mm)

// Ramp/stairs dimensions
ramp_width = 100;           // Width of the ramp (mm)
ramp_height = 85;         // Total depth of the ramp (how far down from platform) (mm)
ramp_length = 100;        // Total length of the steps area (mm)

// Ridge dimensions for better grip
ridge_height = 2;          // Height of ridges above step surface (mm)
ridge_width = 1;           // Width/thickness of each ridge (mm)

// ===== MAIN ASSEMBLY =====
turtle_basking_spot();

// Ramp/stairs positioned at the front of the platform
translate([platform_length/2 - ramp_width/2, -ramp_length, 0])
    ramp_stairs();

// ===== MODULES =====
module turtle_basking_spot() {
    union() {
        // Main platform
        basking_platform();
        
        // Back wall with glass hook
        translate([0, platform_width - wall_thickness, platform_thickness])
            back_wall_with_hook();
    }
}

module basking_platform() {
    union() {
        // Simple flat platform
        cube([platform_length, platform_width, platform_thickness]);
        
        // Add ridge at front edge for better grip
        translate([0, 0, platform_thickness])
            cube([platform_length, ridge_width, ridge_height]);
    }
}

module back_wall_with_hook() {
    union() {
        // Main wall
        cube([platform_length, wall_thickness, wall_height]);
        
        // Glass hook at the top
        translate([0, 0, wall_height])
            glass_hook();
        
        // Upper wall above the hook
        translate([0, 0, wall_height + hook_thickness])
            cube([platform_length, wall_thickness, upper_wall_height]);
    }
}

module glass_hook() {
    // L-shaped hook that goes over the glass edge with gap for glass
    union() {
        // Horizontal part (goes over the glass, extends to accommodate glass + hook material)
        translate([0, 0, 0])
            cube([platform_length, wall_thickness + glass_thickness + hook_thickness, hook_thickness]);
        
        // Vertical part (drops down behind the glass, positioned to create proper glass gap)
        translate([0, wall_thickness + glass_thickness, -hook_drop])
            cube([platform_length, hook_thickness, hook_drop]);
    }
}

module ramp_stairs() {
    // Calculate starting position - ramp goes down from platform level
    ramp_start_height = -ramp_height;

    // Calculate optimal step count and dimensions
    calculated_step_count = max(1, round(ramp_height / 10));
    actual_step_height = ramp_height / calculated_step_count;
    actual_step_length = ramp_length / calculated_step_count;
    
    // Create overlapping steps to prevent gaps
    for (i = [0 : calculated_step_count - 1]) {
        // Calculate step position
        step_y_position = i * actual_step_length;
        step_z_position = ramp_start_height + (i * actual_step_height);
        
        // Make each step extend to connect properly
        step_length_with_overlap = (i == calculated_step_count - 1) ? 
            ramp_length - step_y_position + 3 : actual_step_length + 3;
        
        translate([0, step_y_position, step_z_position])
            ridged_step(ramp_width, step_length_with_overlap, actual_step_height);
    }

}

module ridged_step(width, length, height) {
    union() {
        // Base step
        cube([width, length, height]);
        
        // Add ridges on top for better grip
        translate([0, 0, height])
            ridges_on_step(width, length);
    }
}

module ridges_on_step(width, length) {
    // Single ridge at the front edge of the step for better grip
    translate([0, 0, 0])
        cube([width, ridge_width, ridge_height]);
}

// ===== CUSTOMIZATION NOTES =====
// To customize this design:
// 1. Adjust platform_length and platform_width for your aquarium size
// 2. Modify wall_height based on your turtle's size
// 3. Set upper_wall_height for the wall above the hook
// 4. Adjust hook_drop for how far it extends behind the glass
// 5. Set glass_thickness to match your aquarium glass thickness
// 6. Configure ramp_width for the ramp width
// 7. Set ramp_height to control how deep the ramp goes (distance down from platform)
// 8. Set ramp_length for the total ramp length
// 9. Adjust ridge_height and ridge_width for better grip on step edges
// 10. All measurements are in millimeters
