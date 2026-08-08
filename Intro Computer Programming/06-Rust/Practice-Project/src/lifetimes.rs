// ===========================
// LIFETIMES EXAMPLES
// ===========================

use std::fmt::Display;

// 1. Basic Lifetime Annotation
pub fn longest<'a>(x: &'a str, y: &'a str) -> &'a str {
    if x.len() > y.len() {
        x
    } else {
        y
    }
}

// 2. Lifetime with Structs
#[derive(Debug)]
pub struct Book<'a> {
    pub title: &'a str,
    pub author: &'a str,
}

impl<'a> Book<'a> {
    pub fn new(title: &'a str, author: &'a str) -> Book<'a> {
        Book { title, author }
    }
    
    pub fn get_info(&self) -> String {
        format!("{} by {}", self.title, self.author)
    }
    
    pub fn get_title(&self) -> &'a str {
        self.title
    }
    
    pub fn get_author(&self) -> &'a str {
        self.author
    }
}

// 3. Multiple Lifetime Parameters
pub fn compare_and_return<'a, 'b>(x: &'a str, y: &'b str, return_first: bool) -> &'a str
where
    'b: 'a, // 'b outlives 'a
{
    if return_first {
        x
    } else {
        x // Can only return 'a lifetime
    }
}

// 4. Lifetime Elision Examples
pub fn first_word(s: &str) -> &str {
    let bytes = s.as_bytes();
    
    for (i, &item) in bytes.iter().enumerate() {
        if item == b' ' {
            return &s[..i];
        }
    }
    
    s
}

pub fn get_first_element(list: &[i32]) -> &i32 {
    &list[0] // Lifetime is inferred
}

// 5. Static Lifetime
static GLOBAL_STR: &'static str = "This lives for the entire program";

pub fn get_static_str() -> &'static str {
    GLOBAL_STR
}

pub fn create_static_reference() -> &'static str {
    "This string literal has static lifetime"
}

// 6. Lifetime with Generic Types and Traits
#[derive(Debug)]
pub struct Wrapper<'a, T: Display> {
    pub value: &'a T,
}

impl<'a, T: Display> Wrapper<'a, T> {
    pub fn new(value: &'a T) -> Wrapper<'a, T> {
        Wrapper { value }
    }
    
    pub fn print(&self) {
        println!("Wrapped value: {}", self.value);
    }
    
    pub fn get_value(&self) -> &'a T {
        self.value
    }
}

// 7. Trait with Lifetime Parameters
pub trait Summary {
    fn summarize(&self) -> String;
    fn get_snippet<'a>(&'a self) -> &'a str;
}

#[derive(Debug)]
pub struct Article<'a> {
    pub headline: &'a str,
    pub content: &'a str,
}

impl<'a> Summary for Article<'a> {
    fn summarize(&self) -> String {
        let snippet = if self.content.len() > 50 {
            &self.content[..50]
        } else {
            self.content
        };
        format!("{}: {}", self.headline, snippet)
    }
    
    fn get_snippet<'b>(&'b self) -> &'b str {
        if self.content.len() > 100 {
            &self.content[..100]
        } else {
            self.content
        }
    }
}

pub fn get_summary<'a>(item: &'a dyn Summary) -> String {
    item.summarize()
}

// 8. Struct with Multiple Lifetime Parameters
#[derive(Debug)]
pub struct Context<'a, 'b> {
    pub name: &'a str,
    pub data: &'b str,
}

impl<'a, 'b> Context<'a, 'b> {
    pub fn new(name: &'a str, data: &'b str) -> Context<'a, 'b> {
        Context { name, data }
    }
    
    pub fn announce(&self) -> String {
        format!("Context '{}' contains: {}", self.name, self.data)
    }
}

// 9. Function that returns the longer of two string slices
pub fn longer_string<'a>(s1: &'a str, s2: &'a str) -> &'a str {
    if s1.len() > s2.len() {
        s1
    } else {
        s2
    }
}

// 10. Struct that holds references with different lifetimes
#[derive(Debug)]
pub struct RefHolder<'a, 'b> {
    pub first: &'a i32,
    pub second: &'b i32,
}

