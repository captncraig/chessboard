$sq = 50;
$wall = 2;
$high = 30;

$inset = 30;
$low = 3;

difference(){
    cube([$sq*4,$sq*4,$high]);
    for ( x = [0 : 3] ){
        for ( y = [0 : 3] ){
            translate([$sq/2+$sq*x,$sq/2+$sq*y,$high/2-.001])
            cube([$sq-$wall*2,$sq-$wall*2,$high+10],center=true);
        }
        // long in x
        translate([$sq*2.7,$sq/2+$sq*x,$high/2+$low])cube([$sq*5,$inset,$high],center=true);
        // long in y
        translate([$sq/2+$sq*x,$sq*2.7,$high/2+$low])cube([$inset,$sq*5,$high],center=true);
    }
}

