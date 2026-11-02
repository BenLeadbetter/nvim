return {
	"folke/todo-comments.nvim",
	opts = {
		keywords = {
			-- NOTE: Marks a justification for why an `unsafe` block upholds its invariants.
			SAFETY = { icon = " ", color = "safety" },
		},
		colors = {
			-- NOTE: Uses the theme's DiagnosticOk colour, falling back to a hex colour if it isn't defined.
			safety = { "DiagnosticOk", "#22C55E" },
		},
	},
}
