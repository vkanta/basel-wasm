#[allow(warnings)]
mod bindings;
use bindings::docs::calculate0_1_0::calculate::eval_expression;

fn main() {
 let sum = eval_expression("1+1");
 println!("{}",sum);
}
