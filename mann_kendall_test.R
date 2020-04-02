
### Mann-Kendal (MK) test for forest loss and forest cover datasets
### This script calculates temporal trends for landscape metrics using the Mann-Kendall test
### You can find more about this test in this link https://vsp.pnnl.gov/help/Vsample/Design_Trend_Mann_Kendall.htm


### We will use the some functions of different libraries to organize the data and 
### apply the MK test

## Libraries
#install.packages("Package name to be installed")
require(tidyr)
require(trend)
require(dplyr)


### import the table data
df<-read.csv("C:/dask/slope_trends/fc_mean_patch_area_years.csv", header = T)

### The input table consists in 19 columns. One with the ID of the grid cells created 
### and used to extract and calculate the landscape metrics. In this example the metric is 
### "mean patch area" of forest cover. The remaining columns are the single mean patch 
### area value for each year (from 2000 to 2017)

### Before apply the MK test, it is necessary to prepare the data in the format that the 
### MK function can "read" it. We will use the function gather to convert columns into 
### single key rows. Read more about it in https://garrettgman.github.io/tidying/
long_DF <- df %>% gather(year, value, "fc_00":"fc_17")

### Next we need to convert the year column to numeric format
long_DF$year[long_DF$year == "fc_00"] <- 2000
long_DF$year[long_DF$year == "fc_01"] <- 2001
long_DF$year[long_DF$year == "fc_02"] <- 2002
long_DF$year[long_DF$year == "fc_03"] <- 2003
long_DF$year[long_DF$year == "fc_04"] <- 2004
long_DF$year[long_DF$year == "fc_05"] <- 2005
long_DF$year[long_DF$year == "fc_06"] <- 2006
long_DF$year[long_DF$year == "fc_07"] <- 2007
long_DF$year[long_DF$year == "fc_08"] <- 2008
long_DF$year[long_DF$year == "fc_09"] <- 2009
long_DF$year[long_DF$year == "fc_10"] <- 2010
long_DF$year[long_DF$year == "fc_11"] <- 2011
long_DF$year[long_DF$year == "fc_12"] <- 2012
long_DF$year[long_DF$year == "fc_13"] <- 2013
long_DF$year[long_DF$year == "fc_14"] <- 2014
long_DF$year[long_DF$year == "fc_15"] <- 2015
long_DF$year[long_DF$year == "fc_16"] <- 2016
long_DF$year[long_DF$year == "fc_17"] <- 2017


### Now we create a function (coef.fcn) that will apply the MK test (mk.test). The "p.value" 
### and the "statistic" (which are the z score values) will be retrieved for each ID.
coef.fcn = function(newdata) {
  res<-mk.test(newdata$value) 
  return(data.frame(res$p.value,res$statistic))
}

### We will use the function "group_by" from dplyr package to apply the function for each 
### ID (tile_id).
mk_coefs = long_DF %>% 
  group_by(long_DF$tile_id) %>%
  do(coef.fcn(.))
mk_coefs #### check the first rows of the output 

### the dataframe result can be saved as .csv file using the following code line
write.csv(mk_coefs,"C:/dask/slope_trends/fc_mean_patch_area_years_MK.csv")






