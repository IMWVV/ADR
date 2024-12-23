# 定义需要安装的 CRAN 包的列表
cran_packages <- c(
  "tidyverse",      # 数据处理和可视化核心包
  "data.table",     # 高效数据处理
  "lubridate",      # 日期和时间处理
  "ggplot2",        # 强大的数据可视化
  "ggthemes",       # 额外的 ggplot2 主题
  "plotly",         # 创建交互式图表 (可选)
  "rmarkdown",      # 生成动态报告
  "knitr",          # R Markdown 的核心引擎
  # "flextable",      # 生成漂亮的表格 (可选)
  # "gt",             # 另一个用于生成漂亮表格的包 (可选)
  "readr",          # 读取文本文件 (如 CSV)
  "readxl"          # 读取 Excel 文件
  # 在这里添加你在 technical_方案.md 中列出的其他包，
  # 特别是信号检测相关的包
  # 例如: "epiR" 如果你在技术方案中提到了
)

# 循环检查并安装 CRAN 包
for (pkg in cran_packages) {
  if (!requireNamespace(pkg, quietly = TRUE)) {
    install.packages(pkg)
    cat(paste("包 '", pkg, "' 安装完成。\n", sep = ""))
  } else {
    cat(paste("包 '", pkg, "' 已安装。\n", sep = ""))
  }
}

# 如果需要安装 Bioconductor 的包
# if (!requireNamespace("BiocManager", quietly = TRUE))
#   install.packages("BiocManager")
#
# # 示例: 安装 Bioconductor 包 (根据你的技术方案添加)
# # BiocManager::install("BiocStyle")

cat("所有必要的包安装检查完毕。\n")