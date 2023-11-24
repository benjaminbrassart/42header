--[[
local ascii = {
	"        :::      ::::::::",
	"      :+:      :+:    :+:",
	"    +:+ +:+         +:+  ",
	"  +#+  +:+       +#+     ",
	"+#+#+#+#+#+   +#+        ",
	"     #+#    #+#          ",
	"    ###   ########.fr    ",
}

local function get_date()
	return os.date("%Y/%m/%d %H:%M:%S")
end
--]]

local function has_header()
	return false
end

local function update_header()
	print 'Update header'
end

local function create_header()
	print 'Create header'
end

local function stdheader()
	if has_header() then
		update_header()
	else
		create_header()
	end
end

local function register_auto_cmds()
	local group = vim.api.nvim_create_augroup("42header", { clear = true })

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = group,
		callback = function()
			stdheader()
		end,
	})
end

register_auto_cmds()
vim.api.nvim_create_user_command("Stdheader", stdheader, {})

return {
	stdheader = stdheader,
}
