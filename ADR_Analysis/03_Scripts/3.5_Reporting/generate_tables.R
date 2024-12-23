# 加载必要的包
library(readr)
library(dplyr)
library(knitr) # 用于生成简单的表格
library(flextable) # 用于生成更复杂的表格 (可选)

# 设定输入和输出路径 (根据你的实际情况修改)
input_tables_path <- "04_Output/tables/"
output_report_path <- "04_Output/intermediate_results/" # 用于存放供报告使用的中间结果

# ---------------------
# 读取和格式化描述性统计表格
# ---------------------
descriptive_stats_table_file <- paste0(input_tables_path, "descriptive_stats_table.csv")
if (file.exists(descriptive_stats_table_file)) {
  descriptive_stats <- read_csv(descriptive_stats_table_file)
  
  # 对表格进行一些格式化，例如重命名列名
  descriptive_stats_formatted <- descriptive_stats %>%
    rename(Variable = variable_name, # 假设你的描述性统计表中有 "variable_name" 列
           Mean = mean_value,        # 假设有 "mean_value" 列
           Median = median_value)    # 假设有 "median_value" 列
  
  # 使用 knitr::kable 生成简单的 Markdown 表格 (适合 R Markdown)
  kable(descriptive_stats_formatted, caption = "描述性统计结果")
  
  # 或者使用 flextable 生成更复杂的表格并保存 (如果需要)
  # ft_descriptive_stats <- flextable(descriptive_stats_formatted) %>%
  #   set_caption("描述性统计结果")
  # save_as_docx(ft_descriptive_stats, path = paste0(output_report_path, "descriptive_stats_table.docx"))
} else {
  warning(paste("找不到描述性统计表格文件:", descriptive_stats_table_file))
}

# ---------------------
# 读取和格式化信号检测结果表格 (PRR)
# ---------------------
signal_results_prr_file <- paste0(input_tables_path, "signal_results_prr.csv") # 假设你的 PRR 结果保存在这个文件中
if (file.exists(signal_results_prr_file)) {
  signal_results_prr <- read_csv(signal_results_prr_file)
  
  # 格式化 PRR 表格
  signal_results_prr_formatted <- signal_results_prr %>%
    rename(Drug = drug_name,      # 假设有 "drug_name" 列
           Event = event_name,    # 假设有 "event_name" 列
           PRR = prr_value)       # 假设有 "prr_value" 列
  
  kable(signal_results_prr_formatted, caption = "信号检测结果 (PRR)")
  
  # 也可以使用 flextable
  # ft_signal_prr <- flextable(signal_results_prr_formatted) %>%
  #   set_caption("信号检测结果 (PRR)")
  # save_as_docx(ft_signal_prr, path = paste0(output_report_path, "signal_results_prr.docx"))
  
} else {
  warning(paste("找不到 PRR 结果表格文件:", signal_results_prr_file))
}

# ---------------------
# 读取和格式化其他需要的表格 (例如 ROR 结果，验证结果等)，按照类似的模式进行
# ---------------------

# 将格式化后的数据保存为 R 对象，供 R Markdown 使用
if (exists("descriptive_stats_formatted")) {
  saveRDS(descriptive_stats_formatted, file = paste0(output_report_path, "descriptive_stats_formatted.rds"))
}
if (exists("signal_results_prr_formatted")) {
  saveRDS(signal_results_prr_formatted, file = paste0(output_report_path, "signal_results_prr_formatted.rds"))
}

# ... 其他表格的保存 ...

print("表格数据处理完成并保存。")