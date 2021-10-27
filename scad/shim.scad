h=2;

dc = 1.5;
ds=1.5;
atk = 1.7;
difference(){
cylinder(d=10,h=h,$fn=30);
translate([0,0,-.01]){
    cylinder(d1=dc,d2=dc*atk,h+1,$fn=30);
    translate([2.54,0,0])
    cylinder(d1=ds,d2=ds*atk,h+1,$fn=30);
    translate([-2.54,0,0])
    cylinder(d1=ds,d2=ds*atk,h+1,$fn=30);
}
}