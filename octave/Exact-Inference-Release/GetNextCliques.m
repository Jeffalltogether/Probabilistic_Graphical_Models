%GETNEXTCLIQUES Find a pair of cliques ready for message passing
%   [i, j] = GETNEXTCLIQUES(P, messages) finds ready cliques in a given
%   clique tree, P, and a matrix of current messages. Returns indices i and j
%   such that clique i is ready to transmit a message to clique j.
%
%   We are doing clique tree message passing, so
%   do not return (i,j) if clique i has already passed a message to clique j.
%
%	 messages is a n x n matrix of passed messages, where messages(i,j)
% 	 represents the message going from clique i to clique j.
%   This matrix is initialized in CliqueTreeCalibrate as such:
%      MESSAGES = repmat(struct('var',FFC [], 'card', [], 'val', []), N, N);
%
%   If more than one message is ready to be transmitted, return
%   the pair (i,j) that is numerically smallest. If you use an outer
%   for loop over i and an inner for loop over j, breaking when you find a
%   ready pair of cliques, you will get the right answer.
%
%   If no such cliques exist, returns i = j = 0.
%
%   See also CLIQUETREECALIBRATE
%
% Copyright (C) Daphne Koller, Stanford University, 2012


function [i, j] = GetNextCliques(P, messages)

% initialization
% you should set them to the correct values in your code



%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% YOUR CODE HERE
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
##disp('P.edges')
##disp(P.edges)
##
##disp('messages')

% first we iterate through the upper right triangular portion of messages.
% these represent the bottom-up messages
for j = 1:size(messages)(2)
  for i = 1:size(messages)(1)
    % this keeps us in the upper right triangular portion of messages
    if i >= j
      continue;
    endif

##    disp(sprintf('i: %i', i))
##    disp(sprintf('j: %i', j))
##    disp(messages(i,j))
##    disp('P.edges(i, j)')
##    disp(P.edges(i, j))

    % the first connection that we arrive at that does not have a value for
    % a message is the next message to pass
    if P.edges(i, j) == 1 && isempty(messages(i,j).var)
##      disp(sprintf('found next message'))
##      disp([i j])
      return
    endif

  endfor
endfor

% next we iterate through the lower left triangular portion of messages.
% these represent the top-down messages
for i = size(messages)(1):-1:1
  for j = 1:size(messages)(2)
    % this keeps us in the lower left triangular portion of messages
    if j >= i
      continue;
    endif

##    disp(sprintf('i: %i', i))
##    disp(sprintf('j: %i', j))
##    disp(messages(i,j))

    % the first connection that we arrive at that does not have a value for
    % a message is the next message to pass
    if P.edges(i, j) == 1 && isempty(messages(i,j).var)
##      disp(sprintf('found next message'))
##      disp([i j])
      return

    endif
  endfor
endfor
 i = 0;
 j = 0;

return;
