# you should all know Python well enough, but there are a few things I need to
# teach you before we do anything serious

def myFunction():       # nested statements are defined by : and tabs in Python;
    print('u = v')      # Julia requires 'end' as opposed to whitespsaces

# one concept that is absolutely necessary is the dictionary; which is a very
# powerful data structure for...well...data

data = {'x':[0,1,2,3],'y':[9,3,19,17]}          # maps x,y to arrays of data

k = data.keys()                         # returns an array of dictionary keys
v = data.values()                       # returns an array of dictionary values
k,v = data.items()                      # does both of the above in less code

# convert a dictionary to individual variables using exec() which is akin to
# metaprogramming; you can also use eval() for one liners

for k,v in data.items(): exec(k+'='+str(v))     # this will do the job!

# now suppose we have an array we want to raise to the 2nd power using eval
# in Python it is a little more difficult

statement = 'x**2'                          # obviously we cannot do this to an
try: eval(statement)                        # array, since eval takes a compiled
except TypeError: print('not a chance')     # string and runs the code

# eval() takes a string => compile(string) => runs compile(string) as script, so
# we need to take the parts of the code we want and rearrange it to apply to an
# array. using lambda calculus, take the given argument and apply

var = compile(statement,'<term>','exec').co_names[0]    # compile but don't run
func = eval(statement.replace(var,'lambda t:t'))        # convert to a function
print([func(i) for i in eval(var)])                     # apply to our variable

# compile() returns a code object (co) and .co_names[0] returns the first var-
# iable in the statement as a string, so we still need to evaluate it to return
# the actual variable

# this is a fairly useful concept if you want to design modular code that you
# can use for projects in the future. it may seem overkill, but this will work
# right out of the box if you apply it to a totally different context.