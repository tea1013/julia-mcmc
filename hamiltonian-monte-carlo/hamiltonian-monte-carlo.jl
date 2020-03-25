using Distributions
using LinearAlgebra
using Plots

function sampling_p()
  mu = [0., 0.]
  sigma = [1.0 0.; 0. 1.0]
  p = rand(MvNormal(mu, sigma))

  p
end

function sampling(z_before::Array{Float64, 1}, p_before::Array{Float64, 1}, epsilon::Float64, L::Int64)
  z_i = z_before
  p_i = p_before
  for i in 1:L
    z_i = (1 + 0.5 * epsilon^2) .* z_i + epsilon .* p_i
    p_i = (1 + 0.5 * epsilon^2) .* p_i + (epsilon + 0.25 * epsilon^3) .* (z_i)
  end

  z_i, p_i
end

sampling(z_before, p_before) = sampling(z_before, p_before, 0.02, 10)

function hamiltonian(z::Array{Float64, 1}, p::Array{Float64, 1})
  mu = [0., 0.]
  sigma = [1.0 0.; 0. 1.0]
  d = MvNormal(mu, sigma)
  u = pdf(d, z)
  k = 0.5 * norm(p)^2

  u + k
end

function main()
  zs = Array{Float64, 1}[]
  accepts = Bool[]
  z_t = rand(Float64, 2)
  push!(zs, z_t)
  push!(accepts, true)

  for i in 1:50
    p_t = sampling_p()
    z_star, p_star = sampling(z_t, p_t)
    r = min(1, hamiltonian(z_star, p_star) / hamiltonian(z_t, p_t))
    if r >= rand(Uniform(0., 1.0))
      push!(zs, z_star)
      push!(accepts, true)
      z_t = z_star
    else
      push!(zs, z_star)
      push!(accepts, false)
    end
  end

  for (i, z_i) in enumerate(zs)
    if i == 1
      scatter!([z_i[1]], [z_i[2]], color="green", legend=false)
    elseif accepts[i]
      scatter!([z_i[1]], [z_i[2]], color="blue", legend=false)
    else
      scatter!([z_i[1]], [z_i[2]], color="red", legend=false)
    end
  end

  plot!(hcat(zs...)[1, :], hcat(zs...)[2, :])

  savefig("sampling.pdf")
end

main()
