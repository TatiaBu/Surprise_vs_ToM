# Load required packages
library(bain)
library(psych)

# Load your accuracy data
# Make sure your CSV has 5 columns (Surprise, ToM-0, ToM-1, ToM-2, Participant)
data <- read.csv("/Users/tatia/Library/Mobile Documents/com~apple~CloudDocs/My files/PhD_files/TCG_main_data_code/Surprise_vs_ToM/Receiver behavior analysis/receiver_accuracy_data.csv")

# Convert to long format for easier group handling (optional but useful)
library(tidyr)
long_data <- pivot_longer(data, cols = c(SM, Tom0, Tom1, Tom2), names_to = "group", values_to = "accuracy")
long_data$group <- factor(long_data$group)

# Descriptive stats
descrip <- describeBy(long_data$accuracy, long_data$group, mat=TRUE)
print(descrip)

# Linear model without intercept to get group means
model <- lm(accuracy ~ group - 1, data=long_data)

# Extract group means
estm <- coef(model)
names(estm) <- c("g1", "g2", "g3", "g4")  # SM = g1, Tom0 = g2, Tom1 = g3, Tom2 = g4

# Residual variance
varm <- (summary(model)$sigma)^2

# Sample sizes per group
sampm <- table(long_data$group)

# Covariance matrix per group
covm <- list()
for (i in 1:4) {
  covm[[i]] <- matrix(varm / sampm[i], 1, 1)
}

# Run Bayesian hypothesis test (example: SM = Tom2)
set.seed(123)
res <- bain(estm, "g1 = g4", n = sampm, Sigma = covm, group_parameters = 1, joint_parameters = 0)

# View Bayes factor
print(res)
