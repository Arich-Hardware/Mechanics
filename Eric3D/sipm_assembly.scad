
sipm_draw = 1;
conn_draw = 1;
sipm_pcb_draw = 1;

sipm_pcb_only1 = 0;

sipm_board_flip = 0;

// Hamamatsu SiPM 4x4 25x25mm
pixel_pitch = (25.0/4.0);
sipm_pitch = 25.50;
sipm_gap = 0.5;
sipm_size = sipm_pitch-sipm_gap;
sipm_thick = 1.3;

// Dimensions from datasheet for MW series (tall stack header)
samtec_tall = "MW-34-03-G-D-245-065-ES.stl";
samtec_mw_pins = 34;
samtec_mw_len = samtec_mw_pins;
samtec_mw_wid = 3.18;

// Dimensions from datasheet for CLM series (socket)
samtec_clm_pins = 40;
samtec_clm_len = samtec_clm_pins+.318; 
samtec_clm_wid = 2.54;
samtec_socket = "CLM-134-02-F-D.stl";

// generic PCB thickness
pcb_thick = 1.6;

// PCB edge gap for visibility
pcb_gap = 1.0;

sipm_board_size = sipm_pitch*2-pcb_gap;


function conn1_pos() = -12.63;
function conn2_pos() = -37.88;

// draw one 4x4 SiPM with lines showing pixels
sipm_lines = 0.1;

module sipm() {
     color("blue") 
	  cube( [sipm_pitch-sipm_gap, sipm_pitch-sipm_gap, sipm_thick]);
     for( ix=[1:3]) {
	  translate( [ix*pixel_pitch, 0, -sipm_lines]) cube( [sipm_lines, sipm_size, sipm_lines]);
	  translate( [0, ix*pixel_pitch, -sipm_lines]) cube( [sipm_size, sipm_lines, sipm_lines]);
     }
}




module sipm_board() {
       if( sipm_draw) {
	  for( ix=[0:1]) {
	       for( iy=[0:1]) {
		    translate( [ix*sipm_pitch, iy*sipm_pitch, 0]) sipm();
	       }
	  }
       }
	  rotate( [90, 0, 0]) {
	       if( conn_draw) {
		    translate( [sipm_pitch, 3.2, conn1_pos() ])
			 samtec_tall_conn();
		    translate( [sipm_pitch, 3.2, conn2_pos() ])	       
			 samtec_tall_conn();
	       }
	  }
	  translate( [0, 0, sipm_thick])
	       sipm_pcb();
}

module sipm_pcb() {
     color("green") {
	  cube( [sipm_pitch*2-pcb_gap, sipm_pitch*2-pcb_gap, pcb_thick]);
     }
}

// samtec tall stacking header
module samtec_tall_conn() {
     scale( [25.4, 25.4, 25.4]) {
	  color("#404040") import( samtec_tall, convexity=3);
     }
}


// assembly jig

oborder = 10;
iborder = 5;

ycount = 3;
ypitch = sipm_board_size + oborder;

jig_xsize = sipm_board_size + 2*oborder;
jig_ysize = ycount * sipm_board_size + (1+ycount)*oborder;

for( iy=[0:ycount-1]) {

  translate( [0, iy*ypitch, 0]) {
    if( sipm_pcb_draw) {
      if( !sipm_pcb_only1 || iy == 0)
	if( sipm_board_flip)
	  rotate( [0, 180, 0])
	    translate( [-sipm_board_size, 0, -3*pcb_thick])
	    sipm_board();
	else
	  sipm_board();
    }
  }
}

difference() {

  union() {
    translate( [-oborder, -oborder, pcb_thick]) {
      cube( [jig_xsize, jig_ysize, pcb_thick]);
      translate( [0, 0, pcb_thick])
         cube( [jig_xsize, jig_ysize, pcb_thick]);
    }
  }  

  for( iy=[0:ycount-1]) {
    translate( [0, iy*ypitch, pcb_thick-0.1]) {
      cube( [sipm_board_size, sipm_board_size, pcb_thick+0.2]);
      translate( [iborder, iborder, pcb_thick+0.1])
           cube( [sipm_board_size-2*iborder, sipm_board_size-2*iborder, pcb_thick+0.2]);
    }
  }

}

