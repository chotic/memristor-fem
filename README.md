# 	Finitie element method simulation of a simplified memristor model

## General description:
#### Author: Patrik Reizinger
#### Purpose: 
Created as the part of the course *Field Simulation with Finite Element Methods (BMEVIHVJV35)* at the __*Budapest University of Technology and Economics*__ __(BUTE)__.
For legal matters see the included *LICENSE* file, with the following __restrictions__: the use of this material for the above mentioned course or its successors is prohibited, except to study the project while seeking technical help, e.g how to use specific Matlab functions. But regarding the additional *content*, please do not use this material which was made available to help other enthusiasts gaining a better control above the *PDE Toolbox* of Matlab.


### memristor_pde.m
The __*memristor_pde.m*__ function creates a PDE model then porcesses it during the following steps:
- Geometry
- Mesh
- Boundary conditions
- PDE coefficient specification
- Solution

#### Functionality:
this function creates a simplified model for a memristor, specifiesand solves a PDE for it

##### Input arguments:
- semi_a: semiaxis of the ellipse (along the X-axis)
- semi_b: semiaxis of the ellipse (along the Y-axis)
- boundary_offset: offset of the material boundary (0 means the sigmoid is "centered" at 0)
- plot_flag: binary variable to switch the plot function on/off

##### Output arguments:
- results: solution of the PDE
- model: PDE model

##### Example use:
```matlab
[results, model] = memristor_pde(semi_a, semi_b, boundary_offset, plot_flag)
```

### process_results.m
The __*process_results.m*__ script makes the postporcessing and visualization on the solution(s) obtained with __*memristor_pde.m*__.

The following parameters can be specified to customize the created plots/animations:
- plot_mode:
    - 0 - u-plot
    - 1 - E + u-plot without c
    - 2 - E + u-plot with c (D)
- change_mode:
    - 0 - ellipse size will be changed
    - 1 - state boundary will be changed
    - 2 - ellipse and state boundary will be changed
- en_3D: while plotting, creates a 3D figure is set to nonzero
- write_video: flag to specify whether to write videos into file (.avi), target directory is ./videos
- show_animation: flag to specify whether to show the animations

##### Example use:
```matlab
process_results
```
