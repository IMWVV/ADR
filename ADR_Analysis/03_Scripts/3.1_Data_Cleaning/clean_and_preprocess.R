# 加载必要的包
library(dplyr)
library(lubridate) # 常用于日期处理
# 其他可能需要的包，例如用于字符串处理的 stringr

# 1. 读取数据
# 从 RDS 文件中读取之前导入的原始数据
hospital_adr <- readRDS("02_Data/processed_data/hospital_adr_raw.rds")
faers_data <- readRDS("02_Data/processed_data/faers_data_raw.rds")
national_adr <- readRDS("02_Data/processed_data/national_adr_raw.rds")

# 如果需要，读取 SAS 导出的数据
# clean_data_sas <- readRDS("02_Data/processed_data/clean_data_sas.rds")

# 2. 数据清洗和预处理

# 2.1 处理缺失值
# 示例：检查 hospital_adr 数据中的缺失值
sum(is.na(hospital_adr))
# 可以针对特定列进行检查
sum(is.na(hospital_adr$age))

# 根据实际情况选择处理方法，例如：
# - 删除包含缺失值的行：
#   hospital_adr_clean <- hospital_adr %>% filter(!is.na(age))
# - 使用均值、中位数等填充：
#   hospital_adr_clean <- hospital_adr %>% mutate(age = ifelse(is.na(age), mean(age, na.rm = TRUE), age))
# - 使用特定值填充：
#   hospital_adr_clean <- hospital_adr %>% mutate(diagnosis = ifelse(is.na(diagnosis), "Unknown", diagnosis))

# 对其他数据集进行类似的缺失值处理

# 2.2 处理重复值
# 示例：检查 hospital_adr 数据中的重复行
hospital_adr %>% duplicated() %>% sum()
# 删除重复行
hospital_adr_unique <- hospital_adr %>% distinct()

# 对其他数据集进行类似的重复值处理

# 2.3 数据类型转换
# 示例：将报告日期转换为日期格式
hospital_adr_clean <- hospital_adr %>%
  mutate(report_date = as.Date(report_date), # 假设原始格式可以直接转换
         # 如果原始格式不同，可以使用 lubridate 的函数，例如：
         # report_date = ymd(report_date)
  )

# 对其他数据集进行类似的数据类型转换

# 2.4 异常值处理
# 示例：使用箱线图查看年龄分布并识别潜在异常值
boxplot(hospital_adr_clean$age)
# 根据实际情况决定如何处理异常值，例如删除或替换

# 2.5 数据过滤和选择
# 示例：筛选特定时间段的数据
hospital_adr_filtered <- hospital_adr_clean %>%
  filter(report_date >= "2022-01-01" & report_date <= "2022-12-31")

# 2.6 创建新变量 (特征工程)
# 示例：计算患者的年龄段
hospital_adr_engineered <- hospital_adr_filtered %>%
  mutate(age_group = case_when(
    age < 18 ~ "Under 18",
    age >= 18 & age < 60 ~ "18-59",
    age >= 60 ~ "60 and Over",
    TRUE ~ NA_character_
  ))

# 3. 数据整合 (如果需要)
# 示例：将 hospital_adr 和 faers_data 合并 (假设有共同的键)
# combined_data <- bind_rows(hospital_adr_clean, faers_data_clean)
# 或者使用 join 函数，例如 left_join, right_join, inner_join

# 4. 保存清洗后的数据
output_path <- "02_Data/processed_data/"
if (!dir.exists(output_path)) {
  dir.create(output_path, recursive = TRUE)
}

saveRDS(hospital_adr_engineered, paste0(output_path, "clean_data_r_hospital.rds"))
saveRDS(faers_data_clean, paste0(output_path, "clean_data_r_faers.rds")) # 假设 faers_data 也进行了清洗
saveRDS(national_adr_clean, paste0(output_path, "clean_data_r_national.rds")) # 假设 national_adr 也进行了清洗

cat("数据清洗和预处理完成，已保存清洗后的数据到 02_Data/processed_data/。\n")