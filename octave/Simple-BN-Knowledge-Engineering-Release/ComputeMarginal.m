%ComputeMarginal Computes the marginal over a set of given variables
%   M = ComputeMarginal(V, F, E) computes the marginal over variables V
%   in the distribution induced by the set of factors F, given evidence E
%
%   M is a factor containing the marginal over variables V
%   V is a vector containing the variables in the marginal e.g. [1 2 3] for
%     X_1, X_2 and X_3.
%   F is a vector of factors (struct array) containing the factors
%     defining the distribution
%   E is an N-by-2 matrix, each row being a variable/value pair.
%     Variables are in the first column and values are in the second column.
%     If there is no evidence, pass in the empty matrix [] for E.


function M = ComputeMarginal(V, F, E)

% Check for empty factor list
if (numel(F) == 0)
      warning('Warning: empty factor list');
      M = struct('var', [], 'card', [], 'val', []);
      return;
end

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE:
% M should be a factor
% Remember to renormalize the entries of M!
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% compute unnormalized measure given the evidence
F_observed = ObserveEvidence(F, E);

% compute the joint distribution of all the input factors
Joint = ComputeJointDistribution(F_observed);

% normalize
Z = sum(Joint.val);
Joint.val = Joint.val./Z;

% removing observed variables from scope of M
M = FactorMarginalization(Joint, setdiff(Joint.var, V)); % setdif gives us a vector containing elements in Joint.var that are not in V


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
end
