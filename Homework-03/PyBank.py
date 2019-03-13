'''
Homework #3 - PyBank.py
Created On: 03/10/2019					Last Modified: 03/10/2019

Your task is to create a Python script that analyzes the records to calculate each of the folloiwng:
	1. The total number of months included in the dataset.
	2. The net toal amount of 'Profit/Losses' over the entire period.
	3. The average the changes in 'Profit/Losses' over the entire period.
	4. The greatest increase in profits (date and amount) over the entire period.
	5. The greatest decrease in losses (date and amount) over the entire period.

	*In addition, your final script should both print the analysis t the terminal window and export a 
	text file with the results. 

'''
import csv, os

# PyBank CSV File Path
csv_path = 'C:\\Users\\Ryan Tamashiro\\Desktop\\Ryan\\UCI Bootcamp\\Class Repo\\02-Homework\\03-Python\\Instructions\\PyBank\\Resources\\budget_data.csv'

# Open PyBank CSV 
with open(csv_path, newline='') as csv_file:
	pybank_data = csv.reader(csv_file, delimiter=',')
	next(pybank_data)

	#Read PyBank CSV Into List Using List Comprehension
	pybank_transactions = [entry for entry in pybank_data]
	
# Net Dollar Change = End Period Amount - Beg Period Amount
period_net_dollar_change = float(pybank_transactions[-1][1]) - float(pybank_transactions[0][1])

# Net Percent Change = (End Period Amount - Beg Period Amount) / Beg Period Amount
period_net_percent_change = round(period_net_dollar_change/float(pybank_transactions[0][-1])*100, 2)

# Average Daily Change = Net Dollar Change / Number of Days in Period
average_daily_change = round(period_net_dollar_change/len(pybank_transactions), 2)

# Daily Changes = (Current Day Amount - Previous Day Amount) For Each Day Using List Comprehension
daily_changes = [float(pybank_transactions[x][1]) - float(pybank_transactions[x-1][1])
				 for x in range(1, len(pybank_transactions))]

# Highest Daily Profit = Maximium Value in Daily Changes List
highest_daily_profit_amount = max(daily_changes)

# Highest Daily Profit = Using Index Value Returned Index Value of Greatest Daily Profit in Daily Changes List
# 						 Return Associated Day Plus One in PyBank Transactions List of Index Value
highest_daily_profit_day = pybank_transactions[daily_changes.index(highest_daily_profit_amount) + 1][0]

# Highest Daily Loss = Minimum Value in Daily Changes List
highest_daily_loss_amount = min(daily_changes)

# Highest Daily Profit = Using Index Value Returned Index Value of Highest Daily Loss in Daily Changes List
# 						 Return Associated Day Plus One in PyBank Transactions List of Index Value
highest_daily_loss_day = pybank_transactions[daily_changes.index(highest_daily_loss_amount) + 1][0]

#Print PyBank Statistics Summary
print(f'Period Dollar Change: ${period_net_dollar_change}' + 
	  f'\nPeriod Percent Change: {period_net_percent_change}%' +
	  f'\nAverage Daily Change: ${average_daily_change}' +
	  f'\nHighest Profit: {highest_daily_profit_day} / ${highest_daily_profit_amount}' +
	  f'\nHighest Loss: {highest_daily_loss_day} / ${highest_daily_loss_amount}')


