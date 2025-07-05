// Turtle Basking Spot for Aquarium
// All dimensions are parameterized for customization

// ===== PARAMETERS =====
// Main platform dimensions
platform_length = 100;     // Length of the basking platform (mm)
platform_width = 150;       // Width of the basking platform (mm)
platform_thickness = 5;    // Thickness of the platform (mm)

// Wall dimensions
wall_height = 40;          // Height of the back wall (mm)
wall_thickness = 5;        // Thickness of the wall (mm)
upper_wall_height = 40;    // Height of the upper wall above the hook (mm)

// Glass hook dimensions
hook_drop = 30;            // How far the hook drops down behind the glass (mm)
hook_thickness = 5;        // Thickness of the hook (mm)
glass_thickness = 6;       // Thickness of aquarium glass (mm)

// Ramp/stairs dimensions
ramp_width = 100;           // Width of the ramp (mm)
ramp_length = 50;         // Length of the ramp (mm)
ramp_start_height = -80;   // Starting height of ramp (negative = below platform)
use_stairs = true;         // true for stairs, false for smooth ramp
step_count = 10;            // Number of steps (if using stairs)
step_height = 10;           // Height of each step (mm)

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
    // Simple flat platform
    cube([platform_length, platform_width, platform_thickness]);
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
    total_height = platform_thickness - ramp_start_height;
    
    if (use_stairs) {
        // Create uniform rectangular steps at different heights
        step_length = ramp_length / step_count;
        // Calculate step positions so top step aligns with platform
        available_height = total_height - step_height;
        for (i = [0 : step_count - 1]) {
            // Position steps so the top of the highest step is at platform level
            step_z_position = ramp_start_height + (i * available_height / (step_count - 1));
            translate([0, i * step_length, step_z_position])
                cube([ramp_width, step_length, step_height]);
        }
    } else {
        // Create steep smooth ramp using polyhedron
        polyhedron(
            points = [
                // Bottom face at starting height
                [0, 0, ramp_start_height],
                [ramp_width, 0, ramp_start_height],
                [ramp_width, ramp_length, ramp_start_height],
                [0, ramp_length, ramp_start_height],
                // Top face (front at start height, back at platform height)
                [0, 0, ramp_start_height],
                [ramp_width, 0, ramp_start_height],
                [ramp_width, ramp_length, platform_thickness],
                [0, ramp_length, platform_thickness]
            ],
            faces = [
                [0, 1, 2, 3],  // Bottom
                [4, 7, 6, 5],  // Top (sloped)
                [0, 4, 5, 1],  // Front
                [2, 6, 7, 3],  // Back
                [0, 3, 7, 4],  // Left
                [1, 5, 6, 2]   // Right
            ]
        );
    }
}

// ===== CUSTOMIZATION NOTES =====
// To customize this design:
// 1. Adjust platform_length and platform_width for your aquarium size
// 2. Modify wall_height based on your turtle's size
// 3. Set upper_wall_height for the wall above the hook
// 4. Adjust hook_drop for how far it extends behind the glass
// 5. Set glass_thickness to match your aquarium glass thickness
// 6. Configure ramp_width, ramp_length, and step settings for the ramp
// 7. Set ramp_start_height (negative value) to control ramp steepness
// 8. Set use_stairs to true for steps, false for smooth ramp
// 9. All measurements are in millimeters

// ===== PRINTING NOTES =====
// - Print with the platform flat on the bed
// - Use PLA or PETG for aquarium safety
// - Consider adding supports for the hook overhang
// - Post-process: sand smooth and ensure no sharp edges
