#!/usr/bin/env Rscript
a <- scan(file("stdin"), c(0), quiet=TRUE);
tmp = a;
tmp2 <- rev( sort(tmp) );
tmp3 <- cumsum(tmp2) <= sum(tmp)/2;
n50 = tmp2[ sum(tmp3) ];
cat("Min:", min(a),"Max:", max(a), "Mean:", mean(a), "Median:",  median(a), "SD:", sd(a), "Sum:", sum(a), "N50:", n50, "\n");
