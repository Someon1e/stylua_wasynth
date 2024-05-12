local wasm = { env = { func_list = {  } } }
local stylua = require(script.stylua_wasynth)(wasm)

return function(text)
	-- TODO: clean up memory

	text ..= "\0" -- CString, must be null terminated

	local vec = stylua.func_list.wasm_heap_alloc_string(#text)
	stylua.rt.store.string(stylua.memory_list.memory, vec, text)

	local returned = stylua.func_list.wasm_process(vec, #text)
	local returnedLength = stylua.func_list.wasm_processed_length()
	return stylua.rt.load.string(stylua.memory_list.memory, returned, returnedLength)
end