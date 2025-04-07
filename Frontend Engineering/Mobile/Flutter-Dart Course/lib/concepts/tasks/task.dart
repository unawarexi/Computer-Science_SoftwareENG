double calculateRentalCost(int rentalDays) {
  const double dailyRate = 50.0;
  double totalCost = rentalDays * dailyRate;

  if (rentalDays >= 7 && rentalDays <= 14) {
    totalCost *= 0.90;
  } else if (rentalDays > 14) {
    totalCost *= 0.85;
  }

  return totalCost;
}

void main() {
  // Test cases
  print(calculateRentalCost(5));
  print(calculateRentalCost(7));
  print(calculateRentalCost(15));
}
