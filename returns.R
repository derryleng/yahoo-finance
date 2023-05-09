library(data.table)

setwd(dirname(rstudioapi::getSourceEditorContext()$path))

# Import and merge data
sym_path <- list.files("downloaded", ".csv", full.names = T)
sym_list <- lapply(sym_path, fread)
sym <- Reduce(function(x, y) merge(x, y, by = "index", all = T), sym_list)

# Get only adjusted closing prices
sym <- sym[, sort(c(1, grep("^.*.Adjusted$", names(sym)))), with = F]

# Calculate log returns
for (i in names(sym)[-1]) {
  sym[[gsub("^(.*)Adjusted$", "\\1", i)]] <- c(NA, diff(log(sym[[i]])))
}

# Get only log returns
sym <- sym[, -grep("^.*.Adjusted$", names(sym)), with = F]

# Filter data by date range
d <- sym[index >= "2018-04-01" & index <= "2023-04-01"]

# Rearrange column order
setcolorder(d, c("index", sort(names(d)[-1])))

# Rename column index to Date
names(d)[1] <- "Date"

# Export data
fwrite(d, "Returns_Data.csv")
