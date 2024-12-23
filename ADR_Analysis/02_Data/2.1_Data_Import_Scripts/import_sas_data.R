# 加载必要的包
library(readr)
# 如果 SAS 导出的数据是 Excel 格式，则需要加载 readxl
# library(readxl)

# 定义 SAS 导出数据文件路径
sas_clean_data_file <- "02_Data/processed_data/from_sas/clean_data_sas.csv"
# 其他 SAS 导出的文件路径 (根据实际情况添加)
# 例如:
# sas_output_file_1 <- "02_Data/processed_data/from_sas/other_sas_outputs/output1.csv"
# sas_output_file_2 <- "02_Data/processed_data/from_sas/other_sas_outputs/output2.txt"

# 导入 clean_data_sas.csv (假设是 CSV 格式)
if (file.exists(sas_clean_data_file)) {
  clean_data_sas <- read_csv(sas_clean_data_file,
                             col_types = cols()) # 根据实际情况指定列类型
  cat("成功导入 clean_data_sas.csv\n")
} else {
  cat(paste("错误：文件", sas_clean_data_file, "不存在！\n"))
}

# 导入其他 SAS 导出的文件 (根据实际情况添加)
# 示例 1: 导入 CSV 文件
# if (file.exists(sas_output_file_1)) {
#   sas_output1 <- read_csv(sas_output_file_1, col_types = cols())
#   cat("成功导入 output1.csv\n")
# } else {
#   cat(paste("错误：文件", sas_output_file_1, "不存在！\n"))
# }

# 示例 2: 导入其他文本文件 (例如，空格分隔)
# if (file.exists(sas_output_file_2)) {
#   sas_output2 <- read_delim(sas_output_file_2, delim = " ", col_types = cols())
#   cat("成功导入 output2.txt\n")
# } else {
#   cat(paste("错误：文件", sas_output_file_2, "不存在！\n"))
# }

# 示例 3: 如果 SAS 导出的是 Excel 文件
# sas_excel_file <- "02_Data/processed_data/from_sas/sas_results.xlsx"
# if (file.exists(sas_excel_file)) {
#   sas_results <- read_excel(sas_excel_file, sheet = 1) # 指定工作表
#   cat("成功导入 sas_results.xlsx\n")
# } else {
#   cat(paste("错误：文件", sas_excel_file, "不存在！\n"))
# }

# (可选) 将导入的 SAS 数据保存为 .rds 格式
output_path <- "02_Data/processed_data/"
if (!dir.exists(output_path)) {
  dir.create(output_path, recursive = TRUE)
}

if (exists("clean_data_sas")) {
  saveRDS(clean_data_sas, paste0(output_path, "clean_data_sas.rds"))
  cat("clean_data_sas 数据已保存为 .rds 格式。\n")
}

# (可选) 保存其他导入的 SAS 数据
# if (exists("sas_output1")) {
#   saveRDS(sas_output1, paste0(output_path, "sas_output1.rds"))
# }

cat("SAS 导出数据导入脚本执行完毕。\n")