%CLIQUETREECALIBRATE Performs sum-product or max-product algorithm for
%clique tree calibration.

%   P = CLIQUETREECALIBRATE(P, isMax) calibrates a given clique tree, P
%   according to the value of isMax flag. If isMax is 1, it uses max-sum
%   message passing, otherwise uses sum-product. This function
%   returns the clique tree where the .val for each clique in .cliqueList
%   is set to the final calibrated potentials.
%
% Copyright (C) Daphne Koller, Stanford University, 2012

function P = CliqueTreeCalibrate(P, isMax)

% Number of cliques in the tree.
N = length(P.cliqueList);

% Setting up the messages that will be passed.
% MESSAGES(i,j) represents the message going from clique i to clique j.
MESSAGES = repmat(struct('var', [], 'card', [], 'val', []), N, N);

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% We have split the coding part for this function in two chunks with
% specific comments. This will make implementation much easier.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%
% YOUR CODE HERE
% While there are ready cliques to pass messages between, keep passing
% messages. Use GetNextCliques to find cliques to pass messages between.
% Once you have clique i that is ready to send message to clique
% j, compute the message and put it in MESSAGES(i,j).
% Remember that you only need an upward pass and a downward pass.
%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

if isMax == 1
  %%%%% log-transform of the values in the factors/cliques using natural log
  for i = 1:length(P.cliqueList)
    P.cliqueList(i).val = log(P.cliqueList(i).val);
  endfor
endif

%%%%% max-calibrate setting the .val fields of the cliqueList to the final beliefs  i(Ci)
##disp('compute messages')
% get index of first message to be passed
[i j] = GetNextCliques(P, MESSAGES);


while i ~= 0 && j ~=0
##  disp('curr message:')
##  disp([i j])

  %%% initialize message as the sending clique potential
  MESSAGES(i,j) = P.cliqueList(i);
##    disp(MESSAGES(i,j))

  %%% multiply all the messages coming into Clique(i)
  %% Passing messages up the tree
  if i < j
    % find all the 1's in P.edges for column `i`
    for e = 1:size(P.edges)(1)
      % when passing messages up the tree we don't
      % go into the lower triangular portion of P.edges
      if e < i && P.edges(e,i) == 1

        if isMax == 0
          % compute the product of clique `i` and the incoming message
          MESSAGES(i,j) = FactorProduct(MESSAGES(i,j), MESSAGES(e,i));
        endif

        if isMax == 1
           % compute the sum of clique `i` and the incoming message
           MESSAGES(i,j) = FactorSum(MESSAGES(i,j), MESSAGES(e,i));
        endif

##        disp('found incoming message')
##        disp([e i])
##        disp(MESSAGES(e,i).var)

      endif
    endfor
  endif

  %% Passing messages down the tree
  if i > j
    % find all the 1's in P.edges for row `i` < `j`
    % loop through all the rows of P.edges. An edge that = 1 is a connection with a message
    for e = 1:size(P.edges)(2)
      if e ~= j && P.edges(i,e) == 1

        if isMax == 0
          % compute the product of clique `i` and the incoming message
          MESSAGES(i,j) = FactorProduct(MESSAGES(i,j), MESSAGES(e,i));
        endif

        if isMax == 1
          % compute the Sum of clique `i` and the incoming message
          MESSAGES(i,j) = FactorSum(MESSAGES(i,j), MESSAGES(e,i));
        endif

##        disp('found incoming message')
##        disp([e i])
##        disp(MESSAGES(e,i).var)

      endif
    endfor
  endif


  %%%% magrinalize the variables not in the sepset S_{i,j}
  clique_i_var = reshape(P.cliqueList(i).var, 1, []);
  clique_j_var = reshape(P.cliqueList(j).var, 1, []);

  do_not_communicate = setdiff([clique_i_var, clique_j_var], intersect(clique_i_var, clique_j_var));

  if isMax == 0
    MESSAGES(i,j) = FactorMarginalization(MESSAGES(i,j), do_not_communicate);

    %%% normalize the message
    MESSAGES(i,j).val = MESSAGES(i,j).val / sum( MESSAGES(i,j).val );
  endif

  if isMax == 1
    MESSAGES(i,j) = FactorMaxMarginalization(MESSAGES(i,j), do_not_communicate);
  endif
##    disp('marginalized message')
##    disp(MESSAGES(i,j).val)

  % get index of next message to be passed
  [i j] = GetNextCliques(P, MESSAGES);
endwhile

##for i = 1:N
##  for j = 1:N
##    if P.edges(i,j) == 1
##      disp([i j])
##      disp(MESSAGES(i,j))
##    endif
##  endfor
##endfor


%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%
% Now the clique tree has been calibrated.
% Compute the final potentials for the cliques and place them in P.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

##disp('Compute the final potentials/beliefs')

%%%% loop through all the cliques in the graph
for i = 1:length(P.cliqueList)
##  disp(sprintf('clique %d', i))

  % loop through all the rows of P.edges. An edge that = 1 is a connection with a message
  for j = 1:size(P.edges)(2)
    if P.edges(i,j) == 1

##      disp('found edge')
##      disp([j i])

      if isMax == 0
        % multiply the incoming message by the clique potential at i
        P.cliqueList(i) = FactorProduct(P.cliqueList(i), MESSAGES(j,i)); % !!! we need to flip i and j, because the incoming message is the message at MESSAGES(J,i)
      endif

      if isMax == 1
        % multiply the incoming message by the clique potential at i
        P.cliqueList(i) = FactorSum(P.cliqueList(i), MESSAGES(j,i)); % !!! we need to flip i and j, because the incoming message is the message at MESSAGES(J,i)
      endif

    endif
  endfor
endfor

##for i = 1:size(P.cliqueList)(2)
##  disp(sprintf('P.cliqueList(%d)',i))
##  disp(P.cliqueList(i))
##endfor


return
