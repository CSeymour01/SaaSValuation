#the only user input data is:
#the number of shares owned, price paid for them, mkt % change
#number of shares to add, and company name I guess

def userquery():
  position_name = input("Company name: ")
  shares_initial = float(input("How many shares do you own? "))
  shares_initialprice = float(input("What was the price paid per share? "))
  position_target = float(input("What was your target price at purchase? "))
  shares_toadd = float(input("How many shares would you like to add? "))
  position_marketchange = float(input("What is the return since your purchase (% as a decimal)? "))
  return(position_name, shares_initial, shares_initialprice, position_target, shares_toadd, position_marketchange)


