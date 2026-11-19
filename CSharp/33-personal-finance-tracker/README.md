# Personal Finance Tracker

A console-based personal finance management application developed in C#.

This project allows users to manage income and expenses, organize financial transactions, and monitor their overall financial situation. Transaction data is stored locally in a text file, so records remain available between program executions.

## Features

- Add income and expense transactions
- View all recorded transactions
- Search transactions by category, type, or keyword
- Edit existing transactions
- Delete transactions with confirmation
- Calculate total income, expenses, and current balance
- Generate monthly financial summaries
- Save and load transaction records using file handling

## Technologies and Concepts

- **Language:** C#
- **Framework:** .NET 8
- Object-Oriented Programming
- Classes and objects
- Collections (`List<T>`)
- LINQ queries
- File handling (`StreamReader`, `StreamWriter`)
- CRUD operations
- Input validation
- Exception handling
- Date and numeric formatting

## Project Structure

```text
33-personal-finance-tracker/
├── Program.cs
├── Transaction.cs
├── FinanceManager.cs
├── transactions.txt
├── README.md
└── 33-personal-finance-tracker.csproj
```

## How to Run

1. Install the .NET 8 SDK.
2. Clone this repository.
3. Navigate to the project directory.
4. Run:

```bash
dotnet run
```

## Data Storage

Transactions are stored in `transactions.txt` using a pipe-separated format.

The application loads existing records when it starts and saves changes when transactions are added, updated, or deleted.

## Project Purpose

This project was developed to practice C# programming, object-oriented design, collections, LINQ, and persistent file storage through a practical application.

---

**Project 33 — University Programming Portfolio**
