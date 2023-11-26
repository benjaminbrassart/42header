local function format_line(start, stop, left, right)
	local margin_left = (" "):rep(5 - #start)
	local margin_right = (" "):rep(5 - #stop)

	left = left:sub(1, 80 - #start - #margin_left - #right - #margin_right - #stop - 2)

	local line_left = start .. margin_left .. left
	local line_right = right .. margin_right .. stop
	local padding = (" "):rep(80 - #line_left - #line_right)

	return line_left .. padding .. line_right
end

return {
	format_line = format_line,
}
