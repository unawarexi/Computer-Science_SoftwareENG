class User {
    #password;
  
    constructor(username, password) {
      this.username = username;
      this.#password = password;
    }
  
    checkPassword(inputPassword) {
      return this.#password === inputPassword;
    }
  }
  
  const user = new User('Bernhard', 'mySecretPassword');
  console.log(user.checkPassword('wrongPassword')); // Output: false
  