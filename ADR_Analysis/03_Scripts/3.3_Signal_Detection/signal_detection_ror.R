# 该脚本用于计算报告比值比 (ROR)

library(dplyr)
library(readr)

# 读取分析用数据
analysis_data <- readRDS("02_Data/processed_data/clean_data_r.rds")

# 计算 ROR
ror_data <- analysis_data %>%
  group_by(DRUG_NAME, ADR_TYPE) %>%
  summarise(n11 = n(), .groups = 'drop') %>%
  right_join(analysis_data %>% group_by(DRUG_NAME) %>% summarise(n1_ = n(), .groups = 'drop'), by = "DRUG_NAME") %>%
  right_join(analysis_data %>% group_by(ADR_TYPE) %>% summarise(n_1 = n(), .groups = 'drop'), by = "ADR_TYPE") %>%
  mutate(n__ = nrow(analysis_data)) %>%
  mutate(n10 = n1_ - n11,
         n01 = n_1 - n11,
         n00 = n__ - n11 - n10 - n01,
         ROR = (n11 * n00) / (n10 * n01),
         ROR_SE_log = sqrt(1/n11 + 1/n10 + 1/n01 + 1/n00),
         ROR_LB = exp(log(ROR) - 1.96 * ROR_SE_log),
         ROR_UB = exp(log(ROR) + 1.96 * ROR_SE_log),
         signal_ror = ifelse(ROR >= 2 & n11 >= 3 & ROR_LB > 1, 1, 0)) %>%
  filter(!is.na(ROR))

print("ROR 计算结果：")
print(ror_data)

# 可以将结果保存到文件
saveRDS(ror_data, "04_Output/tables/ror_results.rds")
write.csv(ror_data, "04_Output/tables/ror_results.csv", row.names = FALSE)