
#include <iostream>
#include <vector>
#include <queue>
using namespace std;

const int MAX_NODES = 20;

vector<int> graph[MAX_NODES];
int nodeCount = 0;

void addConnection() {
    int from, to;

    cout << "\nEnter the first node (0 to " << nodeCount - 1 << "): ";
    if (!(cin >> from)) {
        cout << "Invalid input.\n";
        cin.clear();
        cin.ignore(10000, '\n');
        return;
    }

    cout << "Enter the second node: ";
    if (!(cin >> to)) {
        cout << "Invalid input.\n";
        cin.clear();
        cin.ignore(10000, '\n');
        return;
    }

    if (from < 0 || from >= nodeCount ||
        to < 0 || to >= nodeCount) {
        cout << "These nodes do not exist.\n";
        return;
    }

    graph[from].push_back(to);
    graph[to].push_back(from);

    cout << "Connection added!\n";
}

void displayGraph() {
    if (nodeCount == 0) {
        cout << "\nThere are no nodes yet.\n";
        return;
    }

    cout << "\n========== GRAPH ==========\n";

    for (int i = 0; i < nodeCount; i++) {
        cout << i << " -> ";

        for (int neighbor : graph[i]) {
            cout << neighbor << " ";
        }

        cout << endl;
    }
}

void breadthFirstSearch(int start) {
    if (start < 0 || start >= nodeCount) {
        cout << "Invalid starting node.\n";
        return;
    }

    bool visited[MAX_NODES] = {false};
    queue<int> waiting;

    visited[start] = true;
    waiting.push(start);

    cout << "\nBFS: ";

    while (!waiting.empty()) {
        int current = waiting.front();
        waiting.pop();

        cout << current << " ";

        for (int neighbor : graph[current]) {
            if (!visited[neighbor]) {
                visited[neighbor] = true;
                waiting.push(neighbor);
            }
        }
    }

    cout << endl;
}

void depthFirstSearch(int current, bool visited[]) {
    visited[current] = true;
    cout << current << " ";

    for (int neighbor : graph[current]) {
        if (!visited[neighbor]) {
            depthFirstSearch(neighbor, visited);
        }
    }
}

void startDFS() {
    int start;

    cout << "\nEnter the starting node: ";
    if (!(cin >> start)) {
        cout << "Invalid input.\n";
        cin.clear();
        cin.ignore(10000, '\n');
        return;
    }

    if (start < 0 || start >= nodeCount) {
        cout << "Invalid starting node.\n";
        return;
    }

    bool visited[MAX_NODES] = {false};

    cout << "\nDFS: ";
    depthFirstSearch(start, visited);
    cout << endl;
}

int main() {
    int choice;

    cout << "How many nodes should the graph have? ";
    if (!(cin >> nodeCount) || nodeCount < 1 ||
        nodeCount > MAX_NODES) {
        cout << "Choose between 1 and " << MAX_NODES << " nodes.\n";
        return 1;
    }

    do {
        cout << "\n========== GRAPH TOOLKIT ==========\n";
        cout << "1. Add a connection\n";
        cout << "2. Display graph\n";
        cout << "3. Breadth-First Search (BFS)\n";
        cout << "4. Depth-First Search (DFS)\n";
        cout << "0. Exit\n";

        cout << "\nChoose an option: ";

        if (!(cin >> choice)) {
            cout << "Please enter a number.\n";
            cin.clear();
            cin.ignore(10000, '\n');
            continue;
        }

        switch (choice) {
            case 1:
                addConnection();
                break;

            case 2:
                displayGraph();
                break;

            case 3: {
                int start;

                cout << "Enter the starting node: ";
                if (cin >> start) {
                    breadthFirstSearch(start);
                } else {
                    cout << "Invalid input.\n";
                    cin.clear();
                    cin.ignore(10000, '\n');
                }
                break;
            }

            case 4:
                startDFS();
                break;

            case 0:
                cout << "Closing graph toolkit...\n";
                break;

            default:
                cout << "Invalid option.\n";
        }

    } while (choice != 0);

    return 0;
}
