

%% ----------------------------------Verbal Description of Theory of Mind Model for Tacit Communication Game ----------------------------------
% 1) ToM-0 Players
%    - Sender ToM-0: 
%      Mental model: The ToM-0 sender has no mental model of the receiver but knows
%      the rules of the game and wants to be successful.
%      Path selection strategy: The sender selects a movement pattern that
%      passes through the receiver’s goal location and ends in her own goal
%      location. To minimize score loss, the sender tries to minimize the path length. 
%      If multiple paths satisfy this criterion, the selection is random.

%    - Receiver ToM-0:
%      Mental model: The ToM-0 receiver has no mental model of the sender but knows
%      the rules of the game and wants to be successful.
%      Goal selection strategy: The receiver observes the sender's movement
%      pattern and eliminates the sender's goal as a possibility. The remaining
%      locations are chosen from equally at random.

% 2) ToM-1 Players
%    - Sender ToM-1:
%      Mental model: The ToM-1 sender has a ToM-0 mental model of the receiver, 
%      knowing that the receiver will choose randomly among the remaining locations
%      after eliminating the sender’s goal.
%      Path selection strategy: The sender attempts to minimize the number of remaining
%      possible locations to maximize the probability that the receiver will guess the 
%      correct goal.

%    - Receiver ToM-1:
%      Mental model: The receiver knows the sender selects the shortest path 
%      passing through the receiver’s and sender’s goal locations.
%      Goal selection strategy: The receiver eliminates locations based on how the ToM-0 sender
%      would choose a path. The receiver assigns zero probability to locations that could have 
%      been communicated through a shorter path.

% 3) ToM-2 Players
%    - Sender and Receiver ToM-2:
%      Mental model: The ToM-2 receiver has a ToM-1 model of the sender, knowing the sender 
%      chooses the path with the least remaining locations.
%      Goal selection strategy: Similar to the ToM-1 receiver, but the ToM-2 receiver assigns 
%      zero probability to locations that could have been communicated by the path with fewer
%      remaining locations, rather than just the shortest path.

%% ----------------------------------Script Description----------------------------------------------------------
% This script demonstrates how a sender selects different messages based on varying levels of 
% Theory of Mind (level-0, level-1, and level-2) for a specified goal configuration.
% 
% Example scenario:
% - Starting location: 6th state on the grid (start = 6)
% - Receiver's goal location: 11th state (gr = 11)
% - Sender's goal location: 15th state (gs = 15)
%
% In this script:
% 1. We load all goal locations and corresponding messages.
% 2. We identify the target goal location and retrieve all possible messages.
% 3. The sender chooses one message based on belief distributions, which vary by Theory of Mind level.
% 4. To switch between ToM levels, adjust the 'tomLevel' variable.

clear all; close all;

%% ----------------------------------Step 1: Specify Goal Locations------------------------------------------------
gs = 15;   % Sender's goal location
gr = 11;   % Receiver's goal location
start = 6; % Starting location

%% ----------------------------------Step 2: Load Goal Locations and Messages--------------------------------------
% simData contains pregenerated message data for different starting locations and goal configurations.
% The rows (6, 7, 10, 11) represent distinct starting locations on the grid. For each starting location, 
% there are 210 goal configurations. Each cell in simData holds thousands of possible messages that the 
% sender can choose from, with variations based on the sender's ToM level.
load('C:\Users\user\Desktop\Surprise_vs_ToM\Computational models\ToM models\simulated_paths.mat'); % Load all paths and goal configurations

%% ----------------------------------Step 3: Identify Target Goal Configuration-------------------------------------
% Find the index for the specified start location in simData
indSt = find([simData{:,1}] == start);

% Loop through goal configurations to find the one matching the specified sender and receiver goals
for l = 1:length(simData{indSt,2})
    if simData{indSt,2}(l,1) == gs && simData{indSt,2}(l,2) == gr
        pathData = simData{indSt,3}{l}; % Extract path data for the specific goal configuration
        goal = [gs, gr]; 
        
        % Create a structure array P to store paths and belief distributions
        nlocations = 16; % Number of locations on the grid
        for i = 1:length(pathData)
            P(i).path = pathData{1, i};  % Store the path for the specific goal configuration
            P(i).goal = goal;            % Store the goal locations
            P(i).len = length(P(i).path);% Store the length of the path
            P(i).sb0 = zeros(1, nlocations); % Sender's zero-order beliefs
            P(i).sb1 = zeros(1, nlocations); % Sender's first-order beliefs
            P(i).sb2 = zeros(1, nlocations); % Sender's second-order beliefs
            P(i).rb0 = zeros(1, nlocations); % Receiver's zero-order beliefs
            P(i).rb1 = zeros(1, nlocations); % Receiver's first-order beliefs
            P(i).rb2 = zeros(1, nlocations); % Receiver's second-order beliefs
        end
        
        %% ---------------------Step 4: Select Path Based on ToM Level-----------------------------------
        tomLevel = 0;  % Define the Theory of Mind level (0 for ToM-0, 1 for ToM-1, 2 for ToM-2)
        [pathSelected] = senderSelectPath(tomLevel, goal, P); % Function to select a path based on ToM level
        
        %% ---------------------Step 5: Display Selected Path--------------------------------------------
        display(pathSelected); % Display the selected path
    end
end
