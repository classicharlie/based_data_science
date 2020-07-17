# the shitty version that uses regex
function parseFormula(formula::String,data::Dict)
    # split the formula into terms
    terms = split(replace(formula," " => ""),"~")

    ind_vars = Dict()
    dep_vars = Dict()
    M = Array{Any}(undef,0,0)

    # isolate the independent and dependent variables
    for (key, value) in data
        if key == terms[1]
            dep_vars[key] = value
        elseif occursin(key,terms[2])
            ind_vars[key] = value
        end
    end

    # construct a vector of outputs given the name of the dep var
    y = collect(values(dep_vars))
    y = y[1]

    add = split(terms[2],"+")

    # add a vector of ones to represent an intercept term
    if "1" in add
        M = ones(length(y))
    end

    # parse each additive term by searching through the dict of ind vars
    for trm in add
        for ind in keys(ind_vars)
            if occursin(ind,trm)
                # match any numerical values via a regex statement
                rgx_pwr = match(r"(\^)(-?\d+(,\d+)*(\.\d+(e\d+)?)?$)",trm)

                # for a match, extract the number in the exp using .captures[2]
                if rgx_pwr !== nothing
                    pwr = parse(Float64,rgx_pwr.captures[2])
                    M = hcat(M,ind_vars[ind].^pwr)
                else
                    M = hcat(M,ind_vars[ind])
                end
            end
        end
    end

    return M,y
end