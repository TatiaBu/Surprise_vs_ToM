function [pathSelected] = senderSelectPath(tomLevel, goal, P)
% ToM model for Tacit Communication Game
% This function selects the optimal path based on the sender's Theory of Mind (ToM) level.
%
% Inputs:
%   tomLevel - Level of ToM reasoning {0,1,2}
%   goal     - 1x2 vector with goal configuration [sender_goal, receiver_goal]
%   P        - Struct array representing all paths and belief distributions for the given goal.
%
% Fields of P:
%   P(i).path  - Path corresponding to goal configuration (starts at 6, 7, 10, or 11, 
%                passes through receiver’s goal, ends at sender’s goal)
%   P(i).goal  - [goal_sender, goal_receiver]
%   P(i).len   - Length of the path
%   P(i).sb0   - Sender's 0-order belief vector
%   P(i).sb1   - Sender's 1-order belief vector
%   P(i).sb2   - Sender's 2-order belief vector
%   P(i).rb0   - Receiver's 0-order belief vector
%   P(i).rb1   - Receiver's 1-order belief vector
%   P(i).rb2   - Receiver's 2-order belief vector
%
% Output:
%   pathSelected - Selected path based on ToM reasoning

nlocations = 16;  % Total number of locations in the grid

%% ----------------------------------ToM-0 Sender------------------------------------
if tomLevel >= 0
    % Sender with no mental model of the receiver, tries to minimize path length.
    % Random path selection if multiple paths have the same length.
    for i = 1:length(P)
        P(i).sb0(P(i).path) = 1 / length(P(i).path);  % Equal belief distribution over the path
        len(i, 1) = P(i).len;  % Path lengths
    end
    
    % Extract beliefs for comparison
    sb0 = zeros(length(P), nlocations);
    for i = 1:length(P)
        sb0(i, :) = P(i).sb0(end, :);  % Belief vector at the last step of the path
    end
    
    % Maximize beliefs at the receiver's goal location
    j = find(sb0(:, goal(2)) == max(sb0(:, goal(2))));
    if length(j) > 1
        k = find(len(j) == min(len(j)));  % Select the shortest path if multiple options
        if length(k) > 1
            x = randsample(length(k), 1);  % Random selection if multiple shortest paths
            pathSent(1) = j(k(x));
        else
            pathSent(1) = j(k);
        end
    else
        pathSent(1) = j;
    end
end

%% ----------------------------------ToM-1 Sender------------------------------------
if tomLevel >= 1
    % Sender with a ToM-0 mental model of the receiver, aiming to minimize remaining possible locations.
    Level_1_confidence = 1;  % Full confidence in first-order beliefs
    
    % Update beliefs based on remaining candidate locations
    for i = 1:length(P)
        candL = unique(P(i).path(end, 1:end));  % Get unique locations
        candL(candL == P(i).goal(1)) = [];  % Remove sender's goal from the candidates
        P(i).sb1(candL) = 1 / length(candL);  % Equal belief distribution over remaining candidates
    end
    
    % Combine first-order and zero-order beliefs
    combinedB1 = zeros(length(P), nlocations);
    for i = 1:length(P)
        combinedB1(i, :) = Level_1_confidence * P(i).sb1(end, :) + (1 - Level_1_confidence) * P(i).sb0(end, :);
    end
    
    % Maximize combined beliefs at the receiver's goal location
    j = find(combinedB1(:, goal(2)) == max(combinedB1(:, goal(2))));
    if length(j) > 1
        x = randsample(length(j), 1);  % Random selection if multiple maximum belief paths
        pathSent(2) = j(x);
    else
        pathSent(2) = j;
    end
end

%% ----------------------------------ToM-2 Sender------------------------------------
if tomLevel >= 2
    % Sender with a ToM-1 model of the receiver, aware that the receiver uses an elimination strategy.
    Level_2_confidence = 1;  % Full confidence in second-order beliefs
    
    for i = 1:length(P)
        path = P(i).path(end, :);  % Current path
        [enterExitLocations, allLocations] = identify_states_outside_of_direct_path(path, goal);
        
        if ~isempty(enterExitLocations)
            % If there are "enter-exit" states, distribute belief probabilities between these locations
            P(i).sb2(nonzeros(enterExitLocations)) = 1 / length(nonzeros(enterExitLocations));
        else
            % Otherwise, distribute beliefs across all candidate locations from the path
            P(i).sb2(allLocations) = 1 / length(allLocations);
        end
    end
    
    % Combine second-order and first-order beliefs
    combinedB2 = zeros(length(P), nlocations);
    for i = 1:length(P)
        combinedB2(i, :) = Level_2_confidence * P(i).sb2(end, :) + (1 - Level_2_confidence) * P(i).sb1(end, :);
    end
    
    % Maximize combined beliefs at the receiver's goal location
    j = find(combinedB2(:, goal(2)) == max(combinedB2(:, goal(2))));
    if length(j) > 1
        k = find(len(j) == min(len(j)));  % Select the shortest path if multiple options
        if length(k) > 1
            x = randsample(length(k), 1);  % Random selection if multiple shortest paths
            pathSent(3) = j(k(x));
        else
            pathSent(3) = j(k);
        end
    else
        pathSent(3) = j;
    end
end

%% ----------------------------------Negotiating Between ToM Levels------------------------------------
% If there are conflicting choices across ToM levels, use softmax to decide.
if tomLevel == 0
    pathSent = pathSent(1);
elseif tomLevel == 1
    b = [P(pathSent(1)).sb0(end, goal(2)), combinedB1(pathSent(2), goal(2))];
    p = softmax(b, 20);
    tmp = find(rand <= cumsum(p), 1, 'first');
    pathSent = pathSent(tmp);
elseif tomLevel == 2
    b = [P(pathSent(1)).sb0(end, goal(2)), combinedB1(pathSent(2), goal(2)), combinedB2(pathSent(3), goal(2))];
    p = softmax(b, 20);
    tmp = find(rand <= cumsum(p), 1, 'first');
    pathSent = pathSent(tmp);
end

pathSelected = P(pathSent).path;  % Final path selection

end


%% Helper Functions

function [enterExitLocations, allLocations] = identify_states_outside_of_direct_path(path, goal)
    % Identify unique locations and detect repeated states in the path
    allLocations = unique(path(end, 1:end));  % All candidate locations (unique)
    allLocations(allLocations == goal(1)) = [];  % Remove sender's goal from candidates
    
    [count, states] = hist(path, unique(path));  % Find repeated states
    [~, b] = ismember(path, states(count >= 2)); % States repeated more than once
    pos = unique(b); pos = pos(2:end);           % Skip the first value
    
    for in = 1:length(pos)
        tmp = find(b == pos(in));  % Find the indices of repeated states
        if tmp(2) - tmp(1) == 2    % Check if the state was repeated with only one state in between
            enterExitLocations(in) = path(tmp(1) + 1);  % Identify the middle "enter-exit" state
        end
    end
    
    if ~exist('enterExitLocations', 'var')
        enterExitLocations = [];  % Initialize as empty if no enter-exit locations exist
    else
        enterExitLocations(enterExitLocations == 0) = [];  % Remove zeros
        enterExitLocations(enterExitLocations == goal(1)) = [];  % Remove sender's goal
    end
end

function p = softmax(v, temp)
    % Softmax function to compute probability distribution
    p = exp(temp * v) ./ sum(exp(temp * v));
end



