# 该脚本用于生成结果图形

library(dplyr)
library(readr)
library(ggplot2)

# 读取信号检测结果 (例如 PRR)
prr_results <- readRDS("04_Output/tables/prr_results.rds")

# 绘制 PRR 热图
ggplot(prr_results, aes(x = DRUG_NAME, y = ADR_TYPE, fill = PRR)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "red") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("04_Output/figures/prr_heatmap.png", width = 10, height = 8)

# 绘制 ROR 热图 (如果需要)
ror_results <- readRDS("04_Output/tables/ror_results.rds")
ggplot(ror_results, aes(x = DRUG_NAME, y = ADR_TYPE, fill = ROR)) +
  geom_tile() +
  scale_fill_gradient(low = "white", high = "blue") +
  theme_bw() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1))
ggsave("04_Output/figures/ror_heatmap.png", width = 10, height = 8)

# 可以根据需要生成其他类型的图形，例如散点图、条形图等