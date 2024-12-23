# 该脚本用于安装项目所需的 R 包

# 数据处理
install.packages("dplyr")

# 数据导入/导出 (包括 SAS 数据)
install.packages("readr")
install.packages("haven")

# 数据可视化
install.packages("ggplot2")

# 报表生成
install.packages("rmarkdown")
install.packages("knitr")
install.packages("pander") # 用于生成简单的表格

# 时间序列分析 (如果需要更高级的时间序列分析)
install.packages("forecast")
install.packages("trend")

# 模型评估 (如果需要构建和评估预测模型)
install.packages("caret")

# 运行此脚本后，你就可以使用这些包了