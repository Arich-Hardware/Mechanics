//
// 3D model for EMPHATIC A-RICH SiPMs and electronics
// 
// Supports either 10x10 or 9x9 geometry
//   (adjust the x_count, y_count and diam settings)
//


readout_draw = 1;		/* enable "flat" CITIROC display */
cooling_draw = 0;		/* enable cooling plate display */
cooling_extend = 0;		/* extend cooling outside box */
cooling_pipe = 0;
backplane_draw = 1;		/* draw "backplane" boards */
sipm_draw = 0;			/* enable SiPM module display */
disc_draw = 0;			/* enable Cherenkov ring */
corner_fill = 1;		/* fill corners */
box_draw = 0;			/* draw simple enclosure */

draw_panel = 1;
draw_hv_mod = 0;
zynq_draw = 0;
conn_draw = 1;
simple_trenz = 1;

draw_thermal_pad = 1;

prototype = 0;			/* prototype version 2 CITIROC */
// (overrides array size and other things when 1)

// ---------- rendering details ----------
// size of the big array (nom 9x9)
x_count = prototype ? 1 : 9;
y_count = prototype ? 1 : 1;


// select CITIROC package
use_citiroc_bga = 1;

cooling_alpha = 0.75;		/* transparency of cooling plate */

// separation from installed position for viewing / animation
// (param $t goes from 0..1 for animation)

cooling_offset = 0;
backplane_offset = 0;
readout_offset = 0;

//---------- SiPMs ----------

sipm_conn_offset = 4;		/* SiPM connector offset from board edge */
// (also applies to FPGA connector)

// Hamamatsu SiPM 4x4 25x25mm
pixel_pitch = (25.0/4.0);
sipm_pitch = 25.50;
sipm_gap = 0.5;
sipm_size = sipm_pitch-sipm_gap;
sipm_thick = 1.3;

// for now this should be 500 for 10x10 or 450 for 9x9
// diam = 450.0;
diam = x_count * sipm_pitch * 2;

// module pitch
module_size = sipm_pitch*2-sipm_gap*2;
module_pitch = sipm_pitch*2;

//---------- generic PCB parameters ----------

// generic PCB thickness
pcb_thick = 1.6;

// PCB edge gap for visibility
pcb_gap = 1.0;

// Vertical PCB parameters
vert_pcb_Zoffset = 19.3;		/* offset in +Z so connectors mate*/
vert_pcb_Yoffset = -4;		/* offset in +Y */

vert_pcb_Zsize = 110;		/* board size in Z */

//---------- cooling plate ----------
cooling_thick = 8;		/* cooling plate thickness */
thermal_thick = 1;		/* thermal pad thickness */

cooling_edge = 55;		/* cooling edge outside box */



//---------- Samtec Connectors ----------

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

cool_slot_wid_clear = 1.25;
cool_slot_len_clear = 2;

// calculate position of connectors based on CITIROC option
// for "flat" CITIROC, offset by "sipm_conn_offset" from board edge
// for "vertical" option, uniform spacing
// function conn1_pos() = -sipm_pitch*0.5;
// function conn2_pos() = -sipm_pitch*1.5;

// fixed location based on PCB design
// sipm_conn_spacing = 25.25;

function conn1_pos() = -12.63;
function conn2_pos() = -37.88;


module trenz_simple() {
}

module trenz(labl) {
     translate( [-25, -15, 4])
     text( size=3, text=labl);
     rotate( [180, 180, 0]) {
	  if( simple_trenz) {
	       color("#3030c0")
		    cube( [40, 30, 1.6]);
	       color("grey")
		    translate( [13, 8, 1.6])
		    cube( [15, 15, 1]);
	       color("black") {
		    translate( [7, 2, -10])
			 cube( [30, 6, 10]);
		    translate( [2, 21, -10])
			 cube( [30, 6, 10]);
	       }
	  } else {
	       color("#606060") import("trenz-0714.stl");
	  }
     }
}

