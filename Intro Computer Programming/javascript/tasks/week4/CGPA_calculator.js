// Define the values for the classification
const CGPA_Object = {
    first_class: "First Class",
    second_class: "Second Class",
    third_class: "Third Class",
    fail: "Fail",
  };
  
  function Calculator(number_score) {
    const { first_class, second_class, third_class, fail } = CGPA_Object;
    
    if (number_score > 5.0) {
      console.log(`Sorry, the score ${number_score} is not valid - above range.`);
      return; 
    } 
  
    // Handle different classifications
    if (number_score >= 4.5 && number_score <= 5.0) {
      console.log(`Congrats! You graduated with ${first_class}`);

    } else if (number_score >= 3.5 && number_score <= 4.49) {
      console.log(`Great! You finished with ${second_class} Upper`);

    } else if (number_score >= 2.4 && number_score <= 3.49) {
      console.log(`You finished with ${second_class} Lower`);
      
    } else if (number_score >= 1.5 && number_score <= 2.39) {
      console.log(`You finished with ${third_class}`);

    } else if (number_score >= 1.0 && number_score < 1.5) {
      console.log(`Sorry, you ${fail}`);
    } else {
      console.log(`Sorry, the score ${number_score} is not valid - below range.`);
    }
  }
  
  // Test the function
  Calculator(0.1);  // Outputs: Sorry, the score 6.0 is not valid.
//   Calculator(4.7);  // Outputs: Congrats! You graduated with First Class
//   Calculator(3.0);  // Outputs: You finished with Second Class Lower
//   Calculator(0.5);  // Outputs: Sorry, the score 0.5 is not valid.
  