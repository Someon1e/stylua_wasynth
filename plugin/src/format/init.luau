local wasm = { env = { func_list = {} } }
local stylua = require(script.stylua_wasynth)(wasm)

return function(text, config: { useSpaces: boolean, indentWidth: number })
	-- TODO: clean up memory

	local vec = stylua.func_list.wasm_heap_alloc_string(#text)
	stylua.rt.store.string(stylua.memory_list.memory, vec, text)

	local returned = stylua.func_list.wasm_process(vec, #text, if config.useSpaces then 1 else 0, config.indentWidth)
	local returnedLength = stylua.func_list.wasm_processed_length()
	return stylua.rt.load.string(stylua.memory_list.memory, returned, returnedLength)
end
