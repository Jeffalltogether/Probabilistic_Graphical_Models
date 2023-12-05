%COMPUTEEXACTMARGINALSBP Runs exact inference and returns the marginals
%over all the variables (if isMax == 0) or the max-marginals (if isMax == 1).
%
%   M = COMPUTEEXACTMARGINALSBP(F, E, isMax) takes a list of factors F,
%   evidence E, and a flag isMax, runs exact inference and returns the
%   final marginals for the variables in the network. If isMax is 1, then
%   it runs exact MAP inference, otherwise exact inference (sum-prod).
%   It returns an array of size equal to the number of variables in the
%   network where M(i) represents the ith variable and M(i).val represents
%   the marginals of the ith variable.
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function M = ComputeExactMarginalsBP(F, E, isMax)

% initialization
M = [];
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Implement Exact and MAP Inference.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% create the clique tree
P = CreateCliqueTree(F, E);

% calibrate the tree
P = CliqueTreeCalibrate(P, isMax);

% get the list of variables in the network in ascending order
network_vars = [];
for i = 1:length(P.cliqueList)
  for v = 1:length(P.cliqueList(i).var)
    if ~ismember(P.cliqueList(i).var(v), network_vars)
      network_vars = [network_vars P.cliqueList(i).var(v)];
    endif
  endfor
endfor
network_vars = sort(network_vars);
##
##disp('netowrk variables:');
##disp(network_vars);

% Initialize M
M = repmat(struct('var', [], 'card', [], 'val', []), 1, length(network_vars));

% once calibrated all the cluques should agree on the final marginals of the
% variables in their sepset
% therefore, we can use the first clique we find with the variable of interest

% loop through all variables
for v = 1:length(network_vars)
  curr_v = network_vars(v);
  % loop through all the calibrated cliques
  for c = 1:length(P.cliqueList)
    if ismember(curr_v, P.cliqueList(c).var)
      % get list of variables to marginalize out
      vars_to_marginalize = P.cliqueList(c).var(P.cliqueList(c).var != curr_v);

      % marginalize and then normalize
      if isMax == 0
        marginal_vect = FactorMarginalization(P.cliqueList(c), vars_to_marginalize).val;
        marginal_vect = marginal_vect/sum(marginal_vect);
      endif

      if isMax == 1
        marginal_vect = FactorMaxMarginalization(P.cliqueList(c), vars_to_marginalize).val;
      endif

      % append to M
      M(v).var = curr_v;
      indx = find( P.cliqueList(c).var == curr_v );
      M(v).card = P.cliqueList(c).card(indx);
      M(v).val = marginal_vect;
      break
    endif
  endfor
endfor

##  for i = 1:length(M)
##    disp(i)
##    disp(M(i))
##  endfor

end
