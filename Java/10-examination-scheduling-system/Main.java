
import java.util.ArrayList;
import java.util.Scanner;

class Exam {
    int id;
    String subject;
    String date;
    String time;
    String room;

    Exam(int id, String subject, String date, String time, String room) {
        this.id = id;
        this.subject = subject;
        this.date = date;
        this.time = time;
        this.room = room;
    }
}

public class Main {

    static Scanner input = new Scanner(System.in);
    static ArrayList<Exam> exams = new ArrayList<>();

    static void addExam() {
        System.out.print("Enter exam ID: ");
        int id = input.nextInt();
        input.nextLine();

        for (Exam exam : exams) {
            if (exam.id == id) {
                System.out.println("This ID is already used.");
                return;
            }
        }

        System.out.print("Enter subject name: ");
        String subject = input.nextLine();

        System.out.print("Enter exam date: ");
        String date = input.nextLine();

        System.out.print("Enter exam time: ");
        String time = input.nextLine();

        System.out.print("Enter room: ");
        String room = input.nextLine();

        exams.add(new Exam(id, subject, date, time, room));

        System.out.println("Exam added successfully!");
    }

    static void showExams() {
        if (exams.isEmpty()) {
            System.out.println("There are no exams scheduled yet.");
            return;
        }

        System.out.println("\n--- Examination Schedule ---");

        for (Exam exam : exams) {
            System.out.println("\nExam ID: " + exam.id);
            System.out.println("Subject: " + exam.subject);
            System.out.println("Date: " + exam.date);
            System.out.println("Time: " + exam.time);
            System.out.println("Room: " + exam.room);
        }
    }

    static void searchExam() {
        System.out.print("Enter exam ID to search: ");
        int id = input.nextInt();

        for (Exam exam : exams) {
            if (exam.id == id) {
                System.out.println("\nExam found!");
                System.out.println("Subject: " + exam.subject);
                System.out.println("Date: " + exam.date);
                System.out.println("Time: " + exam.time);
                System.out.println("Room: " + exam.room);
                return;
            }
        }

        System.out.println("No exam found with this ID.");
    }

    static void deleteExam() {
        System.out.print("Enter exam ID to delete: ");
        int id = input.nextInt();

        for (int i = 0; i < exams.size(); i++) {
            if (exams.get(i).id == id) {
                exams.remove(i);
                System.out.println("Exam deleted successfully.");
                return;
            }
        }

        System.out.println("Exam not found.");
    }

    public static void main(String[] args) {

        int choice = -1;

        while (choice != 0) {
            System.out.println("\n===== Examination Scheduling System =====");
            System.out.println("1. Add an exam");
            System.out.println("2. Show all exams");
            System.out.println("3. Search for an exam");
            System.out.println("4. Delete an exam");
            System.out.println("0. Exit");
            System.out.print("Choose an option: ");

            if (!input.hasNextInt()) {
                System.out.println("Please enter a number.");
                input.nextLine();
                continue;
            }

            choice = input.nextInt();

            switch (choice) {
                case 1 -> addExam();
                case 2 -> showExams();
                case 3 -> searchExam();
                case 4 -> deleteExam();
                case 0 -> System.out.println("Goodbye!");
                default -> System.out.println("Invalid choice. Try again.");
            }
        }

        input.close();
    }
}
