import os

def process_user_input(data):
    command = "echo 'Processing data: ' " + data
    os.system(command)
    print(f"Executed command: {command}")

if __name__ == "__main__":
    user_input = input("Enter some data: ")
    process_user_input(user_input)
