library(data.table)
library(quantmod)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

dir.create("downloaded/", showWarnings = F)

# Import symbol list
symbols <- fread("symbols.csv")

for (x in symbols$Symbol) {
  file_path <- paste0("downloaded/", x, ".csv")
  if (!file.exists(file_path)) {

    # Get data from Yahoo Finance
    sym_x <- getSymbols(
      Symbols = x,
      periodicity = "daily",
      src = "yahoo",
      from = "2018-03-01",
      to = "2023-04-01",
      auto.assign = F
    )
    sym_x <- as.data.table(sym_x)

    # Export
    fwrite(sym_x, file_path)
  }
}
