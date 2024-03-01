using Plots
using DifferentialEquations

N = 10100
I0 = 66
R0 = 26
S0 = N - I0 - R0

alpha = 0.2
beta = 0.6

function ode_fn(du, u, p,t)
	S, I, R = u
	du[1] = 0
	du[2] = -beta*u[2]
	du[3] = beta*I
end

v0 = [S0, I0, R0]
tspan = (0.0, 60.0)
prob = ODEProblem(ode_fn, v0, tspan)
sol = solve(prob, dtmax = 0.05)
S = [u[1] for u in sol.u]
I = [u[2] for u in sol.u]
R = [u[3] for u in sol.u]
T = [t for t in sol.t]

plt = plot(dpi=600, legend=:topright)
plot!(plt, T, S, label = "Восприимчивые особи", color=:blue)
plot!(plt, T, I, label = "Инфицированные особи", color=:green)
plot!(plt, T, R, label = "Особи с иммунитетом", color=:red)

savefig(plt, "lab06_1.png")