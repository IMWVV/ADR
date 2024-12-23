# 该脚本用于生成结果表格

library(dplyr)
library(pander) # 用于生成简单的 markdown 表格

# 读取信号检测结果
prr_results <- readRDS("04_Output/tables/prr_results.rds")
ror_results <- readRDS("04_Output/tables/ror_results.rds")

# 合并结果 (如果需要)
combined_results <- full_join(prr_results, ror_results, by = c("DRUG_NAME", "ADR_TYPE"))

# 生成 PRR 结果表格
cat("PRR 结果表格：\n")
prr_results %>%
  select(DRUG_NAME, ADR_TYPE, n11, PRR, PRR_LB, PRR_UB, signal_prr) %>%
  arrange(desc(PRR)) %>%
  pander()

# 生成 ROR 结果表格
cat("\nROR 结果表格：\n")
ror_results %>%
  select(DRUG_NAME, ADR_TYPE, n11, ROR, ROR_LB, ROR_UB, signal_ror) %>%
  arrange(desc(ROR)) %>%
  pander()

# 你可以将表格输出到文件 (例如 markdown 或 CSV)
# sink("04_Output/tables/prr_table.md")
# prr_results %>%
#   select(DRUG_NAME, ADR_TYPE, n11, PRR, PRR_LB, PRR_UB, signal_prr) %>%
#   arrange(desc(PRR)) %>%
#   pander()
# sink()