impl<'a, 'b> RefHolder<'a, 'b> {
    pub fn new(first: &'a i32, second: &'b i32) -> RefHolder<'a, 'b> {
        RefHolder { first, second }
    }
    
    pub fn get_sum(&self) -> i32 {
        self.first + self.second
    }
}

// 11. Iterator with lifetimes
pub struct StrSplit<'a> {
    remainder: Option<&'a str>,
    delimiter: char,
}

impl<'a> StrSplit<'a> {
    pub fn new(string: &'a str, delimiter: char) -> Self {
        StrSplit {
            remainder: Some(string),
            delimiter,
        }
    }
}

impl<'a> Iterator for StrSplit<'a> {
    type Item = &'a str;
    
    fn next(&mut self) -> Option<Self::Item> {
        if let Some(remainder) = self.remainder {
            if let Some(index) = remainder.find(self.delimiter) {
                let (before, after) = remainder.split_at(index);
                self.remainder = Some(&after[1..]);
                Some(before)
            } else {
                self.remainder = None;
                Some(remainder)
            }
        } else {
            None
        }
    }
}

// 12. Function with lifetime bounds
pub fn process_strings<'a, 'b>(s1: &'a str, s2: &'b str) -> &'a str
where
    'b: 'a, // 'b must outlive 'a
{
    println!("Processing: {} and {}", s1, s2);
    s1
}

// 13. Struct with lifetime and generic type
#[derive(Debug)]
pub struct Container<'a, T> {
    pub items: &'a [T],
}

impl<'a, T> Container<'a, T> {
    pub fn new(items: &'a [T]) -> Self {
        Container { items }
    }
    
    pub fn len(&self) -> usize {
        self.items.len()
    }
    
    pub fn get(&self, index: usize) -> Option<&T> {
        self.items.get(index)
    }
}

impl<'a, T: Display> Container<'a, T> {
    pub fn print_all(&self) {
        for (i, item) in self.items.iter().enumerate() {
            println!("Item {}: {}", i, item);
        }
    }
}

// 14. Function returning reference to local data (won't compile - example of what NOT to do)
// This is commented out because it won't compile:
/*
pub fn return_local_ref() -> &str {
    let local_string = String::from("local");
    &local_string // ERROR: borrowed value does not live long enough
}
*/

// 15. Lifetime with closure
pub fn apply_closure<'a, F>(data: &'a str, f: F) -> &'a str
where
    F: Fn(&'a str) -> &'a str,
{
    f(data)
}

// 16. Struct with self-referential pattern (using lifetimes correctly)
pub struct Parser<'a> {
    input: &'a str,
    position: usize,
}

impl<'a> Parser<'a> {
    pub fn new(input: &'a str) -> Self {
        Parser { input, position: 0 }
    }
    
    pub fn parse_word(&mut self) -> Option<&'a str> {
        let start = self.position;
        
        while self.position < self.input.len() {
            if self.input.chars().nth(self.position).unwrap().is_whitespace() {
                break;
            }
            self.position += 1;
        }
        
        if start < self.position {
            let word = &self.input[start..self.position];
            self.skip_whitespace();
            Some(word)
        } else {
            None
        }
    }
    
    fn skip_whitespace(&mut self) {
        while self.position < self.input.len() {
            if !self.input.chars().nth(self.position).unwrap().is_whitespace() {
                break;
            }
            self.position += 1;
        }
    }
}

// ===========================
// MAIN FUNCTION WITH EXAMPLES
// ===========================

