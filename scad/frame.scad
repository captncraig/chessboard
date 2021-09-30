
$height = 31.5;
$sq = 50;
$lip = 10;
$attack = 1.15;
$text = 2;
$txscale = .6;

rotate([180,0,0])
difference(){
    linear_extrude(height = $height,scale=$attack)square(size=$sq*8+$lip*2,center=true);
    translate([0,0,.1])cube([$sq*8,$sq*8,$height*2],center=true);
}


letters = ["A","B","C","D","E","F","G","H"];
nums = ["1","2","3","4","5","6","7","8"];
for (idx = [ 0 : len(letters) - 1 ] ) {
    
    // bottom
    translate([-$sq*4+$sq/2+$sq*idx,-$sq*4-$lip/2,0])
    scale($txscale)
    linear_extrude($text)
    text(letters[idx], valign="center",halign="center");
    
    // top
    translate([-$sq*4+$sq/2+$sq*idx,$sq*4+$lip/2,0])
    scale($txscale)
    rotate([0,0,180])
    linear_extrude($text)
    text(letters[idx], valign="center",halign="center");
    
     // left
    translate([-$sq*4-$lip/2,-$sq*4+$sq/2+$sq*idx,0])
    scale($txscale)
    linear_extrude($text)
    text(nums[idx], valign="center",halign="center");
    
    // right
    translate([$sq*4+$lip/2,-$sq*4+$sq/2+$sq*idx,0])
    scale($txscale)
    rotate([0,0,180])
    linear_extrude($text)
    text(nums[idx], valign="center",halign="center");
    
}