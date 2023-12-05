%MAXDECODING Finds the best assignment for each variable from the marginals M
%passed in. Returns A such that A(i) returns the index of the best
%instantiation for variable i.
%
%   For instance: Let's say we have two variables 1 and 2.
%   Marginals for 1 = [0.1, 0.3, 0.6]
%   Marginals for 2 = [0.92, 0.08]
%   A(1) = 3, A(2) = 1.
%
%   M is a list of factors, where each factor is only over one variable.
%
%   See also COMPUTEEXACTMARGINALSBP
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function A = MaxDecoding( M )


% initialization
% you should set it to the correct value in your code
A = [];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
% Compute the best assignment for variables in the network.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% get the list of variables in the network in ascending order
A = zeros(1, length(M));

for i = 1:length(M)
  [MAP_value, MAP_assignment] = max(M(i).val);
  A(M(i).var) = MAP_assignment;
endfor

##disp('A = ')
##disp(A)

end

