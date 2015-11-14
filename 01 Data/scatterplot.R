require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)

df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
"select POP, REAL_GDP, YEAR, COUNTRY
  from globaleconomics
  where REAL_GDP is not NULL
;"
')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_ryl96', PASS='orcl_ryl96', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), verbose = TRUE))); 

df<-dplyr::filter(df, POP < 266859)

ggplot() + 
  geom_point() +
  labs(title='Real GDP Versus Population') +
  labs(x=paste("Pop"), y=paste("Real GDP")) +
  layer(data=df, 
        mapping=aes(x=POP, y=REAL_GDP, color=YEAR, label=COUNTRY), 
        stat="identity", 
        stat_params=list(), 
        geom="point",
        geom_params=list(), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=POP, y=REAL_GDP, color=YEAR, label=COUNTRY), 
        stat="identity", 
        stat_params=list(), 
        geom="text",
        geom_params=list(), 
        position=position_identity()
        
  ) 
