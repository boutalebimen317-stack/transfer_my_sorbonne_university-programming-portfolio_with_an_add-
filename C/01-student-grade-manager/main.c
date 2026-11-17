
#include <stdio.h>
#include <string.h>

#define MAX_STUDENTS 50
#define SUBJECTS 3

// Structure to store student information
struct Student {
    char name[50];
    float grades[SUBJECTS];
};

// Calculate the average of a student
float calculateAverage(struct Student s) {
    float sum = 0;
    int i;

    for (i = 0; i < SUBJECTS; i++) {
        sum = sum + s.grades[i];
    }

    return sum / SUBJECTS;
}

// Add a new student
int addStudent(struct Student students[], int count) {
    int i;

    if (count >= MAX_STUDENTS) {
        printf("The student list is full!\n");
        return count;
    }

    printf("Enter student name (one word): ");
    scanf("%49s", students[count].name);

    for (i = 0; i < SUBJECTS; i++) {
        do {
            printf("Enter grade %d (0 to 20): ", i + 1);
            scanf("%f", &students[count].grades[i]);

            if (students[count].grades[i] < 0 ||
                students[count].grades[i] > 20) {
                printf("Invalid grade! Try again.\n");
            }

        } while (students[count].grades[i] < 0 ||
                 students[count].grades[i] > 20);
    }

    printf("Student added successfully!\n");

    return count + 1;
}

// Display all students
void displayStudents(struct Student students[], int count) {
    int i;

    if (count == 0) {
        printf("No students available.\n");
        return;
    }

    printf("\n--- STUDENT LIST ---\n");

    for (i = 0; i < count; i++) {
        printf("\nName: %s\n", students[i].name);
        printf("Average: %.2f/20\n",
               calculateAverage(students[i]));
    }
}

// Find the highest and lowest averages
void showHighestLowest(struct Student students[], int count) {
    int i;
    int highest = 0;
    int lowest = 0;

    if (count == 0) {
        printf("No students available.\n");
        return;
    }

    for (i = 1; i < count; i++) {
        if (calculateAverage(students[i]) >
            calculateAverage(students[highest])) {
            highest = i;
        }

        if (calculateAverage(students[i]) <
            calculateAverage(students[lowest])) {
            lowest = i;
        }
    }

    printf("\n--- HIGHEST AVERAGE ---\n");
    printf("%s: %.2f/20\n",
           students[highest].name,
           calculateAverage(students[highest]));

    printf("\n--- LOWEST AVERAGE ---\n");
    printf("%s: %.2f/20\n",
           students[lowest].name,
           calculateAverage(students[lowest]));
}

// Search for a student
void searchStudent(struct Student students[], int count) {
    char searchName[50];
    int i;
    int found = 0;

    printf("Enter the name to search: ");
    scanf("%49s", searchName);

    for (i = 0; i < count; i++) {
        if (strcmp(students[i].name, searchName) == 0) {
            printf("\nStudent found!\n");
            printf("Name: %s\n", students[i].name);
            printf("Average: %.2f/20\n",
                   calculateAverage(students[i]));

            found = 1;
            break;
        }
    }

    if (found == 0) {
        printf("Student not found.\n");
    }
}

// Sort students by average (highest to lowest)
void sortStudents(struct Student students[], int count) {
    int i, j;
    struct Student temp;

    if (count == 0) {
        printf("No students available.\n");
        return;
    }

    for (i = 0; i < count - 1; i++) {
        for (j = 0; j < count - i - 1; j++) {

            if (calculateAverage(students[j]) <
                calculateAverage(students[j + 1])) {

                temp = students[j];
                students[j] = students[j + 1];
                students[j + 1] = temp;
            }
        }
    }

    printf("Students sorted successfully!\n");
    displayStudents(students, count);
}

// Main program
int main() {
    struct Student students[MAX_STUDENTS];

    int count = 0;
    int choice;

    do {
        printf("\n===== STUDENT MANAGEMENT SYSTEM =====\n");
        printf("1. Add student\n");
        printf("2. Display students\n");
        printf("3. Show highest and lowest averages\n");
        printf("4. Search for a student\n");
        printf("5. Sort students by average\n");
        printf("0. Exit\n");

        printf("\nEnter your choice: ");
        scanf("%d", &choice);

        switch (choice) {
            case 1:
                count = addStudent(students, count);
                break;

            case 2:
                displayStudents(students, count);
                break;

            case 3:
                showHighestLowest(students, count);
                break;

            case 4:
                if (count == 0) {
                    printf("No students available.\n");
                } else {
                    searchStudent(students, count);
                }
                break;

            case 5:
                sortStudents(students, count);
                break;

            case 0:
                printf("Thank you for using the program!\n");
                break;

            default:
                printf("Invalid choice! Try again.\n");
        }

    } while (choice != 0);

    return 0;
}
