size = 40;
spacing = 250;
face_angle = 41.81;
point_face_angle = 37.38;
corner_angle = 60;
blade_thickness = 2;
blade_size = 170;
module rock(bumps=0, seed=12343) {
    function fract(x) = x - floor(x);
    function rand(v) = fract(sin(v * 12.9898 + seed * 78.233) * 43758.5453);
    core_r = size;
    union() {
        // Base core
        sphere(r = 2*size);
        // Random bumps
        if (bumps > 0) for (i = [0:bumps-1]) {
            theta = rand(i*3+0) * 360;
            phi   = rand(i*3+1) * 180;
            dir = [
                cos(theta) * sin(phi),
                sin(theta) * sin(phi),
                cos(phi)
            ];
            offset = core_r * (0.5 + rand(i*5) * 1.2);
            bump_r = core_r * (1 + rand(i*7) * 0.4);
            translate([dir[0]*offset, dir[1]*offset, dir[2]*offset])
                sphere(r = bump_r, $fn=20);
        }
    }
}
// ======================
// Fixed cutting plane (NO rotation at all)
// ======================
module cut_plane() {
   rotate([0,-90,0]) cylinder(h=4*size, r=blade_size);
}
module blade() {
    rotate([0,-90,0]) cylinder(h=blade_thickness,r=blade_size);
}
// ======================
// Step builder
// ======================
module step(i) {
    //color([ i/30, 1, 1])
    if (i == 0) {
        translate([size*2.5, 0, 0])
       rock();
    }
    if (i == 1) {
        difference() {
           translate([-size*1, 0, 0])
                step(0);
            // Plane is fixed
            cut_plane();
        }
    }
    if (i == 2) {
        difference() {
            translate([size*1.5, 0, 0])
            rotate([0, -point_face_angle, 0])
            rotate([0, 0, 180])
            translate([size*-1.5,0,0])
                    step(1);
            cut_plane();
        }
    }
    if (i == 3 || i == 4 || i == 5 || i == 6) {
        difference() {
            translate([size*1.5,0,0])
            rotate(a=72, v=[1, 0, 0.763])
            translate([size*-1.5,0,0])
            step(i-1);
            cut_plane();
        }
    }
    if (i == 7) {
       difference() {
           translate([size*-0.5,0,0])
           rotate([0,0,180])
           translate([size*-1.5,0,0])
           step(i-1);
           cut_plane();
        }
    }
    if (i == 8 || i == 9 || i == 10 || i == 11) {
        difference() {
            translate([size*-0.5,0,0])
            rotate(a=72, v=[-1, 0, 0.763])
            translate([size*0.5,0,0])
            step(i-1);
            cut_plane();
        }
    }
    x_distance = size*0.3; // TODO: need to mathematically figure out the x distance here... at what distance should it be cut from the middle? 
    if (i == 12) {
        difference() {
            translate([x_distance,0,0]) 
            rotate([90,0,face_angle])
            translate([size*0.5,0,0])
            step(i-1);
            cut_plane();
        }
    }
    if (i == 13 || i == 14 || i == 15 || i == 16) {
        difference() {
            translate([x_distance,0,0])
            rotate(a=72, v=[1, 5.237, 0])
            translate([-x_distance,0,0])
            step(i-1);
            cut_plane();
        }
    }
    if (i == 17) {
        difference() {
            translate([x_distance*2.5,0,0])
            rotate([0, 0, 180])
            translate([-x_distance,0,0])
            step(i-1);
            cut_plane();
        }
    }
    if (i == 18 || i == 19 || i == 20 || i == 21) {
        difference() {
            translate([x_distance*2.5,0,0])
            rotate(a=72, v=[1, 5.237, 0])
            translate([x_distance*-2.5,0,0])
            step(i-1);
            cut_plane();
        }
    }
    if(i==22){
        translate([size,0,0])
        step(i-1);
    }

}
// ======================
// Render steps
// ======================
for (i = [1:22]) {
    translate([i * spacing, i * spacing, 0]) {
        blade();
        step(i);
    }   
}



