// src/lib.rs
mod bindings;

use bindings::exports::docs::calculate::calculate;

use bindings::exports::docs::adder::add::{self, GuestAddresource} ;


struct Implementation;
pub struct DataObject {
    pub stack: bindings::docs::adder::add::Addresource,
}
impl GuestAddresource for  DataObject  {
    //only the new or default here
     fn new() ->Self{
         Self{stack:bindings::docs::adder::add::Addresource::new()}  
      }
      fn add(&self, operants: bindings::docs::adder::add::Operants) -> u32 {
        self.stack.add (operants)
     }
}
impl add::Guest for Implementation{
    type Addresource = DataObject;
}
         
impl calculate::Guest for Implementation {
    
    fn eval_expression(_expr: String) -> u32 {
        100
    }
}

bindings::export!(Implementation with_types_in bindings);

// Export a no-op `_start` symbol so the module can be wrapped as a WASI Command core module
// The adapter expects a `_start` export for command-style components.
#[no_mangle]
pub extern "C" fn _start() {}

