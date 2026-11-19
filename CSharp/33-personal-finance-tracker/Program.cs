
using System;
using System.Collections.Generic;
using System.Globalization;

class Program
{
    static FinanceManager manager = new FinanceManager();

    static void Main()
    {
        int choice = 0;

        while (choice != 8)
        {
            Console.Clear();

            Console.WriteLine("====================================");
            Console.WriteLine("       PERSONAL FINANCE TRACKER");
            Console.WriteLine("====================================");
            Console.WriteLine("1. Add Income");
            Console.WriteLine("2. Add Expense");
            Console.WriteLine("3. View Transactions");
            Console.WriteLine("4. Search Transactions");
            Console.WriteLine("5. Edit Transaction");
            Console.WriteLine("6. Delete Transaction");
            Console.WriteLine("7. Financial Summary");
            Console.WriteLine("8. Exit");
            Console.WriteLine("====================================");

            Console.Write("Choose an option: ");

            if (!int.TryParse(Console.ReadLine(), out choice))
            {
                Console.WriteLine("Invalid input.");
                Pause();
                continue;
            }

            switch (choice)
            {
                case 1:
                    AddTransaction("Income");
                    break;

                case 2:
                    AddTransaction("Expense");
                    break;

                case 3:
                    ViewTransactions(manager.GetTransactions());
                    break;

                case 4:
                    SearchTransactions();
                    break;

                case 5:
                    EditTransaction();
                    break;

                case 6:
                    DeleteTransaction();
                    break;

                case 7:
                    ShowSummary();
                    break;

                case 8:
                    Console.WriteLine("Goodbye!");
                    break;

                default:
                    Console.WriteLine("Choose an option between 1 and 8.");
                    break;
            }

            if (choice != 8)
                Pause();
        }
    }

    static void AddTransaction(string type)
    {
        Console.Clear();

        Console.WriteLine("===== ADD " + type.ToUpper() + " =====");

        Console.Write("Category: ");
        string category = Console.ReadLine() ?? "";

        Console.Write("Amount: ");
        double amount;

        if (!double.TryParse(Console.ReadLine(),
            NumberStyles.Number, CultureInfo.CurrentCulture, out amount)
            || amount <= 0)
        {
            Console.WriteLine("Invalid amount.");
            return;
        }

        Console.Write("Description: ");
        string description = Console.ReadLine() ?? "";

        try
        {
            manager.AddTransaction(type, category, amount, description);
            Console.WriteLine("\nTransaction added successfully.");
        }
        catch (ArgumentException ex)
        {
            Console.WriteLine(ex.Message);
        }
    }

    static void ViewTransactions(List<Transaction> records)
    {
        Console.Clear();

        Console.WriteLine("========== TRANSACTIONS ==========");

        if (records.Count == 0)
        {
            Console.WriteLine("No transactions found.");
            return;
        }

        Console.WriteLine(
            "{0,-6} {1,-10} {2,-15} {3,12} {4,-12}",
            "ID", "Type", "Category", "Amount", "Date");

        Console.WriteLine(new string('-', 65));

        foreach (Transaction t in records)
        {
            Console.WriteLine(
                "{0,-6} {1,-10} {2,-15} {3,12:F2} {4,-12}",
                t.Id,
                t.Type,
                t.Category,
                t.Amount,
                t.Date.ToString("yyyy-MM-dd")
            );

            Console.WriteLine("       Description: " + t.Description);
        }
    }

    static void SearchTransactions()
    {
        Console.Clear();

        Console.Write("Enter a category, type or keyword: ");
        string keyword = Console.ReadLine() ?? "";

        List<Transaction> results = manager.SearchTransactions(keyword);

        ViewTransactions(results);
    }

    static void EditTransaction()
    {
        Console.Clear();

        Console.Write("Enter transaction ID: ");
        int id;

        if (!int.TryParse(Console.ReadLine(), out id))
        {
            Console.WriteLine("Invalid ID.");
            return;
        }

        Transaction? transaction = manager.FindTransaction(id);

        if (transaction == null)
        {
            Console.WriteLine("Transaction not found.");
            return;
        }

        Console.WriteLine("Current category: " + transaction.Category);
        Console.Write("New category: ");
        string category = Console.ReadLine() ?? "";

        Console.Write("New amount: ");
        double amount;

        if (!double.TryParse(Console.ReadLine(),
            NumberStyles.Number, CultureInfo.CurrentCulture, out amount)
            || amount <= 0)
        {
            Console.WriteLine("Invalid amount.");
            return;
        }

        Console.Write("New description: ");
        string description = Console.ReadLine() ?? "";

        if (manager.UpdateTransaction(id, category, amount, description))
            Console.WriteLine("Transaction updated successfully.");
        else
            Console.WriteLine("Could not update transaction. Check your input.");
    }

    static void DeleteTransaction()
    {
        Console.Clear();

        Console.Write("Enter transaction ID to delete: ");
        int id;

        if (!int.TryParse(Console.ReadLine(), out id))
        {
            Console.WriteLine("Invalid ID.");
            return;
        }

        Transaction? transaction = manager.FindTransaction(id);

        if (transaction == null)
        {
            Console.WriteLine("Transaction not found.");
            return;
        }

        Console.WriteLine("Transaction: " + transaction.Category);
        Console.WriteLine("Amount: " + transaction.Amount);

        Console.Write("Are you sure? (y/n): ");
        string answer = Console.ReadLine() ?? "";

        if (answer.Equals("y", StringComparison.OrdinalIgnoreCase))
        {
            if (manager.DeleteTransaction(id))
                Console.WriteLine("Transaction deleted.");
        }
        else
        {
            Console.WriteLine("Deletion cancelled.");
        }
    }

    static void ShowSummary()
    {
        Console.Clear();

        double income = manager.GetTotalIncome();
        double expenses = manager.GetTotalExpenses();
        double balance = manager.GetBalance();

        Console.WriteLine("========== FINANCIAL SUMMARY ==========");

        Console.WriteLine("Total income:   " + income.ToString("F2"));
        Console.WriteLine("Total expenses: " + expenses.ToString("F2"));

        Console.WriteLine("---------------------------------------");

        Console.WriteLine("Current balance: " + balance.ToString("F2"));

        Console.WriteLine("\n========== MONTHLY REPORT ==========");

        Console.Write("Enter year: ");
        int year;

        if (!int.TryParse(Console.ReadLine(), out year))
        {
            Console.WriteLine("Invalid year.");
            return;
        }

        Console.Write("Enter month (1-12): ");
        int month;

        if (!int.TryParse(Console.ReadLine(), out month) ||
            month < 1 || month > 12)
        {
            Console.WriteLine("Invalid month.");
            return;
        }

        List<Transaction> monthly =
            manager.GetMonthlyTransactions(year, month);

        double monthlyIncome = 0;
        double monthlyExpenses = 0;

        foreach (Transaction t in monthly)
        {
            if (t.Type == "Income")
                monthlyIncome += t.Amount;
            else
                monthlyExpenses += t.Amount;
        }

        Console.WriteLine("\nMonthly income: " + monthlyIncome.ToString("F2"));
        Console.WriteLine("Monthly expenses: " + monthlyExpenses.ToString("F2"));
        Console.WriteLine("Monthly balance: " +
            (monthlyIncome - monthlyExpenses).ToString("F2"));
        Console.WriteLine("Number of transactions: " + monthly.Count);
    }

    static void Pause()
    {
        Console.WriteLine("\nPress Enter to continue...");
        Console.ReadLine();
    }
}
