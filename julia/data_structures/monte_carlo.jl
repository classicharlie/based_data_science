"""
monte carlo methods estimate the value of an unkown quantity using inferential
statistics to draw conclusions from known data

general process:
    - define a domain of possible inputs
    - generate inputs randomly from a probability distribution over the domain
    - perform a deterministic computation on the inputs
    - aggregate the results
"""

using Distributions
using Plots

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

# alias CartesianIndex because it takes up a lot of linespace
idx(i,j) = CartesianIndex(i,j)


# data is indexed starting at the most recent observation
function monteCarlo(data::Array,num_sims::Int,sim_obs::Int)
    num_obs = length(data)

    μ = sum(data)/num_obs
    σ = sqrt(sum((data.-μ).^2)/num_obs)

    mtx = ones(num_sims,sim_obs)
    mtx[idx(1,1)] = data[1]

    for j in 1:sim_obs
        mtx[idx(1,j)] = data[1]*exp(rand(Normal(μ,σ)))
        for i in 2:num_sims
            mtx[idx(i,j)] = mtx[idx(i-1,j)]*exp(rand(Normal(μ,σ)))
        end
    end
    
    return mtx
end


# if data isn't indexed going back in time use: reverse!(data)
data = readCSV("apple.csv")
close = data["Adj_Close"][1:251]

# convert the prices to log prices = ln(today/yesterday)
ln_close = map(cl->log(cl),close[2:251]./close[1:250])
plot(monteCarlo(ln_close,1000,251))