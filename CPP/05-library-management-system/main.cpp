
#include <iostream>
#include <vector>
#include <string>
#include <limits>
using namespace std;

struct Book {
    int id;
    string title;
    string author;
    bool borrowed;
};

vector<Book> books;
int nextBookId = 1;

int readNumber() {
    int number;

    while (!(cin >> number)) {
        cout << "Please enter a valid number: ";
        cin.clear();
        cin.ignore(numeric_limits<streamsize>::max(), '\n');
    }

    cin.ignore(numeric_limits<streamsize>::max(), '\n');
    return number;
}

void addBook() {
    Book newBook;

    newBook.id = nextBookId++;

    cout << "\nBook title: ";
    getline(cin, newBook.title);

    if (newBook.title.empty()) {
        cout << "The title cannot be empty.\n";
        nextBookId--;
        return;
    }

    cout << "Author name: ";
    getline(cin, newBook.author);

    if (newBook.author.empty()) {
        cout << "The author name cannot be empty.\n";
        nextBookId--;
        return;
    }

    newBook.borrowed = false;
    books.push_back(newBook);

    cout << "\nBook added! Its ID is " << newBook.id << ".\n";
}

void showBooks() {
    if (books.empty()) {
        cout << "\nThe library is empty for now.\n";
        return;
    }

    cout << "\n========== LIBRARY BOOKS ==========\n";

    for (const Book& book : books) {
        cout << "\nID: " << book.id << '\n';
        cout << "Title: " << book.title << '\n';
        cout << "Author: " << book.author << '\n';
        cout << "Status: "
             << (book.borrowed ? "Borrowed" : "Available") << '\n';
    }
}

void searchBook() {
    string title;
    bool found = false;

    cout << "\nEnter the book title: ";
    getline(cin, title);

    for (const Book& book : books) {
        if (book.title == title) {
            cout << "\nBook found!\n";
            cout << "ID: " << book.id << '\n';
            cout << "Title: " << book.title << '\n';
            cout << "Author: " << book.author << '\n';
            cout << "Status: "
                 << (book.borrowed ? "Borrowed" : "Available") << '\n';

            found = true;
        }
    }

    if (!found) {
        cout << "\nNo book with that title was found.\n";
    }
}

void borrowBook() {
    cout << "\nEnter the book ID: ";
    int id = readNumber();

    for (Book& book : books) {
        if (book.id == id) {
            if (book.borrowed) {
                cout << "This book is already borrowed.\n";
            } else {
                book.borrowed = true;
                cout << "You borrowed \"" << book.title << "\".\n";
            }
            return;
        }
    }

    cout << "Book not found.\n";
}

void returnBook() {
    cout << "\nEnter the book ID: ";
    int id = readNumber();

    for (Book& book : books) {
        if (book.id == id) {
            if (!book.borrowed) {
                cout << "This book is already available.\n";
            } else {
                book.borrowed = false;
                cout << "Book returned successfully!\n";
            }
            return;
        }
    }

    cout << "Book not found.\n";
}

int main() {
    int choice;

    do {
        cout << "\n========== MY LIBRARY ==========\n";
        cout << "1. Add a book\n";
        cout << "2. Display all books\n";
        cout << "3. Search for a book\n";
        cout << "4. Borrow a book\n";
        cout << "5. Return a book\n";
        cout << "0. Exit\n";

        cout << "\nChoose an option: ";
        choice = readNumber();

        switch (choice) {
            case 1:
                addBook();
                break;

            case 2:
                showBooks();
                break;

            case 3:
                searchBook();
                break;

            case 4:
                borrowBook();
                break;

            case 5:
                returnBook();
                break;

            case 0:
                cout << "\nLeaving the library. see u next time!\n";
                break;

            default:
                cout << "\nThat option is not available.\n";
        }

    } while (choice != 0);

    return 0;
}