module mars() {
     rotate( [180, 0, 0])
	  translate( [0, -27, 0])
     import( "mars.stl", convexity=3);
}
     

// SO-DIMM socket
module sodimm() {
     translate( [0, 4.5, 0]) {
	  rotate( [0, 0, -68]) {
	       color("#404040") import( "dimm_angle.stl", convexity=3);
	       rotate( [0, 90, 0])
		    translate( [-48, 5, 0])
		    color("#707000")
		    mars();
	  }
     }
}

// AD7585D HV module
module hv_mod() {
     color("#e03030")
     cube( [35.6, 39, 5.4]);
     translate( [7, 15, 6])
	  text( size=4, text="AD7585");
}

// samtec backplane connector
// ERF8-060-05.0-L-DV-TR.stl
module samtec_erf8() {
//     scale( [25.4, 25.4, 25.4]) {
	  color("#404040") import( "ERF8-060-05.0-L-DV-TR.stl", convexity=3);
//     }
}     

// samtec readout board connector
// ERM8-060-01-L-D-RA-TR.stl
module samtec_erm8() {
     color("#808040") import( "ERM8-060-01-L-D-RA-TR.stl", convexity=3);
}     

// samtec tall stacking header
module samtec_tall_conn() {
     scale( [25.4, 25.4, 25.4]) {
	  color("#404040") import( samtec_tall, convexity=3);
     }
}

module samtec_socket_conn() {
     scale( [25.4, 25.4, 25.4]) {
	  color("#404040") import( samtec_socket, convexity=3);
     }
}

module rj45_jack() {
     translate( [27, -2.5, -34])
	  color("#505050") import( "RJ45_jack.stl", convexity=3);
}

// ----- cooling pipe ------
     pipe_dia = 5;
     pipe_len = cooling_edge*2+diam;
     bend_dia = cooling_edge/5;
     


module draw_cooling_pipe() {
	       color("red") {
		    rotate( [0, 0, 180])
		    rotate_extrude( angle=180) {
		    translate( [bend_dia, 0])
			 circle( d=pipe_dia);
 	            }
		    rotate([270, 90, 0]) {
			 translate( [0, cooling_edge/4-pipe_dia/2, 0])
			      cylinder( d=pipe_dia, h=pipe_len);
			 translate( [0, -(cooling_edge/4-pipe_dia/2), 0])
			      cylinder( d=pipe_dia, h=pipe_len);
			 }
	       }
}



// ---------- Box parameters ----------
// pseudo front-panel dimensions
panel_height = module_pitch-pcb_gap;
panel_thick = 1.6;
panel_overhang = 12;

box_height = diam+2*panel_overhang;
box_width = diam-conn1_pos();
box_depth = vert_pcb_Zoffset + vert_pcb_Zsize;

box_posX = -panel_overhang;
box_posY = conn1_pos();
box_posZ = 0;

// readout_pcb_height = prototype ? 100 : diam;
readout_pcb_height = prototype ? 450 : diam;

module box() {
     translate( [box_posX, box_posY, box_posZ]) {
	  color( [0.5, 0, 0, 0.55]) {
	       cube( [box_height, box_width, box_depth]);
	  }
     }
}


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



// draw one 2x2 SiPM array with a PCB and two Samtec connectors on back
// if enabled, draw a CITIROC module too
// if enabled, draw a piece of the cooling plate
module sipm_array() {

