
board = [
    [5, 3, 0, 0, 7, 0, 0, 0, 0],
    [6, 0, 0, 1, 9, 5, 0, 0, 0],
    [0, 9, 8, 0, 0, 0, 0, 6, 0],
    [8, 0, 0, 0, 6, 0, 0, 0, 3],
    [4, 0, 0, 8, 0, 3, 0, 0, 1],
    [7, 0, 0, 0, 2, 0, 0, 0, 6],
    [0, 6, 0, 0, 0, 0, 2, 8, 0],
    [0, 0, 0, 4, 1, 9, 0, 0, 5],
    [0, 0, 0, 0, 8, 0, 0, 7, 9]
]


def show_board():
    for row in board:
        print(" ".join(str(number) if number != 0 else "." for number in row))


def can_place(row, col, number):
    for i in range(9):
        if board[row][i] == number:
            return False

        if board[i][col] == number:
            return False

    start_row = (row // 3) * 3
    start_col = (col // 3) * 3

    for r in range(start_row, start_row + 3):
        for c in range(start_col, start_col + 3):
            if board[r][c] == number:
                return False

    return True


def solve():
    for row in range(9):
        for col in range(9):
            if board[row][col] == 0:
                for number in range(1, 10):
                    if can_place(row, col, number):
                        board[row][col] = number

                        if solve():
                            return True

                        board[row][col] = 0

                return False

    return True


print("Sudoku before solving:")
show_board()

if solve():
    print("\nSolved Sudoku:")
    show_board()
else:
    print("\nNo solution found.")
