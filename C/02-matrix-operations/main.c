
#include <stdio.h>

#define MAX 10

void readMatrix(int matrix[MAX][MAX], int rows, int cols, char name) {
    printf("\nEnter the values for matrix %c:\n", name);

    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("Element [%d][%d]: ", i + 1, j + 1);
            scanf("%d", &matrix[i][j]);
        }
    }
}

void displayMatrix(int matrix[MAX][MAX], int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            printf("%5d", matrix[i][j]);
        }
        printf("\n");
    }
}

void addMatrices(int a[MAX][MAX], int b[MAX][MAX],
                 int result[MAX][MAX], int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            result[i][j] = a[i][j] + b[i][j];
        }
    }
}

void subtractMatrices(int a[MAX][MAX], int b[MAX][MAX],
                      int result[MAX][MAX], int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            result[i][j] = a[i][j] - b[i][j];
        }
    }
}

void multiplyMatrices(int a[MAX][MAX], int b[MAX][MAX],
                      int result[MAX][MAX],
                      int rowsA, int colsA, int colsB) {
    for (int i = 0; i < rowsA; i++) {
        for (int j = 0; j < colsB; j++) {
            result[i][j] = 0;

            for (int k = 0; k < colsA; k++) {
                result[i][j] += a[i][k] * b[k][j];
            }
        }
    }
}

void transposeMatrix(int matrix[MAX][MAX],
                     int result[MAX][MAX], int rows, int cols) {
    for (int i = 0; i < rows; i++) {
        for (int j = 0; j < cols; j++) {
            result[j][i] = matrix[i][j];
        }
    }
}

int main() {
    int first[MAX][MAX], second[MAX][MAX], result[MAX][MAX];
    int rowsA, colsA, rowsB, colsB;
    int choice;

    do {
        printf("\n========== MATRIX TOOLKIT ==========\n");
        printf("1. Add two matrices\n");
        printf("2. Subtract two matrices\n");
        printf("3. Multiply two matrices\n");
        printf("4. Transpose a matrix\n");
        printf("0. Exit\n");

        printf("\nChoose an operation: ");

        if (scanf("%d", &choice) != 1) {
            printf("Please enter a valid number.\n");

            int ch;
            while ((ch = getchar()) != '\n' && ch != EOF) {
            }

            choice = -1;
            continue;
        }

        if (choice == 0) {
            printf("\nClosing the matrix toolkit.\n");
            break;
        }

        if (choice < 1 || choice > 4) {
            printf("\nInvalid option. Try again.\n");
            continue;
        }

        if (choice == 4) {
            printf("\nEnter matrix dimensions (rows columns): ");
            scanf("%d %d", &rowsA, &colsA);

            if (rowsA < 1 || rowsA > MAX ||
                colsA < 1 || colsA > MAX) {
                printf("Dimensions must be between 1 and %d.\n", MAX);
                continue;
            }

            readMatrix(first, rowsA, colsA, 'A');

            transposeMatrix(first, result, rowsA, colsA);

            printf("\nOriginal matrix:\n");
            displayMatrix(first, rowsA, colsA);

            printf("\nTranspose:\n");
            displayMatrix(result, colsA, rowsA);
        }
        else {
            printf("\nDimensions of matrix A (rows columns): ");
            scanf("%d %d", &rowsA, &colsA);

            printf("Dimensions of matrix B (rows columns): ");
            scanf("%d %d", &rowsB, &colsB);

            if (rowsA < 1 || rowsA > MAX ||
                colsA < 1 || colsA > MAX ||
                rowsB < 1 || rowsB > MAX ||
                colsB < 1 || colsB > MAX) {
                printf("Dimensions must be between 1 and %d.\n", MAX);
                continue;
            }

            if ((choice == 1 || choice == 2) &&
                (rowsA != rowsB || colsA != colsB)) {
                printf("\nAddition and subtraction require matrices "
                       "with the same dimensions.\n");
                continue;
            }

            if (choice == 3 && colsA != rowsB) {
                printf("\nThe columns of A must equal the rows of B.\n");
                continue;
            }

            readMatrix(first, rowsA, colsA, 'A');
            readMatrix(second, rowsB, colsB, 'B');

            if (choice == 1) {
                addMatrices(first, second, result, rowsA, colsA);
                printf("\nA + B:\n");
                displayMatrix(result, rowsA, colsA);
            }
            else if (choice == 2) {
                subtractMatrices(first, second, result, rowsA, colsA);
                printf("\nA - B:\n");
                displayMatrix(result, rowsA, colsA);
            }
            else {
                multiplyMatrices(first, second, result,
                                 rowsA, colsA, colsB);
                printf("\nA x B:\n");
                displayMatrix(result, rowsA, colsB);
            }
        }

    } while (choice != 0);

    return 0;
}
