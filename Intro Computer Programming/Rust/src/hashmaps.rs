use std::collections::HashMap;

pub fn hashmaps() {
    // Create a new HashMap
    let mut scores: HashMap<String, u32> = HashMap::new();

    // Insert key-value pairs
    scores.insert(String::from("Alice"), 90);
    scores.insert(String::from("Bob"), 85);
    scores.insert(String::from("Charlie"), 78);

    // Accessing values
    if let Some(score) = scores.get("Alice") {
        println!("Alice's score: {}", score);
    } else {
        println!("Alice not found");
    }

    // Iterating over key-value pairs
    for (name, score) in &scores {
        println!("{}: {}", name, score);
    }

    // Removing a key-value pair
    scores.remove("Bob");

    // Check if a key exists
    if scores.contains_key("Bob") {
        println!("Bob's score is still in the map.");
    } else {
        println!("Bob's score has been removed.");
    }
}