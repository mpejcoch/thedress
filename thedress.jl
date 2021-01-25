### A Pluto.jl notebook ###
# v0.12.18

using Markdown
using InteractiveUtils

# ╔═╡ 305051e6-5e42-11eb-3c5e-393c2b770d5e
begin
	using ColorBlendModes
	using Distances
	using Images
	using SHA
end

# ╔═╡ 40f62c3c-5e42-11eb-3f95-cda6a419efbe
begin
	url = "https://upload.wikimedia.org/wikipedia/en/a/a8/The_Dress_%28viral_phenomenon%29.png"

	download(url, "thedress.png")

	thedress_sha2_256 = "08c12632602c50803177f9f6760c6b99677255477731ad3e8efd36f85d44f689"

	open("thedress.png") do f
   	@assert thedress_sha2_256 == bytes2hex(sha2_256(f))
	end
end

# ╔═╡ 556332d2-5e42-11eb-28e6-1f521e37fad2
thedress = load("thedress.png")

# ╔═╡ 336a077c-5e43-11eb-00bd-d1e1b18c05a5
mask = load("thedress_mask.png")

# ╔═╡ 71937090-5f3f-11eb-0238-759044399d27
BlendMultiply.(thedress, mask)

# ╔═╡ 3ebd3f0e-5e43-11eb-1bfd-bbd85bce62c3
begin
	gold = RGB(1, 215 / 255, 0)
	white = RGB(1, 1, 1)
	blue = RGB(0, 0, 1)
	black = RGB(0, 0, 0)
	
	fourColors = [gold, white, blue, black]
end

# ╔═╡ 944b0afa-5e43-11eb-0614-9fa44a6d4944
begin
    color_distance_GoldWhiteBlueBlack = [0.0, 0.0, 0.0, 0.0]
    new_image = Array{RGB,2}(undef, size(thedress)[1], size(thedress)[2])

    for ci in CartesianIndices(thedress)
        for (i, c) in enumerate(fourColors)
            color_distance_GoldWhiteBlueBlack[i] = evaluate(Euclidean(), channelview([c]), channelview([thedress[ci]])) 
        end
   
        new_image[ci] = fourColors[argmin(color_distance_GoldWhiteBlueBlack)]
    end
end

# ╔═╡ 2dc4fe4c-5f3f-11eb-05a8-e30b84c7bdb1
new_image

# ╔═╡ 82a32580-5f3d-11eb-3e76-733b9c90873c
BlendMultiply.(new_image, mask)

# ╔═╡ 9b1aedfa-5e43-11eb-327c-296484c79912
begin
	nim = new_image[Bool.(mask)]
	map(fourColors) do c
		cpix_count = count(pix -> (pix == c), nim) / length(nim)
		lnim = length(nim)
		md"Color $c Count $cpix_count"
	end
end

# ╔═╡ Cell order:
# ╠═305051e6-5e42-11eb-3c5e-393c2b770d5e
# ╠═40f62c3c-5e42-11eb-3f95-cda6a419efbe
# ╠═556332d2-5e42-11eb-28e6-1f521e37fad2
# ╠═336a077c-5e43-11eb-00bd-d1e1b18c05a5
# ╠═71937090-5f3f-11eb-0238-759044399d27
# ╠═3ebd3f0e-5e43-11eb-1bfd-bbd85bce62c3
# ╠═944b0afa-5e43-11eb-0614-9fa44a6d4944
# ╠═2dc4fe4c-5f3f-11eb-05a8-e30b84c7bdb1
# ╠═82a32580-5f3d-11eb-3e76-733b9c90873c
# ╠═9b1aedfa-5e43-11eb-327c-296484c79912
