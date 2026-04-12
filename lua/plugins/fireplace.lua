return {
	"tpope/vim-fireplace",

    -- copied from the LazyVim clojure extra
	recommended = function()
		return LazyVim.extras.wants({
			ft = { "clojure", "edn" },
			root = { "project.clj", "deps.edn", "build.boot", "shadow-cljs.edn", "bb.edn" },
		})
	end,
}
