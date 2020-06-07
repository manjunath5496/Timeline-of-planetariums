% Debugging with breakpoints (red dots on left), dbstep, dbcont, dbquit

% Import the csv data file
data = importdata('test.csv'); % Using semicolon supresses output

% Save desired variables in .mat file
save('data.mat', 'data');

% clear variables from workspace
clear

% Load matlab data file
load('data.mat')

% plot data (colon means all rows or all columns where the format is
% data(rows,columns)
figure(1)
plot(data(:,1),data(:,2))

% plot data as red points with a connecting line
% go here for fun line specs:
% http://www.mathworks.com/help/matlab/ref/linespec.html
figure(2)
plot(data(:,1),data(:,2),'r.-')

% Manipulate matrices (notice lack of terminal semicolon to display output)
A = [4,5; 3,5; 24,4;]
B = [42,5; 1,35; 2,44;]

C = A.*B
D = A./B
E = A+B

% Create vectors out of ranges of numbers
V = 1:0.1:10; % vector starting at 1, ending with 10, with 0.1 increments
U = 9:-0.1:0;

% Concatenate vectors and take some averages and standard deviations
H = horzcat(V,U);
L = vertcat(V',U'); % Priming gives you the vector transpose

M = mean(H);
S = std(H);

% Use some functions
eL = exp(L);
sL = sin(L);

% Plot with errorbars
h = figure(3);
errorbar(L,sL)
title('Awesome Plot')
xlim([0 200])
ylim([0 11])
xlabel('Monkey seconds^{-2}')
ylabel('Awesomeness_x')

saveas(h,'plot.fig')
saveas(h,'plot.pdf')
clf

for i=1:10
    if i>5
        -i
    else
        i
    end
end