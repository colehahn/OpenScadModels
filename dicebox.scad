

$fn=64;

// ======================
// A5 + 10% footprint
// ======================

length = 225*0.84;
width = 156*0.84;

wall = 3;
corner_r = 16;
corner_extra_thickness = 15;

middle_h = 12.5;
box_size = 25.2;
vault_height = wall + box_size - 5;
tray_height = wall + box_size - middle_h;

// divider
divider = 3;
divider_position = 0.32;
divider_drop = 6.35;


// ======================
// Magnet settings
// ======================

magnet_d = 5.2;
magnet_depth = 3;
magnet_offset = 8;


// ======================
// Rounded rectangle
// ======================

module rounded_rect(x,y,r){
offset(r=r)
offset(delta=-r)
square([x,y]);
}


// ======================
// Magnet pockets
// ======================

module magnet_holes(z){

for (x=[magnet_offset,length-magnet_offset])
for (y=[magnet_offset,width-magnet_offset])
color([1,0.3,0.2])
translate([x,y,z])
cylinder(d=magnet_d,h=magnet_depth);
}


// ======================
// Correct D20 logo geometry
// ======================

module d20_logo(){

line = 0.5;

u = [0,7];
ur1 = [4,2.5];
ur2 = [6.2,3.5];
m = [0,-4.3];
b = [0,-7.2];
br = [6.2,-3.8];
ul1 = [-4,2.5];
ul2 = [-6.2,3.5];
bl = [-6.2,-3.8];

module edge(a,b){
hull(){
translate(a) circle(d=line);
translate(b) circle(d=line);
}
}

edge(u,ul2);
edge(u,ul1);
edge(u,ur1);
edge(u,ur2);
edge(ul2,ul1);
edge(ul1,ur1);
edge(ur1,ur2);
edge(ul2,bl);
edge(ul1,bl);
edge(ul1,m);
edge(ur1,m);
edge(ur1,br);
edge(ur2,br);
edge(bl,m);
edge(bl,b);
edge(br,m);
edge(br,b);
edge(m,b);

}


// ======================
// True 3D D20
// ======================

module d20(diameter=22){

phi=(1+sqrt(5))/2;

v=[
[-1, phi,0],[1, phi,0],[-1,-phi,0],[1,-phi,0],
[0,-1, phi],[0,1, phi],[0,-1,-phi],[0,1,-phi],
[phi,0,-1],[phi,0,1],[-phi,0,-1],[-phi,0,1]
];

f=[
[0,11,5],[0,5,1],[0,1,7],[0,7,10],[0,10,11],
[1,5,9],[5,11,4],[11,10,2],[10,7,6],[7,1,8],
[3,9,4],[3,4,2],[3,2,6],[3,6,8],[3,8,9],
[4,9,5],[2,4,11],[6,2,10],[8,6,7],[9,8,1]
];

scale(diameter/(2*phi))
polyhedron(points=v,faces=f);

}


// ======================
// Bottom vault
// ======================

module bottom_piece(){

difference(){

linear_extrude(vault_height)
rounded_rect(length,width,corner_r);

translate([wall,wall,wall])
linear_extrude(vault_height)
rounded_rect(length-2*wall,width-2*wall,corner_r+corner_extra_thickness);

// magnet pockets
magnet_holes(vault_height-magnet_depth);

// engraved logo
translate([length/2,0.5,vault_height/2])
rotate([90,0,0])
scale(1.6)
linear_extrude(1.2)
d20_logo();

translate([length/2,width+0.5,vault_height/2])
rotate([90,0,0])
scale(1.6)
linear_extrude(1.2)
d20_logo();

}

}


// ======================
// Middle layer
// ======================

module middle_plate(){

difference(){

linear_extrude(middle_h)
rounded_rect(length,width,corner_r);

translate([wall,wall,wall])
linear_extrude(middle_h)
rounded_rect(length-2*wall,width-2*wall,corner_r+corner_extra_thickness);

// magnets
magnet_holes(0);
magnet_holes(middle_h-magnet_depth);

}

}


// ======================
// Top tray
// ======================

module top_piece(){

divider_x = length*divider_position;

difference(){

union(){

difference(){

linear_extrude(tray_height)
rounded_rect(length,width,corner_r);

translate([wall,wall,wall])
linear_extrude(tray_height)
rounded_rect(length-2*wall,width-2*wall,corner_r+corner_extra_thickness);

}

translate([divider_x-divider/2,wall,wall])
cube([
divider,
width-2*wall,
tray_height-wall-divider_drop
]);

}

// magnets
magnet_holes(0);
magnet_holes(tray_height-magnet_depth);

}

}


// ======================
// Scene layout
// ======================

bottom_piece();

translate([0,width+30,0])
middle_plate();

translate([0,(width+30)*2,0])
 top_piece();


// ======================
// Highlight D20
// ======================

// color([1,0.3,0.2])

// translate([length*0.75,width*0.5,10+wall])
// rotate([58,0,36])
// d20(22);

