
#include <iostream>
#include <queue>
#include <map>
#include <string>
using namespace std;

struct Node {
    char character;
    int frequency;
    Node* left;
    Node* right;

    Node(char letter, int count) {
        character = letter;
        frequency = count;
        left = nullptr;
        right = nullptr;
    }
};

struct CompareNodes {
    bool operator()(Node* a, Node* b) {
        return a->frequency > b->frequency;
    }
};

void buildCodes(Node* root, string code, map<char, string>& codes) {
    if (root == nullptr) {
        return;
    }

    if (root->left == nullptr && root->right == nullptr) {
        codes[root->character] = code.empty() ? "0" : code;
        return;
    }

    buildCodes(root->left, code + "0", codes);
    buildCodes(root->right, code + "1", codes);
}

Node* buildTree(const string& message) {
    map<char, int> frequencies;

    for (char letter : message) {
        frequencies[letter]++;
    }

    priority_queue<Node*, vector<Node*>, CompareNodes> nodes;

    for (auto item : frequencies) {
        nodes.push(new Node(item.first, item.second));
    }

    while (nodes.size() > 1) {
        Node* left = nodes.top();
        nodes.pop();

        Node* right = nodes.top();
        nodes.pop();

        Node* parent = new Node('\0',
                                left->frequency + right->frequency);

        parent->left = left;
        parent->right = right;

        nodes.push(parent);
    }

    return nodes.empty() ? nullptr : nodes.top();
}

string encodeMessage(const string& message, map<char, string>& codes) {
    string encoded;

    for (char letter : message) {
        encoded += codes[letter];
    }

    return encoded;
}

string decodeMessage(const string& encoded, Node* root) {
    if (root == nullptr) {
        return "";
    }

    // A one-character message only needs one repeated code.
    if (root->left == nullptr && root->right == nullptr) {
        return string(encoded.size(), root->character);
    }

    string decoded;
    Node* current = root;

    for (char bit : encoded) {
        if (bit == '0') {
            current = current->left;
        }
        else if (bit == '1') {
            current = current->right;
        }
        else {
            return "";
        }

        if (current == nullptr) {
            return "";
        }

        if (current->left == nullptr && current->right == nullptr) {
            decoded += current->character;
            current = root;
        }
    }

    if (current != root) {
        return "";
    }

    return decoded;
}

void freeTree(Node* root) {
    if (root == nullptr) {
        return;
    }

    freeTree(root->left);
    freeTree(root->right);
    delete root;
}

int main() {
    string message;

    cout << "========== HUFFMAN COMPRESSION ==========\n";
    cout << "Enter a message to encode: ";
    getline(cin, message);

    if (message.empty()) {
        cout << "You entered an empty message.\n";
        return 0;
    }

    Node* root = buildTree(message);

    map<char, string> codes;
    buildCodes(root, "", codes);

    cout << "\nCharacter codes:\n";

    for (auto item : codes) {
        if (item.first == ' ') {
            cout << "[space]";
        }
        else {
            cout << item.first;
        }

        cout << " : " << item.second << endl;
    }

    string encoded = encodeMessage(message, codes);

    cout << "\nOriginal message:\n";
    cout << message << endl;

    cout << "\nEncoded message:\n";
    cout << encoded << endl;

    string decoded = decodeMessage(encoded, root);

    cout << "\nDecoded message:\n";
    cout << decoded << endl;

    cout << "\nOriginal size: " << message.size() * 8
         << " bits (assuming 8-bit characters)\n";

    cout << "Encoded size: " << encoded.size() << " bits\n";

    freeTree(root);

    return 0;
}
