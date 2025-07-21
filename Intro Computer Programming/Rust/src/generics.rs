// ===========================
// GENERIC TYPES EXAMPLES
// ===========================

use std::fmt::Display;
use std::cmp::PartialOrd;

// 1. Basic Generic Function
pub fn print_value<T: Display>(value: T) {
    println!("Value: {}", value);
}

// 2. Generic Function with Multiple Type Parameters
pub fn swap<T, U>(tuple: (T, U)) -> (U, T) {
    (tuple.1, tuple.0)
}

// 3. Generic Function with Trait Bounds
pub fn find_largest<T: PartialOrd + Copy>(list: &[T]) -> T {
    let mut largest = list[0];
    for &item in list {
        if item > largest {
            largest = item;
        }
    }
    largest
}

// 4. Generic Struct - Single Type Parameter
#[derive(Debug)]
pub struct Point<T> {
    pub x: T,
    pub y: T,
}

impl<T> Point<T> {
    pub fn new(x: T, y: T) -> Point<T> {
        Point { x, y }
    }
    
    pub fn x(&self) -> &T {
        &self.x
    }
    
    pub fn y(&self) -> &T {
        &self.y
    }
}

// 5. Generic Struct - Multiple Type Parameters
#[derive(Debug)]
pub struct Pair<T, U> {
    pub first: T,
    pub second: U,
}

impl<T, U> Pair<T, U> {
    pub fn new(first: T, second: U) -> Pair<T, U> {
        Pair { first, second }
    }
    
    pub fn into_tuple(self) -> (T, U) {
        (self.first, self.second)
    }
    
    pub fn get_first(&self) -> &T {
        &self.first
    }
    
    pub fn get_second(&self) -> &U {
        &self.second
    }
}

// 6. Generic Enum
#[derive(Debug)]
pub enum MyResult<T, E> {
    Ok(T),
    Err(E),
}

impl<T, E> MyResult<T, E> {
    pub fn is_ok(&self) -> bool {
        matches!(self, MyResult::Ok(_))
    }
    
    pub fn is_err(&self) -> bool {
        matches!(self, MyResult::Err(_))
    }
}

// 7. Generic Implementation with Constraints
impl<T: Display> Point<T> {
    pub fn print_coordinates(&self) {
        println!("Point coordinates: ({}, {})", self.x, self.y);
    }
}

// 8. Generic Container (Vector-like)
#[derive(Debug)]
pub struct Container<T> {
    items: Vec<T>,
}

impl<T> Container<T> {
    pub fn new() -> Container<T> {
        Container { items: Vec::new() }
    }
    
    pub fn add(&mut self, item: T) {
        self.items.push(item);
    }
    
    pub fn get(&self, index: usize) -> Option<&T> {
        self.items.get(index)
    }
    
    pub fn len(&self) -> usize {
        self.items.len()
    }
    
    pub fn is_empty(&self) -> bool {
        self.items.is_empty()
    }
}

impl<T: Clone> Container<T> {
    pub fn duplicate(&self) -> Container<T> {
        Container {
            items: self.items.clone(),
        }
    }
}

// 9. Generic function with where clause
pub fn compare_and_display<T, U>(t: &T, u: &U) -> bool
where
    T: Display + PartialEq<U>,
    U: Display,
{
    println!("Comparing {} and {}", t, u);
    t == u
}

// 10. Generic Stack Implementation
#[derive(Debug)]
pub struct Stack<T> {
    items: Vec<T>,
}

impl<T> Stack<T> {
    pub fn new() -> Self {
        Stack { items: Vec::new() }
    }
    
    pub fn push(&mut self, item: T) {
        self.items.push(item);
    }
    
    pub fn pop(&mut self) -> Option<T> {
        self.items.pop()
    }
    
    pub fn peek(&self) -> Option<&T> {
        self.items.last()
    }
    
    pub fn is_empty(&self) -> bool {
        self.items.is_empty()
    }
    
    pub fn size(&self) -> usize {
        self.items.len()
    }
}

// 11. Higher-Ranked Trait Bounds (HRTB)
pub fn apply_to_all<F>(f: F) 
where
    F: for<'a> Fn(&'a str) -> &'a str,
{
    let s1 = "hello";
    let s2 = "world";
    
    println!("{}", f(s1));
    println!("{}", f(s2));
}

// 12. Generic Associated Types (GAT)
pub trait StreamingIterator {
    type Item<'a> where Self: 'a;
    
    fn next<'a>(&'a mut self) -> Option<Self::Item<'a>>;
}

// 13. Combining Generics, Traits, and Lifetimes
pub struct Cache<'a, T, K> 
where
    T: Clone,
    K: Eq + std::hash::Hash,
{
    data: std::collections::HashMap<K, &'a T>,
}

