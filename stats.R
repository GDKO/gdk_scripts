#!/usr/bin/env Rscript
a <- scan(file("stdin"), c(0), quiet=TRUE);
cat("Min:", min(a),"Max:", max(a), "Mean:", mean(a), "Median:",  median(a), "SD:", sd(a), "Sum:", sum(a), "\n");
