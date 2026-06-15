User = {
    "account_name" : "Sarutech Institute",
    "pin" : "1234",
    "account_number" : "283473468347",
    "account_balance" : 500000,
    "card_number" : "123456789"
}

def automate(User) :
    print("")
    print("Welcome... Please insert your card : ")
    
    
    proceed = input("1. Insert card, 2. Exit: ")
    
    if proceed == "1":
        card_number = input("\nEnter Card Number : ")
        if card_number == User["card_number"]:
            print("Card inserted successfully\n")
            pin = input("Enter PIN : ")
            if pin == User["pin"]:
                print("confirming account Loading...", User["account_name", "account_number"])
                print("\nAccount confirmed ... Successfully Logged In")
                main_menu(User)
            else:
                print("Incorrect PIN")
        else:
            print("Incorrect Card Number")
    elif proceed == "2":
        print("Exiting...")
    else:
        print("Invalid option")
        
    
        
    
        
   
def main_menu(User):
    while True:
         print("\nMain Menu:")
         print("1. Check balance")
         print("2. Withdraw money")
         print("3. Deposit money")
         print("4. Exiting") 
         
         choice = input(str("Enter Your choice : "))
         if choice == "1":
            print("Balance: ", User["account_balance"]) 
             
         elif choice == "2":
             print("Withdraw Money")
             withdraw_money(User)
             
         elif choice == "3":
             print("deposit Money")
             deposit_money(User)
             
         elif choice == "4":
             print("Thank you for using the ATM. Goodbye!", User["account_name"])
             automate(User)
         
         else:
             print("Invalid choice. Please try again.")
             
             
def withdraw_money(User):
    amount = float(input("Enter amount to withdraw : "))
    if amount <=  User["account_balance"]:
        User["account_balance"] -= amount 
        print("Withdrawal successful. New Balance : ", User["account_balance"])
    else:
        print("Insufficient funds.")
        
def deposit_money(User):
    amount = float(input("Enter amount to diposit : "))
    User["account_balance"] += amount
    print("Deposit successful. New balance:", User["account_balance"])
    
             
    
automate(User)