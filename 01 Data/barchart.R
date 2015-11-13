require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)

df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
"select country, consumption_percentage, year
  from globaleconomics
;"
')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_ryl96', PASS='orcl_ryl96', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE))); 

df<-dplyr::filter(df, YEAR == 2009)


df$COUNTRY <- factor(df$COUNTRY, levels = df$COUNTRY[order(desc(df$CONSUMPTION_PERCENTAGE))])

ggplot() + 
  geom_bar() +
  coord_flip() +
  scale_x_discrete() +
  scale_y_discrete() +
  labs(title='Consumption Percentage per Country in 2009') +
  labs(x=paste("Country"), y=paste("Consumption Percentage")) +
  layer(data=df, 
        mapping=aes(x=COUNTRY, y=CONSUMPTION_PERCENTAGE, label=CONSUMPTION_PERCENTAGE), 
        stat="identity", 
        stat_params=list(), 
        geom="bar",
        geom_params=list(colour="black"), 
        position=position_identity()
  ) 
