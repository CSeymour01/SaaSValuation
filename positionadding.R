library(reticulate)
# want to make a program that can calculate the upside of adding during drawdowns
# x is initial position and y is purchase price and z is # shares added
user.query <- py$userquery # enter the following into console: userinput()
user.input <- list()
user.input <- user.query()

position.name <- user.input[[1]]
# initialize the situation (cost, quantity, % change)
share.count1 <- user.input[[2]]
share.price1 <- user.input[[3]]
share.pricetarget <-user.input[[4]]

price.performance <- user.input[[6]]  # % as a decimal

# find cost basis and market value given this information
position.costbasis1 <- share.count1 * share.price1
position.marketvalue1 <- position.costbasis1*(1+price.performance)
# shares to be added to the position
share.added <- user.input[[5]]
# price, quantity, and new costbasis given added shares
share.price2 <- share.price1 * (1+price.performance)
share.count2 <- share.count1 + share.added
share.added.cost <- (share.added * share.price2)
position.costbasis2 <- position.costbasis1 + share.added.cost

# find the average price on your position after this position addition
position.price.avg <- (share.count1*share.price1 + share.added*share.price2)/share.count2

position.upside.target1 <- ((share.count1*share.pricetarget) - position.costbasis1)
position.upside.targetmargin1 <- (position.upside.target1)/position.costbasis1
# now upside can be thought of in quite a few different ways
#if the current share price is lower than your initial purchase price,
#the difference in avg.price1 and avg.price2 times #shares.total tells you the
#$ upside if the stock returns to where you bought it (it gets more complicated if it continues to rise above the initial purchase price)

# this means: if I bought 10 more shares at -30%, and the price returned
#to my initial purchase price (25) from its current drawdown price (17.5)
# so if I did that, and it returned to 25, the lowered avgprice on the position

position.upside.gross2 <- (share.price1 - position.price.avg) * share.count2

position.upside.net2 <- (position.upside.gross2 - share.added.cost)

position.upside.netmargin2 <- (position.upside.net2 / share.added.cost)
# if net margin is negative that means if the price were to return to your 
#original purchase price, you would not have made profit on your addition
# you would have spent price2*shares_added and you would only see real gains
# equal to your net upside. If net upside < share.added.cost then you don't


# the variables going into upside are: initial purchase price, new avg price
# total share count, shares added, cost of new shares

# so these upside calculations are just if you expect the price to return to where you bought it
# the factors of net upside existing are several ratios:
# position size old : position size new
# price performance (is a ratio also)

#lets see a comparative metric
position.marketvalue2 <- position.marketvalue1 + share.added.cost
# mkt value change of holdings with no further price action
position.marketchange1 <- (position.marketvalue1 / position.costbasis1)-1
position.marketchange2 <- (position.marketvalue2 / position.costbasis2)-1

# so even though the net margin of upside of the addition is -50% meaning you
#spend twice as much as you make. But, this does lower the position.marketchange
#to less of a loss than you previously had

# if we include an initial thesis based price target (above initial purchase price)
# then we can caclulate the difference in profits by adding at lower prices 

position.upside.target2 <- (share.pricetarget * share.count2) - position.costbasis2

position.upside.targetmargin2 <- position.upside.target2 / position.costbasis2

# lets include final sums:
position.upside.marketvalue1 <- share.count1*share.price1
position.upside.marketvalue2 <- share.count2*share.price1
position.upside.targetmarketvalue1 <- share.count1*share.pricetarget
position.upside.targetmarketvalue2 <- share.count2*share.pricetarget
# and lets include final return %s
position.upside.marketchange1 <- (position.upside.marketvalue1/position.costbasis1)*100
position.upside.marketchange2 <- (position.upside.marketvalue2/position.costbasis2)*100
position.upside.targetmktchange1 <- (position.upside.targetmarketvalue1/position.costbasis1)*100
position.upside.targetmktchange2 <- (position.upside.targetmarketvalue2/position.costbasis2)*100

# now print out a report for the program
# we want to report before and after for the following: values and ratios
# values: costbasis, marketvalue, upside target value, upside gross, upside net
# ratios: marketchange, upside net margin, upside target margin
position.values1 <- c(" ", position.costbasis1, position.marketvalue1, position.upside.target1, 0, 0, position.upside.marketvalue1, position.upside.targetmarketvalue1)
position.values2 <- c(" ", position.costbasis2, position.marketvalue2, position.upside.target2, position.upside.gross2, position.upside.net2, position.upside.marketvalue2, position.upside.targetmarketvalue2)
position.ratios1 <- c(" ", position.marketchange1, 0, position.upside.targetmargin1, position.upside.marketchange1, position.upside.targetmktchange1)
position.ratios2 <- c(" ", position.marketchange2, position.upside.netmargin2, position.upside.targetmargin2,position.upside.marketchange2, position.upside.targetmktchange2)

position.1 <- c(position.values1, position.ratios1)
position.2 <- c(position.values2, position.ratios2)

report.categories <- c("VALUES", "Cost Basis", "Market Value", "Bull Net Upside",
                       "Nuetral Gross Upside", "Neutral Net Upside", "Neutral Market Value", "Bull Market Value", "RATIOS",
                       "Market Change", "Neutral Upside Net Margin", "Bull Upside Net Margin", "Neutral Total % Return", "Bull Total % Return")

report.positions <- c("No add", "Add shares")

# need to put these vectors together and then into a single df so can be compared
report.results <- data.frame(position.1, position.2, row.names = report.categories)
`colnames<-`(report.results, report.positions)

# Explain the results of the test:
#Cost basis: shares owned * price paid
#market value: shares owned * market price
#bull net upside: Total return if stock meets your price target in either case
#neutral gross upside: total return if the stock returns to your initial purchase price
#neutral net upside: total return - cost of additional shares if stock returns to your initial purchase price
#market change: the % change between the cost basis and the market value
#Neutral upside net margin: neutral net upside / cost of new shares as a percentage
#bull upside net margin: bull net upside / cost of all shares






