pub fn greet(what: &str) -> String {
    format!("Hello from {}!", what)
}

#[cfg(test)]
mod internal_tests {
    use super::*;
    #[test]
    fn greet_works() {
        assert_eq!(greet("unit test"), "Hello from unit test!");
    }
}
