## Create 4gamete/LD plot

### (Optional) Remove low covered positions (below 10 cov)

```remove_low_cov_vcf.pl [vcf_file] 10 > [new_vcf_file]```

### Create file for plotting
* If vcf is unphased or contains only haploid calls
  * ```4gamete.pl [vcf_file] > [4g_LD.txt]```

* If vcf file is phased
  * ```4gamete_het.pl vcf_file] > [4g_LD.txt]```

### Create plot in R
```library(ggplot2)
library(stringr)
library(dplyr)
q=read.table(file="4g_LD.txt",header=F)
q$distc <- cut(q$V3,breaks=seq(from=min(q$V3)-1,to=max(q$V3)+1,by=1000))
dfr1 <- q %>% group_by(distc) %>% summarise(mean=mean(V5),median=median(V5))
dfr1 <- dfr1 %>% mutate(start=as.integer(str_extract(str_replace_all(distc,"[\\(\\)\\[\\]]",""),"^[0-9-e+.]+")),end=as.integer(str_extract(str_replace_all(distc,"[\\(\\)\\[\\]]",""),"[0-9-e+.]+$")),mid=start+((end-start)/2))
dfr2 <- q %>% group_by(distc) %>% summarise(per = length(V4[V4==4])/ length(V4) )
dfr2 <- dfr2 %>% mutate(start=as.integer(str_extract(str_replace_all(distc,"[\\(\\)\\[\\]]",""),"^[0-9-e+.]+")),end=as.integer(str_extract(str_replace_all(distc,"[\\(\\)\\[\\]]",""),"[0-9-e+.]+$")),mid=start+((end-start)/2))
ggplot()+geom_point(data=dfr1,aes(x=start,y=mean),size=0.4,colour="grey20")+geom_line(data=dfr1,aes(x=start,y=mean),size=0.3,alpha=0.5,colour="red")+geom_point(data=dfr2,aes(x=start,y=per),size=0.4,colour="grey20")+geom_line(data=dfr2,aes(x=start,y=per),size=0.3,alpha=0.5,colour="blue")+labs(x="Distance between SNPs (Kilobases)", y=expression(LD~(r^{2})))+scale_x_continuous(breaks=c(0,5*10^4,10*10^4,15*10^4,20*10^4),labels=c("0","50","100","150","200"),limits=c(0,100000))+theme_bw()```

