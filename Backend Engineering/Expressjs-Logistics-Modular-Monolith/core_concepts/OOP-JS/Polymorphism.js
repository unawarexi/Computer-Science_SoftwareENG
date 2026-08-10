class Bird {
    fly() {
      console.log('Flying...');
    }
  }
  
  class Penguin extends Bird {
    fly() {
      console.log('Penguins cannot fly.');
    }
  }
  
  const birds = [new Bird(), new Penguin()];
  
  birds.forEach(bird => bird.fly());
  // Output: Flying... Penguins cannot fly.
  