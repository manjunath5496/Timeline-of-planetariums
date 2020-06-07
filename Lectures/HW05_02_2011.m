% HW5_2: Matlab script file to rearrange names.
%
% Ask user for name
fprintf('\n----------------------------------------\n');
name = input('12.010 HW 05 Q2:\nEnter Name (first middle last) ','s');
%
% Convert to lower case so that we know state
name = lower(name);
%
% Find the blanks in the sting
blanks = strfind(name,' ');
if length(blanks) == 1
    % Only two names passed, so skip middle initial
    first = name(1:blanks(1)-1);
    first(1) = upper(first(1));
    last = name(blanks(1)+1:length(name));
    last(1) = upper(last(1));
    fprintf('%s, %s \n',last, first)
elseif length(blanks) == 2
    % Split of the names.  The function strtok could also be used to split
    % the string into parts.
    first = name(1:blanks(1)-1);
    middle = name(blanks(1)+1:blanks(2)-1);
    last = name(blanks(2)+1:length(name));
    first(1) = upper(first(1));
    middlei = upper(middle(1));
    last(1) = upper(last(1));
    fprintf('%s, %s %s.\n',last, first, middlei)
else
    fprintf('Too many names or spaces in %s\nProgram end\n',name)
end
