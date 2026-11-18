
import java.util.Scanner;

public class Main {

    static Scanner input = new Scanner(System.in);
    static double balance = 1000;
    static int transactions = 0;

    static void showBalance() {
        System.out.println("Current balance: " + balance);
    }

    static void deposit() {
        System.out.print("Amount to deposit: ");
        double amount = input.nextDouble();

        if (amount <= 0) {
            System.out.println("Enter a valid amount.");
            return;
        }

        balance += amount;
        transactions++;
        System.out.println("Deposit successful!");
    }

    static void withdraw() {
        System.out.print("Amount to withdraw: ");
        double amount = input.nextDouble();

        if (amount <= 0) {
            System.out.println("Enter a valid amount.");
        } else if (amount > balance) {
            System.out.println("Not enough money in your account.");
        } else {
            balance -= amount;
            transactions++;
            System.out.println("Withdrawal successful!");
        }
    }

    public static void main(String[] args) {
        int choice = -1;

        while (choice != 0) {
            System.out.println("\n===== Banking System =====");
            System.out.println("1. Check balance");
            System.out.println("2. Deposit");
            System.out.println("3. Withdraw");
            System.out.println("4. Transaction count");
            System.out.println("0. Exit");
            System.out.print("Choose: ");

            if (!input.hasNextInt()) {
                System.out.println("Enter a number.");
                input.nextLine();
                continue;
            }

            choice = input.nextInt();

            switch (choice) {
                case 1 -> showBalance();
                case 2 -> deposit();
                case 3 -> withdraw();
                case 4 -> System.out.println("Successful transactions: " + transactions);
                case 0 -> System.out.println("Goodbye!");
                default -> System.out.println("Invalid choice.");
            }
        }

        input.close();
    }
}
