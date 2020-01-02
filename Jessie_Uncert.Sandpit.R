##packages 
library(dplyr)
library(ggplot2)

#add in rurality status to data file 

#remove un-needed columns from rural ranking data set 
dplyr::select(iris, Sepal.Width, Petal.Length, Species)


#load rurality file 
rural <- read.csv("/Users/robertj9/L.GitHub/L.uncert_spatial_map/SLA_2006asgc.csv")

#add rurality & SocioEconomic Area & Disadvantage to SLA file 

SLA$ariap <- rural$ariap_cat
SLA$IRSD <- rural$Seifa06_IRSD
SLA$IRSAD <- rural$Seifa06_IRSAD


## add rurality & socioeconomi to data file 
data$ariap <- rural$ariap_cat
data$IRSD <- rural$Seifa06_IRSD
data$IRSAD <- rural$Seifa06_IRSAD

#Create variable for CI half Length 
data <- dplyr::mutate(data, ci.half = ci.length/2) 

#Create scale variable that will be used to adjust for the crowing variance as the est increases. Therefore the expected uncertainty increases. 

## using a ratio of the estimate over the variance we can attempt to adjust for the increased variance as the estimate increases.  scale variable is a ratio of est/variance 

x.var <- (data$ci.length/4)^.5
plot(data$est, x.var)
data$x.var <- x.var

##create scale variable using x.var 
test.scale <- data$est/x.var
plot(data$est, test.scale)
###add test.scale to data database 
data$test.scale <- test.scale


# Define and create action variable - three different action variables are detailed below. (first line, creates new column action - and fills rows that don't meet criteria with NA. Subsequent rows replace the NAs)
##action1 = 
data <- data %>% mutate(action = ifelse(est >=(ci.length/2 +1) & ci.length < 2,  1, NA))
data <- data %>% mutate(action = ifelse(est <(ci.length/2+1) & (est>(0.5-ci.length)*2), 2, data$action))
data <- data %>% mutate(action = ifelse(est<=(-0.5*ci.length + 1), 3, data$action))
data <- data %>% mutate(action = ifelse(ci.length >= 2, 4, data$action))

##action2  = 
data <- data %>% mutate(action2 = ifelse(est >=(ci.half +1),  1, NA))
data <- data %>% mutate(action2 = ifelse(est <(ci.half+1) & (est>(0.5-ci.length)*2), 3, data$action2))
data <- data %>% mutate(action2 = ifelse(est <(ci.half+1) & (est>(0.5-ci.length)*2) & ci.l >= 0.85, 2, data$action2))
data <- data %>% mutate(action2 = ifelse(est<=(-0.5*ci.length + 1), 4, data$action2))
data <- data %>% mutate(action2 = ifelse(ci.half >= .8, 5, data$action2))

##action3 = uses test.scale to scale the credible interval length as est increases. 
data <- data %>% mutate(action3 = ifelse(est >= 1 & (test.scale <=2.5), 1, NA))
data <- data %>% mutate(action3 = ifelse(est >= 1 & (test.scale >2.5), 2, data$action3))
data <- data %>% mutate(action3 = ifelse(est <1 & (test.scale <= 2.5), 3, data$action3))

data$action3


                                                                 

######
# data <- data %>% mutate(action2 = ifelse(est >1.0 & ci.l >= 0.95, 2, NA))
# data <- data %>% mutate(action2 = ifelse(est >1.0 & ci.l >= 1.05, 1, data$action2 ))
# data <- data %>% mutate(action2 = ifelse(est <(ci.half+1) & (est>(0.5-ci.length)*2) & ci.l >= 0.85, 3, data$action2))
# data <- data %>% mutate(action2 = ifelse(est <1.0 & ci.u >= 0.95, 4, data$action2))
# data <- data %>% mutate(action2 = ifelse(est < 1.0 & ci.u < 1.00, 5, data$action2))
# data <- data %>% mutate(action2 = ifelse(est< 1.0 & ci.u > 1.15, 2, data$action2))
# data <- data %>% mutate(action2 = ifelse(ci.half >= 1, 6, data$action2))
# 


#write data to csv file in L.uncer.spatial folder.
write.csv(data, '/Volumes/robertj9/L.RProjects/L.Uncert.spatialmap/BDVAmap.SLA.sept2016.csv', row.names=F) 


#scatterplot f ci.length vs risk estimate

p.est.ci <- ggplot(data, aes(ci.half, est))
p.est.ci <- p.est.ci + geom_point()
p.est.ci 

