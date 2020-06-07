function result = gpsgui(option, breaks, edits)
% GPSGUI Function to control gui plots
%
% Get the current graphics handles
% Define constants we need
CompName = ['North';'East ';'Up   '];

sitehndl = findobj(gcbf, 'Tag','Listbox1');
comphndl = findobj(gcbf, 'Tag','PopupMenu1');
siten = get(sitehndl,'Value');
sites = get(sitehndl,'UserData');
comp = get(comphndl,'Value');
name = sites(siten,:); Comptext = CompName(comp,:);
PlotTitle = sprintf('Data %s %s',strrep(name,'_','\_'),Comptext);
%
% Generate the file name
fname = strcat('mb_',name,'.dat',num2str(comp,'%1d'));

switch(option)
	case 'Load'  ;
		[fid, message] = fopen(fname,'r');
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
		H3 = fgetl(fid);
		% The rest of the file is numeric with three values per lines and we
		% can read all at once
		[Data,tot] = fscanf(fid,' %f %f %f');
		% Close the data file at this point
		fclose(fid);
		% Now reshape the Data into 3:tot/3 array
		num = tot/3;
		Data = reshape(Data,3,num);
		
		set(gcbf,'UserData',Data);
		Data(2,:) = (Data(2,:)-mean(Data(2,:)))*1000 ; % Convert to mm
		Data(3,:) = Data(3,:)*1000 ; % Convert to mm
		% Remove the mean and plot
		hold off
		errorbar(Data(1,:),Data(2,:),Data(3,:),'ro'); 
		hold on
		hp = plot(Data(1,:),Data(2,:),'bo'); % Save the graphics handle
		set(hp,'MarkerFaceColor',[.8 .8 0]);
		set(hp','Tag','PlottedData');
		ylabel('Position (mm)'); 
		title(PlotTitle);
		% Initialize the Breaks and Edit values
		Initbe
	case 'Append' 
		[fid, message] = fopen(fname,'r');
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
		H3 = fgetl(fid);
		% The rest of the file is numeric with three values per lines and we
		% can read all at once
		[Datn,tot] = fscanf(fid,' %f %f %f');
		% Close the data file at this point
		fclose(fid);
		% Now reshape the Data into 3:tot/3 array
		num = tot/3;
		Datn = reshape(Datn,3,num);
		Data = get(gcbf,'UserData');
		Data = [Data, Datn];
		set(gcbf,'UserData',Data);
		Data(2,:) = (Data(2,:)-mean(Data(2,:)))*1000 ; % Convert to mm
		Data(3,:) = Data(3,:)*1000 ; % Convert to mm
		% Remove the mean and plot
		hold off
		errorbar(Data(1,:),Data(2,:),Data(3,:),'ro'); 
		hold on
		hp = plot(Data(1,:),Data(2,:),'bo'); % Save the graphics handle
		set(hp,'MarkerFaceColor',[1 .5 0]);
		set(hp','Tag','PlottedData');
		ylabel('Position (mm)'); 
		title(PlotTitle);
	case 'Break'
%		Get the times at which we should add breaks in the
%		times series 
		breaks = get(gcbo,'UserData');
		button = 3;
		while button == 3;
			[x, y, button] = ginput(1);
			breaks = [breaks; x] ;
			plot([x x],ylim,'y');
		end	
		set(gcbo,'UserData',breaks);
	case 'Edit'
		edits = get(gcbo,'UserData');
		hp = findobj(gcbf, 'Tag','PlottedData');	
		Data = get(gcbf,'UserData');
%		Get the data actually plotted on the screen		
		xdata = get(hp,'Xdata') ;
		ydata = get(hp,'Ydata') ;		
		button = 3;
		xsize = xlim; ysize = ylim;
		xtol = abs(xsize(2)-xsize(1))/100;
		ytol = abs(ysize(2)-ysize(1))/100;
		
		while button == 3;
			[x, y, button] = ginput(1);
			for i = 1:length(xdata)
				if abs(xdata(i)-x) < xtol & abs(ydata(i)-y) < ytol
%					We found point plotted, now find the time in
%					in the raw data, k is the point number in the
%					in the raw data set.
					k = i ;
					while abs(xdata(i)-Data(1,k)) > xtol/100
						k = k+1;
					end
					edits = [edits, k];
					plot(Data(1,k),ydata(i),'rx','MarkerSize',12);
				end
			end		
		end	
		set(gcbo,'UserData',edits);	
	case 'BlockEdit'
		zoom off;		% Turn off zoom in case it is on
		he = findobj(gcbf, 'Tag','Pushbutton4');
		edits = get(he,'UserData');
		hp = findobj(gcbf, 'Tag','PlottedData');	
		Data = get(gcbf,'UserData');
%		Get the data actually plotted on the screen		
		xdata = get(hp,'Xdata') ;
		ydata = get(hp,'Ydata') ;		
%       Wait until user presses the mouse button
		k = waitforbuttonpress;
		point1 = get(gca,'CurrentPoint');    % button down detected
		finalRect = rbbox;                   % return Figure units
		point2 = get(gca,'CurrentPoint');    % button up detected
		point1 = point1(1,1:2);              % extract x and y
		point2 = point2(1,1:2);
		p1 = min(point1,point2);             % calculate locations
		offset = abs(point1-point2);         % and dimensions

		for i = 1:length(xdata)
			if xdata(i) > p1(1) & xdata(i) < p1(1)+offset(1) & ...
			   ydata(i) > p1(2) & ydata(i) < p1(2)+offset(2)
%				We found point plotted, now find the time in
%				in the raw data, k is the point number in the
%				in the raw data set.
				k = i ;
				while xdata(i) ~= Data(1,k) 
					k = k+1;
				end
				edits = [edits, k];
				plot(Data(1,k),ydata(i),'rx','MarkerSize',12);
			end
		end	
		set(he,'UserData',edits);		
		
	case 'Detrend'
		breakhndl = findobj(gcbf, 'Tag','Pushbutton5');	
		breaks = get(breakhndl,'UserData');
		breaks = checkbr(breaks);
		edithndl = findobj(gcbf, 'Tag','Pushbutton4');	
		edits = get(edithndl,'UserData');
		
		Data = get(gcbf,'UserData');
		
		for i = 1:length(Data)
			if( Data(3,i) > 0.1 )
				edits = [edits,i];
			end
		end
edits
		eds = ones(1,length(Data));
		eds = logical(eds);
		for i = 1:length(edits)
			eds(edits(i)) = 0;
		end
		Data = Data(:,eds);

%		Do the least squares fit.  Set the time
%		reference to be the mid piont of the data
		meanT = mean(Data(1,:));
		nb = length(breaks);
		np = nb+2 ;
%		Form the partial derivatives for the estimation
%		Dimension first (for speed).  Parameters are:
%       1  -- Offset at MeanT
%       2  -- Linear rate (m/yr)
%       3-np -- Values of the offsets at the break times.
		a = zeros(length(Data(1,:)),np);
		for i = 1:length(Data)
			p(1) = 1 ; p(2) = Data(1,i)-meanT;			
			for j = 1:nb
				if( Data(1,i) > breaks(j) )
					p(j+2) = 1;
				else
					p(j+2) = 0;
				end
			end
			a(i,:) = p;
		end
%		Do the Least squares solution.  From pre-fit
%		Normal equations and solve.  Compute statistics
%		from the residuals to the fit.
		neq = a'*a ;
%		In case we have breaks that can not be determined
%		add a small apriori sigma to the diagonal for the
%		for the break estimates
		for i = 3:np
			if neq(i,i) ~= 0
				neq(i,i) = neq(i,i)*(1+1.d-6);
			else
				neq(i,i) = 1;
			end 
		end
		
		bvec = a'*Data(2,:)';

		soln = inv(neq)*bvec ;
		res = (Data(2,:) - (a*soln)')*1000;
%		Compute RMS scatter of residuals
		numdata = length(res) ;
		resrms = sqrt(res*res'/numdata) ;
		cov = inv(neq)*resrms^2 ;
		Data(3,:) = Data(3,:)*1000;
		hold off		
		errorbar(Data(1,:),res,Data(3,:),'ro'); 
		hold on
		hp = plot(Data(1,:),res,'bo'); % Save the graphics handle
		set(hp,'MarkerFaceColor',[1 1 0]);
		set(hp','Tag','PlottedData');
		ylabel('Position (mm)'); 
		title(PlotTitle);
%		Show where the breaks are on the plot
		for i = 1:length(breaks)
			x = breaks(i);
			plot([x x],ylim,'g');
		end
		
%		Write out the solution 
		fprintf(1,'Detrend of %s %s RMS scatter %10.1f mm from %5d data\n', ...
			name, Comptext, resrms, length(res));
		fprintf(1,'Solution:\n')
		fprintf(1,'Rate              %10.2f ± %6.2f mm/yr\n', ...
			soln(2)*1000, sqrt(cov(2,2)));
%		Now write out breaks
		for i = 1:length(breaks)
%			get the fractional part of the year and convert to month and
%			day
			yr = fix(breaks(i));
			fyr = mod(breaks(i),1) ;
			if mod(yr,4) == 0 
				doy = fyr*366 ;
			else
				doy = fyr*366 ;
			end
			ser = datenum(yr,1,doy) ;
			bdate = datevec(ser) ;
			fprintf(1,'Break %4d %2d %2d  %10.2f ± %6.2f mm\n',...
				bdate(1),bdate(2),bdate(3),soln(2+i)*1000, ...
				sqrt(cov(2+i,2+i)))
		end	
		
	end


function Initbe
% INITBE Initialized the breaks and edit arrays
%
% Set the breaks to a null array, and save call back
breaks = [];
breakhndl = findobj(gcbf, 'Tag','Pushbutton5');	
set(breakhndl,'UserData',breaks);
%
% Initialize and save the edits
edits = [];
edithndl = findobj(gcbf, 'Tag','Pushbutton4');	
set(edithndl,'UserData',edits);

function unbrk = checkbr(breaks)
% CHECKBR Check for duplicate times with breaks
%
ed = ones(1,length(breaks));
for i = 1:length(breaks)-1
	for j = i+1:length(breaks)
		if breaks(j) == breaks(i)
			ed(j) = 0;
			fprintf(1,' Removing duplicate break %d\n',j)
		end
	end
end
ed = logical(ed);
unbrk = breaks(ed);


