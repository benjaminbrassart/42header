local LOGO = {
	"                         ",
	"        :::      ::::::::",
	"      :+:      :+:    :+:",
	"    +:+ +:+         +:+  ",
	"  +#+  +:+       +#+     ",
	"+#+#+#+#+#+   +#+        ",
	"     #+#    #+#          ",
	"    ###   ########.fr    ",
	"                         ",
}

local ascii = require("ascii")

local user = nil
local mail = nil

local function get_date()
	return os.date("%Y/%m/%d %H:%M:%S")
end

local function get_buffer_name()
	local name = vim.fn.expand("%:t")

	if name == nil or name == "" then
		name = "<unnamed>"
	end

	return name
end

local function get_comment(cs)
	if cs == "" then
		return nil
	end

	local start_index, stop_index = cs:find("%%s")
	local start = cs:sub(1, start_index - 1)
	local stop = cs:sub(stop_index + 1)

	if start[#start] ~= " " then
		start = start .. " "
	end

	if stop == "" then
		 stop = start:reverse()
	end

	if stop[1] ~= " " then
		stop = " " .. stop
	end

	return { start, stop }
end

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

local function update_header(comment, date)
	if comment == nil then
		comment = get_comment(vim.bo.commentstring)

		if comment == nil then
			vim.notify("Cannot update header for '" .. vim.bo.filetype .. "'", "error")
			return
		end
	end

	if date == nil then
		date = get_date()
	end

	local start = comment[1]
	local stop = comment[2]
	local name_line = ascii.format_line(start, stop, get_buffer_name(), LOGO[3])
	local update_line = ascii.format_line(start, stop, "Updated: " .. date .. " by " .. user, LOGO[8])

	vim.api.nvim_buf_set_lines(0, 3, 4, true, {name_line});
	vim.api.nvim_buf_set_lines(0, 8, 9, true, {update_line})
end

local function create_header()
	local comment = get_comment(vim.bo.commentstring)

	if comment == nil then
		vim.notify("Cannot create header for '" .. vim.bo.filetype .. "'", "error")
		return
	end

	local start = comment[1]
	local stop = comment[2]

	local fill_len = 80 - #stop - #start
	local fill = ("*"):rep(fill_len)
	local first_line = start .. fill .. stop

	local date = get_date()
	local lines = {}

	lines[#lines + 1] = first_line

	for i, logo_line in ipairs(LOGO) do
		local left

		if i == 5 then
			left = "By: " .. user .. " <" .. mail .. ">"
		elseif i == 7 then
			left = "Created: " .. date .. " by " .. user
		else
			left = ""
		end

		lines[#lines + 1] = ascii.format_line(start, stop, left, logo_line)
	end

	lines[#lines + 1] = first_line
	lines[#lines + 1] = ""

	vim.api.nvim_buf_set_lines(0, 0, 0, false, lines)

	update_header(comment, date)
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
			callback = function()
				if has_header() then
					update_header(nil, nil)
				end
			end,
		})
	end
end

-- TODO use lazy.nvim config
--
-- https://github.com/folke/lazy.nvim#-plugin-spec

return {
	setup = setup,
}
