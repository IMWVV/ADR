# 该脚本用于进行时间趋势分析

library(dplyr)
library(readr)
library(ggplot2)
library(lubridate)

# 读取清洗后的数据
cleaned_data <- readRDS("02_Data/processed_data/clean_data_r.rds")

# 将 ONSET_DATE 转换为日期格式
cleaned_data <- cleaned_data %>%
  mutate(ONSET_DATE = as.Date(ONSET_DATE))

# 按月份统计不良反应报告数量
monthly_reports <- cleaned_data %>%
  mutate(year_month = format(ONSET_DATE, "%Y-%m")) %>%
  group_by(year_month) %>%
  summarise(report_count = n())

# 绘制时间趋势图
ggplot(monthly_reports, aes(x = year_month, y = report_count)) +
  geom_line() +
  geom_point() +
  labs(title = "每月不良反应报告数量趋势", x = "月份", y = "报告数量") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))

# 可以按药品名称或其他因素分组进行时间趋势分析