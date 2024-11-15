class Phone {
    makeCall(number) {
      console.log(`Calling ${number}...`);
    }
  
    sendText(number, message) {
      console.log(`Sending text to ${number}: ${message}`);
    }
  }
  
  const myPhone = new Phone();
  myPhone.makeCall('123-456-7890');
  myPhone.sendText('123-456-7890', 'Hello, World!');
  