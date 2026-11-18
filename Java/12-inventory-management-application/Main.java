
import java.util.ArrayList;
import java.util.Scanner;

class Product {
    int id;
    String name;
    int quantity;
    double price;

    Product(int id, String name, int quantity, double price) {
        this.id = id;
        this.name = name;
        this.quantity = quantity;
        this.price = price;
    }
}

public class Main {

    static Scanner input = new Scanner(System.in);
    static ArrayList<Product> products = new ArrayList<>();

    static void addProduct() {
        System.out.print("Product ID: ");
        int id = input.nextInt();
        input.nextLine();

        for (Product p : products) {
            if (p.id == id) {
                System.out.println("This ID already exists.");
                return;
            }
        }

        System.out.print("Product name: ");
        String name = input.nextLine();

        System.out.print("Quantity: ");
        int quantity = input.nextInt();

        System.out.print("Price: ");
        double price = input.nextDouble();

        if (quantity < 0 || price < 0) {
            System.out.println("Quantity and price cannot be negative.");
            return;
        }

        products.add(new Product(id, name, quantity, price));
        System.out.println("Product added!");
    }

    static void showProducts() {
        if (products.isEmpty()) {
            System.out.println("The inventory is empty.");
            return;
        }

        for (Product p : products) {
            System.out.println("\nID: " + p.id);
            System.out.println("Name: " + p.name);
            System.out.println("Quantity: " + p.quantity);
            System.out.println("Price: " + p.price);
        }
    }

    static void searchProduct() {
        System.out.print("Enter product ID: ");
        int id = input.nextInt();

        for (Product p : products) {
            if (p.id == id) {
                System.out.println("Found: " + p.name);
                System.out.println("Quantity: " + p.quantity);
                System.out.println("Price: " + p.price);
                return;
            }
        }

        System.out.println("Product not found.");
    }

    static void updateQuantity() {
        System.out.print("Enter product ID: ");
        int id = input.nextInt();

        for (Product p : products) {
            if (p.id == id) {
                System.out.print("New quantity: ");
                int quantity = input.nextInt();

                if (quantity < 0) {
                    System.out.println("Quantity cannot be negative.");
                    return;
                }

                p.quantity = quantity;
                System.out.println("Quantity updated.");
                return;
            }
        }

        System.out.println("Product not found.");
    }

    static void inventoryValue() {
        double total = 0;

        for (Product p : products) {
            total += p.quantity * p.price;
        }

        System.out.println("Total inventory value: " + total);
    }

    public static void main(String[] args) {
        int choice = -1;

        while (choice != 0) {
            System.out.println("\n===== Inventory Management =====");
            System.out.println("1. Add product");
            System.out.println("2. Show products");
            System.out.println("3. Search product");
            System.out.println("4. Update quantity");
            System.out.println("5. Calculate inventory value");
            System.out.println("0. Exit");
            System.out.print("Choose: ");

            if (!input.hasNextInt()) {
                System.out.println("Please enter a number.");
                input.nextLine();
                continue;
            }

            choice = input.nextInt();

            switch (choice) {
                case 1 -> addProduct();
                case 2 -> showProducts();
                case 3 -> searchProduct();
                case 4 -> updateQuantity();
                case 5 -> inventoryValue();
                case 0 -> System.out.println("Goodbye!");
                default -> System.out.println("Invalid choice.");
            }
        }

        input.close();
    }
}
