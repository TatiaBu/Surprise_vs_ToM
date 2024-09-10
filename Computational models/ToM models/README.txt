# README: Theory of Mind Model for Tacit Communication Game

## Overview
This folder contains three main components:

1. **Main Script (`ToM_agent_main.m`)**: Explains how a sender selects different messages based on varying levels of Theory of Mind (ToM).
2. **Path Selection Function (`senderSelectPath.m`)**: A helper function that is called by the main script to select the sender's path.
3. **Pregenerated Data (`simData`)**: A variable containing precomputed goal locations and corresponding possible messages for the sender.

Each file is designed to simulate how senders select paths and communicate based on different levels of mental reasoning (ToM-0, ToM-1, and ToM-2).

---

## Contents

### 1. Main Script (`ToM_agent_main.m`)
This script showcases the message selection process in a grid-based game. The sender and receiver both have their own goals, and the sender selects paths based on their Theory of Mind level.

#### Script Workflow:
- **Specify Goal Locations**: Sender's, receiver's, and starting locations are defined.
- **Load Data**: Precomputed message and goal location data is loaded from the `simData` variable.
- **Identify Target Goal Configuration**: The script identifies the current goal configuration from the data.
- **Select Path**: A path is selected based on the defined Theory of Mind level (ToM-0, ToM-1, ToM-2).
- **Display Path**: The selected path is displayed.

You can adjust the ToM level by modifying the `tomLevel` variable in the script to see how the sender's behavior changes depending on their level of reasoning.

---

### 2. Path Selection Function (`senderSelectPath.m`)
This function is responsible for selecting the optimal path based on the sender’s level of Theory of Mind (ToM). It takes three inputs:

#### Inputs:
- `tomLevel`: The ToM reasoning level (0, 1, or 2).
- `goal`: A 1x2 vector containing the sender's and receiver's goal locations.
- `P`: A struct array holding all paths and belief distributions for the current goal configuration.

#### Output:
- `pathSelected`: The selected path, chosen based on the sender's reasoning level:

  - **ToM-0**: The sender selects the shortest path randomly if there are multiple options.
  - **ToM-1**: The sender maximizes the probability that the receiver will guess the correct goal.
  - **ToM-2**: The sender anticipates the receiver's mental model and selects a path accordingly.

---

### 3. Pregenerated Data (`simData`)
This variable (`simData`) contains precomputed data for different starting locations and goal configurations. The data includes all possible paths the sender could take, and the corresponding messages they could send. It is indexed by starting location and goal configuration and is loaded into the main script.

---

## How to Use
1. Ensure that `simData` (from `simulated_paths.mat`) is in the same directory. The main script (`ToM_agent_main.m`) loads this data directly to simulate the selection process.
   
2. Run the main script (`ToM_agent_main.m`). The script will load the pregenerated paths and messages, identify the current configuration, and use the `senderSelectPath` function to select a path based on the current ToM level.

3. Adjust the ToM level by modifying the `tomLevel` variable in the script to simulate different levels of mental reasoning (0 for ToM-0, 1 for ToM-1, and 2 for ToM-2).

---

## Dependencies
- **MATLAB environment**: This repository requires MATLAB to run the scripts.
- **Data File**: 
  - `simulated_paths.mat`: This file contains the `simData` variable used by the main script.

