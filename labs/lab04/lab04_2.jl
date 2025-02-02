using DifferentialEquations
using Plots

function lorenz!(du, u, p, t)
	a, b = p
	du[1] = u[2]
	du[2] = -a*du[1] - b*u[1]
end

const x = 1.5
const y = 1.1
u0 = [x, y]

p = (3, 3)
tspan = (0.0, 44.0)
prob = ODEProblem(lorenz!, u0, tspan, p)
sol = solve(prob, dtmax = 0.05)

plot(sol)
savefig("lab4_2_juliasolve.png")

plot(sol, vars=(1,2))
savefig("lab4_2_juliaphase.png")