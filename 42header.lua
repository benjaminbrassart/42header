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
	local header_lines = vim.api.nvim_buf_get_lines(0, 0, 11, false)

	if #header_lines < 11 then
		-- buffer does not have enough lines
		return false
	end

	for _, line in ipairs(header_lines) do
		-- TODO improve header detection
		if #line ~= 80 then
			return false
		end
	end

	return true
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
	local update_on_write = true

	vim.api.nvim_create_user_command("Stdheader", stdheader, {})

	if opts ~= nil then
		for k, v in pairs(opts) do
			if k == "user" then
				user = v
			elseif k == "mail" then
				mail = v
			elseif k == "update_on_write" then
				update_on_write = v
			end
		end
	end

	if user == nil or user == "" then
		user = "marvin"
	end

	if mail == nil or mail == "" then
		mail = user .. "@student.42.fr"
	end

	if update_on_write then
		local group = vim.api.nvim_create_augroup("42header", { clear = true })

		vim.api.nvim_create_autocmd("BufWritePre", {
			group = group,
			callback = stdheader,
		})
	end
end

return {
	setup = setup,
}
