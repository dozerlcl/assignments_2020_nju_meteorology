%Wrapper code to run lid-driven cavity flow 

close all
clear all

%-----------------------------------------------------------------
%Example of how to run N-S solver:
%Set Reynolds number, integration time, and time step 
%-----------------------------------------------------------------
tf = 15;
dt = 0.002;
Re = 1000.;
nx = 64;
ny = 64;

[U,V,P,X,Y] = navier(Re,nx,ny,dt,tf); %call function

%Note - the plots from navier.m show several layers:
% --> velocity magnitude in filled color contours
% --> velocity vectors (blue)
% --> velocity streamlines (black)
% --> pressure contours (white)
%If you want to investigate any of these flow features further, you can modify
%the plotting loop or create additional plots here.


%--------------------------------------------------------------------------
%Here are some commands you will find useful to answer the questions in the
%problem set:
%--------------------------------------------------------------------------
%update boundary condition for U before plotting
U(:,end) = 1.0;

%extract center point velocity and store for later plotting/calculations
midx = floor((nx+2)/2);
midy = floor((ny+2)/2);
ucenter(1) = 0.5*U(midx,midy)+0.5*U(midx,midy+1); %average due to staggering
vcenter(1) = 0.5*V(midx,midy)+0.5*V(midx+1,midy);
dx(1) = 1/nx; %store grid spacing for plotting later


%--------------------------------------------------------------------------
%benchmark - compare to data from our finest grid
%--------------------------------------------------------------------------
% benchmark %call script - see benchmark.m


%--------------------------------------------------------------------------
%Additional thoughts for the convergence study:
%--------------------------------------------------------------------------
%Note: use Re = 0.1 for this part to ensure enough grid resolution.

%(1) Estimate the order of the scheme using equation 3.52 in F&P.
%(Do these steps separately for u and v.)

%(2) Then estimate error on your 128x128 grid using equation 3.53.

%(3) Calculate estimate of u and v values at center point on 256x256 grid.

%(4) Use the estimate on the 256 grid as your ``exact'' solution, and 
%calculate and plot the absolute error for all grids compared to the 256 grid.


