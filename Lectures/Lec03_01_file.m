function Lec03_01_file(fn)
% LEC02_01_FILE: Either requests a file name or uses one
% passed to it.
% Matlab test of file operations
%
global Data h0 filename
fid = 0; 
detrend = 0 ;
if nargin == 0 
	filename = input('Open file: ','s');
elseif fn == 1
	detrend = 1
else
	filename = fn
end
if ~detrend 
	[fid, message] = fopen(filename,'r');
	if fid == -1
		disp(message)
		ok = 0;
		return
	end	


	% Now we will try to read the file.  These
	% files have three header lines and then data
	%
	% Read the header lines
	H1 = fgetl(fid);
	H2 = fgetl(fid);
	disp(H2)
	H3 = fgetl(fid);
	% The rest of the file is numeric with three values per lines and we
	% can read all at once
	[Data,tot] = fscanf(fid,' %f %f %f');
	% Close the data file at this point
	fclose(fid);
	% Now reshape the Data into 3:tot/3 array
	num = tot/3;
	Data = reshape(Data,3,num);
    % Now use the find command to remove points with large error bars
    GoodSig = find(Data(3,:)<0.020);
    Data = [Data(1,GoodSig); Data(2,GoodSig); Data(3,GoodSig)];
    
	Data(2,:) = Data(2,:)*1000 ; % Convert to mm
	Data(3,:) = Data(3,:)*1000 ; % Convert to mm	
	h0 = 0;
else
    p = polyfit(Data(1,:),Data(2,:),1) ;
	Data(2,:) = Data(2,:) - polyval(p,Data(1,:)) ;
end
% Now make a simple plot of the data
if ~h0
   h0 = figure('Color',[0.8 0.8 0.8], ...
	'Position',[437 303 512 384], ...
	'Tag','Fig1');
	h1 = axes('Parent',h0, ...
		'Position',[0.1289    0.1120    0.6152    0.8151]);
else
   figure(h0);
end   


% We might want to demean and change the units to mm as well
MeanData = mean(Data(2,:));
fprintf(1,'Removing mean of %8.4f m from data\n',MeanData)
Data(2,:) = (Data(2,:) - MeanData);
Data(3,:) = Data(3,:);
hold off
errorbar(Data(1,:),Data(2,:),Data(3,:),'ro'); 
hold on
hp = plot(Data(1,:),Data(2,:),'bo'); % Save the graphics handle
set(hp,'MarkerFaceColor',[1 1 0]);
ylabel('Position (mm)'); 
title(strrep(strcat('Data file : ',filename),'_',' '))
figure(h0);
%
% Detrend button
h1 = uicontrol('Parent',h0, ...
	'Units','points', ...
	'Callback','Lec03_01_file(1)', ...
	'Position',[397 329 74 27], ...
	'String','Detrend', ...
	'Tag','Pushbutton1');






