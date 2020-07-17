import re

def parse(model,data):
    '''
    Parses regression equations into a matrix.
    
    To add a constant terms, use '+1'; to add exponents, use 'x^3'; for 
    multiplication, use '4*x'.
    '''

    m = model.replace(' ','')
    m = m.split('~')
    M = []

    ind_vars = {}
    dep_vars = {}

    for key,val in data.items():
        if key == m[0]:
            dep_vars[key] = val
        elif key in m[1]:
            ind_vars[key] = val

    y = list(dep_vars.values())
    y = y[0]

    try:
        add = re.split(r'\+',m[1])
    except TypeError:
        add = m[1]

    if "1" in add:
        M.append([1.0 for i in y])
        
    # parse each additive term by searching through the dict of ind vars
    for trm in add:
        for ind in ind_vars.keys():
            if ind in trm:
                # match any numerical values via a regex statement
                rgx_pwr = re.search(ind+r'(\^)(\d)',trm)

                # for a match, extract the number in the exp using .captures[2]
                if rgx_pwr:
                    M.append([i**float(rgx_pwr.group(2)) for i in ind_vars[ind]])
                else:
                    M.append([float(i) for i in ind_vars[ind]])

        
    y = [[i] for i in y]
    M = [*map(list,[*zip(*M)])]

    return M,y