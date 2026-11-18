
import java.util.ArrayList;
import java.util.Scanner;

class Student {
    int id;
    String name;
    String department;

    Student(int id, String name, String department) {
        this.id = id;
        this.name = name;
        this.department = department;
    }
}

class Course {
    int id;
    String name;
    int credits;

    Course(int id, String name, int credits) {
        this.id = id;
        this.name = name;
        this.credits = credits;
    }
}

class Registration {
    int studentId;
    int courseId;

    Registration(int studentId, int courseId) {
        this.studentId = studentId;
        this.courseId = courseId;
    }
}

public class Main {
    static Scanner input = new Scanner(System.in);

    static ArrayList<Student> students = new ArrayList<>();
    static ArrayList<Course> courses = new ArrayList<>();
    static ArrayList<Registration> registrations = new ArrayList<>();

    static void addStudent() {
        System.out.print("\nStudent ID: ");
        int id = input.nextInt();
        input.nextLine();

        if (findStudent(id) != null) {
            System.out.println("This student ID already exists.");
            return;
        }

        System.out.print("Student name: ");
        String name = input.nextLine();

        System.out.print("Department: ");
        String department = input.nextLine();

        if (name.trim().isEmpty() || department.trim().isEmpty()) {
            System.out.println("Name and department cannot be empty.");
            return;
        }

        students.add(new Student(id, name, department));
        System.out.println("Student added successfully!");
    }

    static void addCourse() {
        System.out.print("\nCourse ID: ");
        int id = input.nextInt();
        input.nextLine();

        if (findCourse(id) != null) {
            System.out.println("This course ID already exists.");
            return;
        }

        System.out.print("Course name: ");
        String name = input.nextLine();

        System.out.print("Number of credits: ");
        int credits = input.nextInt();
        input.nextLine();

        if (name.trim().isEmpty() || credits <= 0) {
            System.out.println("Enter a valid course name and credit value.");
            return;
        }

        courses.add(new Course(id, name, credits));
        System.out.println("Course added successfully!");
    }

    static Student findStudent(int id) {
        for (Student student : students) {
            if (student.id == id) {
                return student;
            }
        }

        return null;
    }

    static Course findCourse(int id) {
        for (Course course : courses) {
            if (course.id == id) {
                return course;
            }
        }

        return null;
    }

    static void registerStudent() {
        System.out.print("\nEnter student ID: ");
        int studentId = input.nextInt();

        System.out.print("Enter course ID: ");
        int courseId = input.nextInt();

        input.nextLine();

        Student student = findStudent(studentId);
        Course course = findCourse(courseId);

        if (student == null || course == null) {
            System.out.println("Student or course not found.");
            return;
        }

        for (Registration registration : registrations) {
            if (registration.studentId == studentId &&
                registration.courseId == courseId) {
                System.out.println("This student is already registered.");
                return;
            }
        }

        registrations.add(new Registration(studentId, courseId));
        System.out.println("Registration completed!");
    }

    static void showStudents() {
        if (students.isEmpty()) {
            System.out.println("\nNo students registered yet.");
            return;
        }

        System.out.println("\n========== STUDENTS ==========");

        for (Student student : students) {
            System.out.println("ID: " + student.id);
            System.out.println("Name: " + student.name);
            System.out.println("Department: " + student.department);
            System.out.println("-------------------------");
        }
    }

    static void showCourses() {
        if (courses.isEmpty()) {
            System.out.println("\nNo courses available.");
            return;
        }

        System.out.println("\n========== COURSES ==========");

        for (Course course : courses) {
            System.out.println("ID: " + course.id);
            System.out.println("Name: " + course.name);
            System.out.println("Credits: " + course.credits);
            System.out.println("-------------------------");
        }
    }

    static void showStudentCourses() {
        System.out.print("\nEnter student ID: ");
        int id = input.nextInt();
        input.nextLine();

        Student student = findStudent(id);

        if (student == null) {
            System.out.println("Student not found.");
            return;
        }

        System.out.println("\nCourses for " + student.name + ":");

        boolean found = false;

        for (Registration registration : registrations) {
            if (registration.studentId == id) {
                Course course = findCourse(registration.courseId);

                if (course != null) {
                    System.out.println("- " + course.name +
                                       " (" + course.credits + " credits)");
                    found = true;
                }
            }
        }

        if (!found) {
            System.out.println("This student has no courses yet.");
        }
    }

    public static void main(String[] args) {
        int choice = 0;

        do {
            System.out.println("\n========== UNIVERSITY SYSTEM ==========");
            System.out.println("1. Add student");
            System.out.println("2. Add course");
            System.out.println("3. Register student in a course");
            System.out.println("4. Display students");
            System.out.println("5. Display courses");
            System.out.println("6. Show a student's courses");
            System.out.println("0. Exit");

            System.out.print("\nChoose an option: ");

            if (!input.hasNextInt()) {
                System.out.println("Please enter a number.");
                input.nextLine();
                continue;
            }

            choice = input.nextInt();
            input.nextLine();

            switch (choice) {
                case 1 -> addStudent();

                case 2 -> addCourse();

                case 3 -> registerStudent();

                case 4 -> showStudents();

                case 5 -> showCourses();

                case 6 -> showStudentCourses();

                case 0 -> System.out.println("University system closed.");

                default -> System.out.println("Invalid option.");
            }

        } while (choice != 0);

        input.close();
    }
}
