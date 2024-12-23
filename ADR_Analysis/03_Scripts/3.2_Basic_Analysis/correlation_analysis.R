# 加载必要的包
library(dplyr)
library(ggplot2)
library(corrplot) # 用于可视化相关性矩阵

# 1. 读取清洗后的数据
# 根据你在 clean_and_preprocess.R 中保存的文件名进行调整
hospital_adr_clean <- readRDS("02_Data/processed_data/clean_data_r_hospital.rds")
faers_data_clean <- readRDS("02_Data/processed_data/clean_data_r_faers.rds")
national_adr_clean <- readRDS("02_Data/processed_data/clean_data_r_national.rds")

# 2. 选择需要进行相关性分析的数值型变量
# 示例：选择 hospital_adr 数据中的年龄和某些数值指标
hospital_adr_numeric <- hospital_adr_clean %>%
  select_if(is.numeric) # 选择所有数值型列
# 或者手动选择特定的列，例如：
# select(age, other_numeric_column_1, other_numeric_column_2)

faers_data_numeric <- faers_data_clean %>%
  select_if(is.numeric)

national_adr_numeric <- national_adr_clean %>%
  select_if(is.numeric)

# 3. 计算相关系数
# 使用 cor() 函数计算 Pearson 相关系数（适用于线性关系）
cor_matrix_hospital <- cor(hospital_adr_numeric, use = "pairwise.complete.obs") # 处理缺失值

cor_matrix_faers <- cor(faers_data_numeric, use = "pairwise.complete.obs")

cor_matrix_national <- cor(national_adr_numeric, use = "pairwise.complete.obs")

# 如果数据不满足线性关系假设，可以考虑使用 Spearman 或 Kendall 相关系数
# cor(hospital_adr_numeric, method = "spearman", use = "pairwise.complete.obs")

# 4. 可视化相关性矩阵
# 使用 corrplot 包
output_path_figures <- "04_Output/figures/"
if (!dir.exists(output_path_figures)) {
  dir.create(output_path_figures, recursive = TRUE)
}

png(filename = paste0(output_path_figures, "correlation_heatmap_hospital.png"), width = 800, height = 600)
corrplot(cor_matrix_hospital, method = "color", type = "upper",
         addCoef.col = "black", # 添加相关系数值
         number.cex = 0.8,
         tl.col = "black", tl.srt = 45) # 调整标签颜色和角度
dev.off()

png(filename = paste0(output_path_figures, "correlation_heatmap_faers.png"), width = 800, height = 600)
corrplot(cor_matrix_faers, method = "color", type = "upper",
         addCoef.col = "black",
         number.cex = 0.8,
         tl.col = "black", tl.srt = 45)
dev.off()

png(filename = paste0(output_path_figures, "correlation_heatmap_national.png"), width = 800, height = 600)
corrplot(cor_matrix_national, method = "color", type = "upper",
         addCoef.col = "black",
         number.cex = 0.8,
         tl.col = "black", tl.srt = 45)
dev.off()

# 5. 保存相关性矩阵 (可选)
output_path_tables <- "04_Output/tables/"
if (!dir.exists(output_path_tables)) {
  dir.create(output_path_tables, recursive = TRUE)
}

write.csv(cor_matrix_hospital, paste0(output_path_tables, "correlation_matrix_hospital.csv"))
write.csv(cor_matrix_faers, paste0(output_path_tables, "correlation_matrix_faers.csv"))
write.csv(cor_matrix_national, paste0(output_path_tables, "correlation_matrix_national.csv"))

cat("相关性分析完成。\n")