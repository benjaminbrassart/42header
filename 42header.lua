--[[
local ascii = {
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
--]]

local function get_date()
	return os.date("%Y/%m/%d %H:%M:%S")
end

local user = nil
local mail = nil

local function get_comment(cs)
	local start_index, stop_index = cs:find("%%s")
	local start = cs:sub(1, start_index - 1)
	local stop = cs:sub(stop_index + 1)

	if stop == "" then
		 stop = start:reverse()
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

--[[ Header update line:
#    Updated: 2023/05/25 08:12:24 by bbrassar         ###   ########.fr        #
/*   Updated: 2023/05/25 07:57:41 by bbrassar         ###   ########.fr       */
--]]
local function update_header(created)
	local comment = get_comment(vim.bo.commentstring)
	local start = comment[1]
	local stop = comment[2]

	local margin_left = (" "):rep(5 - #start)
	local margin_right = (" "):rep(5 - #stop)
	local date = get_date()
	local line_left = start .. margin_left .. "Updated: " .. date .. " by " .. user
	local line_right = margin_right .. stop;

	vim.api.nvim_buf_set_lines(0, 8, 8, true, {line})
	vim.notify("update_header()", "info")
end

local function create_header()
	local comment = get_comment(vim.bo.commentstring)
	local start = comment[1]
	local stop = comment[2]

	local fill_len = 80 - #stop - #start
	local fill = ("*"):rep(fill_len)
	local first_line = start .. fill .. stop

	vim.api.nvim_buf_set_lines(0, 0, 0, true, {first_line})

	update_header(true)
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
					update_header(false)
				end
			end,
		})
	end
end

return {
	setup = setup,
}
