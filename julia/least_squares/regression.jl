# least squares parser and algorithm Julia implementation
include("./formula_parser_v2.jl")
using Printf

# create a struct to contain the necessary info for a LS model
struct LeastSquares
    betas::Dict
    r_squared::Float64
end

# custom method to print the regression table all nice and fancy
function Base.show(io::IO,z::LeastSquares)
    println(io,"\t\tβ\tse")
    for k in keys(z.betas)
        print(io,"$(@sprintf("%12s",k))","\t",
            "$(@sprintf("%.2f",z.betas[k][1]))\t",
            "$(@sprintf("%.4f",z.betas[k][2]))\n")
    end
    print(io,"\n\tR²:  $(@sprintf("%.4f",z.r_squared))")
end

function ls(formula::String,data::Dict)
    # parse this bad bitch
    parsed = parseFormula(formula,data)
    labels = parsed[3]

    A = parsed[1]
    b = parsed[2]
    n = length(b)
    
    # left division, or "\", is like inversion
    betas  = (A'*A)\(A'*b)
    errors = b-A*betas
    b_hat  = sum(b)/n

    # find r-squared using sum of squares
    sse = errors'*errors
    sst = b'*b-(n*b_hat^2)
    ssr = sst-sse

    # find the standard errors and eventually t-values
    σ² = sse/(n-2)
    invA = inv(A'*A)
    se = [sqrt(σ²*invA[i,i]) for i in 1:size(betas,1)]

    betas_labelled = Dict(zip(labels,zip(betas,se)))
    model = LeastSquares(betas_labelled,1-(sse/sst))

    return model
end


data = Dict(
    :x => [0,1,2,3],
    :z => [1,5,4,9],
    :y => [1,0,2,2]
)

ls("y ~ x*z + z^2 + 1",data)