# 加载必要的包
library(dplyr)

# 1. 读取清洗后的数据
# 根据你在 clean_and_preprocess.R 中保存的文件名进行调整
# 这里假设你有一个包含药物和事件信息的统一数据集，
# 如果没有，你需要先进行数据整合
adr_data_clean <- readRDS("02_Data/processed_data/your_unified_adr_data.rds")

# 假设你的数据集中包含 'drug' (药物名称) 和 'event' (不良事件名称) 列

# 2. 计算 PRR

calculate_prr <- function(data, drug_col = "drug", event_col = "event") {
  # a: 报告了特定药物和特定事件的病例数
  a <- data %>%
    filter(!!sym(drug_col) == current_drug, !!sym(event_col) == current_event) %>%
    nrow()
  
  # b: 报告了特定药物和除该事件之外的其他事件的病例数
  b <- data %>%
    filter(!!sym(drug_col) == current_drug, !!sym(event_col) != current_event) %>%
    nrow()
  
  # c: 报告了该特定事件和除该药物之外的其他药物的病例数
  c <- data %>%
    filter(!!sym(drug_col) != current_drug, !!sym(event_col) == current_event) %>%
    nrow()
  
  # d: 报告了除该特定药物和该特定事件之外的其他药物和其他事件的病例数
  d <- data %>%
    filter(!!sym(drug_col) != current_drug, !!sym(event_col) != current_event) %>%
    nrow()
  
  prr <- a / (a + b) / (c / (c + d))
  return(prr)
}

# 获取所有独特的药物和事件组合
drug_event_combinations <- adr_data_clean %>%
  distinct(drug, event)

# 初始化一个空的数据框来存储 PRR 结果
prr_results <- data.frame(drug = character(), event = character(), prr = numeric(), stringsAsFactors = FALSE)

# 循环计算每个药物-事件组合的 PRR
for (i in 1:nrow(drug_event_combinations)) {
  current_drug <- drug_event_combinations$drug[i]
  current_event <- drug_event_combinations$event[i]
  
  prr_value <- calculate_prr(adr_data_clean) # 注意这里需要传递完整的数据集
  
  prr_results <- prr_results %>%
    add_row(drug = current_drug, event = current_event, prr = prr_value)
}

# 3. 添加其他指标 (可选)
# 例如：计算病例数 a, b, c, d 等
prr_results <- prr_results %>%
  mutate(
    a = adr_data_clean %>% filter(drug == .data$drug, event == .data$event) %>% nrow(),
    b = adr_data_clean %>% filter(drug == .data$drug, event != .data$event) %>% nrow(),
    c = adr_data_clean %>% filter(drug != .data$drug, event == .data$event) %>% nrow(),
    d = adr_data_clean %>% filter(drug != .data$drug, event != .data$event) %>% nrow()
  )

# 4. 设置信号阈值 (根据你的项目设定)
prr_threshold <- 2
n_threshold <- 3 # 例如，至少报告 3 例

signals_prr <- prr_results %>%
  filter(prr >= prr_threshold, a >= n_threshold)

# 5. 保存 PRR 结果
output_path_tables <- "04_Output/tables/"
if (!dir.exists(output_path_tables)) {
  dir.create(output_path_tables, recursive = TRUE)
}

write.csv(prr_results, paste0(output_path_tables, "signal_detection_prr_all.csv"), row.names = FALSE)
write.csv(signals_prr, paste0(output_path_tables, "signal_detection_prr_signals.csv"), row.names = FALSE)

cat("PRR 信号检测完成。\n")