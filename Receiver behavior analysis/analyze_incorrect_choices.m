clear all; close all; clc;
%% Load behavioral data
% The data file contains results from 40 participants and 4 computational models.
% For each participant and model, 30 trials are included with behavioral measures
% such as reaction times (RT), accuracy, and message type information.
load('/Users/tatia/Library/Mobile Documents/com~apple~CloudDocs/My files/PhD_files/TCG_main_data_code/Surprise_vs_ToM/Receiver behavior analysis/recevier_bevavioral_data.mat')

% Helper function: Convert index to (row, col) in 4x4 grid
index_to_coord = @(idx) [ceil(idx/4), mod(idx-1,4)+1];

% Preallocate
error_dists = cell(1,4);  % for 4 models
trial_counts = zeros(1,4);  % to store number of incorrect trials

% Loop over models
for model = 1:4
    all_dists = [];
    for subj = 1:size(data, 1)
        trials = data{subj, model};
        for t = 1:length(trials)
            if trials(t).result == 0
                true_goal = trials(t).GC(2);
                chosen = trials(t).GC(4);
                g_coord = index_to_coord(true_goal);
                c_coord = index_to_coord(chosen);
                dist = sum(abs(g_coord - c_coord));
                all_dists(end+1) = dist;
            end
        end
    end
    error_dists{model} = all_dists;
    trial_counts(model) = length(all_dists);
end

% Compute means and SEMs
means = cellfun(@mean, error_dists);
sems = cellfun(@(x) std(x)/sqrt(length(x)), error_dists);

% Nice color palette
bar_colors = [...
    0.25 0.45 0.85;  % Surprise - blue
    0.30 0.70 0.30;  % ToM-0 - green
    0.95 0.60 0.15;  % ToM-1 - orange
    0.80 0.25 0.45]; % ToM-2 - red

% Plot
figure;
b = bar(1:4, means, 'FaceColor', 'flat');
for i = 1:4
    b.CData(i,:) = bar_colors(i,:);
end
hold on;

% Add error bars
errorbar(1:4, means, sems, 'k', 'LineStyle', 'none', 'LineWidth', 1.5);

% Scatter individual data points with jitter
for i = 1:4
    x_jitter = (randn(size(error_dists{i})) * 0.05) + i;
    scatter(x_jitter, error_dists{i}, 25, 'k', 'filled', 'MarkerFaceAlpha', 0.5);
end

% Add text for number of trials above bars
for i = 1:4
    text(i, means(i) + sems(i) + 0.3, ...
        sprintf('n = %d', trial_counts(i)), ...
        'HorizontalAlignment', 'center', 'FontSize', 10);
end

% Labels
xticks(1:4);
xticklabels({'Surprise', 'ToM-0', 'ToM-1', 'ToM-2'});
ylabel('Mean Manhattan Distance (Incorrect Trials)');
title('Receiver Error Distance by Sender Model');
ylim([0, max(means + sems) + 4]);
