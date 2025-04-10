# -------------------------------------------
# Bayesian Analysis of Receiver Accuracy Data
# -------------------------------------------

# Load necessary libraries
library(bain)   # For Bayesian informative hypothesis testing
library(psych)  # For descriptive statistics
library(tidyr)  # For data reshaping (long format)

# -------------------------------
# 1. Load and prepare the dataset
# -------------------------------

# Load accuracy data from a CSV file
# The CSV is expected to have columns: SM, Tom0, Tom1, Tom2 (plus optionally a Participant ID)
data <- read.csv("/Surprise_vs_ToM/Receiver behavior analysis/receiver_accuracy_data.csv")

# Convert from wide format to long format to facilitate group-wise operations
# Each row now represents a single accuracy score with its associated model label
long_data <- pivot_longer(data, 
                          cols = c(SM, Tom0, Tom1, Tom2), 
                          names_to = "group", 
                          values_to = "accuracy")

# Convert group to a factor variable (required for modeling)
long_data$group <- factor(long_data$group)

# ---------------------------------------
# 2. Compute descriptive group statistics
# ---------------------------------------

# Summary statistics (mean, SD, SE, etc.) for each model group
descrip <- describeBy(long_data$accuracy, long_data$group, mat=TRUE)
print(descrip)

# -------------------------------
# 3. Fit linear model to estimate group means
# -------------------------------

# Fit a linear model without an intercept to estimate the mean for each group directly
model <- lm(accuracy ~ group - 1, data=long_data)

# Extract group means (regression coefficients)
estm <- coef(model)

# Rename parameters to match the notation used in bain
# g1 = SM, g2 = Tom0, g3 = Tom1, g4 = Tom2
names(estm) <- c("g1", "g2", "g3", "g4")

# ------------------------------------
# 4. Prepare parameters for BAIN model
# ------------------------------------

# Extract residual variance from the model
varm <- (summary(model)$sigma)^2

# Extract sample size for each model
sampm <- table(long_data$group)

# Create list of covariance matrices for each group mean
# These represent the variance of the group mean (residual variance / sample size)
covm <- list()
for (i in 1:4) {
  covm[[i]] <- matrix(varm / sampm[i], 1, 1)
}

# ----------------------------------
# 5. Run Bayesian hypothesis testing
# ----------------------------------

# Set seed for reproducibility
set.seed(123)

# Test the hypothesis: Surprise model (g1) = ToM-2 model (g4)
res <- bain(estm, "g1 = g4", 
            n = sampm, 
            Sigma = covm, 
            group_parameters = 1, 
            joint_parameters = 0)

# -----------------
# 6. Print results
# -----------------

# View Bayes Factors and posterior model probabilities
print(res)
