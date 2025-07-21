use anyhow::Result;
use flutter_rust_bridge::frb;

/// Simple function that returns a greeting message
#[frb]
pub fn get_greeting(name: String) -> Result<String> {
    Ok(format!("Hello, {}! Welcome to Flutter Rust Bridge!", name))
}

/// Simple function that adds two numbers
#[frb]
pub fn add_numbers(a: i32, b: i32) -> Result<i32> {
    Ok(a + b)
}

/// Simple function that multiplies two numbers
#[frb]
pub fn multiply_numbers(a: i32, b: i32) -> Result<i32> {
    Ok(a * b)
}

/// Simple function that returns a list of numbers
#[frb]
pub fn get_number_list(count: i32) -> Result<Vec<i32>> {
    let mut numbers = Vec::new();
    for i in 0..count {
        numbers.push(i);
    }
    Ok(numbers)
}

/// Simple function that calculates fibonacci number
#[frb]
pub fn fibonacci(n: u32) -> Result<u64> {
    if n <= 1 {
        return Ok(n as u64);
    }

    let mut a = 0u64;
    let mut b = 1u64;

    for _ in 2..=n {
        let temp = a + b;
        a = b;
        b = temp;
    }

    Ok(b)
}

/// Simple function that reverses a string
#[frb]
pub fn reverse_string(input: String) -> Result<String> {
    Ok(input.chars().rev().collect())
}

/// Simple function that counts characters in a string
#[frb]
pub fn count_characters(input: String) -> Result<i32> {
    Ok(input.len() as i32)
}

/// Simple function that checks if a number is prime
#[frb]
pub fn is_prime(n: u32) -> Result<bool> {
    if n < 2 {
        return Ok(false);
    }
    if n == 2 {
        return Ok(true);
    }
    if n % 2 == 0 {
        return Ok(false);
    }

    let sqrt_n = (n as f64).sqrt() as u32;
    for i in (3..=sqrt_n).step_by(2) {
        if n % i == 0 {
            return Ok(false);
        }
    }

    Ok(true)
}