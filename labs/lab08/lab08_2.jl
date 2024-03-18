using Plots
using DifferentialEquations

cr = 10.5
N = 28
q = 1
t1 = 16
t2 = 25
p1 = 7.2
p2 = 5.1

a1 = cr / (t1 * t1 * p1 * p1 * N * q)
a2 = cr / (t2 * t2 * p2 * p2 * N * q)
b = cr / (t1 * t1 * p1 * p1 * t2 * t2 * p2 * p2 * N * q)
c1 = (cr - p1) / (t1*p1)
c2 = (cr - p2) / (t2*p2)

function ode_fn(du, u, p, t)
	M1, M2 = u
	du[1] = u[1] - (b / c1 + 0.0007) * u[1] * u[2] - a1 / c1 * u[1] * u[1]
	du[2] = c2 / c1 * u[2] - b / c1 * u[1] * u[2] - a2 / c1 * u[2] * u[2]
end

v0 = [4.4, 4]
tspan = (0.0, 30.0)
prob = ODEProblem(ode_fn, v0, tspan)
sol = solve(prob, dtmax = 0.05)
M1 = [u[1] for u in sol.u]
M2 = [u[2] for u in sol.u]
T = [t for t in sol.t]

plt = plot(dpi = 600, legend = :topright)

plot!(plt, T, M1, label = "Оборотные средства фирмы #1", color = :green)
plot!(plt, T, M2, label = "Оборотные средства фирмы #2", color = :red)

savefig(plt, "lab08_2.png")