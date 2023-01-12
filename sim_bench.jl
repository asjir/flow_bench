using Plots, WaterLily
using LinearAlgebra: norm2

function circle(n, m; Re=250)
    # Set physical parameters
    U, R, center = 1.0, m / 8.0, [m / 2, m / 2]
    ν = U * R / Re
    @show R, ν

    body = AutoBody((x, t) -> norm2(x .- center) - R)
    Simulation((n + 2, m + 2), [U, 0.0], R; ν, body)
end


function gen_data(ts::AbstractRange)
    @info "gen data... "
    p = Progress(length(ts))

    n, m = 3(2^5), 2^6
    circ = circle(n, m)

    𝐩s = Array{Float32}(undef, 1, n, m, length(ts))
    for (i, t) in enumerate(ts)
        sim_step!(circ, t)
        𝐩s[1, :, :, i] .= Float32.(circ.flow.p)[2:(end-1), 2:(end-1)]

        next!(p)
    end
    return 𝐩s
end

n = 20
@time data = gen_data(LinRange(100, 100 + n - 1, n))


anim = @animate for i in 1:size(data)[end]
    heatmap(data[1, 2:(end-1), 2:(end-1), i]', color=:coolwarm,
        clim=(-1.5, 1.5))
    scatter!([size(data, 3) ÷ 2 - 2.5], [size(data, 3) ÷ 2 - 2.25],
        markersize=40, color=:black, legend=false, ticks=false)
    annotate!(5, 5, text("i=$i", :left))
end
gif(anim, "waterlily.gif", fps=2)


using ViscousFlow

function circle2(n, m; Re=250)
    U, R, center = 1.0, m / 8.0, (m / 2, m / 2)
    my_params = Dict()
    my_params["Re"] = Re
    my_params["freestream speed"] = U
    my_params["freestream angle"] = 0.0

    xlim = (0, n + 2)
    ylim = (0, m + 2)
    my_params["grid Re"] = 25.0
    g = setup_grid(xlim, ylim, my_params)

    Δs = surface_point_spacing(g, my_params)
    body = Circle(R, Δs)
    body = RigidTransform(center, 0)(body)
    sys = viscousflow_system(g, body, phys_params=my_params)
end

gen_data2(ts) =
    let sys = circle2(3 * 2^1, 2^2)
        u0 = init_sol(sys)
        tspan = (0.0, 20.0)
        integrator = init(u0, tspan, sys)

        @info "gen data... "
        p = Progress(length(ts))
        n, m = u0.x[1] |> size
        @info n m
        𝐩s = Array{Float32}(undef, 1, n - 2, m - 2, length(ts))
        step!(integrator, first(ts))
        for (i, t) in enumerate(ts[2:end])
            𝐩s[1, :, :, i] .= Float32.(integrator.u.x[1])[2:(end-1), 2:(end-1)]
            step!(integrator, 1.0)
            next!(p)
        end
        return 𝐩s
    end

n = 20
@time data = gen_data2(LinRange(100, 100 + n - 1, n))

anim = @animate for i in 1:size(data)[end]
    heatmap(data[1, 2:(end-1), 2:(end-1), i]', color=:coolwarm,
        clim=(-1.5, 1.5))
    scatter!([size(data, 3) ÷ 2 - 2.5], [size(data, 3) ÷ 2 - 2.25],
        markersize=40, color=:black, legend=false, ticks=false)
    annotate!(5, 5, text("i=$i", :left))
end

gif(anim, "viscousflow.gif", fps=2)
