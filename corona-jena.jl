### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 23671914-5cef-11eb-2b76-8161d5326fc6
using CSV

# ╔═╡ abb6c3be-5cef-11eb-3133-072602116ca7
using DataFrames

# ╔═╡ e67b0672-5cef-11eb-0469-b1e7235b32ff
using Dates

# ╔═╡ 4844cf8e-5cf0-11eb-3dc3-7dc0d8555dc1
using Plots

# ╔═╡ 9c64b37a-5cff-11eb-3d84-333daa0ceebc
using Statistics

# ╔═╡ 30629c0e-5d85-11eb-1443-c179c474f226
jenaDataUrl = "https://opendata.jena.de/dataset/2cc7773d-beba-43ad-9808-a420a67ffcb3/resource/d3ba07b6-fb19-451b-b902-5b18d8e8cbad/download/corona_erkrankungen_jena.csv"

# ╔═╡ 4e0be99c-5d85-11eb-2ea1-f9ae70ed03ac
jenaDataPath = "data/corona-jena.csv"

# ╔═╡ 3f805796-5d85-11eb-0f52-d9297b5e1803
begin
	download(jenaDataUrl, jenaDataPath)
	df = CSV.File(jenaDataPath) |> DataFrame
end

# ╔═╡ f21fa00a-5cef-11eb-097d-677d90a6a866
days = unix2datetime.(df.zeit)

# ╔═╡ 14d6da92-606e-11eb-0045-99f86ed39628
lastUpdate = (time=unix2datetime(df.zeit[end]), infections=df.neu_erkrankte[end])

# ╔═╡ fb849638-5cf0-11eb-29cc-51a4a787a806
days2021 = [day for day in days if Dates.year(day) >= 2021]

# ╔═╡ 28cf2994-5cf1-11eb-36e1-2526bc45ffdf
187 / 172.7

# ╔═╡ 65f5978e-5cfd-11eb-2082-f3c64f6a276e
216 / 1.08207

# ╔═╡ e396b34e-5cfd-11eb-2efe-63c5d7fa275e
dataJena = CSV.File("data/from-jena-homepage.csv") |> DataFrame

# ╔═╡ 2302ab40-5d86-11eb-2cb0-f32306ab705d
dataJenaTime = unix2datetime.(dataJena.time)

# ╔═╡ 5a1b68ba-5cff-11eb-2bd6-99cb2bbf2284
ratio = dataJena.total ./ dataJena.per100k

# ╔═╡ 7b3d22cc-5cff-11eb-23da-a363cf9adcfa
correction = 1.11434 / Statistics.mean(ratio)

# ╔═╡ 6641e4c4-5d87-11eb-3158-c5b917fb2b9a
Statistics.mean(ratio)

# ╔═╡ 828566f2-5cf0-11eb-0eb2-ab71632ece9b
sevenDaysIncidence = [sum(df.neu_erkrankte[i-6:i])/1.11434 for i in 7:length(df.zeit)]

# ╔═╡ e8f7e122-6230-11eb-321c-f14ebcb04ae3
currentIncidence = sevenDaysIncidence[end]

# ╔═╡ ca20bed2-6301-11eb-2790-e35382c404f8
sevenDaysIncidence[end-1]

# ╔═╡ d48f9292-6301-11eb-1908-dff593481617
sevenDaysIncidence[end-7]

# ╔═╡ b08f2eb0-5d00-11eb-3053-d5c6c3123740
sevenDaysCorrected = sevenDaysIncidence .* correction

# ╔═╡ 3ff6e226-64cc-11eb-3feb-a18306e336f4
fourteenDaysIncidence = [sum(df.neu_erkrankte[i-13:i])/1.11434 for i in 14:length(df.zeit)]

# ╔═╡ ed672170-5cef-11eb-0093-4973699ace66
begin
	plot(days, df.neu_erkrankte, fmt=png, legend=(0.15, 0.95), label="new infections", title="New Corona infections in Jena", )
	plot!(days[7:end], sevenDaysIncidence, label="7 days incidence")
	plot!(days[14:end], fourteenDaysIncidence, label="14 days incidence")
	plot!(days, df.aktive_faelle, label="active cases")
end

# ╔═╡ 067024ea-5d87-11eb-127f-57bf165a065f
md"""
7-days-incidence reported on Jena website seems to be calculated with other population (something like `108'300`). here, we use the value from Thüringer Landesamt für Statistik of 2019, `111'434`. Hence, we also present corrected data (which estimates the 7-days-incidence Jena is publishing on it's website for that day).
"""

# ╔═╡ d21cf31a-5cf0-11eb-2760-81a807d13292
begin
	plot(days[end-6:end], sevenDaysIncidence[end-6:end], fmt=png, label="7 days incidence", title="seven days incidences of last seven days", legend=(.15, .2))
	plot!(days[end-6:end], sevenDaysCorrected[end-6:end], label="7 days incidence corrected")
end

# ╔═╡ e2673e42-5cf0-11eb-0d79-19eb998d4633
begin
	plot(days, df.aktive_faelle, fmt=png, legend=(.15, .95), label="active")
	#plot!(days, df.erkrankte, label="total")
	plot!(days, df.tote, label="deaths")
end

# ╔═╡ Cell order:
# ╠═23671914-5cef-11eb-2b76-8161d5326fc6
# ╠═abb6c3be-5cef-11eb-3133-072602116ca7
# ╠═30629c0e-5d85-11eb-1443-c179c474f226
# ╠═4e0be99c-5d85-11eb-2ea1-f9ae70ed03ac
# ╠═3f805796-5d85-11eb-0f52-d9297b5e1803
# ╠═e67b0672-5cef-11eb-0469-b1e7235b32ff
# ╠═f21fa00a-5cef-11eb-097d-677d90a6a866
# ╠═14d6da92-606e-11eb-0045-99f86ed39628
# ╠═e8f7e122-6230-11eb-321c-f14ebcb04ae3
# ╠═ca20bed2-6301-11eb-2790-e35382c404f8
# ╠═d48f9292-6301-11eb-1908-dff593481617
# ╠═4844cf8e-5cf0-11eb-3dc3-7dc0d8555dc1
# ╠═ed672170-5cef-11eb-0093-4973699ace66
# ╠═fb849638-5cf0-11eb-29cc-51a4a787a806
# ╠═28cf2994-5cf1-11eb-36e1-2526bc45ffdf
# ╠═65f5978e-5cfd-11eb-2082-f3c64f6a276e
# ╠═e396b34e-5cfd-11eb-2efe-63c5d7fa275e
# ╠═2302ab40-5d86-11eb-2cb0-f32306ab705d
# ╠═5a1b68ba-5cff-11eb-2bd6-99cb2bbf2284
# ╠═7b3d22cc-5cff-11eb-23da-a363cf9adcfa
# ╠═6641e4c4-5d87-11eb-3158-c5b917fb2b9a
# ╠═b08f2eb0-5d00-11eb-3053-d5c6c3123740
# ╠═9c64b37a-5cff-11eb-3d84-333daa0ceebc
# ╠═828566f2-5cf0-11eb-0eb2-ab71632ece9b
# ╠═3ff6e226-64cc-11eb-3feb-a18306e336f4
# ╠═067024ea-5d87-11eb-127f-57bf165a065f
# ╠═d21cf31a-5cf0-11eb-2760-81a807d13292
# ╠═e2673e42-5cf0-11eb-0d79-19eb998d4633
