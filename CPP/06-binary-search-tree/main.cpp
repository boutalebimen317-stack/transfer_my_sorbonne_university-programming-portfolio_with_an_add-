
#include <iostream>
using namespace std;

struct Node {
    int value;
    Node* left;
    Node* right;

    Node(int number) {
        value = number;
        left = nullptr;
        right = nullptr;
    }
};

Node* insert(Node* root, int number) {
    if (root == nullptr) {
        return new Node(number);
    }

    if (number < root->value) {
        root->left = insert(root->left, number);
    }
    else if (number > root->value) {
        root->right = insert(root->right, number);
    }
    else {
        cout << "This value is already in the tree.\n";
    }

    return root;
}

bool search(Node* root, int number) {
    if (root == nullptr) {
        return false;
    }

    if (root->value == number) {
        return true;
    }

    if (number < root->value) {
        return search(root->left, number);
    }

    return search(root->right, number);
}

Node* findSmallest(Node* root) {
    while (root != nullptr && root->left != nullptr) {
        root = root->left;
    }

    return root;
}

Node* deleteNode(Node* root, int number) {
    if (root == nullptr) {
        return nullptr;
    }

    if (number < root->value) {
        root->left = deleteNode(root->left, number);
    }
    else if (number > root->value) {
        root->right = deleteNode(root->right, number);
    }
    else {
        if (root->left == nullptr) {
            Node* temp = root->right;
            delete root;
            return temp;
        }

        if (root->right == nullptr) {
            Node* temp = root->left;
            delete root;
            return temp;
        }

        // Replace this node with the smallest value in its right subtree.
        Node* temp = findSmallest(root->right);
        root->value = temp->value;
        root->right = deleteNode(root->right, temp->value);
    }

    return root;
}

void showInOrder(Node* root) {
    if (root == nullptr) {
        return;
    }

    showInOrder(root->left);
    cout << root->value << " ";
    showInOrder(root->right);
}

void showPreOrder(Node* root) {
    if (root == nullptr) {
        return;
    }

    cout << root->value << " ";
    showPreOrder(root->left);
    showPreOrder(root->right);
}

void showPostOrder(Node* root) {
    if (root == nullptr) {
        return;
    }

    showPostOrder(root->left);
    showPostOrder(root->right);
    cout << root->value << " ";
}

void clearTree(Node* root) {
    if (root == nullptr) {
        return;
    }

    clearTree(root->left);
    clearTree(root->right);
    delete root;
}

int main() {
    Node* root = nullptr;
    int choice;
    int number;

    do {
        cout << "\n========== BINARY SEARCH TREE ==========\n";
        cout << "1. Insert a value\n";
        cout << "2. Search for a value\n";
        cout << "3. Delete a value\n";
        cout << "4. In-order traversal\n";
        cout << "5. Pre-order traversal\n";
        cout << "6. Post-order traversal\n";
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
                cout << "Enter a value: ";
                if (cin >> number) {
                    root = insert(root, number);
                } else {
                    cout << "Invalid value.\n";
                    cin.clear();
                    cin.ignore(10000, '\n');
                }
                break;

            case 2:
                cout << "Enter the value to search: ";
                if (cin >> number) {
                    if (search(root, number)) {
                        cout << "Value found!\n";
                    } else {
                        cout << "Value not found.\n";
                    }
                } else {
                    cout << "Invalid value.\n";
                    cin.clear();
                    cin.ignore(10000, '\n');
                }
                break;

            case 3:
                cout << "Enter the value to delete: ";
                if (cin >> number) {
                    if (!search(root, number)) {
                        cout << "Value not found.\n";
                    } else {
                        root = deleteNode(root, number);
                        cout << "Value deleted.\n";
                    }
                } else {
                    cout << "Invalid value.\n";
                    cin.clear();
                    cin.ignore(10000, '\n');
                }
                break;

            case 4:
                cout << "In-order: ";
                showInOrder(root);
                cout << endl;
                break;

            case 5:
                cout << "Pre-order: ";
                showPreOrder(root);
                cout << endl;
                break;

            case 6:
                cout << "Post-order: ";
                showPostOrder(root);
                cout << endl;
                break;

            case 0:
                cout << "Closing the tree toolkit...\n";
                break;

            default:
                cout << "Invalid option.\n";
        }

    } while (choice != 0);

    clearTree(root);

    return 0;
}
