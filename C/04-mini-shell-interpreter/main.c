
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

#define INPUT_SIZE 200

void removeSpaces(char command[]) {
    int start = 0;

    while (isspace((unsigned char)command[start])) {
        start++;
    }

    if (start > 0) {
        memmove(command, command + start, strlen(command + start) + 1);
    }

    int length = strlen(command);

    while (length > 0 && isspace((unsigned char)command[length - 1])) {
        command[length - 1] = '\0';
        length--;
    }
}

void showHelp() {
    printf("\nAvailable commands:\n");
    printf("help       - Show this list\n");
    printf("clear      - Clear the screen\n");
    printf("date       - Display the current date and time\n");
    printf("dir        - List files in the current folder\n");
    printf("cd         - Show the current folder\n");
    printf("exit       - Close the program\n");
    printf("Other commands are passed to Windows.\n");
}

int main() {
    char command[INPUT_SIZE];
    int running = 1;

    printf("Welcome to MY Mini Shell!\n");
    printf("Type 'help' to see the available commands.\n");

    while (running) {
        printf("\nmini-shell> ");

        if (fgets(command, sizeof(command), stdin) == NULL) {
            break;
        }

        command[strcspn(command, "\n")] = '\0';
        removeSpaces(command);

        if (strlen(command) == 0) {
            continue;
        }

        if (strcmp(command, "exit") == 0) {
            printf("Closing Mini Shell...\n");
            running = 0;
        }
        else if (strcmp(command, "help") == 0) {
            showHelp();
        }
        else if (strcmp(command, "clear") == 0) {
            system("cls");
        }
        else if (strcmp(command, "date") == 0) {
            system("date /t");
            system("time /t");
        }
        else if (strcmp(command, "dir") == 0) {
            system("dir");
        }
        else if (strcmp(command, "cd") == 0) {
            system("cd");
        }
        else {
            int result = system(command);

            if (result != 0) {
                printf("The command may not exist or could not be executed.\n");
            }
        }
    }

    return 0;
}
