function print_map(o, indent)
	indent = indent or 0
	for key, value in pairs(o) do
		print(string.rep(" ", indent) .. string.format("key:%s val:%s", key, value))
		if type(value) == "table" then
			print_map(value, indent + 1)
		end
	end
end

return print_map
