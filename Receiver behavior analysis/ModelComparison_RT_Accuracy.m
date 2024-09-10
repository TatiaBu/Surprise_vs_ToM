% --------------------------------------------------------
% Receiver Behavior Analysis across Computational Models
% --------------------------------------------------------
% This script analyzes the receiver's accuracy and reaction times (RT) across 
% four computational models in a Tacit Communication Game (TCG). The models include:
% 1) Surprise Model
% 2) ToM-0 Model
% 3) ToM-1 Model
% 4) ToM-2 Model
%
% For each participant (40 participants), the script computes the average accuracy
% and reaction time (RT) across 30 trials for each model. Then, it performs
% statistical analyses (ANOVA) to compare the models in terms of accuracy and RT.
%
% The script also generates visualizations (scatter plots, boxplots) for both accuracy
% and RT, and calculates significance values to evaluate the differences between models.
%
% Additionally, accuracy and frequency is computed for different message types (EnterExit, PassBy, Wiggling)
% to compare the performance of the models.

clear all; close all; clc;

%% Load behavioral data
% The data file contains results from 40 participants and 4 computational models.
% For each participant and model, 30 trials are included with behavioral measures
% such as reaction times (RT), accuracy, and message type information.
load('C:\Users\user\Desktop\Surprise_vs_ToM\Receiver behavior analysis\recevier_bevavioral_data.mat')

%% Initialize matrices for storing accuracy and reaction time data
% Adata: Accuracy data (40 participants x 4 models)
% rtData: Reaction time data (40 participants x 4 models)
for i = 1:length(data)
    for g = 1:4
        % Sum the accuracy ('result') and reaction times (RT) over 30 trials for each participant and model
        Adata(i, g) = sum([data{i, g}.result]) / 30;  % Average accuracy over 30 trials
        rtData(i, g) = sum([data{i, g}.RT]) / 30;     % Average reaction time over 30 trials
    end
end

%% --------------------------------------------------------
% Part 1: Statistical Analysis and Visualization of Accuracy
% --------------------------------------------------------

%% Perform one-way ANOVA for accuracy across models
[p, tbl, stats] = anova1(Adata);
F_stat = tbl{2,5};          % F-statistic
pval = p;                   % P-value from ANOVA
SS_between = tbl{2,2};      % Sum of squares between groups
SS_total = tbl{4,2};        % Total sum of squares
eta_squared = SS_between / SS_total;  % Effect size (eta squared)

% If the result is significant, perform multiple comparisons between models
if p < 0.05
    [c, m, h, nms] = multcompare(stats);  % Multiple comparisons
    significantPairs = c(:, 6) < 0.05;    % Identify significant pairs (p < 0.05)
    
    % Calculate t-values for significant pairs
    mean_diff = c(:, 3);  % Mean differences between groups
    SE = (c(:, 5) - c(:, 4)) / 4;  % Standard error (half the width of the confidence interval)
    T_values = mean_diff ./ SE;    % T-values for significant pairs
end

%% Scatter Plot for Accuracy
groups = {'Surprise', 'Belief', 'SB1', 'SB2'};  % Model names for labeling
figure;
boxplot(Adata, 'Labels', groups, 'Colors', 'k', 'Symbol', '');  % Create boxplot for accuracy

% Overlay individual data points for each participant
hold on;
group_number = size(Adata, 2);  % Number of models
for i = 1:group_number
    xScatter = repmat(i, size(Adata, 1), 1) + (rand(size(Adata, 1), 1) - 0.5) * 0.4;  % Jitter points
    scatter(xScatter, Adata(:, i), 'k', 'filled', 'jitter', 'on', 'jitterAmount', 0.05, 'SizeData', 17);
end

% Set axis labels
xlabel('Model Type');
ylabel('Mean Accuracy');
title('Receiver Accuracy Across Models');

%% --------------------------------------------------------
% Part 2: Statistical Analysis and Visualization of Reaction Time
% --------------------------------------------------------

