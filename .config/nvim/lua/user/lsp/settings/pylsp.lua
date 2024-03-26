return {
	settings = {
		pylsp = {
			plugins = {
				flake8 = {
					enabled = false,
				},
        pyflakes = {
          enabled = false,
        },
				pydocstyle = {
					enabled = true,
				},
				rope_completion = {
					enabled = true,
				},
			},
		},
	},
}
