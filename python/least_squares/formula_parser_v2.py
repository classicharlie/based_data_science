def parse(formula:str,data:dict):
    # split the formula into terms
    lhs,rhs = formula.replace(' ','').split('~')
    terms = rhs.split('+')

    coef_labels = []
    M = []

    for k,v in data.items(): exec(k+'='+str(v))
    dep = eval(lhs)

    # add a vector of ones to represent an intercept term
    if '1' in terms:
        coef_labels.append('constant')
        M.append([1 for i in range(len(dep))])
        # set terms to evaluate all non-constant terms
        terms.remove('1')

    # this will break if interaction terms are implemented
    for trm in terms:
        coef_labels.append(str(trm))
        trm = trm.replace('^','**')

        var = compile(trm,'<term>','exec').co_names[0]
        func = eval(trm.replace(var,'lambda t:t'))

        M.append([func(i) for i in eval(var)])

    # transpose that shit like you should have all along
    M = [list(m) for m in zip(*M)]
    dep = [[i] for i in dep]

    return M,dep,coef_labels