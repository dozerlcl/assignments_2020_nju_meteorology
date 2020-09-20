%--------------------------------------------------------------------------
%Matlab script to calculate derivative using three different finite 
%difference formulas
%--------------------------------------------------------------------------
%CE 200B, Problem Set #1, Problem 3
%--------------------------------------------------------------------------
%Author: ???
%Date created: ???
%--------------------------------------------------------------------------

close all %close all figure windows
clear all %clear memory of all variables

%-------------------------------------------------------
%Define variables that do not change for different grids
%-------------------------------------------------------
L=3; %Length of domain
m=1; %counter for number of grid sizes to plot

%---------------------------------------------------------------
%Loop over different grid sizes (N = number of points in domain)
%---------------------------------------------------------------
for N = [8 16 32 64 128 256 512 1024 2048] 

  %-------------------------------------
  %Define resolution-dependent variables
  %-------------------------------------
  deltax = L/N; %Grid spacing
  x =0:deltax:L; %define x, grid
  nx=length(x); %number of points in grid

  f = sin(5*x); %function to be differentiated

  dfdx_exact = 5*cos(5*x); %exact (analytical) derivative

  %-----------------------------------------------------------------------
  %Initialize arrays for 3 schemes with NaNs so that un-used values at the 
  %edge of the domain will not be plotted. This isn't necessary, but just
  %makes the plotting a bit easier.
  %-----------------------------------------------------------------------
  dfdx_1st = NaN*ones(size(dfdx_exact));
  dfdx_2nd = NaN*ones(size(dfdx_exact));
  dfdx_4th = NaN*ones(size(dfdx_exact));

  %-----------------------------------------------------------------------
  %Compute derivatives with three different approximations
  %-----------------------------------------------------------------------
  for i=3:nx-2 %Notice the limits here
%       dfdx_1st(i) =  ???; %first order forward
%       dfdx_2nd(i) =  ???; %second order central
%       dfdx_4th(i) =  ???; %fourth order central
  end

  %-----------------------------------------------------------------------
  %Plot the exact and approximated derivatives for the case where N=16
  %-----------------------------------------------------------------------
  if (N == 16)
    figure
    plot(x,dfdx_exact,'-',x,dfdx_1st,'-.',x,dfdx_2nd,'--',x,dfdx_4th,':')
    xlabel('???')
    ylabel('???')
    legend('Exact','Forward difference - 1st order',...
          'Central difference - 2nd order', 'Central difference - 4th order')
  end

  %-----------------------------------------------------------------------
  %Extract the errors for x = 1.5, the midpoint of the domain
  %-----------------------------------------------------------------------
  dx(m) = deltax; %store the current deltax in an array for plotting later
%   midpoint = ???; %calculate the midpoint index 
  error_1st(m) = abs(dfdx_1st(midpoint)-dfdx_exact(midpoint));
% % %   error_2nd(m) = ???;
% %   error_4th(m) = ???;

  m = m +1; %Advance counter for number of grids
  
end %end of loop over different grid sizes

%-----------------------------
%Calculate slopes of lines
%-----------------------------
slope_1st = diff(log(error_1st))./diff(log(dx))
slope_2nd = diff(log(error_2nd))./diff(log(dx))
slope_4th = diff(log(error_4th))./diff(log(dx))

%--------------------------------
%Plot dx versus error at x = 1.5
%--------------------------------
figure
loglog(dx,error_1st,'-*',dx,???,'x--',dx,???,'+:')
xlabel('\Delta')
ylabel('Error at x=1.5')
legend('Forward difference - 1st order','Central difference - 2nd order', ...
      'Central difference - 4th order')
