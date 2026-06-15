def main():
    while True:
        expression = input("\nEnter any mathematical expression or type 'exit' to quit: ")

        if expression.lower() == 'exit':
            print("Exiting...")
            break

        try:
            result = calculate(expression)
            print("Result:", result)
        except Exception as e:
            print("Error:", e)


def calculate(expression):
    operators = set('+-*/%')
    num = ''
    nums = []
    ops = []
    for i, char in enumerate(expression):
        if char.isdigit() or char == '.' or (char == '-' and (i == 0 or expression[i - 1] in operators)):
            num += char
        elif char in operators:
            if num:
                nums.append(float(num))
                num = ''
            ops.append(char)
    if num:
        nums.append(float(num))

    # Perform multiplication
    perform_multiplication(nums, ops)

    # Perform division
    perform_division(nums, ops)

    # Perform addition
    perform_addition(nums, ops)

    # Perform subtraction
    perform_subtraction(nums, ops)
    
    perform_modulus(nums, ops)

    return nums[0]


def perform_multiplication(nums, ops):
    i = 0
    while i < len(ops):
        if ops[i] == '*':
            nums[i] = nums[i] * nums[i + 1]
            del nums[i + 1]
            del ops[i]
        else:
            i += 1


def perform_division(nums, ops):
    i = 0
    while i < len(ops):
        if ops[i] == '/':
            nums[i] = nums[i] / nums[i + 1]
            del nums[i + 1]
            del ops[i]
        else:
            i += 1


def perform_addition(nums, ops):
    result = nums[0]
    for i in range(len(ops)):
        if ops[i] == '+':
            result += nums[i + 1]
    nums[0] = result


def perform_subtraction(nums, ops):
    result = nums[0]
    for i in range(len(ops)):
        if ops[i] == '-':
            result -= nums[i + 1]
    nums[0] = result
    
def perform_modulus(nums, ops):
    result = nums[0]
    for i in range(len(ops)):
        if ops[i] == '%':
            result -= nums[i + 1]
    nums[0] = result


main()
