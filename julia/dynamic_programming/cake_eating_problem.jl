# the cake eating problem is a classic example of dynamic programming

β = .7
α = 0
T = 20

x = Float64[20]  # 20 units of cake

# we are solving the following optimization problem
# max{ Σ β^t u(c[t]) }    s.t.    c[t] = x[t] - x[t+1]

function adjustX(min_x,max_x,initial_x)
    new_x = [initial_x]
    push!(new_x,(max_x+min_x)/2)

    for t in 3:T+2
        # push!(new_x,β*new_x[t]/(1+β))
        push!(new_x,(1+β)*new_x[t-1]-β*new_x[t-2])
    end

    return new_x
end

min_x = 0
max_x = x[1]

x = adjustX(min_x,max_x,x[1])

while true
    global x, max_x, min_x
    if x[T+1] > 0.00001
        max_x = x[2]
    elseif x[T+1] < -0.00001
        min_x = x[2]
    else
        break
    end
    x = adjustX(min_x,max_x,x[1])
end

println(x)

c = [x[t]-x[t+1] for t in 1:T-1]
sum([β^(t-1)*log(c[t]) for t in 1:T-1])