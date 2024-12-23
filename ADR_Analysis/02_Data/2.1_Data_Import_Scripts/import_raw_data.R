# 加载必要的包
library(readr)
library(dplyr) # 方便后续的数据处理 (可选，但常用)

# 定义数据文件路径
hospital_adr_file <- "02_Data/raw_data/hospital_adr.csv"
faers_data_file <- "02_Data/raw_data/faers_data.csv"
national_adr_file <- "02_Data/raw_data/national_adr.csv"

# 导入 hospital_adr.csv
if (file.exists(hospital_adr_file)) {
  hospital_adr <- read_csv(hospital_adr_file,
                           col_types = cols( # 可以根据实际情况指定列类型，提高效率
                             # 例如：
                             # patient_id = col_character(),
                             # age = col_integer(),
                             # report_date = col_date(format = "%Y-%m-%d")
                           ))
  cat("成功导入 hospital_adr.csv\n")
} else {
  cat(paste("错误：文件", hospital_adr_file, "不存在！\n"))
}

# 导入 faers_data.csv
if (file.exists(faers_data_file)) {
  faers_data <- read_csv(faers_data_file,
                         col_types = cols()) # 根据实际情况指定列类型
  cat("成功导入 faers_data.csv\n")
} else {
  cat(paste("错误：文件", faers_data_file, "不存在！\n"))
}

# 导入 national_adr.csv
if (file.exists(national_adr_file)) {
  national_adr <- read_csv(national_adr_file,
                           col_types = cols()) # 根据实际情况指定列类型
  cat("成功导入 national_adr.csv\n")
} else {
  cat(paste("错误：文件", national_adr_file, "不存在！\n"))
}

# (可选) 将导入的原始数据保存为 .rds 格式，方便后续快速读取
output_path <- "02_Data/processed_data/"
if (!dir.exists(output_path)) {
  dir.create(output_path, recursive = TRUE)
}

if (exists("hospital_adr")) {
  saveRDS(hospital_adr, paste0(output_path, "hospital_adr_raw.rds"))
  cat("hospital_adr 数据已保存为 .rds 格式。\n")
}
if (exists("faers_data")) {
  saveRDS(faers_data, paste0(output_path, "faers_data_raw.rds"))
  cat("faers_data 数据已保存为 .rds 格式。\n")
}
if (exists("national_adr")) {
  saveRDS(national_adr, paste0(output_path, "national_adr_raw.rds"))
  cat("national_adr 数据已保存为 .rds 格式。\n")
}

cat("原始数据导入脚本执行完毕。\n")