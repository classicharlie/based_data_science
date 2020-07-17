# the good version using some sick metaprogramming
function parseFormula(formula::String,data::Dict)
    # split the formula into terms
    lhs,rhs = split(replace(formula," " => ""),"~")
    # rhs = replace(rhs,"^" => ".^")
    terms = split(rhs,"+")

    coef_labels = []
    M = Array{Any}(undef,0,0)

    for key in keys(data) @eval const $key = data[$(QuoteNode(key))] end
    dep = eval(Meta.parse(lhs))

    # add a vector of ones to represent an intercept term
    if "1" in terms
        coef_labels = push!(coef_labels,"constant")
        M = ones(length(dep))
        # set terms to evaluate all non-constant terms
        terms = filter!(term->term≠"1",terms)
    end

    # parse each additive term by searching through the dict of ind vars
    for trm in terms
        coef_labels = push!(coef_labels,string(trm))
        trm = replace(trm,"^" => ".^")
        ex = eval(Meta.parse(trm))
        M = hcat(M,ex)
    end
    
    return M,dep,coef_labels
end