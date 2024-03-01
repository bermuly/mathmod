using Plots
using DifferentialEquations

x0 = 8
y0 = 18

a = 0.59
b = 0.058
c = 0.57
d = 0.056

function ode_fn(du, u, p, t)
	x, y = u
	du[1] = -a*x + b*x*y 
	du[2] = c*y - d*x*y
end

v0 = [x0, y0]
tspan = (0.0, 60.0)
prob = ODEProblem(ode_fn, v0, tspan)
sol = solve(prob, dtmax=0.05)
X = [u[1] for u in sol.u]
Y = [u[2] for u in sol.u]
T = [t for t in sol.t]

plt = plot(dpi=300, legend=false)
plot!(plt, X, Y, color=:blue)

savefig(plt, "lab05_1.png") 

plt2 = plot(dpi=300, legend=false)
plot!(plt2, T, X, label="Численность жертв", color=:red)
plot!(plt2, T, Y, label="Численность хищников", color=:green)

savefig(plt2, "lab05_2.png") 