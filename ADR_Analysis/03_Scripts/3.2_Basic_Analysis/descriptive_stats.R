# 该脚本用于进行描述性统计分析

library(dplyr)
library(readr)

# 读取清洗后的数据
cleaned_data <- readRDS("02_Data/processed_data/clean_data_r.rds")

# 基本统计量
print("年龄的描述性统计：")
summary(cleaned_data$AGE)

# 按性别分组的年龄统计
print("按性别分组的年龄统计：")
cleaned_data %>%
  group_by(GENDER) %>%
  summarise(
    Mean_Age = mean(AGE, na.rm = TRUE),
    SD_Age = sd(AGE, na.rm = TRUE),
    Median_Age = median(AGE, na.rm = TRUE),
    Count = n()
  )

# 不良反应类型频率
print("不良反应类型频率：")
cleaned_data %>%
  count(ADR_TYPE, sort = TRUE)

# 药品名称频率
print("药品名称频率：")
cleaned_data %>%
  count(DRUG_NAME, sort = TRUE)