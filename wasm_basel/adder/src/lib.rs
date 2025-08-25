#![allow(unused)]

mod bindings;
use std::cell::RefCell;

// Separating out the interface puts it in a sub-module
use bindings::exports::{self,docs::adder::add::{Guest, GuestAddresource}};

pub struct Operants {
    pub a:u32,
    pub b:u32,
}

pub struct DataObject {
    pub stack: RefCell<Vec<u32>>,
}
impl GuestAddresource for DataObject{
    fn add(&self, operants: exports::docs::adder::add::Operants) -> u32 {
       operants.a + operants.b
    }
    fn new() ->Self{
        Self{stack: RefCell::default()}
    }

    
}

struct Implementation;
impl Guest for Implementation {
    
    //the type should be the name of the resource with a capital first letter
    type Addresource= DataObject;
}
//exports the struct that the guest is implemented for 
//this is missing from the basic example 
bindings::export!(Implementation with_types_in bindings);

