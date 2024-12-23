# 该脚本用于导入原始的 CSV 数据文件

library(readr)
library(dplyr)

# 设置数据文件路径
raw_data_path <- "02_Data/raw_data/"

# 导入医院 ADR 数据
hospital_adr <- read_csv(paste0(raw_data_path, "hospital_adr.csv"))
cat("医院 ADR 数据已成功导入，行数：", nrow(hospital_adr), "\n")

# 导入 FDA FAERS 数据
faers_data <- read_csv(paste0(raw_data_path, "faers_data.csv"))
cat("FDA FAERS 数据已成功导入，行数：", nrow(faers_data), "\n")

# 导入国家监测中心数据
national_adr <- read_csv(paste0(raw_data_path, "national_adr.csv"))
cat("国家监测中心数据已成功导入，行数：", nrow(national_adr), "\n")

# 可以选择将导入的数据保存为 R 的 RDS 格式，方便后续快速加载
saveRDS(hospital_adr, "02_Data/processed_data/hospital_adr.rds")
saveRDS(faers_data, "02_Data/processed_data/faers_data.rds")
saveRDS(national_adr, "02_Data/processed_data/national_adr.rds")

cat("原始数据已保存为 RDS 格式到 02_Data/processed_data/ 目录\n")

# 如果需要，可以将所有原始数据合并到一个数据框中
all_raw_data <- bind_rows(hospital_adr, faers_data, national_adr)
cat("所有原始数据已合并，总行数：", nrow(all_raw_data), "\n")