## coloured by each of the different action categories
p.est.ci + geom_point(aes(colour=factor(action)))
p.est.ci + geom_point(aes(colour=factor(action2)))
p.est.ci + geom_point(aes(colour=factor(action3)))



  
p.est.ci + ylim(0, 1.5) + xlim(0,2.0)  + geom_point(aes(colour=factor(action3))) + geom_vline(xintercept=1.0)+  ggtitle("Type of Action Required") + labs( x =  "Relative Cancer Risk\n (1.0 = state average)" , y ="Uncertainty\n (CI half length)", colour = NULL) + theme(plot.title = element_text(size = rel(2)) ) 

geom_abline(intercept = 1.0, slope = 1.0) + geom_abline(intercept=2, slope =-1.0)

p.est.ci 

# For visualising CI. 
limits1 <- aes(ymax = ci.u , ymin=ci.l, colour=factor(action2))
limits2 <- aes(ymax = ci.u, ymin=ci.l)


#plot with ci.half rather than ci.length
p2.est.ci <- ggplot(data, aes(ci.half, est))
p2.est.ci + geom_point()
p2.est.ci <- p2.est.ci + geom_linerange(limits1) 
p2.est.ci + ggtitle("RER Lung Cancer vs Uncertainty")
ggplotly(p2.est.ci)




p2.est.ci + geom_linerange(limits2) + facet_wrap(~action2)


p2.est.ci + geom_point(aes(colour=factor(action2)))
p2.est.ci + geom_point(aes(colour=factor(action2))) + facet_wrap(~action2)
p2.est.ci <- p2.est.ci + geom_point()
p2.est.ci <- p2.est.ci + geom_pointrange(limits2)

p2.est.ci + geom_point() + ggtitle("RER Lung Cancer\n Vs Uncertainty") +labs( x = "Uncertainty\n (CI half length)", y = "Relative Cancer Risk\n (1.0 = state average)", colour = NULL) + theme(plot.title = element_text(size = rel(2)) ) 

p2.est.ci  + ylim(0, 2.5) + xlim(0,1.25) + geom_abline(intercept = 1.0, slope = 1) + geom_abline(intercept=1.0, slope =-1)  + geom_point(aes(colour=factor(action2))) + ggtitle("Type of Action Required") + labs( x = "Uncertainty\n (CI half length)", y = "Relative Cancer Risk\n (1.0 = state average)", colour = NULL) + theme(plot.title = element_text(size = rel(2)) ) + xlim(0, 1.5)
#save graph as plotly graph 
ggplotly(p2.est.ci)
#save as htmlwidget

x <- htmlwidgets::saveWidget()
  
  
  ##facet 
p2.est.ci  + ylim(0, 3.5) + xlim(0,1.25) + geom_abline(intercept = 1.0, slope = 1) + geom_abline(intercept=1.0, slope =-1) + geom_point(aes(colour=factor(action2))) + ggtitle("Type of Action Required") + facet_wrap(~action2) + labs( x = "Uncertainty\n (CI half length)", y = "Relative Cancer Risk\n (1.0 = state average)", colour = NULL) + theme(plot.title = element_text(size = rel(2)) ) 

p2.est.ci  + ylim(0, 3.5) + xlim(0,1.25) + geom_linerange(limits) + ggtitle("Type of Action Required") + labs( x = "Uncertainty\n (CI half length)", y = "Relative Cancer Risk\n (1.0 = state average)", colour = NULL) + theme(plot.title = element_text(size = rel(2)) ) 

##add lines
p.est.ci + geom_point(aes(colour = factor(ariap)))
p.est.ci + geom_vline(xintercept = 1.0) + geom_hline(yintercept=0.5)


##ggplot version 
plot.var <- ggplot(data, aes(est, x.var))
plot.var<- plot.var + geom_point()
plot.var


#showing lower bound vs ci.length. 
lower <- ggplot(data, aes(ci.length, ci.l)) + geom_point()
lower
lower + geom_hline(yintercept = 1.0) + geom_vline(xintercept = 0.75) 

lower
lower + geom_point(aes(colour=factor(ariap)))
lower 

upper <- ggplot(data, aes(ci.length, ci.u)) + geom_point()
upper + geom_point(aes(colour=ci.l))

#look at rurality 
p.est.ci + facet_wrap(~ariap) +geom_point(aes(colour=factor(ariap)))

#index of Socio Economic Disadvantage
p.est.ci + facet_wrap(~IRSD)

#facet_grid 
mt <- ggplot(data, aes(ci.length, p.est.ci, colour = factor(ariap))) + geom_point()
mt + facet_grid(. ~ ariap, scales = "free")




