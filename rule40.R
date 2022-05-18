library(rvest)

# read_html(link) will read a website page and store it into a variable if wanted
stock1 <- "PARA"
stock2 <- "GOOG"
stock3 <- "PINS"
stock4 <- "TWTR"
stock5 <- "SPOT"
stocknames <- c(stock1, stock2, stock3, stock4, stock5)

ruleof40 <- function(ticker) {
  linkbase <- "https://finance.yahoo.com/quote/"
  
  yahoofield1 <- "/key-statistics?p="
  
  yahoofield2 <- "/analysis?p="
  
  link1 <- paste0(linkbase, ticker, yahoofield1, ticker)
  link2 <- paste0(linkbase, ticker, yahoofield2, ticker)
  
  driver1 <- read_html(link1)
  driver2 <- read_html(link2)
  
  allTables1 <- html_nodes(driver1, css="table")
  
  profitability <- html_table(allTables1)[[6]]
  
  allTables2 <- html_nodes(driver2, css="table")
  
  analystforecast <- html_table(allTables2)[[2]]
  
  profitmargin <- profitability[1,2]
  
  salesgrowthproj <- analystforecast[6,4]
  
  pm.free <- unlist(strsplit(profitmargin[[1]], split="%", fixed=TRUE)) [1]
  sgp.free <- unlist(strsplit(salesgrowthproj[[1]], split="%", fixed=TRUE)) [1]
  
  r40<-as.numeric(pm.free)+as.numeric(sgp.free)
  
  output <- list(r40, pm.free, sgp.free)
  
  return(output)
}

#could use any stock here
r40scores <- data.frame()

row1<-ruleof40(stock1)
row2<-ruleof40(stock2)
row3<-ruleof40(stock3)
row4<-ruleof40(stock4)
row5<-ruleof40(stock5)

r40scores <- rbind(row1,row2,row3,row4,row5)

row.names(r40scores) <- c(stocknames)
colnames(r40scores) <- c("R40 Score", "Profit Margin", "Sales Growth")


explainrule <- "Scores benchmark is 40 for growing SaaS businesses,"
col1scores <- as.numeric(r40scores[,1])
averagescore <- mean(col1scores)
medianscore <- median(col1scores)

avgscore<-paste("the average score was:", averagescore)
mdnscore<-paste("the median score was:", medianscore)


cat(paste(explainrule, avgscore, mdnscore, sep="\n"))
r40scores




