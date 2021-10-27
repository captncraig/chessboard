module piece(name, n=0){
    translate([n*50,0,0])
    difference(){
        union(){
            import(name, convexity=3);
            outer();
        }
        inner();
    }
}


module outer(){
    cylinder(d=15,h=11);
}

module inner(){
    translate([0,0,-.1])cylinder(d=10.32,h=10,$fn=20);
}


piece(name="/home/craig/Downloads/pawn-v5.stl");
piece(name="/home/craig/Downloads/rook-v1.stl",n=1);
piece(name="/home/craig/Downloads/knight-21-v3.stl",n=2);
piece(name="/home/craig/Downloads/bishop-v12.stl",n=3);
piece(name="/home/craig/Downloads/queen-20-v3.stl",n=4);
piece(name="/home/craig/Downloads/king-body-v2.stl",n=5);
