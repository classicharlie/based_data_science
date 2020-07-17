x = [0,1,2,3]

trm = 'x**2'

var = compile(trm,'<term>','exec').co_names[0]
func = eval(trm.replace(var,'lambda t:t'))

print([func(i) for i in eval(var)])