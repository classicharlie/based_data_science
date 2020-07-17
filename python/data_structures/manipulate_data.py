from read_data import readCSV

# define the filepath to the csv and load the data set
data = readCSV('mtcars.csv')

# convert each column name into a variable
for k,v in data.items(): exec(k+'='+str(v))