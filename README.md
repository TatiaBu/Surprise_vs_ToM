
# Surprise_vs_ToM: Tacit Communication Game Analysis

## Overview
This repository contains the results and code from a study designed to investigate the effectiveness of various cognitive strategies in non-verbal communication within the Tacit Communication Game (TCG). The study examines how different computational models (Surprise model, ToM-0, ToM-1, and ToM-2) simulate sender behavior, and how human receivers interpret these non-verbal messages to identify hidden goals.

### Key Highlights:
- **Four Computational Models** were used to generate sender behavior in the TCG:
  1. **Surprise Model**: Focuses on expectancy violations to capture attention and communicate goals.
  2. **ToM-0 (Zero-order Theory of Mind)**: Assumes no mental model of the receiver.
  3. **ToM-1 (First-order Theory of Mind)**: Considers how the receiver might interpret the sender's movement.
  4. **ToM-2 (Second-order Theory of Mind)**: Anticipates how the receiver might simulate the sender's intentions and adjusts accordingly.

- **Behavioral Data**: The responses of human receivers were recorded and analyzed, with a focus on accuracy, reaction times (RT), and the types of messages used (e.g., Pass-By, Enter-Exit, Wiggling).
- **Statistical Analysis**: The repository includes scripts to compare the effectiveness of the different models by analyzing receiver accuracy and reaction times, as well as message-type-based performance.

---

## Repository Structure

### 1. **Receiver Behavior Analysis**
This folder contains the data and scripts used to analyze the behavioral responses of human receivers in the TCG.

#### Files:
- **`receiver_behavioral_data.mat`**: Contains the behavioral data from 40 participants across 30 trials for each of the four models (Surprise, ToM-0, ToM-1, ToM-2). The data includes accuracy, reaction times (RT), and message-type information.
  
- **`ModelComparison_RT_Accuracy.m`**: 
  - This script performs statistical analysis on the receiver's accuracy and reaction times (RT) across the four computational models. 
  - It calculates the mean accuracy and RT for each model and participant, performs one-way ANOVA, and generates visualizations like scatter plots and boxplots.
  - It also includes analysis for different message types (Pass-By, Enter-Exit, Wiggling), assessing how these types influence receiver performance.

### 2. **Computational Models**
This folder contains the scripts and data related to the computational models used to simulate sender behavior in the Tacit Communication Game.

#### Subfolders:
- **ToM Models**:
  - This folder contains three levels of Theory of Mind (ToM) models: ToM-0, ToM-1, and ToM-2.
  - These models progressively increase in their complexity of mentalizing, simulating how the sender anticipates the receiver's interpretation of their movements.

  **Files**:
  - **`ToM_agent_main.m`**: 
    - The main script that demonstrates how a sender selects different messages based on varying levels of Theory of Mind (ToM).
    - The sender's path is selected according to the ToM level (ToM-0, ToM-1, ToM-2).
    - The script allows for simulation of different cognitive strategies by adjusting the `tomLevel` variable.
  
  - **`senderSelectPath.m`**: 
    - A function that selects the sender's path based on the specified ToM level. The function considers the goal configuration and message options for the sender.
    - Inputs: `tomLevel` (ToM reasoning level), `goal` (goal locations), `P` (data structure containing precomputed paths and belief distributions).
    - Outputs: `pathSelected` (optimal path based on the ToM level).

  - **`simulated_paths.mat`**: 
    - This file contains pregenerated goal locations and possible paths that the sender can take, indexed by starting location and goal configuration. 
    - The data is used to simulate different paths for the sender based on the computational model being applied.

- **Surprise Model**:
  - This folder contains the code for the **Surprise Model**, a computational model that differs from the ToM models in that it relies on the principle of expectancy violations. The Surprise Model creates communicative signals by deviating from expected movement paths to capture the receiver's attention.


---

## Dependencies
- **MATLAB**: This repository requires MATLAB to run the scripts and analyze the data.
- **Data Files**:
  - `receiver_behavioral_data.mat` for behavioral analysis.
  - `simulated_paths.mat` for pregenerated sender path data used in computational model simulations.

---

## Conclusion
This repository provides a comprehensive analysis of how different cognitive strategies (Theory of Mind models and Surprise model) perform in non-verbal communication tasks. The findings help us understand the influence of sender behavior on receiver accuracy, reaction times, and message interpretation strategies in the Tacit Communication Game.
