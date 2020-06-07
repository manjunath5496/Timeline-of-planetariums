% Matlab Lecture 1 example of operators
%
% Matlab script
% Define a pair of matrices in which we will operate

fprintf(1,'%s\n','------------------------------------------------')
fprintf(1,'%s\n','Example use of Matlab operators')
fprintf(1,'%s\n','------------------------------------------------')
fprintf(1,'%s','Define the two matrices a and b that we will use')
a = [2 1 ; 3 2] 
b = [4 2 ; -1 6]
%
% Standard matix multiply
fprintf(1,'%s','+++++Standard Matrix multiple of c = a*b')
c = a*b

% Now and element by element multiply
fprintf(1,'%s',+++++'Element by element multiple of d = a.*b')
d = a.*b

% Division of matrices (a*inv(b))
fprintf(1,'%s','+++++Division of matrices e = a/b')
e = a/b

% Backwards Division of matrices (inv(a)*b)
fprintf(1,'%s','+++++Backwards Division of matrices f = a\b')
f = a\b

% Backwards Division of matrices (inv(a)*b)
fprintf(1,'%s','+++++Division of matrices')
g = inv(a)*b

fprintf(1,'g is %8.3f %8.3f\n     %8.3f %8.3f\n',g)
fprintf(1,'NOTICE the order of the elements: Same as fortran\n')


