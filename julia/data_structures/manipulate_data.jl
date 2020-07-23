include("./read_data.jl")

# define the filepath and load the data set
data = readCSV("apple.csv")

# convert each column name into a variable
for (k,v) in data @eval Meta.parse("k=v") end
data