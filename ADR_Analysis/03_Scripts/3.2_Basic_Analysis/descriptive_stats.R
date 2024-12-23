# 加载必要的包
library(dplyr)
library(psych) # 提供 describe() 函数
library(ggplot2) # 用于可视化

# 1. 读取清洗后的数据
# 根据你在 clean_and_preprocess.R 中保存的文件名进行调整
hospital_adr_clean <- readRDS("02_Data/processed_data/clean_data_r_hospital.rds")
faers_data_clean <- readRDS("02_Data/processed_data/clean_data_r_faers.rds")
national_adr_clean <- readRDS("02_Data/processed_data/clean_data_r_national.rds")

# 2. 计算描述性统计量

# 2.1 对数值型变量进行描述性统计
# 使用 psych::describe() 函数可以提供更详细的统计信息
describe_hospital_numeric <- describe(hospital_adr_clean %>% select_if(is.numeric))
describe_faers_numeric <- describe(faers_data_clean %>% select_if(is.numeric))
describe_national_numeric <- describe(national_adr_clean %>% select_if(is.numeric))

# 2.2 对分类型变量进行频数统计
# 使用 dplyr::count() 函数
frequency_hospital_categorical <- hospital_adr_clean %>% select_if(is.character) %>% summarise_all(n_distinct) # 统计唯一值数量
frequency_faers_categorical <- faers_data_clean %>% select_if(is.character) %>% summarise_all(n_distinct)
frequency_national_categorical <- national_adr_clean %>% select_if(is.character) %>% summarise_all(n_distinct)

# 或者使用更详细的方式查看频数分布
# hospital_adr_clean %>% count(gender)
# hospital_adr_clean %>% group_by(age_group) %>% summarise(n = n())

# 3. 可视化 (可选，但推荐)

# 3.1 数值型变量的分布
# 使用直方图或箱线图
ggplot(hospital_adr_clean, aes(x = age)) +
  geom_histogram(binwidth = 5, fill = "lightblue", color = "black") +
  ggtitle("年龄分布 - Hospital ADR 数据")

ggplot(hospital_adr_clean, aes(y = age)) +
  geom_boxplot(fill = "lightblue") +
  ggtitle("年龄分布 (箱线图) - Hospital ADR 数据")

# 3.2 分类型变量的分布
# 使用柱状图
ggplot(hospital_adr_clean, aes(x = age_group)) +
  geom_bar(fill = "lightgreen", color = "black") +
  ggtitle("年龄组分布 - Hospital ADR 数据")

# 4. 保存结果 (可选)
output_path_tables <- "04_Output/tables/"
if (!dir.exists(output_path_tables)) {
  dir.create(output_path_tables, recursive = TRUE)
}

write.csv(describe_hospital_numeric, paste0(output_path_tables, "descriptive_stats_hospital_numeric.csv"), row.names = FALSE)
write.csv(frequency_hospital_categorical, paste0(output_path_tables, "frequency_hospital_categorical.csv"), row.names = FALSE)

# 可以将生成的图表保存到 04_Output/figures/ 目录

cat("描述性统计分析完成。\n")