     if( sipm_draw) {
	  for( ix=[0:1]) {
	       for( iy=[0:1]) {
		    translate( [ix*sipm_pitch, iy*sipm_pitch, 0]) sipm();
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


     if( cooling_draw) {
	  translate( [0, 0, pcb_thick+1+cooling_offset]) {
	       // draw thermal pads cooling plate with cutouts for connectors using difference()
	       difference() {
		    // draw thermal pads and cooling plate
		    union() {
			 if( draw_thermal_pad)
			 color([0.5, 0, 0, cooling_alpha])
			      // thermal pad
			      cube( [module_pitch, module_pitch, thermal_thick]);
			 translate( [0, 0, thermal_thick])
			      // cooling plate
			      color([0.35, .25, 0.75, cooling_alpha])
			      cube( [module_pitch, module_pitch, cooling_thick]);
		    }
		    translate( [0, 0, -1])
			 union() {
			 // cutouts for connectors:  this is a mess!
			 // need a module to do this
			 rotate( [90, 0, 0]) {
			      translate( [ module_pitch/2-samtec_mw_len/2-cool_slot_len_clear, 
					   0, 
					   conn1_pos() -samtec_mw_wid/2-cool_slot_wid_clear])
				   cube( [samtec_mw_len+cool_slot_len_clear*2,
					  cooling_thick+thermal_thick+2, 
					  samtec_mw_wid+cool_slot_wid_clear*2]);
			      translate( [module_pitch/2-samtec_mw_len/2-cool_slot_len_clear, 
					  0, 
					  conn2_pos()-samtec_mw_wid/2-cool_slot_wid_clear])
				   cube( [samtec_mw_len+cool_slot_len_clear*2,
					  cooling_thick+thermal_thick+2, 
					  samtec_mw_wid+cool_slot_wid_clear*2]);

			 }
		    }
	       }
	      
	  }
     }

}



module sipm_pcb() {
     color("green") {
	  cube( [sipm_pitch*2-pcb_gap, sipm_pitch*2-pcb_gap, pcb_thick]);
     }
}


// CITIROC in LQFP160
lqfp_size = 28;
lqfp_thick = 1.6;
module lqfp160(colr,labl) {
     color(colr) cube( [lqfp_size, lqfp_size, lqfp_thick]);
     translate( [5, 5, lqfp_thick])
	  text( size=3, text=labl);

}

// CITIROC in BGA 12x12 mm for 32 channels (two SiPM)
bga353_size = 12;
bga353_thick = 1.2;
module bga353( colr, labl) {
     color(colr) cube( [bga353_size, bga353_size, bga353_thick]);
     rotate( [0, 0, 0]) translate( [ 0, bga353_size/2,  bga353_thick])
	  text( size=2, text=labl);
}

// CITIROC in BGA 12x12 mm for 32 channels (two SiPM)
module citiroc( colr, labl) {
     if( use_citiroc_bga && !prototype)
	  bga353( colr, labl);
     else
	  lqfp160( colr, labl);
}

// // Vertical option CITIROC PCB
// module vert_pcb() {
//      color( [0, 0.45, 0.45, 0.75])
// 	  cube( [sipm_pitch*2-pcb_gap, pcb_thick, vert_pcb_Zsize]);
//      translate( [10, 0, 10]) {
// 	  rotate( [90, 0, 0]) {
// 	       citiroc( "brown","CITIROC");
// //	       lqfp160("brown","CITIROC");
// 	       translate( [10, 40, 0])
// 	       fpga();
// 	  }
//      }
// }

// Xilinx FPGA sizes for plausible Artix-7 parts
//   Pkg         mm     max I/O
//   CPGA196     8x8    100  (XC7S6, XC7S15)
//   CSGA225     13x13  150  (XC7S6, XC7S15, XC7S25)
//   FTG256      17x17  170  (XC7A15T, 35T, 50T, 75T, 100T)
//   FGG484      23x23  285  (XC7A75, 100, 200)
//   F{BG}G676   27x27  400  (XC7A200)
//   FFG1176     35x35  500  (XC7A200)

// fpga_size = vertical_citiroc ? 13 : 35;
fpga_size = 23;


module fpga() {
     translate( [-fpga_size/2, -fpga_size/2, pcb_thick])
	  color("brown") 
	  cube( [fpga_size, fpga_size, 2]);
     translate( [-3, 3, 4])
	  text( size=4, text="FPGA");
}

center_x = (module_pitch*x_count)/2;
center_y = (module_pitch*y_count)/2;

// is (ix, iy) inside a 250mm circle?
function lt250(ix,iy) = sqrt( pow((0.5+ix)*module_pitch-center_x,2) + 
			 pow((0.5+iy)*module_pitch-center_y,2))
		   < diam/2;

// backplane connector spacing (Y direction)
pitch_y = (diam-2*module_pitch)/5;
bp_loop_y = prototype ? [50] : [ module_pitch : pitch_y : diam-module_pitch];

// draw a readout board
// always 500mm tall
// populate CITIROC where needed
// two large FPGA at center


citiroc_stagger = 15;

// fpga_pos = [ 2, 4, 7];  // three
fpga_pos = [ 1, 2, 4, 5, 7, 8 ];  // six

// fpga_pos = [ 2, 3, 4, 5, 6 ];  // five



module readout_pcb(row) {

     // adjust position

     // draw one long PCB
     color( [0, 0.4, 0, 1])
	  cube( [readout_pcb_height, pcb_thick, vert_pcb_Zsize]);

     // draw panel, for now PCB is in the middle which is a bit odd
     if( draw_panel)
     translate( [-panel_overhang, -panel_height/2, vert_pcb_Zsize])
	  color( [0.7, 0.7, 0.7, 0.5])
	  cube( [readout_pcb_height+2*panel_overhang, panel_height, panel_thick]);

     // RJ-45 jack
     translate( [30, pcb_thick, vert_pcb_Zsize-5])
	  rotate( [0, 0, 180])
	  if( conn_draw && draw_panel)
	  rj45_jack();


     // Enclustra Zynq SO-DIMM
     if( zynq_draw) {
	  translate( [65, pcb_thick, vert_pcb_Zsize-40])
	       rotate( [0, 270, 0])
	       sodimm();
     }

     // HV module
     if( draw_hv_mod)
     translate( [readout_pcb_height-10, pcb_thick, vert_pcb_Zsize-10])
	  rotate( [270, 90, 0])
	  hv_mod();
     
     // loop over CITIROC and install needed ones
     // (missing ones in light grey)
     for( ix=[0:x_count-1]) {
	  translate( [ix*module_pitch, 0, 0]) {
	       translate( [45, pcb_thick, 25]) {
		    rotate( [90, 0, 180]) {
			 if( prototype) { /* prototype CITIROCs, FPGA */
			      translate( [5, 0, 0]) {
				   citiroc("brown","CITIROC");
				   translate( [-sipm_pitch-15, 0, 0])
					citiroc("brown","CITIROC");
			      }
				   translate( [15, 75, 10])
					trenz("Trenz");

			 } else { /* standard CITIROCs, FPGA */
			      if( lt250( ix, row) || corner_fill) {
				   // draw installed CITIROC
				   citiroc("brown","CITIROC");
				   translate( [sipm_pitch, citiroc_stagger, 0])
					citiroc("brown","CITIROC");
			      } else {
				   // draw greyed-out CITIROC
				   citiroc([0.75, 0.75, 0.75, 0.4]," ");
				   translate( [sipm_pitch, citiroc_stagger, 0])
					citiroc([0.75, 0.75, 0.75, 0.4]," ");
			      }
			      // 
			      if( search( ix, fpga_pos)) {
				   translate( [77, 70, 10])
					trenz();
			      }
			 }
		    }
	       }
	  }

     }

     // backplane connectors
     for( pos_y = bp_loop_y) {
	  translate( [pos_y, 4, 0])
	       rotate( [0, 180, 0])
	       if( conn_draw)
		    samtec_erm8();
     }

}

// draw backplane for one row of SiPM modules
module backplane_pcb( row) {
     translate( [0, module_pitch, 12])
     rotate( [0, 0, -90]) {
	  color( [0.6, 0.6, 0.2, 0.6])
	       %cube( [panel_height, readout_pcb_height, pcb_thick]);

	  for( ix=[0:x_count-1]) {
	       // SiPM connectors on the bottom
	       if( conn_draw)
	       if( lt250( ix, row) || corner_fill) {
		    rotate( [270, 0, 90]) {
			 translate( [prototype ? 45 : (ix+1)*module_pitch-sipm_pitch, 
				     0, conn1_pos()])
			      samtec_socket_conn();
			 translate( [prototype ? 45 : (ix+1)*module_pitch-sipm_pitch,
				     0, conn2_pos()])
			      samtec_socket_conn();
		    }
	       }
	  }
	  // backplane connectors on the top
	  for( pos_y = bp_loop_y) {
	       translate( [sipm_pitch, pos_y, 2])
		    rotate( [90, 0, 90])
		    if( conn_draw)
		    samtec_erf8();
	  }
     }

}




module array() {
    
     // draw extended cooling plate for chiller
     extend_size = 2*cooling_edge+x_count*sipm_pitch*2;

     if( cooling_extend) {
	  // draw a frame around the cooling plate
	  color([0.35, .25, 0.75, cooling_alpha])
	       translate( [-cooling_edge, -cooling_edge, sipm_thick + pcb_thick])
	       difference() {
	         cube( [extend_size, extend_size, cooling_thick]);
		 translate( [cooling_edge, cooling_edge, -1])
		      cube( [diam, diam, cooling_thick+2]);
	       }

	  // draw cooling pipe
     }

     if( cooling_pipe) {
	  translate( [-cooling_edge/2, -cooling_edge/2, sipm_thick+pcb_thick])
	       draw_cooling_pipe();
	  translate( [ diam+cooling_edge/2, -cooling_edge/2, sipm_thick+pcb_thick])
	       draw_cooling_pipe();
     }
     

     // draw an array of SiPM modules which fall within 25cm of center
     for( ix=[0:x_count-1]) {
	  for( iy=[0:y_count-1]) {
	       if( lt250(ix,iy) || corner_fill) {
		    translate( [prototype ? 20 : ix*module_pitch, 
				iy*module_pitch, 0]) sipm_array();
	       }
	  }
     }

     // draw the backplanes
     if( backplane_draw) {
	  ix = 0;
	  // loop over "slots", only one board per slot
	  for( iy=[0:y_count-1]) {
	       translate( [ix*module_pitch, iy*module_pitch, backplane_offset]) {
		    backplane_pcb( iy);
	       }
	  }
     }

     // draw the readout boards
     if( readout_draw) {
	  ix = 0;
	  // loop over "slots", only one board per slot
	  for( iy=[0:y_count-1]) {
	       translate( [ix*module_pitch, iy*module_pitch, 0]) {

		    translate( [0, vert_pcb_Yoffset, vert_pcb_Zoffset]) {
			 translate( [0, -(conn1_pos()+conn2_pos())/2, readout_offset])
			      readout_pcb( iy);
		    }

	       }
	  }
     }


     // draw a disk to indicate the 250mm radius
     if( disc_draw) {
	  translate( [center_x, center_y, -10]) {
	       color("red")
		    difference() {
		    cylinder( h=0.5, r=diam/2);
		    translate( [0, 0, -1])
			 cylinder( h=2, r=diam/2-2);
	       }
	  }
     }

}

//
//-------------------- main drawing --------------------

xsection = 0;

//translate( [diam, 0, 0])

// normal view
if( xsection == 0)
rotate( [90, 270, 0]) {
     array();
     if( box_draw) {
	  box();
     }
}

// 2D render SiPM, backplane etc
if( xsection == 1) {
     projection( cut=true)
     rotate( [0, 0, 90])
     translate( [0, 0, -5])
	  array();
}

// 2D render readout board
if( xsection == 2) {
     projection( cut=false)
     rotate( [90, 0, 0])
     array();
}
