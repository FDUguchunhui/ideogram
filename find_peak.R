all <- read.csv('All.csv')
head(all)
str(all)
#transform chromosome from factor to integer
all$chromosome <- as.character(all$chromosome)

#define the expression transformation formula
log_trans <- function(x){
  return(log10(x + 1))
}

# log base 10 transformation for all three conditions
all[c('CFASN_log', 'Blood_log', 'LTB4_log')] <- 
          lapply(all[c('CFASN', 'Blood', 'LTB4')], log_trans)


#hist(all$log_expr)
#y <- all[order(all$log_expr,decreasing = T),]
#head(y, 10)

#all is key word of sqlite, be careful
CFASN_high_expr <- sqldf::sqldf(x = '
             select chromosome, \"GENE.ID\",start, end, max(CFASN_log)
             from "all"
             group by chromosome
             order by chromosome
             ')

Blood_high_expr <- sqldf::sqldf(x = '
             select chromosome, \"GENE.ID\",start, end, max(Blood_log)
             from "all"
             group by chromosome
             order by chromosome
             ')

LTB4_high_expr <- sqldf::sqldf(x = '
             select chromosome, \"GENE.ID\",start, end, max(LTB4_log)
             from "all"
             group by chromosome
             order by chromosome
             ')

write.csv(CFASN_high_expr,'CFASN_high_expr.csv',row.names=FALSE, quote = FALSE)
write.csv(Blood_high_expr,'Blood_high_expr.csv',row.names=FALSE, quote = FALSE)
write.csv(LTB4_high_expr,'LTB4_high_expr.csv',row.names=FALSE, quote = FALSE)



high <- all[all$CFASN_log > 2, ]


#plot corr 
Cor_log <-  cor(all[c('Blood_log', 'CFASN_log', 'LTB4_log')])
colnames(Cor_log) <- c('Blood', 'CFASN', 'LTB4')

lc <- locator(1)
corrplot::corrplot(Cor_log, method = 'ellipse', 
                   type = 'upper', tl.pos = 'd')
corrplot::corrplot(Cor_log, method = 'number', 
                   type = 'lower', diag = F, add = T, tl.pos='n', cl.pos='n')
title(sub = 'Base 10 Log-transformation')


Cor <- cor(all[c('Blood', 'CFASN', 'LTB4')])
corrplot::corrplot(Cor, method = 'ellipse', 
                   type = 'upper', tl.pos = 'd')
cor(high[c('Blood', 'CFASN', 'LTB4')])
corrplot::corrplot(Cor, method = 'number', 
                   type = 'lower', diag = F, add = T, tl.pos='n', cl.pos='n')
title(xlab='Pearson')

Cor_sp <- cor(all[c('Blood', 'CFASN', 'LTB4')], method = 'spearman')
corrplot::corrplot(Cor_sp, method = 'ellipse', 
                   type = 'upper', tl.pos = 'd')
cor(high[c('Blood', 'CFASN', 'LTB4')])
corrplot::corrplot(Cor_sp, method = 'number', 
                   type = 'lower', diag = F, add = T, tl.pos='n', cl.pos='n')
title(xlab = 'Spearman')
