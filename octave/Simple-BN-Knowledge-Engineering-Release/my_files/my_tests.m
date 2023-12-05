% my test script

f_1 = struct('var', [1], 'card', [2], 'val', [0.11, 0.89]);
f_2 = struct('var', [2, 1], 'card', [2, 2], 'val', [0.59, 0.41, 0.22, 0.78]);
f_3 = struct('var', [3, 2], 'card', [2, 2], 'val', [0.39, 0.61, 0.06, 0.94]);
%%%%%%%%
% Factor Product
p_1 = FactorProduct(f_1,f_2);
%disp(p_1);

%%%%%%%%
% Factor Marginalization
% f_2 would take the form
%
% -+-----+-----+-----------------------+
%  | X_2 | X_1 | phi_f_1(X_2, X_1)     |
% -+-----+-----+-----------------------+
%  |  1  |  1  |     phi_f_1.val(1)    |
% -+-----+-----+-----------------------+
%  |  2  |  1  |     phi_f_1.val(2)    |
% -+-----+-----+-----------------------+
%  |  1  |  2  |     phi_f_1.val(3)    |
% -+-----+-----+-----------------------+
%  |  2  |  2  |     phi_f_1.val(4)    |
% -+-----+-----+-----------------------+
%
% The marginalization of X_ would result in
% -+-----+---------------------------------------+
%  | X_2 |  phi_m_1(X_2)                         |
% -+-----+---------------------------------------+
%  |  1  |     phi_f_1.val(1) + phi_f_1.val(3)   |
% -+-----+---------------------------------------+
%  |  2  |     phi_f_1.val(2) + phi_f_1.val(4)   |
% -+-----+---------------------------------------+
%


% m_1 = FactorMarginalization(f_2, 2)
% disp(m_1);

%%%%%%%%
% Observe Evidence
%
% First learning what SetValueOfAssignment does:
%
% executing    phi = SetValueOfAssignment(phi, [2 2 1], 6)
%
% causes the value of phi(X_3 = 2, X_1 = 2, X_2 = 1) to be set to 6. Note
% that because MATLAB/Octave passes function arguments by value (not by
% reference), SetValueOfAssignment *does not modify* the factor that you
% passed in. Instead, it returns a new factor with the modified value for
% the specified assignment; this is why we reassigned phi to the result of
% SetValueOfAssignment.
%
%

%mod_f_1 = SetValueOfAssignment(f_1, [2], 0);
%disp(mod_f_1);

% mod_f_2 = SetValueOfAssignment(f_2,[1 1],-99);
% disp(mod_f_2);

%mod_f_2 = SetValueOfAssignment(f_2, [1 2], -99);
%disp(mod_f_2);

%mod_f_2 = SetValueOfAssignment(f_2, [2 1], 99);
%disp(mod_f_2);

%mod_f_2 = SetValueOfAssignment(f_2, [2 2], 99);
%disp(mod_f_2);

% These are invalid because we need to give an assignment to all variables in the factos.
% However, these dodo not return an error

%mod_f_2 = SetValueOfAssignment(f_2, [2], 99); % invalid use of SetValueOfAssignment
%disp(mod_f_2);

%mod_f_2 = SetValueOfAssignment(f_2, [1], 99); % invalid use of SetValueOfAssignment
%disp(mod_f_2);

% Observe Evidnce Testing
%   `evidence` is an N-by-2 matrix, where each row consists of a variable/value pair.
%     Variables are in the first column and values are in the second column.
%
%            assignments = IndexToAssignment(1:length(F.val), F.card);
%
%            % index of all rows in the CPT of F
%            out = 1:rows(assignments);
%
%            for k = 1:rows(E)
%              % find the column index in `assignments` for the evidence variable in E
%              col_of_var_j = find(F.var == E(k,1));
%
%              % find the row index(s) in `assignments` where the evidence variable in E = value
%              observed_value_indices = find(assignments(:,col_of_var_j) == E(k,2));
%              observed_value_indices = transpose(observed_value_indices);
%
%              % keep only the row indices that are in observed_value_indices
%              out = intersect(out, observed_value_indices);
%
%            endfor
%
%
%            for k = 1:length(F.val)
%              % if the row of the CPT in F is not in the intersection of all our
%              % observed variable-value paris (as indexed in `out`), we assign the value 0 to that entry
%              if find(k == out)
%                continue
%              else
%                F.val(k) = 0;
%              endif
%            endfor

% we would expect the above evidence to result in the following modified factor:
% -+-----+-----+-----------------------+
%  | X_2 | X_1 | phi_f_1(X_2, X_1)     |
% -+-----+-----+-----------------------+
%  |  1  |  1  |     phi_f_1.val(1)    |
% -+-----+-----+-----------------------+
%  |  2  |  1  |     0                 |
% -+-----+-----+-----------------------+
%  |  1  |  2  |     0                 |
% -+-----+-----+-----------------------+
%  |  2  |  2  |     0                 |
% -+-----+-----+-----------------------+

% f_2 = struct('var', [2, 1], 'card', [2, 2], 'val', [0.59, 0.41, 0.22, 0.78]);
% evidence = [2 2; 1 1];
% ObserveEvidence(f_2, evidence)

% f_2 = struct('var', [2, 1], 'card', [2, 2], 'val', [0.59, 0.41, 0.22, 0.78]);
% evidence = [2 1];
% ObserveEvidence(f_2, evidence)


f_4 = struct('var', [1   2   4   8], 'card', [2   2   2   2], 'val', [0.2600   0.4600   0.3400   0.5400   0.4600   0.6600   0.5400   0.7400   1.7400   1.5400   1.6600   1.4600   1.5400   1.3400   1.4600   1.2600]);
% evidence = [2 1];
% ObserveEvidence(f_4, evidence)

% IndexToAssignment(1:length(f_4.val), f_4.card)

% Joint Distribution
f_1 = struct('var', [1], 'card', [2], 'val', [0.11, 0.89]);
f_2 = struct('var', [2, 1], 'card', [2, 2], 'val', [0.59, 0.41, 0.22, 0.78]);
f_3 = struct('var', [3, 2], 'card', [2, 2], 'val', [0.39, 0.61, 0.06, 0.94]);
%%%%%%%%
% Factor Product
p_1 = FactorProduct(f_1,f_2);
p_1
p_2 = FactorProduct(p_1,f_3);
p_2
p_3 = FactorProduct(f_1,f_4);
p_3
##f
Joint = struct('var', [], 'card', [], 'val', []);
##p_4 = FactorProduct(Joint,f_2);
##p_4

factors = [f_1  f_2  f_3];

##p_5 = ComputeJointDistribution(factors);
##p_5;
##
##
% FACTORS.INPUT(1) contains P(X_1)
FACTORS.INPUT(1) = struct('var', [1], 'card', [2], 'val', [0.11, 0.89]);

% FACTORS.INPUT(2) contains P(X_2 | X_1)
FACTORS.INPUT(2) = struct('var', [2, 1], 'card', [2, 2], 'val', [0.59, 0.41, 0.22, 0.78]);

% FACTORS.INPUT(3) contains P(X_3 | X_2)
FACTORS.INPUT(3) = struct('var', [3, 2], 'card', [2, 2], 'val', [0.39, 0.61, 0.06, 0.94]);

m_3 = ComputeMarginal([2, 3], FACTORS.INPUT, [1, 2]);

FACTORS.MARGINAL = struct('var', [2, 3], 'card', [2, 2], 'val', [0.0858, 0.0468, 0.1342, 0.7332]);
FACTORS.MARGINAL
m_3

FactorProduct(f_3, f_1)
