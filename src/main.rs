#[cfg(target_arch = "wasm32")]
use std::{
    borrow::Borrow,
    cell::RefCell,
    ffi::{c_char, CString},
};

#[cfg(target_arch = "wasm32")]
thread_local! {
    static WASM_OUT_LENGTH: RefCell<usize> = RefCell::new(0);
}

fn process(code: String) -> String {
    match stylua_lib::format_code(
        &code,
        stylua_lib::Config::new(), // TODO: user config
        None,
        stylua_lib::OutputVerification::None, // TODO: change this later?
    ) {
        Ok(code) => code,
        Err(error) => error.to_string(),
    }
}

#[cfg(target_arch = "wasm32")]
#[no_mangle]
pub fn wasm_process(code: CString) -> *mut c_char {
    let output = match code.to_str() {
        Ok(code) => process(code.to_string()),
        Err(error) => error.to_string(),
    };
    WASM_OUT_LENGTH.set(output.len());
    let s = CString::new(output).unwrap();
    s.into_raw()
}

#[cfg(target_arch = "wasm32")]
#[no_mangle]
pub fn wasm_processed_length() -> usize {
    WASM_OUT_LENGTH.borrow().take()
}

#[cfg(target_arch = "wasm32")]
#[no_mangle]
fn wasm_heap_alloc_string(capacity: usize) -> *mut u8 {
    let mut str = String::with_capacity(capacity);
    let ptr = str.as_mut_ptr();
    std::mem::forget(str);
    ptr
}

fn main() {
    println!("{}", process("print 'test'".to_string()));
}
