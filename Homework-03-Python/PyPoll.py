'''
Homework #3 - PyPoll

You will be given a set of poll data called [election_data.csv] (PyPoll/Resources/election_data.csv)
The dataset is composed of three columns: 'Voter ID', 'County', and 'Candidate'. Your task is to
create a Python script that analyzes the votes and calculates each of the following:

	1. The total number of votes cast
	2. A complete list of candidates who received votes
	3. The percentage of votes each candidate won
	4. The winner of the election based on popular vote


CSV Data Headers >> Voter ID, Country, Candidate
'''

# Import Dependencies 
import csv, os

# Create Variable Containing 'election_data.csv' Path
csv_path = 'C:\\Users\\Ryan Tamashiro\\Desktop\\Ryan\\UCI Bootcamp\\Class Repo\\02-Homework\\03-Python\\Instructions\\PyPoll\\Resources\\election_data.csv'

# Read in CSV Data
with open(csv_path, newline='') as csv_file:
	csv_data = csv.reader(csv_file, delimiter=',')
	next(csv_data)

	election_data = [row for row in csv_data]

# Extrapolate Election Data
candidates_list = []
voting_results = {}
for vote in election_data:
	if vote[2] not in candidates_list:
		candidates_list.append(vote[2])
		voting_results[vote[2]]=1
	else:
		voting_results[vote[2]] += 1

# 1. Total Number of Votes Cast
total_vote_count = len(election_data)
print(f'\nTotal Votes Cast in Election: {total_vote_count}')

# 2. Complete List of Candidates Who Received Votes
print('\nComplete List of Candidates: ', candidates_list)

# 3. The Percentage of Votes Each Candidate Won
print('\nElection Results Summary')
election_outcome = {'winner': {'name' : '', 'votes': 0}}
for candidate, votes_won in voting_results.items():
	percent_won = round((votes_won/total_vote_count)*100, 2)
	print(f'Name: {candidate} | Percent Won: {percent_won}%')

	if votes_won > election_outcome['winner']['votes']:
		election_outcome['winner']['name'] = candidate.title()
		election_outcome['winner']['votes'] = votes_won

# 4. The winner of the election
print(f'\nElection Winner: {election_outcome["winner"]["name"]}')




