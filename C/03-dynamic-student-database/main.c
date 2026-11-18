
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

struct Student {
    int id;
    char name[50];
    float average;
};

struct Student *students = NULL;
int studentCount = 0;

void addStudent() {
    struct Student *temp;

    temp = realloc(students, (studentCount + 1) * sizeof(struct Student));

    if (temp == NULL) {
        printf("\nCould not allocate memory.\n");
        return;
    }

    students = temp;

    printf("\nEnter student ID: ");
    if (scanf("%d", &students[studentCount].id) != 1) {
        printf("Invalid ID.\n");
        while (getchar() != '\n');
        return;
    }

    for (int i = 0; i < studentCount; i++) {
        if (students[i].id == students[studentCount].id) {
            printf("This ID is already used.\n");
            return;
        }
    }

    printf("Enter student name: ");
    scanf(" %49[^\n]", students[studentCount].name);

    printf("Enter average: ");
    if (scanf("%f", &students[studentCount].average) != 1 ||
        students[studentCount].average < 0 ||
        students[studentCount].average > 20) {
        printf("Please enter a valid average between 0 and 20.\n");
        while (getchar() != '\n');
        return;
    }

    studentCount++;
    printf("\nStudent added successfully!\n");
}

void displayStudents() {
    if (studentCount == 0) {
        printf("\nThe database is empty.\n");
        return;
    }

    printf("\n========== STUDENT DATABASE ==========\n");

    for (int i = 0; i < studentCount; i++) {
        printf("\nID: %d\n", students[i].id);
        printf("Name: %s\n", students[i].name);
        printf("Average: %.2f/20\n", students[i].average);
    }
}

void searchStudent() {
    int id;

    printf("\nEnter the student ID: ");

    if (scanf("%d", &id) != 1) {
        printf("Invalid ID.\n");
        while (getchar() != '\n');
        return;
    }

    for (int i = 0; i < studentCount; i++) {
        if (students[i].id == id) {
            printf("\nStudent found!\n");
            printf("ID: %d\n", students[i].id);
            printf("Name: %s\n", students[i].name);
            printf("Average: %.2f/20\n", students[i].average);
            return;
        }
    }

    printf("\nNo student with this ID was found.\n");
}

void deleteStudent() {
    int id;
    int found = -1;

    printf("\nEnter the ID of the student to delete: ");

    if (scanf("%d", &id) != 1) {
        printf("Invalid ID.\n");
        while (getchar() != '\n');
        return;
    }

    for (int i = 0; i < studentCount; i++) {
        if (students[i].id == id) {
            found = i;
            break;
        }
    }

    if (found == -1) {
        printf("\nStudent not found.\n");
        return;
    }

    for (int i = found; i < studentCount - 1; i++) {
        students[i] = students[i + 1];
    }

    studentCount--;

    if (studentCount == 0) {
        free(students);
        students = NULL;
    } else {
        struct Student *temp = realloc(
            students, studentCount * sizeof(struct Student)
        );

        if (temp != NULL) {
            students = temp;
        }
    }

    printf("\nStudent deleted successfully.\n");
}

int main() {
    int choice;

    do {
        printf("\n========== STUDENT DATABASE ==========\n");
        printf("1. Add student\n");
        printf("2. Display all students\n");
        printf("3. Search by ID\n");
        printf("4. Delete a student\n");
        printf("0. Exit\n");

        printf("\nChoose an option: ");

        if (scanf("%d", &choice) != 1) {
            printf("Please enter a number.\n");
            while (getchar() != '\n');
            continue;
        }

        switch (choice) {
            case 1:
                addStudent();
                break;

            case 2:
                displayStudents();
                break;

            case 3:
                searchStudent();
                break;

            case 4:
                deleteStudent();
                break;

            case 0:
                printf("\nClosing the database...\n");
                break;

            default:
                printf("\nInvalid option. Try again.\n");
        }

    } while (choice != 0);

    free(students);

    return 0;
}
