def readCSV(filepath):
	'''
	Reads a csv given a filepath and parses it into a dictionary; it also
	separates the variables into the correct type (keeping strings as is)
	'''
	data = {}

	with open(filepath) as file:
		# read the first line and get rid of any escape characters
		first_line = file.readline().replace('\n','')
		header = first_line.split(',')

		# initiate the dataset with headers mapping to empty arrays
		for col in header:
			data[col] = []

		# read the rest of the file and assign 
		for line in file:
			for i in range(len(header)):
				row = line.replace('\n','').split(',')
				data[header[i]].append(row[i])

	# convert each row to it's respective data type
	for key,col in data.items():
		try: col = [int(obs) for obs in col]
		except ValueError:
			try: col = [float(obs) for obs in col]
			except: continue
		data[key] = col

	return data