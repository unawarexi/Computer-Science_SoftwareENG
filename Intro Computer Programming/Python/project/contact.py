import json
import os


""" 
project has 3 fatures 

add, view all, and view specific by name 
using file handling techniques to create Contatct.txt file based on info
making use of builtin modules 
and using errror handling technique to prevent unforseen causes
"""

# add a contact and save in json
def add_contact():
    name = input("Enter name: ")
    phone = input("Enter phone number: ")
    email = input("Enter email address: ")

    contact = {
        'name': name,
        'phone': phone,
        'email': email
    }

    # Creating document folder if it does not exist
    if not os.path.exists('../docs'):
        os.makedirs('../docs')

    # Write the contact to the contact.txt file in the docs folder
    with open('../docs/contact.txt', 'a') as file:
        json.dump(contact, file)
        file.write('\n')
    
    print("Contact added successfully!")


# view all contacts
def view_all_contacts():
    try:
        with open('../docs/contact.txt', 'r') as file:
            contacts = file.readlines()
            for contact in contacts:
                print(contact.strip())
    except FileNotFoundError:
        print("No contacts found.")


# View contact options specifcally by name
def contact_by_name(name):
    try:
        with open('../docs/contact.txt', 'r') as file:
            contacts = file.readlines()
            for contact in contacts:
                contact_dictionary = json.loads(contact.strip())
                if contact_dictionary['name'] == name:
                    print("Contact found:")
                    print("Name:", contact_dictionary['name'])
                    print("Phone:", contact_dictionary['phone'])
                    print("Email:", contact_dictionary['email'])
                    return
            print("Contact not found.")
    except FileNotFoundError:
        print("No contacts found.")


# main options
def main():
    while True:
        print("\nContact Application")
        print("1. Add Contact")
        print("2. View All Contacts")
        print("3. View Contact by Name")
        print("4. Exit")

        choice = input("Enter your choice: ")

        if choice == '1':
            add_contact()
        elif choice == '2':
            view_all_contacts()
        elif choice == '3':
            name = input("Enter name to search: ")
            contact_by_name(name)
        elif choice == '4':
            print("Exiting...")
            break
        else:
            print("Invalid choice. Please try again.")
main()
