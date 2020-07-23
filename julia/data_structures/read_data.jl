"""
	readCSV(filepath::String)

Reads a csv given a filepath and parses it into a dictionary; it also separates
the variables into the correct type (keeping strings as is)
"""
function readCSV(filepath::String)
	data = Dict{String,Array}()

	# Not as efficient as python, but it does the job in less code
	open(filepath) do file
		header = map(x->replace(x," "=>"_"),split(readline(file),","))
		[data[col]=[] for col in header]
		rows = [split(line,",") for line in readlines(file)]

		for i in 1:length(header)
			[push!(data[header[i]],row[i]) for row in rows]
		end
	end

	# this process is just fucking gross, but what else can I do
	for (k,v) in data
		try data[k] = map(x->parse(Int,x),v)
		catch
			try data[k] = map(x->parse(Float64,x),v)
			catch
				data[k] = map(x->String(x),v)
			end
		end
	end

	return data
end