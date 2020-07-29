# the good version using some sick metaprogramming
function parseFormula(formula::String,data::Dict{Symbol,Array{Float64,1}})
    # split the formula into terms
    lhs,rhs = split(replace(formula," " => ""),"~")
    rhs = replace(rhs,"^" => ".^")
    rhs = replace(rhs,"*" => ".*")
    terms = split(rhs,"+")

    for (key,value) in data eval(:($key = $value)) end
    dep = eval(Meta.parse(lhs))

    coef_labels = String[]
    M = Array{Float64}(undef,0,0)

    # add a vector of ones to represent an intercept term
    if "1" in terms
        coef_labels = push!(coef_labels,"constant")
        M = ones(Float64,length(dep))
        # set terms to evaluate all non-constant terms
        filter!(term->term≠"1",terms)
    end

    # parse each additive term by searching through the dict of ind vars
    for trm in terms
        coef_labels = push!(coef_labels,trm)
        ex = eval(Meta.parse(trm))
        M = hcat(M,ex)
    end
    
    return M,dep,coef_labels
end

data = Dict(
    :x => [0,1,2,3],
    :z => [1,5,4,9],
    :y => [1,0,2,2]
)

@code_warntype parseFormula("y ~ x*z + z^2 + 1",data)