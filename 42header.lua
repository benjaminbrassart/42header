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

local user = nil
local mail = nil

local function has_header()
	return false
end

local function update_header()
	print 'Update header'
end

local function create_header()
	print('Create header')
end

local function stdheader()
	if has_header() then
		update_header()
	else
		create_header()
	end
end

local function setup(opts)
	local group = vim.api.nvim_create_augroup("42header", { clear = true })

	vim.api.nvim_create_autocmd("BufWritePre", {
		group = group,
		callback = stdheader,
	})

	vim.api.nvim_create_user_command("Stdheader", stdheader, {})

	if opts ~= nil then
		for k, v in pairs(opts) do
			if k == "user" then
				user = v
			elseif k == "mail" then
				mail = v
			end
		end
	end

	if user == nil or user == "" then
		user = "marvin"
	end

	if mail == nil or mail == "" then
		mail = user .. "@student.42.fr"
	end
end

return {
	setup = setup,
}
