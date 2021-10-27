

inner_hole = 46;
wall = 2;
div = 1;
h = 20;
div_h = 1.2;

slot_w = 10;
slot_d = 5;

t_without_div = inner_hole + wall + wall;
total = t_without_div + div + div;

module sq2(){
    // outer divider
    difference(){
        cube([total,total,h+div_h]);
        translate([div,div,-.1])cube([t_without_div,t_without_div,h+100]);
    }
    difference(){
        translate([div,div,0])cube([t_without_div,t_without_div,h]);
        translate([div+wall,div+wall,-.1])cube([inner_hole,inner_hole,h+100]);
    }
}

// fudge values
f = .1;
g = -.05;

module sq(x=0,y=0){
    translate([x*total - x*div,y*total-y*div,0]){
        difference(){
            sq2();
            translate([(total-slot_w)/2,g,g])cube([slot_w,total+f,slot_d+f]);
            translate([g,(total-slot_w)/2,g])cube([total+f,slot_w,slot_d+f]);
        }
    }
}

difference(){
for ( x = [0 : 1] ){
        for ( y = [0 : 1] ){
                sq(x,y);
        }
}
//translate([g,g,g])cube([div+f,total*4+f,h+div_h+f]);
translate([g,g,g])cube([total*4+f,div+f,h+div_h+f]);
}