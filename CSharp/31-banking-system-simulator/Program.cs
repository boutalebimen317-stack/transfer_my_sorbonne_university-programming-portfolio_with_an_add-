
using System;
using System.Collections.Generic;

class BankAccount
{
    public int AccountNumber;
    public string Owner;
    public decimal Balance;
    public List<string> History = new List<string>();

    public BankAccount(int number, string name)
    {
        AccountNumber = number;
        Owner = name;
        Balance = 0;
        History.Add("Account created.");
    }
}

class Program
{
    static List<BankAccount> accounts = new List<BankAccount>();
    static int nextAccountNumber = 1001;

    static void Main()
    {
        bool running = true;

        while (running)
        {
            Console.WriteLine("\n===== BANKING SYSTEM =====");
            Console.WriteLine("1. Create account");
            Console.WriteLine("2. Show all accounts");
            Console.WriteLine("3. Deposit money");
            Console.WriteLine("4. Withdraw money");
            Console.WriteLine("5. Check balance");
            Console.WriteLine("6. Transaction history");
            Console.WriteLine("7. Exit");
            Console.Write("Choose an option: ");

            string choice = Console.ReadLine() ?? "";

            switch (choice)
            {
                case "1":
                    createAccount();
                    break;
                case "2":
                    showAccounts();
                    break;
                case "3":
                    moveMoney(true);
                    break;
                case "4":
                    moveMoney(false);
                    break;
                case "5":
                    checkBalance();
                    break;
                case "6":
                    showHistory();
                    break;
                case "7":
                    running = false;
                    Console.WriteLine("Thank you for using our banking system!");
                    break;
                default:
                    Console.WriteLine("Invalid choice. Try again.");
                    break;
            }
        }
    }

    static void createAccount()
    {
        Console.Write("Enter account owner's name: ");
        string name = (Console.ReadLine() ?? "").Trim();

        if (string.IsNullOrWhiteSpace(name))
        {
            Console.WriteLine("Name cannot be empty.");
            return;
        }

        BankAccount newAccount = new BankAccount(nextAccountNumber, name);
        accounts.Add(newAccount);

        Console.WriteLine("Account created successfully!");
        Console.WriteLine("Your account number is: " + nextAccountNumber);

        nextAccountNumber++;
    }

    static void showAccounts()
    {
        if (accounts.Count == 0)
        {
            Console.WriteLine("There are no accounts yet.");
            return;
        }

        Console.WriteLine("\n--- All Bank Accounts ---");

        foreach (BankAccount account in accounts)
        {
            Console.WriteLine("Account: " + account.AccountNumber);
            Console.WriteLine("Owner: " + account.Owner);
            Console.WriteLine("Balance: " + account.Balance.ToString("F2"));
            Console.WriteLine("------------------------");
        }
    }

    static BankAccount? findAccount()
    {
        Console.Write("Enter account number: ");
        string input = Console.ReadLine() ?? "";

        if (!int.TryParse(input, out int number))
        {
            Console.WriteLine("Invalid account number.");
            return null;
        }

        foreach (BankAccount account in accounts)
        {
            if (account.AccountNumber == number)
            {
                return account;
            }
        }

        Console.WriteLine("Account not found.");
        return null;
    }

    static void moveMoney(bool isDeposit)
    {
        BankAccount? account = findAccount();

        if (account == null)
            return;

        Console.Write("Enter amount: ");
        string input = Console.ReadLine() ?? "";

        if (!decimal.TryParse(input, out decimal amount) || amount <= 0)
        {
            Console.WriteLine("Please enter a valid positive amount.");
            return;
        }

        if (isDeposit)
        {
            account.Balance += amount;
            account.History.Add("Deposited " + amount.ToString("F2"));
            Console.WriteLine("Deposit completed successfully.");
        }
        else
        {
            if (amount > account.Balance)
            {
                Console.WriteLine("Insufficient funds!");
                return;
            }

            account.Balance -= amount;
            account.History.Add("Withdrew " + amount.ToString("F2"));
            Console.WriteLine("Withdrawal completed successfully.");
        }

        Console.WriteLine("Current balance: " + account.Balance.ToString("F2"));
    }

    static void checkBalance()
    {
        BankAccount? account = findAccount();

        if (account != null)
        {
            Console.WriteLine("Owner: " + account.Owner);
            Console.WriteLine("Current balance: " + account.Balance.ToString("F2"));
        }
    }

    static void showHistory()
    {
        BankAccount? account = findAccount();

        if (account == null)
            return;

        Console.WriteLine("\n--- Transaction History ---");

        foreach (string transaction in account.History)
        {
            Console.WriteLine(transaction);
        }
    }
}