%% Perform one-way ANOVA for reaction times across models
[p, tbl, stats] = anova1(rtData);
F_stat = tbl{2,5};          % F-statistic
pval = p;                   % P-value from ANOVA
SS_between = tbl{2,2};      % Sum of squares between groups
SS_total = tbl{4,2};        % Total sum of squares
eta_squared = SS_between / SS_total;  % Effect size (eta squared)

% If significant, perform multiple comparisons
if p < 0.05
    [c, m, h, nms] = multcompare(stats);  % Multiple comparisons
    significantPairs = c(:, 6) < 0.05;    % Identify significant pairs
    mean_diff = c(:, 3);  % Mean differences between groups
    SE = (c(:, 5) - c(:, 4)) / 4;  % Standard error
    T_values = mean_diff ./ SE;    % Calculate T-values
end

%% Scatter Plot for Reaction Times
figure;
boxplot(rtData, 'Labels', groups, 'Colors', 'k', 'Symbol', '');  % Create boxplot for reaction times

% Overlay individual data points for each participant
hold on;
group_number = size(rtData, 2);  % Number of models
for i = 1:group_number
    xScatter = repmat(i, size(rtData, 1), 1) + (rand(size(rtData, 1), 1) - 0.5) * 0.4;  % Jitter points
    scatter(xScatter, rtData(:, i), 'k', 'filled', 'jitter', 'on', 'jitterAmount', 0.05, 'SizeData', 17);
end

% Set axis labels
xlabel('Model Type');
ylabel('Mean Reaction Time (seconds)');
ylim([0 9]);
title('Receiver Reaction Times Across Models');

%% --------------------------------------------------------
% Part 3: Accuracy for Different Message Types
% --------------------------------------------------------

group_id = 1;  % Specify which model's data to analyze
plot_mtype_accuracy(data, group_id);  % Call the function to plot message type accuracy

%% Function to plot message type accuracies
function plot_mtype_accuracy(data, id)
    % data: Behavioral data
    % id: Model identifier (1 for Surprise, 2 for ToM-0, 3 for ToM-1, 4 for ToM-2)
    
    data = data(:, id);
    data = data(~cellfun('isempty', data));  % Remove empty cells
    totalM = length(data);  % Total number of participants
    
    % Initialize arrays for accuracies and frequencies
    for in = 1:totalM
        % Accuracy calculations
        sumW(in) = nansum([data{in}.wiggS]) / nansum([data{in}.wiggling]);
        sumE(in) = nansum([data{in}.enterExitS]) / nansum([data{in}.enterExit]);
        sumPa(in) = nansum([data{in}.PassByS]) / nansum([data{in}.PassBy]);
        
        % Frequency data
        fW = nansum([data{in}.wiggling]);
        fE = nansum([data{in}.enterExit]);
        fPa = nansum([data{in}.PassBy]);
    end

    % Proportion of message types
    totalN = sum([fW, fE, fPa]);
    proportionW = fW / totalN;
    proportionE = fE / totalN;
    proportionPa = fPa / totalN;

    % Mean accuracies
    meanE = nanmean(sumE);
    meanW = nanmean(sumW);
    meanP = nanmean(sumPa);

    % Create a bar plot for accuracy of different message types
    X = [meanE, meanW, meanP];  % Accuracy for EnterExit, Wiggling, and PassBy
    y = 1:3;
    B = bar(y, X, 'FaceColor', 'flat', 'BarWidth', 0.7);
    
    % Set colors for each bar
    colors = {[0.878, 0.478, 0.373], [0.239, 0.251, 0.357], [0.506, 0.698, 0.604]};
    B.CData(1, :) = colors{1};
    B.CData(2, :) = colors{2};
    B.CData(3, :) = colors{3};

    % Set labels and appearance
    legends = {'Enter-Exit', 'Wiggly', 'Pass-By'};
    ylabel('Accuracy', 'FontSize', 15);
    xticks(1:3);
    xticklabels(legends);
    ylim([0 1]);
    set(gca, 'fontname', 'times');
    hold on;
end