impl<'a, T, K> Cache<'a, T, K> 
where
    T: Clone,
    K: Eq + std::hash::Hash,
{
    pub fn new() -> Self {
        Cache {
            data: std::collections::HashMap::new(),
        }
    }
    
    pub fn get(&self, key: &K) -> Option<&T> {
        self.data.get(key).copied()
    }
    
    pub fn insert(&mut self, key: K, value: &'a T) {
        self.data.insert(key, value);
    }
    
    pub fn contains_key(&self, key: &K) -> bool {
        self.data.contains_key(key)
    }
}

// 14. Generic Option-like enum
#[derive(Debug)]
pub enum Maybe<T> {
    Some(T),
    None,
}

impl<T> Maybe<T> {
    pub fn is_some(&self) -> bool {
        matches!(self, Maybe::Some(_))
    }
    
    pub fn is_none(&self) -> bool {
        matches!(self, Maybe::None)
    }
    
    pub fn unwrap(self) -> T {
        match self {
            Maybe::Some(value) => value,
            Maybe::None => panic!("Called unwrap on a None value"),
        }
    }
    
    pub fn map<U, F>(self, f: F) -> Maybe<U>
    where
        F: FnOnce(T) -> U,
    {
        match self {
            Maybe::Some(value) => Maybe::Some(f(value)),
            Maybe::None => Maybe::None,
        }
    }
}

// ===========================
// MAIN FUNCTION WITH EXAMPLES
// ===========================

pub fn run_generics_examples() {
    println!("=== GENERICS EXAMPLES ===\n");
    
    // Basic generic function
    print_value(42);
    print_value("Hello, Rust!");
    print_value(3.14);
    
    // Generic swap
    let tuple = (1, "hello");
    let swapped = swap(tuple);
    println!("Swapped: {:?}", swapped);
    
    // Finding largest
    let numbers = vec![1, 5, 3, 9, 2];
    let largest = find_largest(&numbers);
    println!("Largest number: {}", largest);
    
    let chars = vec!['a', 'z', 'c', 'y'];
    let largest_char = find_largest(&chars);
    println!("Largest char: {}", largest_char);
    
    // Generic structs
    let int_point = Point::new(1, 2);
    let float_point = Point::new(1.5, 2.7);
    let string_point = Point::new("x", "y");
    
    println!("Int point: {:?}", int_point);
    println!("Float point: {:?}", float_point);
    println!("String point: {:?}", string_point);
    
    int_point.print_coordinates();
    float_point.print_coordinates();
    
    // Pairs with different types
    let pair = Pair::new("key", 42);
    let bool_pair = Pair::new(true, 3.14);
    
    println!("String-Int pair: {:?}", pair);
    println!("Bool-Float pair: {:?}", bool_pair);
    
    let (key, value) = pair.into_tuple();
    println!("Unpacked: key={}, value={}", key, value);
    
    // Generic container
    let mut string_container = Container::new();
    string_container.add("first");
    string_container.add("second");
    string_container.add("third");
    
    println!("String container: {:?}", string_container);
    println!("Container length: {}", string_container.len());
    
    if let Some(item) = string_container.get(1) {
        println!("Item at index 1: {}", item);
    }
    
    // Generic stack
    let mut stack = Stack::new();
    stack.push(1);
    stack.push(2);
    stack.push(3);
    
    println!("Stack: {:?}", stack);
    println!("Stack size: {}", stack.size());
    
    if let Some(top) = stack.peek() {
        println!("Top of stack: {}", top);
    }
    
    while let Some(item) = stack.pop() {
        println!("Popped: {}", item);
    }
    
    println!("Stack is empty: {}", stack.is_empty());
    
    // Generic Result-like enum
    let success: MyResult<i32, String> = MyResult::Ok(42);
    let error: MyResult<i32, String> = MyResult::Err("Something went wrong".to_string());
    
    println!("Success is ok: {}", success.is_ok());
    println!("Error is error: {}", error.is_err());
    
    // Maybe enum
    let some_value = Maybe::Some(10);
    let no_value: Maybe<i32> = Maybe::None;
    
    println!("Some value: {:?}", some_value);
    println!("No value: {:?}", no_value);
    
    let doubled = some_value.map(|x| x * 2);
    println!("Doubled: {:?}", doubled);
    
    // Higher-ranked trait bounds
    println!("\n--- HRTB Example ---");
    apply_to_all(|s| {
        if s.len() > 3 {
            &s[..3]
        } else {
            s
        }
    });
    
    // Cache example
    println!("\n--- Cache Example ---");
    let value1 = 100;
    let value2 = 200;
    let mut cache: Cache<i32, &str> = Cache::new();
    cache.insert("key1", &value1);
    cache.insert("key2", &value2);
    
    if let Some(cached_value) = cache.get(&"key1") {
        println!("Cached value for 'key1': {}", cached_value);
    }
    
    println!("Cache contains 'key2': {}", cache.contains_key(&"key2"));
}