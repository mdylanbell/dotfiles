return {
	"folke/snacks.nvim",
	optional = true,
	opts = {
		picker = {
			sources = {
				files = {
					hidden = true,
					ignored = false,
				},
				explorer = {
					hidden = true,
					matcher = {
						fuzzy = true,
					},
				},
			},
		},
	},
}
