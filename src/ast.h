#ifndef AST_HPP_DEFINE
#define AST_HPP_DEFINE

#include <string>
#include <vector>

class Node {
    public:
    std::string type;
    std::string value;
    std::vector<Node> children;

    Node(std::string, std::string);
    Node* push(Node);
    void display(int = 0);

    private:
    void displayIdent(int size);
};

// typedef struct NodeList NodeList_t;

// typedef struct Node {
//     std::string type;
//     std::string value;
//     NodeList_t* children;
// } Node_t;

// typedef struct NodeList {
//     Node_t* node;
//     NodeList_t* next;
// } NodeList_t;

// Node_t* createNode(std::string type, std::string value);
// void destroyNode(Node_t* node);
// NodeList_t* createChild(Node_t* node);
// void destroyChildren(NodeList_t* parent);
// void destroyChild(NodeList_t* child);
// void mergeChildren(NodeList_t* parent, NodeList_t* children);
// void pushChildren(Node_t* node, NodeList_t* children);
// void pushChild(Node_t* parent, Node_t* node);
// void displayIdent(int size);
// void display(Node_t* node, int deep);
// Node_t* parseBlock(std::string type, std::string value, NodeList_t* children);
// Node_t* parseBinaryOperation(std::string type, Node_t* x, Node_t* y);
// Node_t* parseTernaryOperation(Node_t* condition, Node_t* a, Node_t* b);
// Node_t* parseDeclaration(std::string type, std::string name, Node_t* value);
// Node_t* parseStatement(NodeList_t* children);
// Node_t* parseAssignment(std::string name, std::string type, NodeList_t* value);
// Node_t* parseFunction(std::string type, std::string name, NodeList_t* args, Node_t* block);

#endif
