using Distributions
using Plots

function sampling()
  d = Normal(0, 1)
  z_star = rand(d, 1)

  z_star[1]
end

function main()
  z1s = Float64[]
  z2s = Float64[]

  z1 = rand(Uniform(0, 1), 1)
  push!(z1s, z1[1])
  z2 = rand(Uniform(0, 1), 1)
  push!(z2s, z2[1])

  for i in 1:20
    push!(z2s, z2s[end])
      push!(z1s, sampling())

      push!(z1s, z1s[end])
      push!(z2s, sampling())
  end

  scatter(z1s, z2s)
  plot!(z1s, z2s)

  savefig("sampling.pdf")
end

main()
