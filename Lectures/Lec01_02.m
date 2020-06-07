% Matlab Lecture 1 examples of syntax.
%
% Note the two different but equivalent fprintf structures
fprintf(1,'%s\n','------------------------------------------------')
fprintf(1,'Examples of different syntax rules\n')
fprintf(1, ...
      '%s\n','------------------------------------------------')

% Note: All of the variables from Lec01_01 are available here	  
whos
fprintf(1,'Arrays can be redefined if we wish a = [1 2 3 ; 3 4 5 ; 6 7 8]\n')
a = [1 2 3 ; 3 4 5 ; 6 7 8]
whos a
pause ; 

fprintf(1,'%s\n','------------------------------------------------')
fprintf(1,'I can set values in a if I wish a = [1:3 ; 3:5; 6:8]\n')
a = [1:3 ; 3:5; 6:8]

fprintf(1,'I can display all the elements of a(:)') 
a(:)

fprintf(1,'Or I can display just some of the elements a(1:4) and a(:,2)')
a(1:4)
a(:,2)

fprintf(1,'I can use the : construct on the left hand side to set elements a(:,2) = 0')
a(:,2) = 0


