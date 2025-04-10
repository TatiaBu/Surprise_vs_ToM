%% Receiver Behavior Error Distance Analysis
% ------------------------------------------------------------
% This script analyzes the spatial error in receivers' incorrect
% choices across four computational sender models (Surprise, ToM-0,
% ToM-1, ToM-2) in the Tacit Communication Game (TCG).
% It calculates the Manhattan distance between the chosen location
% and the correct goal on a 4x4 grid for all incorrect trials,
% and plots the mean error distance with error bars.
% Author: Tatia Buidze
% ------------------------------------------------------------

clear all; close all; clc;

%% Load behavioral data
% The data is a cell array where each row represents a participant
% and each column corresponds to a computational model (1 to 4).
% Each cell contains 30 trials per participant with fields including:
% - GC(2): True goal index
% - GC(4): Chosen location index
% - result: 0 = incorrect, 1 = correct

load('/Surprise_vs_ToM/Receiver behavior analysis/recevier_bevavioral_data.mat')

% Helper function: Converts a single index (1-16) to 2D coordinates on 4x4 grid
index_to_coord = @(idx) [ceil(idx/4), mod(idx-1,4)+1];

% Initialize containers
error_dists = cell(1,4);        % Stores distances for each model
trial_counts = zeros(1,4);      % Counts incorrect trials for each model

% Loop through each model (Surprise, ToM-0, ToM-1, ToM-2)
for model = 1:4
    all_dists = [];
    for subj = 1:size(data, 1)
        trials = data{subj, model};
        for t = 1:length(trials)
            if trials(t).result == 0  % only consider incorrect trials
                true_goal = trials(t).GC(2);
                chosen = trials(t).GC(4);
                g_coord = index_to_coord(true_goal);
                c_coord = index_to_coord(chosen);
                dist = sum(abs(g_coord - c_coord)); % Manhattan distance
                all_dists(end+1) = dist;
            end
        end
    end
    error_dists{model} = all_dists;
    trial_counts(model) = length(all_dists);
end

% Calculate mean and standard error of the mean for each model
means = cellfun(@mean, error_dists);
sems = cellfun(@(x) std(x)/sqrt(length(x)), error_dists);

% Define colors for plotting
bar_colors = [...
    0.25 0.45 0.85;  % Surprise - blue
    0.30 0.70 0.30;  % ToM-0 - green
    0.95 0.60 0.15;  % ToM-1 - orange
    0.80 0.25 0.45]; % ToM-2 - red

%% Plotting the results
figure;
b = bar(1:4, means, 'FaceColor', 'flat');
for i = 1:4
    b.CData(i,:) = bar_colors(i,:);
end
hold on;

% Add error bars
errorbar(1:4, means, sems, 'k', 'LineStyle', 'none', 'LineWidth', 1.5);

% Add jittered scatter plot of individual trial distances
for i = 1:4
    x_jitter = (randn(size(error_dists{i})) * 0.05) + i;
    scatter(x_jitter, error_dists{i}, 25, 'k', 'filled', 'MarkerFaceAlpha', 0.5);
end

% Annotate number of trials above each bar
for i = 1:4
    text(i, means(i) + sems(i) + 0.3, ...
        sprintf('n = %d', trial_counts(i)), ...
        'HorizontalAlignment', 'center', 'FontSize', 10);
end

% Customize axes
xticks(1:4);
xticklabels({'Surprise', 'ToM-0', 'ToM-1', 'ToM-2'});
ylabel('Mean Manhattan Distance (Incorrect Trials)');
title('Receiver Error Distance by Sender Model');
ylim([0, max(means + sems) + 4]);
