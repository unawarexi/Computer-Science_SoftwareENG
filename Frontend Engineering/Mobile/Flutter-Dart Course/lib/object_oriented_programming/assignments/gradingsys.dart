class GradingSystem {
  String studentName;
  double studentScore;
  String? studentGrade;

  GradingSystem(this.studentName, this.studentScore);

  void calculateGrade() {
    final totalScore = studentScore;

    if (totalScore >= 70) {
      studentGrade = "A";
    } else if (totalScore >= 60) {
      studentGrade = "B";
    } else {
      studentGrade = "C";
    }
  }

  void displayStudentDetails() {
    print("Student Name: $studentName");
    print("Student Score: $studentScore");
    print("Student Grade: ${studentGrade ?? 'Not Calculated'}");
  }
}

void main() {
  GradingSystem student = GradingSystem("Andrew", 20);

  // Calculate the grade
  student.calculateGrade();

  // Display student details
  student.displayStudentDetails();
}
