% Example of using a dialog box to enter file
% names

% First get the directory for the current folder
d = dir ;
%
% This generates a structure containing information
% about the directory.  Get all the names that start
% with mb_.  These are the data files we want. Note
% that dnames is saved as a cell array.
dnames = {d.name};
% get all file names with mb_ in the first three characters
dnames = dnames(strncmp(dnames,'mb_',3));
ok = 1; fnum = 0;
while ok
	[fnum,ok] = listdlg('PromptString','Select a file: ', ...
					'SelectionMode','single', ...
					'ListString',dnames, ...
					'InitialValue',fnum+1)
	if ok
		dnames(fnum)
%		disp(['You selected: ',dnames(fnum)])
		filename = dnames{fnum};
        fprintf(1,'%s %s \n','You selected: ',filename)
		Lec03_01_file(filename) ;
	end
end	


