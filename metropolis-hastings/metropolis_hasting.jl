# 2次元ガウス N(0, I) からのサンプリング
# 提案分布をN(z^(t-1), I)とする

using Random
using Distributions
using Plots

function sampling(mu::Array{Float64, 1})
  sigma = [1.0 0.; 0. 1.0]
  z_t = rand(MvNormal(mu, sigma))
  z_t
end

function pdf_true(z::Array{Float64, 1})
  mu = [0.0, 0.0]
  sigma = [1.0 0.; 0. 1.0]
  d = MvNormal(mu, sigma)

  pdf(d, z)
end

function pdf_suggest(z1::Array{Float64, 1}, z2::Array{Float64, 1})
  mu = z2
  sigma = [1.0 0.; 0. 1.0]
  d = MvNormal(mu, sigma)

  pdf(d, z1)
end

function accept_ratio(z_before::Array{Float64, 1})
  z_star = sampling(z_before)
  r = (pdf_true(z_star) * pdf_suggest(z_before, z_star)) / (pdf_true(z_before) * pdf_suggest(z_star, z_before))

  z_star, r
end

zs = Array{Float64, 1}[]
accepts = Bool[]
z_t = rand(Float64, 2)
push!(zs, z_t)
push!(accepts, true)

for i in 1:50
  z_star, r = accept_ratio(z_t)
  r = min(1.0, r)
  if r >= rand(Uniform(0., 1.0))
    push!(zs, z_star)
    push!(accepts, true)
    global z_t = z_star
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
