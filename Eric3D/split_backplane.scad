//
// simple example of split backplane
//

thick = 3.2;
height = 500;
width = 270;

cut = 8;

sep = 0;


difference() {
     cube( [width, height, thick]);
     translate( [width-cut, -1, -1])
	  cube( [cut+1, height+2, 1+thick/2]);
}

rotate( [180, 0, 180])
translate( [-2*width-cut-sep, 0, -thick])
difference() {
     cube( [width, height, thick]);
     translate( [width-cut, -1, -1])
	  cube( [cut+1, height+2, 1+thick/2]);
}


