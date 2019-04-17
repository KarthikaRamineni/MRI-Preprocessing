from cvxpy import *
import numpy as np

val = np.genfromtxt("points.txt")
(m, n) = val.shape

a = cvxpy.Variable()
b = cvxpy.Variable()
c = cvxpy.Variable()
d = cvxpy.Variable()
e = cvxpy.Variable()
f = cvxpy.Variable()
g = cvxpy.Variable()

sum = 0
for i in range(m):
    fn = a + b * (val[i][0] ** 3) + c * (val[i][1] ** 3) + d * (val[i][0] ** 2) + e * (val[i][1] ** 2) + f * val[i][0] + g * val[i][1]
    sum += (fn - val[i][2]) ** 2

obj = cvxpy.Minimize(sum)

prob = cvxpy.Problem(obj, [])
prob.solve()


fl = open("temp.txt","w+")
fl.write("%f %f %f %f %f %f %f\n" %(float(a.value), float(b.value), float(c.value), float(d.value), float(e.value), float(f.value), float(g.value)))
fl.close()
