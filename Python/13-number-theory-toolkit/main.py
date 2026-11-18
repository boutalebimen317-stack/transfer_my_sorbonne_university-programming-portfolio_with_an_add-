
import math


def is_prime(number):
    if number < 2:
        return False

    for i in range(2, math.isqrt(number) + 1):
        if number % i == 0:
            return False

    return True


def find_gcd(a, b):
    return math.gcd(a, b)


def find_lcm(a, b):
    if a == 0 or b == 0:
        return 0
    return abs(a * b) // math.gcd(a, b)


def get_factorial(number):
    if number < 0:
        return None
    return math.factorial(number)


def show_divisors(number):
    if number == 0:
        return []

    result = []

    for i in range(1, abs(number) + 1):
        if number % i == 0:
            result.append(i)

    return result


while True:
    print("\n===== Number Theory Toolkit =====")
    print("1. Check prime number")
    print("2. Find GCD")
    print("3. Find LCM")
    print("4. Calculate factorial")
    print("5. Find divisors")
    print("0. Exit")

    choice = input("Choose an option: ")

    if choice == "1":
        n = int(input("Enter a number: "))
        print("Prime number!" if is_prime(n) else "Not a prime number.")

    elif choice == "2":
        a = int(input("First number: "))
        b = int(input("Second number: "))
        print("GCD:", find_gcd(a, b))

    elif choice == "3":
        a = int(input("First number: "))
        b = int(input("Second number: "))
        print("LCM:", find_lcm(a, b))

    elif choice == "4":
        n = int(input("Enter a number: "))
        result = get_factorial(n)
        print("Factorial:", result if result is not None else "Not defined for negative numbers.")

    elif choice == "5":
        n = int(input("Enter a number: "))
        print("Divisors:", show_divisors(n))

    elif choice == "0":
        print("Goodbye!")
        break

    else:
        print("Invalid choice. Try again.")
