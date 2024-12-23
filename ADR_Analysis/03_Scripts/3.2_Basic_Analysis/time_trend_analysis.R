# 03_Scripts/3.2_Basic_Analysis/time_trend_analysis.R

# 加载必要的包
library(dplyr)
library(ggplot2)
library(lubridate) # 用于处理日期
library(zoo)       # 用于时间序列分析 (滚动平均等)

# 1. 读取清洗后的数据
# 根据你在 clean_and_preprocess.R 中保存的文件名进行调整
hospital_adr_clean <- readRDS("02_Data/processed_data/clean_data_r_hospital.rds")
faers_data_clean <- readRDS("02_Data/processed_data/clean_data_r_faers.rds")
national_adr_clean <- readRDS("02_Data/processed_data/clean_data_r_national.rds")

# 2. 准备时间序列数据
# 示例：分析 hospital_adr 数据中报告日期随时间的趋势

# 确保 report_date 是日期格式
hospital_adr_ts <- hospital_adr_clean %>%
  mutate(report_date = as.Date(report_date)) %>%
  count(report_date) %>% # 统计每天的报告数量
  arrange(report_date)

faers_data_ts <- faers_data_clean %>%
  mutate(report_date = as.Date(report_date)) %>%
  count(report_date) %>%
  arrange(report_date)

national_adr_ts <- national_adr_clean %>%
  mutate(report_date = as.Date(report_date)) %>%
  count(report_date) %>%
  arrange(report_date)

# 可以按月、按季度等聚合
hospital_adr_monthly <- hospital_adr_clean %>%
  mutate(report_month = floor_date(report_date, "month")) %>%
  count(report_month) %>%
  arrange(report_month)

# 3. 可视化时间趋势
output_path_figures <- "04_Output/figures/"
if (!dir.exists(output_path_figures)) {
  dir.create(output_path_figures, recursive = TRUE)
}

# 3.1 每日趋势
png(filename = paste0(output_path_figures, "time_trend_daily_hospital.png"), width = 1000, height = 600)
ggplot(hospital_adr_ts, aes(x = report_date, y = n)) +
  geom_line() +
  geom_point() +
  labs(title = "Hospital ADR 每日报告趋势", x = "报告日期", y = "报告数量") +
  theme_minimal()
dev.off()

png(filename = paste0(output_path_figures, "time_trend_daily_faers.png"), width = 1000, height = 600)
ggplot(faers_data_ts, aes(x = report_date, y = n)) +
  geom_line() +
  geom_point() +
  labs(title = "FAERS 数据每日报告趋势", x = "报告日期", y = "报告数量") +
  theme_minimal()
dev.off()

png(filename = paste0(output_path_figures, "time_trend_daily_national.png"), width = 1000, height = 600)
ggplot(national_adr_ts, aes(x = report_date, y = n)) +
  geom_line() +
  geom_point() +
  labs(title = "National ADR 数据每日报告趋势", x = "报告日期", y = "报告数量") +
  theme_minimal()
dev.off()

# 3.2 月度趋势
png(filename = paste0(output_path_figures, "time_trend_monthly_hospital.png"), width = 1000, height = 600)
ggplot(hospital_adr_monthly, aes(x = report_month, y = n)) +
  geom_line() +
  geom_point() +
  labs(title = "Hospital ADR 月度报告趋势", x = "报告月份", y = "报告数量") +
  theme_minimal()
dev.off()

# 4. 添加趋势线或平滑
png(filename = paste0(output_path_figures, "time_trend_monthly_smoothed_hospital.png"), width = 1000, height = 600)
ggplot(hospital_adr_monthly, aes(x = report_month, y = n)) +
  geom_line() +
  geom_point() +
  geom_smooth(method = "loess", color = "red") + # 添加 loess 平滑
  labs(title = "Hospital ADR 月度报告趋势 (平滑)", x = "报告月份", y = "报告数量") +
  theme_minimal()
dev.off()

# 5. 分析不同分组的时间趋势 (示例)
# 分析不同年龄组的报告趋势
hospital_adr_age_trend <- hospital_adr_clean %>%
  mutate(report_month = floor_date(report_date, "month")) %>%
  count(report_month, age_group) %>%
  arrange(report_month)

png(filename = paste0(output_path_figures, "time_trend_monthly_by_age_hospital.png"), width = 1200, height = 800)
ggplot(hospital_adr_age_trend, aes(x = report_month, y = n, color = age_group)) +
  geom_line() +
  geom_point() +
  labs(title = "Hospital ADR 月度报告趋势 (按年龄组)", x = "报告月份", y = "报告数量", color = "年龄组") +
  theme_minimal()
dev.off()

# 6. 保存结果 (可选)
output_path_tables <- "04_Output/tables/"
if (!dir.exists(output_path_tables)) {
  dir.create(output_path_tables, recursive = TRUE)
}

write.csv(hospital_adr_monthly, paste0(output_path_tables, "time_trend_monthly_hospital.csv"), row.names = FALSE)

cat("时间趋势分析完成。\n")