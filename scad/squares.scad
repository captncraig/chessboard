
module hex(hole, wall, thick){
    hole = hole;
    wall = wall;
    difference(){
        rotate([0, 0, 30]) cylinder(d = (hole + wall), h = thick, $fn = 6);
        translate([0, 0, -0.1]) rotate([0, 0, 30]) cylinder(d = hole, h = thick + 0.2, $fn = 6);
    }
}


// first arg is vector that defines the bounding box, length, width, height
// second arg in the 'diameter' of the holes. In OpenScad, this refers to the corner-to-corner diameter, not flat-to-flat
// this diameter is 2/sqrt(3) times larger than flat to flat
// third arg is wall thickness.  This also is measured that the corners, not the flats. 
module hexgrid(box, holediameter, wallthickness) {
    a = (holediameter + (wallthickness/2))*sin(60);
    for(x = [holediameter/2: a: box[0]]) {
        for(y = [holediameter/2: 2*a*sin(60): box[1]]) {
            translate([x, y, 0]) hex(holediameter, wallthickness, box[2]);
            translate([x + a*cos(60), y + a*sin(60), 0]) hex(holediameter, wallthickness, box[2]);

        }
    }
        
}


$sq = 50;
$top = 1.2;
$hole = 10.28;


module standoff(x,y,conn){
    translate([x,y,$top]){
        $m3 = 2.4;
        $extra = 2 + $m3;
        $h = conn - $top;
        difference(){
            cylinder(d=$extra,h=$h,$fn=25);
            translate([0,0,-.001])cylinder(d=$m3,h=$h+.2,$fn=25);
        }
    }
}

module square(x,y,conn){
    translate([x,y,0])union(){
        difference(){
            // main square
            cube([$sq,$sq,$top]);
            // hex inlay
            translate([-1,-3,-1])hexgrid([60, 60, 1.4], 11.5470053838, 0.5);
            // 4 insets for frame
            translate([-.1,-.1,.71]){cube([$sq+.2,2.2,.5]);};
            translate([-.1,-.1,.71]){cube([2.2,$sq+.2,.5]);};
            translate([$sq-2.1,-.1,.71]){cube([2.2,$sq+.2,.5]);};
            translate([-.1,$sq-2.1,.71]){cube([$sq+.2,2.2,.5]);};
            // center hole
            translate([$sq/2,$sq/2,-.01])cylinder(d=$hole,h=10);
        }
        standoff(6.5,6.5,conn);
        standoff(41+2.5,41+2.5,conn);
    }
}

// connectors are slightly different heights. one is 5mm, other is 5.8
color("gray")square(0,0,5);
color("white")square(60,0,5.8);

