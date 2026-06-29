local stylua, _ = require("@self/stylua_spider")()

return function(text, config: { useSpaces: boolean, indentWidth: number })
	-- TODO: clean up memory
	local vec = stylua.wasm_heap_alloc_string[1](stylua.wasm_heap_alloc_string, #text)

	local temp = buffer.fromstring(text)
	buffer.copy(stylua.memory[1], vec, temp)

	local returned =
		stylua.wasm_process[1](stylua.wasm_process, vec, #text, if config.useSpaces then 1 else 0, config.indentWidth)
	local returnedLength = stylua.wasm_processed_length[1](stylua.wasm_processed_length)

	local temp = buffer.create(returnedLength)
	buffer.copy(temp, 0, stylua.memory[1], returned, returnedLength)
	return buffer.tostring(temp)
end
