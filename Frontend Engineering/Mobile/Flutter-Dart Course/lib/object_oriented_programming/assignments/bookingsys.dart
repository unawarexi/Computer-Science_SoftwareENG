class BookingSystem {
  static const int totalSeats = 10;
  int availableSeats = totalSeats;

  void bookSeats(int numberOfSeats) {
    if (numberOfSeats <= availableSeats) {
      availableSeats -= numberOfSeats; // Reduce available seats
      print("Successfully booked $numberOfSeats seats.");
    } else {
      print("Not enough available seats. Only $availableSeats seats left.");
    }
  }

  void checkAvailability() {
    print("Available seats: $availableSeats");
  }

  void cancelBooking(int numberOfSeats) {
    if (numberOfSeats <= (totalSeats - availableSeats)) {
      availableSeats += numberOfSeats; // Increase available seats
      print("Successfully canceled $numberOfSeats seats.");
    } else {
      print(" You cannot cancel more seats than you have booked.");
    }
  }
}

void main() {
  BookingSystem movieTheatre = BookingSystem();

  // Check initial availability
  movieTheatre.checkAvailability();

  // Book seats
  movieTheatre.bookSeats(3);
  movieTheatre.checkAvailability();

  movieTheatre.bookSeats(8); // fail
  movieTheatre.checkAvailability();

  // Cancel seats
  movieTheatre.cancelBooking(2);
  movieTheatre.checkAvailability();

  movieTheatre.cancelBooking(5); // cancel more than booked (fail)
}