pub fn run_lifetimes_examples() {
    println!("=== LIFETIMES EXAMPLES ===\n");
    
    // Basic lifetime
    let string1 = String::from("long string is longer");
    let string2 = "short";
    let result = longest(&string1, string2);
    println!("Longest string: '{}'", result);
    
    // Struct with lifetime
    let title = "The Rust Programming Language";
    let author = "Steve Klabnik and Carol Nichols";
    let book = Book::new(title, author);
    println!("Book info: {}", book.get_info());
    println!("Book title: {}", book.get_title());
    
    println!();
    
    // First word example
    let sentence = "Hello world from Rust programming";
    let word = first_word(sentence);
    println!("First word of '{}': '{}'", sentence, word);
    
    // Get first element
    let numbers = vec![10, 20, 30, 40, 50];
    let first = get_first_element(&numbers);
    println!("First number: {}", first);
    
    println!();
    
    // Static lifetime
    let static_str = get_static_str();
    println!("Static string: '{}'", static_str);
    
    let another_static = create_static_reference();
    println!("Another static string: '{}'", another_static);
    
    println!();
    
    // Wrapper with lifetime and generics
    let number = 42;
    let float_num = 3.14159;
    
    let int_wrapper = Wrapper::new(&number);
    let float_wrapper = Wrapper::new(&float_num);
    
    int_wrapper.print();
    float_wrapper.print();
    println!("Wrapped int value: {}", int_wrapper.get_value());
    
    println!();
    
    // Article with trait
    let headline = "Rust Lifetimes Explained";
    let content = "Lifetimes in Rust ensure that references are valid for as long as needed. They prevent dangling references and ensure memory safety at compile time.";
    
    let article = Article { headline, content };
    let summary = get_summary(&article);
    println!("Article summary: {}", summary);
    
    let snippet = article.get_snippet();
    println!("Article snippet: {}", snippet);
    
    println!();
    
    // Context with multiple lifetimes
    let context_name = "UserData";
    let context_data = "user_id=123, name=Alice, role=admin";
    let context = Context::new(context_name, context_data);
    println!("{}", context.announce());
    
    println!();
    
    // Longer string comparison
    let str1 = "This is a longer string";
    let str2 = "Short";
    let longer = longer_string(str1, str2);
    println!("Longer of '{}' and '{}': '{}'", str1, str2, longer);
    
    // Reference holder
    let num1 = 100;
    let num2 = 200;
    let ref_holder = RefHolder::new(&num1, &num2);
    println!("RefHolder: {:?}", ref_holder);
    println!("Sum of references: {}", ref_holder.get_sum());
    
    println!();
    
    // String splitting iterator
    let text = "hello,world,rust,programming";
    let mut splitter = StrSplit::new(text, ',');
    
    println!("Splitting '{}' by comma:", text);
    while let Some(part) = splitter.next() {
        println!("  Part: '{}'", part);
    }
    
    // Using collect to get all parts at once
    let splitter2 = StrSplit::new("a-b-c-d-e", '-');
    let parts: Vec<&str> = splitter2.collect();
    println!("Split parts: {:?}", parts);
    
    println!();
    
    // Container with lifetime
    let data = vec![1, 2, 3, 4, 5];
    let container = Container::new(&data);
    
    println!("Container length: {}", container.len());
    if let Some(item) = container.get(2) {
        println!("Item at index 2: {}", item);
    }
    
    // Container with strings
    let words = vec!["hello", "world", "rust", "lifetimes"];
    let word_container = Container::new(&words);
    word_container.print_all();
    
    println!();
    
    // Parser example
    let input = "hello world rust programming";
    let mut parser = Parser::new(input);
    
    println!("Parsing '{}' word by word:", input);
    while let Some(word) = parser.parse_word() {
        println!("  Parsed word: '{}'", word);
    }
    
    println!();
    
    // Closure with lifetime
    let text = "Hello, Rust!";
    let result = apply_closure(text, |s| {
        if s.len() > 5 {
            &s[..5]
        } else {
            s
        }
    });
    println!("Applied closure to '{}': '{}'", text, result);
    
    // Demonstrating lifetime relationships
    let long_lived = String::from("This string lives longer");
    {
        let short_lived = String::from("short");
        let processed = process_strings(&long_lived, &short_lived);
        println!("Processed result: '{}'", processed);
        // short_lived goes out of scope here, but that's fine
        // because we returned a reference to long_lived
    }
    // long_lived is still valid here
    println!("Long lived string is still valid: '{}'", long_lived);
}