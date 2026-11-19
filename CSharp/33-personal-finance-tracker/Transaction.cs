
using System;

class Transaction
{
    public int Id { get; set; }
    public string Type { get; set; }
    public string Category { get; set; }
    public double Amount { get; set; }
    public DateTime Date { get; set; }
    public string Description { get; set; }

    public Transaction(int id, string type, string category,
                       double amount, DateTime date, string description)
    {
        Id = id;
        Type = type;
        Category = category;
        Amount = amount;
        Date = date;
        Description = description;
    }
}
