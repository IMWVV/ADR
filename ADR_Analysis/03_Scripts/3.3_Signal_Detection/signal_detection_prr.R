# 该脚本用于计算比例失衡分析 (PRR)

library(dplyr)
library(readr)

# 读取分析用数据
analysis_data <- readRDS("02_Data/processed_data/clean_data_r.rds")

# 计算 PRR
prr_data <- analysis_data %>%
  group_by(DRUG_NAME, ADR_TYPE) %>%
  summarise(n11 = n(), .groups = 'drop') %>%
  right_join(analysis_data %>% group_by(DRUG_NAME) %>% summarise(n1_ = n(), .groups = 'drop'), by = "DRUG_NAME") %>%
  right_join(analysis_data %>% group_by(ADR_TYPE) %>% summarise(n_1 = n(), .groups = 'drop'), by = "ADR_TYPE") %>%
  mutate(n__ = nrow(analysis_data)) %>%
  mutate(PRR = (n11 / n1_) / (n_1 / n__),
         PRR_SE = sqrt(1/n11 - 1/n1_ + 1/n_1 - 1/n__),
         PRR_LB = exp(log(PRR) - 1.96 * PRR_SE),
         PRR_UB = exp(log(PRR) + 1.96 * PRR_SE),
         signal_prr = ifelse(PRR >= 2 & n11 >= 3 & PRR_LB > 1, 1, 0)) %>%
  filter(!is.na(PRR))

print("PRR 计算结果：")
print(prr_data)

# 可以将结果保存到文件
saveRDS(prr_data, "04_Output/tables/prr_results.rds")
write.csv(prr_data, "04_Output/tables/prr_results.csv", row.names = FALSE)