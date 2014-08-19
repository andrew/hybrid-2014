module myshape()
{
  difference() {
    union(){
      cube([30, 30, 30]);
      cube([60, 10, 10]);
    }
    translate([30, 30, 30])
      sphere(20);
	}
}

myshape();
