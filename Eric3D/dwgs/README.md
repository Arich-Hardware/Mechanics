# Mechanical Drawings

This folder contains drawings created by me (Hazen) intended to provide
input to the proper mechanical design.  DXF file geometry was extracted
either from my OpenSCAD "toy" model or PCB layouts.

**Cooling Plate**

```cooling_plate.dxf``` and ```cooling_plate_anno.dxf``` : 
The cooling plate.  Outer dimensions are approximate.  Thickness limited
to stacking height of the connectors (inner surface of PMT board to backplane
board is 8.4mm).  Cutouts are shown for Samtec ```MW-34-03-G-D-245-065-ES```
connectors with shrouds (Manufacturer drawings in corresponding folder).  
Actual shroud dimensions: 36 x 4.32mm.  Geometry extracted from OpenSCAD.

**SiPM Board**

```sipm_board_anno.dxf``` : The SiPM board with connector locations.  Geometry from PCB layout.

**Backplane**

```backplane.dxf``` : Overall dimensions shown just large enough to mount all SiPM boards.
Size can be increased but already manufacturing a board this large is a special
order item and quite expensive.

```readout_backplane_mating.dxf``` : Details (top view) of how one readout board
mates to the backplane with a right-angle connector.
