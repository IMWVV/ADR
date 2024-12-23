# 加载必要的包
library(dplyr)

# 1. 读取在当前数据集中识别出的信号
# 示例：读取 PRR 信号检测识别出的信号
prr_signals <- read.csv("04_Output/tables/signal_detection_prr_signals.csv")

# 2. 读取外部数据集
# 假设你的外部数据集也包含 'drug' 和 'event' 列
external_data <- read.csv("05_Validation/validation_data/external_adr_data.csv")

# 确保外部数据集的列名与当前数据集一致 (如果需要)
external_data <- external_data %>%
  rename(drug = external_drug_name,  # 示例
         event = external_event_name) # 示例

# 3. 在外部数据集中验证信号

# 3.1 简单匹配
# 检查在当前数据集中识别出的信号是否也在外部数据集中出现
validated_signals <- prr_signals %>%
  inner_join(external_data, by = c("drug", "event"))

# 3.2 在外部数据集中重新计算信号值 (例如 PRR, ROR)
# 你可能需要编写类似于 signal_detection_prr.R 或 signal_detection_ror.R 的代码，
# 但使用外部数据集作为输入

# 示例：计算外部数据集的 PRR
calculate_prr_external <- function(data, drug_col = "drug", event_col = "event") {
  # ... (你的 PRR 计算逻辑)
}

external_prr_results <- calculate_prr_external(external_data)

# 将当前数据集识别的信号与外部数据集的 PRR 结果进行比较
validated_signals_by_prr <- prr_signals %>%
  left_join(external_prr_results, by = c("drug", "event")) %>%
  filter(external_prr >= 1.5) # 假设外部数据集的 PRR 阈值

# 4. 评估外部验证结果
# 统计有多少信号在外部数据集中得到验证
n_validated_signals <- nrow(validated_signals)

# 可以比较在外部数据集中信号的强度 (例如 PRR 值) 与当前数据集中的强度

# 5. 保存外部验证结果
output_path_tables <- "04_Output/tables/"
if (!dir.exists(output_path_tables)) {
  dir.create(output_path_tables, recursive = TRUE)
}

write.csv(validated_signals, paste0(output_path_tables, "external_validation_prr_matched_signals.csv"), row.names = FALSE)
# write.csv(validated_signals_by_prr, paste0(output_path_tables, "external_validation_prr_by_prr.csv"), row.names = FALSE)

cat("外部验证脚本已创建。\n")