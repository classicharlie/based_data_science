# this is Julia and it is very similar to Python except faster and better for
# overall scientific computing (which is what we do)

print("Hello World")    # prints Hello World
println("Hello World")  # prints Hello World with a line break at the end


# to install packages you have to press "]" in the Julia environment to launch
# the pkg interface, and then type "add PackageName" and import like so...

using LinearAlgebra

# now let's move to general syntax, this applies to shit like functions,
# conditionals, and structs

function myFunction()           # functions are fairly straight forward, just
    println("u ≠ v")            # use the word function and write the argument,
end                             # and optionally a return

function demoFunc(x::Array)
    return x.^2
end

v = [2 3; 4 5]
w = demoFunc(v)

println(w)

# the reduce function is pretty sick, applying + to every element in the array
# until you get to the last one, hence reducing it to one element

factiorial(x::Int) = reduce(*,1:x)  # this is another way to write functions,
println(factorial(4))               # but only do it for shorter statements

demoFunc2(x::Array) = x.^2
println(demoFunc2(v))

# VERY IMPORTANT Julia treats arrays a little differently than python; here 
# commas define one dimensional arrays, whereas spaces define vectors

# arrays types: Array{T,N} such that T = type and N = dimensions; arrays are
# also indexed at one, not zero like in Python (this still fucks me up)

u = [0,1,2,3]   # this is a 4-element Array{Int64,1}
v = [0 1 2 3]   # this is a 1x4 Array{Int64,2}

if u == v
    println("not supposed to print")
else
    myFunction()
    println("u:\t",typeof(u))
    println("v:\t",typeof(v))
end

# now lets work with matrices from base Julia, which are very similar to Matlab
# which is rarely a good thing, but in this case it is

A = [1 2 3; 4 1 6; 7 8 1]   # A = 1  2  3       B = 1  4  7
B = [1 4 7; 2 1 8; 3 6 1]   #     4  1  6           2  1  8
                            #     7  8  1           3  6  1

# transpose is built in using the apostrophe; however, it is a different object
# type which may cause some problems if you write shitty code, but it's all good

if A' == B
    println("A' is the transpose of A")
end


# applying what little we know of Julia, write some code you are familiar with
# I chose least squares because it's familiar and takes advantage of some very
# important methods used in drafting algorithms

x = [0 1 2 3]
y = [9 3 19 17]

# recall the process to solve for a least squares solution:
#   Ax = b  =>  A'Ax = A'b
#           =>  x = (A'A)⁻¹A'b

function ls(x,y)
    # in this example, let y ~ β0 + β1x, hence A = [1 0; 1 1; 1 2; 1 3]
    A = [1 0; 1 1; 1 2; 1 3]    # which isn't v cash money
    A = [ones(1,length(x));x]'  # which is modular and $$$
    b = y'
    
    lhs,rhs = A'*A,A'*b     # defines two variables at a time
    β = lhs\rhs             # left division, or "\", is essentially inversion

    return β    # also Julia can parse unicode chars like β, ∈, ≠, etc.
end             # you can actually use ∈ as a built in operation

ls(x,y)