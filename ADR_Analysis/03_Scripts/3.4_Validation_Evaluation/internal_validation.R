# 该脚本用于进行内部验证 (例如，数据集分割)

library(dplyr)
library(caret)

# 读取分析用数据
analysis_data <- readRDS("02_Data/processed_data/clean_data_r.rds")

# 创建训练集和测试集
set.seed(123) # 设置随机种子以保证可重复性
train_index <- createDataPartition(analysis_data$ADR_TYPE, p = 0.7, list = FALSE)
train_data <- analysis_data[train_index, ]
test_data <- analysis_data[-train_index, ]

cat("训练集大小：", nrow(train_data), "\n")
cat("测试集大小：", nrow(test_data), "\n")

# 你可以在训练集上重新运行信号检测方法，并在测试集上进行验证
# (具体的验证步骤需要根据你的验证策略来设计)

# 示例：在训练集上计算 PRR
train_prr_data <- train_data %>%
  group_by(DRUG_NAME, ADR_TYPE) %>%
  summarise(n11 = n(), .groups = 'drop') %>%
  right_join(train_data %>% group_by(DRUG_NAME) %>% summarise(n1_ = n(), .groups = 'drop'), by = "DRUG_NAME") %>%
  right_join(train_data %>% group_by(ADR_TYPE) %>% summarise(n_1 = n(), .groups = 'drop'), by = "ADR_TYPE") %>%
  mutate(n__ = nrow(train_data)) %>%
  mutate(PRR = (n11 / n1_) / (n_1 / n__),
         signal_prr = ifelse(PRR >= 2 & n11 >= 3, 1, 0)) %>%
  filter(!is.na(PRR))

print("训练集上的 PRR 结果：")
print(train_prr_data)