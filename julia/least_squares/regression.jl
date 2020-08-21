# least squares parser and algorithm Julia implementation
include("./formula_parser_v2.jl")
include("./t_test.jl")
using Printf

# create a struct to contain the necessary info for a LS model
struct LeastSquares
    betas::Dict
    r_squared::Float64
end

# custom method to print the regression table all nice and fancy
function Base.show(io::IO,z::LeastSquares)
    println(io,"\t β\t se\t t")
    for k in keys(z.betas)
        print(io,"$(@sprintf("%.5s",k))","\t",
            "$(@sprintf("% .2f",z.betas[k][1]))\t",
            "$(@sprintf("% .3f",z.betas[k][2]))\t",
            "$(@sprintf("% .3f",z.betas[k][3]))  ",
            z.betas[k][4],"\n")
    end
    println(io,"----\np-val:  0 ‘***’ .001 ‘**’ .01 ‘*’ .05 ‘.’ .1")
    print(io,"\nR²:  $(@sprintf("%.4f",z.r_squared))")
end

# convert t-value to p-value
function pValue(t_value::Float64,df::Int64)
    # find the corresponding df
    for k in df_keys
        global idx
        if k <= df
            idx = k
        else
            break
        end
    end
    
    row = t_dist[idx]
    num_cols = length(row)
    
    # find the nearest t-value and return α level
    for i in 1:num_cols
        global code
        if row[i] <= abs(t_value)
            code = conf[i]
        else
            break
        end
    end

    return code
end

# least squares method for linear regression
function ls(formula::String,data::Dict)
    # A ≡ formula matrix, b ≡ dependent vector
    A,b,labels = parseFormula(formula,data)

    n,m = size(A)
    df = n-m
    
    # technically β = A\b is more accurate, but this is faster
    β = (A'*A)\(A'*b)
    ϵ = b-A*β
    b_bar = sum(b)/n

    # find r-squared using sum of squares
    ssr = ϵ'*ϵ
    sst = b'*b-(n*b_bar^2)
    sse = sst-ssr

    # find the standard errors and eventually t-values
    σ² = sse/df
    invA = inv(A'*A)
    se = [sqrt(σ²*invA[i,i]) for i in 1:size(β,1)]

    t = [β[i]/se[i] for i in 1:m]
    p = [pValue(t_val,df) for t_val in t]

    betas_labelled = Dict(zip(labels,zip(β,se,t,p)))
    model = LeastSquares(betas_labelled,1-(sse/sst))

    return model
end


data = Dict(
    :x => [0.0,1.0,2.0,3.0],
    :z => [1.0,5.0,4.0,9.0],
    :y => [1.0,0.0,2.0,2.0]
)

ls("y ~ x*z + z^2 + 1",data)