
using System;
using System.Collections.Generic;
using System.Globalization;
using System.IO;
using System.Linq;

class FinanceManager
{
    private List<Transaction> transactions = new List<Transaction>();
    private string filePath = "transactions.txt";
    private int nextId = 1;

    public FinanceManager()
    {
        LoadTransactions();
    }

    public List<Transaction> GetTransactions()
    {
        return transactions;
    }

    public void AddTransaction(string type, string category,
                               double amount, string description)
    {
        if (string.IsNullOrWhiteSpace(category) ||
            string.IsNullOrWhiteSpace(description))
        {
            throw new ArgumentException("Category and description are required.");
        }

        if (category.Contains("|") || description.Contains("|") ||
            category.Contains("\n") || description.Contains("\n"))
        {
            throw new ArgumentException("The | character and new lines are not allowed.");
        }

        if (amount <= 0)
        {
            throw new ArgumentException("Amount must be positive.");
        }

        Transaction transaction = new Transaction(
            nextId,
            type,
            category,
            amount,
            DateTime.Now,
            description
        );

        transactions.Add(transaction);
        nextId++;

        SaveTransactions();
    }

    public Transaction? FindTransaction(int id)
    {
        return transactions.FirstOrDefault(t => t.Id == id);
    }

    public List<Transaction> SearchTransactions(string keyword)
    {
        return transactions.Where(t =>
            t.Category.IndexOf(keyword, StringComparison.OrdinalIgnoreCase) >= 0 ||
            t.Description.IndexOf(keyword, StringComparison.OrdinalIgnoreCase) >= 0 ||
            t.Type.IndexOf(keyword, StringComparison.OrdinalIgnoreCase) >= 0
        ).ToList();
    }

    public bool UpdateTransaction(int id, string category,
                                  double amount, string description)
    {
        Transaction? transaction = FindTransaction(id);

        if (transaction == null)
            return false;

        if (string.IsNullOrWhiteSpace(category) ||
            string.IsNullOrWhiteSpace(description) ||
            category.Contains("|") || description.Contains("|") ||
            category.Contains("\n") || description.Contains("\n") ||
            amount <= 0)
        {
            return false;
        }

        transaction.Category = category;
        transaction.Amount = amount;
        transaction.Description = description;

        SaveTransactions();

        return true;
    }

    public bool DeleteTransaction(int id)
    {
        Transaction? transaction = FindTransaction(id);

        if (transaction == null)
            return false;

        transactions.Remove(transaction);

        SaveTransactions();

        return true;
    }

    public double GetTotalIncome()
    {
        return transactions
            .Where(t => t.Type == "Income")
            .Sum(t => t.Amount);
    }

    public double GetTotalExpenses()
    {
        return transactions
            .Where(t => t.Type == "Expense")
            .Sum(t => t.Amount);
    }

    public double GetBalance()
    {
        return GetTotalIncome() - GetTotalExpenses();
    }

    public List<Transaction> GetMonthlyTransactions(int year, int month)
    {
        return transactions.Where(t =>
            t.Date.Year == year && t.Date.Month == month
        ).ToList();
    }

    private void SaveTransactions()
    {
        using (StreamWriter writer = new StreamWriter(filePath))
        {
            foreach (Transaction t in transactions)
            {
                writer.WriteLine(
                    t.Id + "|" +
                    t.Type + "|" +
                    t.Category + "|" +
                    t.Amount.ToString(CultureInfo.InvariantCulture) + "|" +
                    t.Date.ToString("yyyy-MM-dd HH:mm:ss") + "|" +
                    t.Description
                );
            }
        }
    }

    private void LoadTransactions()
    {
        if (!File.Exists(filePath))
            return;

        string[] lines = File.ReadAllLines(filePath);

        foreach (string line in lines)
        {
            string[] data = line.Split('|');

            if (data.Length != 6)
                continue;

            int id;
            double amount;
            DateTime date;

            bool validId = int.TryParse(data[0], out id);
            bool validAmount = double.TryParse(
                data[3], NumberStyles.Float,
                CultureInfo.InvariantCulture, out amount);
            bool validDate = DateTime.TryParseExact(
                data[4], "yyyy-MM-dd HH:mm:ss",
                CultureInfo.InvariantCulture,
                DateTimeStyles.None, out date);

            if (!validId || !validAmount || !validDate ||
                (data[1] != "Income" && data[1] != "Expense"))
            {
                continue;
            }

            Transaction transaction = new Transaction(
                id, data[1], data[2], amount, date, data[5]
            );

            transactions.Add(transaction);
        }

        if (transactions.Count > 0)
            nextId = transactions.Max(t => t.Id) + 1;
    }
}
