# 该脚本用于清洗和预处理导入的数据

library(dplyr)
library(readr) # 如果直接读取 CSV
library(haven) # 如果读取 SAS 数据

# 读取数据 (根据你的实际情况选择)
# clean_data <- read_csv("02_Data/processed_data/clean_data_sas.csv") # 假设从 SAS 导出为 CSV
clean_data <- readRDS("02_Data/processed_data/hospital_adr.rds") # 假设直接读取 RDS

# 数据清洗和预处理步骤
cleaned_data <- clean_data %>%
  # 处理缺失值 (示例：删除 onset_date 为缺失的行)
  filter(!is.na(ONSET_DATE)) %>%
  # 标准化药品名称 (示例：转换为大写并去除空格)
  mutate(DRUG_NAME = toupper(trimws(DRUG_NAME))) %>%
  # 创建年龄组 (示例)
  mutate(AGE_GROUP = case_when(
    AGE < 18 ~ "Pediatric",
    AGE < 65 ~ "Adult",
    TRUE ~ "Elderly"
  )) %>%
  # 选择需要的列
  select(REPORT_ID, PATIENT_ID, DRUG_NAME, ADR_TYPE, SEVERITY, ONSET_DATE, AGE, GENDER, COMORBIDITY, AGE_GROUP)

# 数据质量检查 (示例：查看各变量的唯一值数量)
print("数据质量检查：")
cleaned_data %>% summarise_all(n_distinct)

# 保存清洗后的数据
saveRDS(cleaned_data, "02_Data/processed_data/clean_data_r.rds")
cat("清洗后的数据已保存到 02_Data/processed_data/clean_data_r.rds\n")