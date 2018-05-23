%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Memristor FEM simulation - script only
% Reizinger Patrik (2018)
%
% Functionality:
% this function creates evaulates the results obtained from a PDE problem
% solved with memristor_pde.m, and also it creates animations.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%% Parameters for the animation
en_3D = 1; % create 3D plot if 1
% plot_mode = 0; % u-plot
% plot_mode = 1; % E + u-plot without c
plot_mode = 2; % E + u-plot with c (D)
change_mode = 0; % ellipse size will be changed
% change_mode = 1; % state boundary will be changed
% change_mode = 2; % ellipse and state boundary will be changed

%%
% %% Epsilon charakteristics
% syms x;
% fplot((1-1./(1+exp(18e7*(x)))))
% xlim([-1e-7; 1e-7]);
% title('Az anyagjellemző súlyozására használt függvény');
% xlabel('Hossz [m]');
% ylabel('Függvényérték');

%% Animation init
n = 40;                  % number of pictures
% Bounding rectangle
% A - along x axis
% B - along y axis
rect_x = 4e-08;
rect_y = 2.5e-08;
A = 2*rect_x;
B = 2*rect_y;

% maxima placeholder
maxu = -Inf;
maxE = -Inf;
maxD = -Inf;

% material threshold offset
material_boundary = -rect_x:A/n:rect_x;

% semiaxes offsets
a_offset = linspace(0, 40e-9, n);
b_offset = linspace(0, 5e-9, n);

%% Solve for all variants
% and get maxima
for i=1:n
    
   switch change_mode
       case 0
           [R(i), M(i)] = memristor_pde(20e-9+a_offset(i), 10e-9+b_offset(i), 0, 0);
           
       case 1
           [R(i), M(i)] = memristor_pde(20e-8, 10e-9, material_boundary(i), 0);
       
       case 2
           [R(i), M(i)] = memristor_pde(20e-9+a_offset(i), 10e-9+b_offset(i), material_boundary(i), 0);
   end
   
   % get max of u
   if max(R(i).NodalSolution) > maxu
       maxu = max(R(i).NodalSolution);
   end
   
   % get max of E
   maxE_abs = max(sqrt(R(i).XGradients.^2 + R(i).YGradients.^2));
   if maxE_abs > maxE
       maxE = maxE_abs;
   end
   
   % get max of D
   [cgradx,cgrady] = evaluateCGradient(R(i));
   maxD_abs = max(sqrt(cgradx.^2 + cgrady.^2));
   if maxD_abs > maxD
       maxD = maxD_abs;
   end
   
end

%% Create animation
newplot;
title('Set size then press any key!')
disp('Set size then press any key!');
pause;
Jmap = load('Jmap.dat');

for i=1:n
    switch plot_mode
        case 0
            if en_3D
                pdeplot(M(i), 'XYData', R(i).NodalSolution, ... specify what to plot on the XY-plane with colors
                              'ZData', R(i).NodalSolution, ... specify value showed on the Z-axis
                              'FaceAlpha', 0.5, ... set the opacity of the face of the plot
                              'FlowData', [-R(i).XGradients, -R(i).YGradients], ... include a Quiver plot
                              'ColorMap', Jmap, ... colormap
                              'Contour', 'on' ... plot contours
                               );
            else
                 pdeplot(M(i), 'XYData', R(i).NodalSolution, ... specify what to plot on the XY-plane with colors
                               'FaceAlpha', 0.5, ... set the opacity of the face of the plot
                               'FlowData', [-R(i).XGradients, -R(i).YGradients], ... include a Quiver plot
                               'ColorMap', Jmap, ... colormap
                               'Contour', 'on' ... plot contours
                               );
            end
            
            title('Electric potential');
            caxis([-maxu maxu]);
            
        case 1
            if en_3D
               pdeplot(M(i), 'XYData', sqrt(R(i).XGradients.^2 + R(i).YGradients.^2), ... specify what to plot on the XY-plane with colors
                             'ZData', R(i).NodalSolution, ... specify value showed on the Z-axis
                             'FaceAlpha', 0.5, ... set the opacity of the face of the plot
                             'FlowData', [-R(i).XGradients, -R(i).YGradients], ... include a Quiver plot
                             'ColorMap', 'jet', ... colormap
                             'Contour', 'on' ... plot contours
                               );
            else
                pdeplot(M(i), 'XYData', sqrt(R(i).XGradients.^2 + R(i).YGradients.^2), ... specify what to plot on the XY-plane with colors
                              'FaceAlpha', 0.5, ... set the opacity of the face of the plot
                              'FlowData', [-R(i).XGradients, -R(i).YGradients], ... include a Quiver plot
                              'ColorMap', 'jet', ... colormap
                              'Contour', 'on' ... plot contours
                              );
            end
            
            title('Electric field');
            caxis([0 maxE]);
           
        case 2
            [cgradx,cgrady] = evaluateCGradient(R(i));
            
            if en_3D
                pdeplot(M(i), 'XYData', sqrt(cgradx.^2 + cgrady.^2), ... specify what to plot on the XY-plane with colors
                               'ZData', R(i).NodalSolution, ... specify value showed on the Z-axis
                               'FaceAlpha', 0.5, ... set the opacity of the face of the plot
                               'FlowData', [-R(i).XGradients, -R(i).YGradients], ... include a Quiver plot
                               'ColorMap', 'jet', ... colormap
                               'Contour', 'on' ... plot contours
                               );
            else
                 pdeplot(M(i), 'XYData', sqrt(cgradx.^2 + cgrady.^2), ... specify what to plot on the XY-plane with colors
                               'FaceAlpha', 0.5, ... set the opacity of the face of the plot
                               'FlowData', [-R(i).XGradients, -R(i).YGradients], ... include a Quiver plot
                               'ColorMap', 'jet', ... colormap
                               'Contour', 'on' ... plot contours
                               );
            end
            
            title('Electric displacement');
            caxis([0 maxD]);
            
    end
   F(i) = getframe(gcf); 
end
clf;
axes('Position', [0 0 1 1]);
movie(F, 10);