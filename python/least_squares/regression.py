from formula_parser_v2 import parse

# OLS regression algorithm using matrix manipulation and a custom function parser

def matrixProd(X,Y):
    '''
    Calculate the product of two matrices, order matters
    '''

    return [[sum(a*b for a,b in zip(x,y)) for y in zip(*Y)] for x in X]


def rref(M):
    '''
    Gauss Jordan Row Reduction of any given matrix M
    '''
    
    c = 0

    for r in range(len(M)):
        if c >= len(M[0]):
            break
        i = r

        while M[i][c] == 0:
            i += 1
            if i == len(M):
                i = r
                c += 1
                if len(M[0]) == c:
                    break

        M[i],M[r] = M[r],M[i]
        lv = M[r][c]
        M[r] = [v/float(lv) for v in M[r]]

        for i in range(len(M)):
            if i != r:
                l = M[i][c]
                M[i] = [v-l*u for u,v in zip(M[r],M[i])]

        c += 1
    
    return M


def ls(formula,data):
    '''
    Least squares regression algorithm using matrix manipulation
    '''

    A,b,labels = parse(formula,data)

    for i in range(len(A)):
        if len(A[i]) != len(A[i-1]):
            raise IndexError('Inconsistent row length in X')
        else:
            continue
    
    if len(A) != len(b):
        raise IndexError('Expected %d arguments, received %d' % (len(A),len(b)))

    else:
        At = [list(i) for i in zip(*A)]
        lhs = matrixProd(At,A)
        rhs = matrixProd(At,b)

        for i in range(len(lhs)): lhs[i].extend(rhs[i])
        B = [m[-1] for m in rref(lhs)]
        Betas = dict(zip(labels,B))
        
        return Betas


obs = {
    'x': [0,1,2,3],
    'y': [1,0,2,2]
}

model = ls(
    formula = 'y ~ x + x^2 + 1',
    data = obs
)

print(model)