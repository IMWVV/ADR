# 加载必要的包
library(dplyr)

# 1. 读取原始信号检测结果
# 示例：读取 PRR 信号检测的完整结果（包含所有药物-事件组合的 PRR 值）
prr_all_results <- read.csv("04_Output/tables/signal_detection_prr_all.csv")

# 2. 定义要进行敏感性分析的参数和其取值范围
# 示例：对 PRR 阈值进行敏感性分析
prr_thresholds <- c(1.5, 2.0, 2.5, 3.0)
n_threshold <- 3 # 固定病例数阈值，或者也可以对其进行敏感性分析

# 初始化一个列表来存储不同阈值下的信号
sensitivity_results <- list()

# 3. 循环不同的参数值，重新识别信号
for (threshold in prr_thresholds) {
  signals <- prr_all_results %>%
    filter(prr >= threshold, a >= n_threshold) %>%
    mutate(prr_threshold = threshold) # 标记当前的阈值
  
  sensitivity_results[[paste0("prr_threshold_", threshold)]] <- signals
}

# 4. 分析敏感性分析的结果
# 统计在不同阈值下识别出的信号数量
summary_sensitivity <- lapply(sensitivity_results, nrow)

# 比较不同阈值下的信号
# 例如，找出在所有阈值下都存在的信号
common_signals <- Reduce(intersect, lapply(sensitivity_results, function(df) paste0(df$drug, "-", df$event)))

# 5. 可视化敏感性分析的结果 (可选)
# 例如，绘制不同阈值下信号数量的变化

# 示例：
# library(ggplot2)
# summary_df <- data.frame(threshold = as.numeric(gsub("prr_threshold_", "", names(summary_sensitivity))),
#                          n_signals = unlist(summary_sensitivity))
#
# ggplot(summary_df, aes(x = threshold, y = n_signals)) +
#   geom_line() +
#   geom_point() +
#   labs(title = "PRR 阈值敏感性分析", x = "PRR 阈值", y = "信号数量")

# 6. 保存敏感性分析结果
output_path_tables <- "04_Output/tables/"
if (!dir.exists(output_path_tables)) {
  dir.create(output_path_tables, recursive = TRUE)
}

# 保存不同阈值下的信号列表
for (name in names(sensitivity_results)) {
  write.csv(sensitivity_results[[name]], paste0(output_path_tables, "sensitivity_prr_", name, ".csv"), row.names = FALSE)
}

# 保存敏感性分析总结
# write.csv(data.frame(threshold = names(summary_sensitivity), n_signals = unlist(summary_sensitivity)),
#           paste0(output_path_tables, "sensitivity_prr_summary.csv"), row.names = FALSE)

cat("PRR 信号检测的敏感性分析完成。\n")