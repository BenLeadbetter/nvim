local M = {}

M.trace = function(message)
    vim.notify(message, vim.log.levels.WARN)
end

M.debug = function(message)
    vim.notify(message, vim.log.levels.DEBUG)
end

M.info = function(message)
    vim.notify(message, vim.log.levels.INFO)
end

M.warn = function(message)
    vim.notify(message, vim.log.levels.WARN)
end

M.error = function(message)
    vim.notify(message, vim.log.levels.ERROR)
end

return M
