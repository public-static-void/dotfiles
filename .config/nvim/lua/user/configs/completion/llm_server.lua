--- Shared completion utilities

local M = {}

M.base_url = "http://localhost:8080"
M.model = "Qwen2.5-Coder-1.5B-Instruct-Q8_0"

--- Check if llm server is reachable.
function M.reachable()
	local ok, code = pcall(function()
		local res = vim.fn.system('curl -s -o /dev/null -w "%{http_code}" ' .. M.base_url .. "/health")
		return tonumber(res) == 200
	end)
	return ok and code
end

return M
