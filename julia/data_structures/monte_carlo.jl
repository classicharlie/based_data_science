using Distributions
using Plots

# include the csv reader to parse the data
include("./read_data.jl")

"""
	monteCarlo(data::Array,num_sims::Int,sim_obs::Int)

monte carlo methods estimate the value of an unkown quantity using inferential
statistics to draw conclusions from known data; resulting matrix contains the
sims which are lists indexed by the number of observations
"""
function monteCarlo(data::Array,num_sims::Int,sim_obs::Int)
	idx(i,j) = CartesianIndex(i,j)
    num_obs  = length(data)

    μ = sum(data)/num_obs
    σ = sqrt(sum((data.-μ).^2)/num_obs)

    mtx = ones(sim_obs,num_sims)
    mtx[idx(1,1)] = data[1]

    for j in 1:num_sims
        mtx[idx(1,j)] = data[1]*exp(rand(Normal(μ,σ)))
        for i in 2:sim_obs
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