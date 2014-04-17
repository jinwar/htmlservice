%Main driver to run the web service maintainence.
% written by Ge Jin, jinwar@gmail.com
%

clear;

% make the plot of stacked phase velocity
disp('Making stack plots');
plot_stack

% make the status report
disp('Making status report');
status_maker

% make the catalog
disp('making event plots');
make_year_html(2014);
