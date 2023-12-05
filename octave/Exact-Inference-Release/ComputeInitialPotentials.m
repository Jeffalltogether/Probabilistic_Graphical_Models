%COMPUTEINITIALPOTENTIALS Sets up the cliques in the clique tree that is
%passed in as a parameter.
%
%   P = COMPUTEINITIALPOTENTIALS(C) Takes the clique tree skeleton C which is a
%   struct with three fields:
%   - nodes: cell array representing the cliques in the tree.
%   - edges: represents the adjacency matrix of the tree.
%   - factorList: represents the list of factors that were used to build
%   the tree.
%
%   It returns the standard form of a clique tree P that we will use through
%   the rest of the assigment. P is struct with two fields:
%   - cliqueList: represents an array of cliques with appropriate factors
%   from factorList assigned to each clique. Where the .val of each clique
%   is initialized to the initial potential of that clique.
%   - edges: represents the adjacency matrix of the tree.
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function P = ComputeInitialPotentials(C)

% number of cliques
N = length(C.nodes);

% initialize cluster potentials
P.cliqueList = repmat(struct('var', [], 'card', [], 'val', []), N, 1);
P.edges = zeros(N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% First, compute an assignment of factors from factorList to cliques.
% Then use that assignment to initialize the cliques in cliqueList to
% their initial potentials.

% C.nodes is a list of cliques.
% So in your code, you should start with: P.cliqueList(i).var = C.nodes{i};
% Print out C to get a better understanding of its structure.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% assign the edges directly from our input data
P.edges = C.edges;

% Create a mapping of variables to cardinality
card_dict = struct();

% Iteratively add items to the struct in a for loop
for i = 1:size(C.factorList)(2)
  for j = 1:size(C.factorList(i).var)(2)
    key = num2str( C.factorList(i).var(j) );
    if ~isfield(card_dict, key)
      value = C.factorList(i).card(j);

      % Add the key-value pair to the struct
      card_dict.(key) = value;

    endif
  endfor
endfor

for i = 1:N
  % get variables in clique

  P.cliqueList(i).var = C.nodes{i};

  % get cardinality of vars in clique
  cardValues = [];
  for j = 1:length(P.cliqueList(i).var)
    variable_as_string = num2str(P.cliqueList(i).var(j));
    cardValues = [cardValues card_dict.(variable_as_string)];
  endfor
  P.cliqueList(i).card = cardValues;

  # create dummy values for the clique by assigning 1 to all variable-value combinations
  P.cliqueList(i).val = ones(1, prod(P.cliqueList(i).card));

endfor


# populate factors into clique tree only if the factor variables EXACTLY match the clique variables
used_factors = [];
for i = 1:N
  for j = 1:size(C.factorList)(2)
    if isequal(sort(C.factorList(j).var ), sort(C.nodes{i}))

      P.cliqueList(i) = FactorProduct(P.cliqueList(i), C.factorList(j));
      used_factors = [used_factors, j];

      continue
    endif
  endfor
endfor

for i = 1:N
  # populate remaining factors into clique tree wherever they first fit
  for j = 1:size(C.factorList)(2)
    if ~ismember(j, used_factors)
      if all(ismember(C.factorList(j).var, C.nodes{i}))
##        disp('C.factorList(j).var')
##        disp(C.factorList(j).var)
##
##        disp('C.nodes{i}')
##        disp(C.nodes{i})
##
##        disp('P.cliqueList(i)')
##        disp(P.cliqueList(i))

        P.cliqueList(i) = FactorProduct(P.cliqueList(i), C.factorList(j));
        used_factors = [used_factors, j];

        continue
      endif
    endif
  endfor
endfor


##for i = 1:N
##  disp(sprintf('P.cliqueList(%i)', i))
##  disp(P.cliqueList(i))
##  disp('~~~~~~~~~')
##endfor


end

