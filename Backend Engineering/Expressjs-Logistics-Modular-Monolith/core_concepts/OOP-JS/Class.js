class Vehicle {
    constructor(make, model) {
      this.make = make;
      this.model = model;
    }
  
    getDetails() {
      return `${this.make} ${this.model}`;
    }
  }
  
  const car = new Vehicle('Tesla', 'Model 3');
  console.log(car.getDetails()); // Output: Tesla Model 3
  