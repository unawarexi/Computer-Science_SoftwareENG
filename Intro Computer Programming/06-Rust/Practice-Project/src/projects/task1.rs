use std::collections::HashMap;
use std::io::{self, Write};


pub fn median_mode() {
    let mut numbers: Vec<i32> = vec![1, 2, 3, 4, 5, 6, 1, 2, 2, 3, 5, 2, 2, 2, 2, 3, 5];
    let mut count_map: HashMap<i32, i32> = HashMap::new();

    numbers.sort(); 

    // 📊 Median
    let middle_index = numbers.len() / 2;
    let median = if numbers.len() % 2 == 0 {
        (numbers[middle_index - 1] + numbers[middle_index]) as f64 / 2.0
    } else {
        numbers[middle_index] as f64
    };

    // 🔁 Mode
    let mut mode = numbers[0];
    let mut max_count = 0;

    for &num in &numbers {
        let count = count_map.entry(num).or_insert(0);
        *count += 1;
        if *count > max_count {
            max_count = *count;
            mode = num;
        }
    }

    println!("Median: {}", median);
    println!("Mode: {}", mode);
}



pub fn pig_latin(sentence: &str) {
    let mut pig_latin_sentence = String::new();
    const VOWELS: [char; 10] = ['a', 'e', 'i', 'o', 'u', 'A', 'E', 'I', 'O', 'U'];
    
    for word in sentence.split_whitespace() {
        let first_char = word.chars().next().unwrap();
        if VOWELS.contains(&first_char) {
            pig_latin_sentence.push_str(&format!("{}-hay ", word));
        } else {
            let rest_of_word = &word[1..];
            pig_latin_sentence.push_str(&format!("{}-{}ay ", rest_of_word, first_char));
        }
    }
    println!("Pig Latin: {}", pig_latin_sentence.trim());
}



pub fn alphabetical_employees_interface() {
    let mut company: HashMap<String, Vec<String>> = HashMap::new();

    loop {
        println!("\nCommands:");
        println!("  Add <Name> to <Department>");
        println!("  Show <Department>");
        println!("  Show All");
        println!("  Exit");

        print!("> ");
        io::stdout().flush().unwrap(); 
        let mut input = String::new();
        io::stdin().read_line(&mut input).expect("Failed to read input");
        let input = input.trim();

        if input.eq_ignore_ascii_case("exit") {
            break;
        } else if input.to_lowercase().starts_with("add ") {
            let parts: Vec<&str> = input.split_whitespace().collect();
            if parts.len() >= 4 && parts[2].eq_ignore_ascii_case("to") {
                let name = parts[1].to_string();
                let dept = parts[3].to_string();
                company.entry(dept.clone()).or_default().push(name.clone());
                println!("✅ Added {} to {}", name, dept);
            } else {
                println!("❌ Invalid format. Use: Add <Name> to <Department>");
            }
        } else if input.to_lowercase().starts_with("show all") {
            for (dept, employees) in &company {
                let mut sorted = employees.clone();
                sorted.sort();
                println!("\n📂 Department: {}", dept);
                for name in sorted {
                    println!(" - {}", name);
                }
            }
        } else if input.to_lowercase().starts_with("show ") {
            let parts: Vec<&str> = input.split_whitespace().collect();
            if parts.len() == 2 {
                let dept = parts[1];
                if let Some(employees) = company.get(dept) {
                    let mut sorted = employees.clone();
                    sorted.sort();
                    println!("\n📂 Department: {}", dept);
                    for name in sorted {
                        println!(" - {}", name);
                    }
                } else {
                    println!("❌ Department not found.");
                }
            }
        } else {
            println!("❌ Unknown command.");
        }
    }
}
