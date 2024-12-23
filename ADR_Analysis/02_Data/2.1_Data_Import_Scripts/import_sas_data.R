# 该脚本用于导入 SAS 的数据文件 (.sas7bdat)

library(haven)
library(dplyr)

# 设置 SAS 数据文件路径
sas_data_path <- "02_Data/processed_data/from_sas/"

# 导入清洗后的 SAS 数据
clean_data_sas <- read_sas(paste0(sas_data_path, "clean_data.sas7bdat"))
cat("清洗后的 SAS 数据已成功导入，行数：", nrow(clean_data_sas), "\n")

# 你可以对导入的 SAS 数据进行进一步的处理或分析
# 例如：
# glimpse(clean_data_sas)

# 如果需要，可以将导入的 SAS 数据保存为 R 的 RDS 格式
saveRDS(clean_data_sas, "02_Data/processed_data/clean_data_sas.rds")
cat("SAS 数据已保存为 RDS 格式到 02_Data/processed_data/ 目录\n")

