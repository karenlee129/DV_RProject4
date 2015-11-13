require("jsonlite")
require("RCurl")
require(ggplot2)
require(dplyr)

KPI_Low_Max_value = 1930.22     
KPI_Medium_Max_value = 4108.52

df <- data.frame(fromJSON(getURL(URLencode(gsub("\n", " ", 'skipper.cs.utexas.edu:5001/rest/native/?query=
"select country, real_gross_domestic_income, year, kpi as ratio,
case
when kpi < "p1" then \\\'03 Low\\\'
when kpi < "p2" then \\\'02 Medium\\\'
else \\\'01 High\\\'
end kpi  
from (select country, real_gross_domestic_income, year, sum(real_gross_domestic_income) as kpi from globaleconomics group_by(country))
where real_gross_domestic_income is not NULL
;"
')), httpheader=c(DB='jdbc:oracle:thin:@sayonara.microlab.cs.utexas.edu:1521:orcl', USER='C##cs329e_ryl96', PASS='orcl_ryl96', MODE='native_mode', MODEL='model', returnDimensions = 'False', returnFor = 'JSON'), p1=KPI_Low_Max_value, p2=KPI_Medium_Max_value, verbose = TRUE))); 

df<-dplyr::filter(df, YEAR > 2000)
df<-dplyr::filter(df, YEAR < 2010)

df <- df %>% mutate(ratio = sum(REAL_GROSS_DOMESTIC_INCOME)) %>% mutate(KPI = ifelse(ratio <= KPI_Low_Max_value, '03 Low', ifelse(ratio <= KPI_Medium_Max_value, '02 Medium', '01 High')))

View(df)

ggplot() + 
  coord_cartesian() + 
  scale_y_discrete() +
  labs(title='KPI of Countries from 2001-2009') +
  labs(x=paste("Year"), y=paste("Country")) +
  
  layer(data=df, 
        mapping=aes(x=YEAR, y=COUNTRY, label=average), 
        stat="identity", 
        stat_params=list(), 
        geom="text",size = 3,
        geom_params=list(colour="black"), 
        position=position_identity()
  ) +
  layer(data=df, 
        mapping=aes(x=YEAR, y=COUNTRY, fill=KPI), 
        stat="identity", 
        stat_params=list(), 
        geom="tile",
        geom_params=list(alpha=0.50), 
        position=position_identity()
  ) 

#+ theme(axis.ticks = element_blank(),axis.text.x = element_blank(), axis.text.y = element_blank())
