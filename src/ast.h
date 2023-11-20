#ifndef AST_H_DEFINE
#define AST_H_DEFINE

typedef struct NodeList NodeList_t;

typedef struct Node {
    char* type;
    char* value;
    NodeList_t* children;
} Node_t;

typedef struct NodeList {
    Node_t* node;
    NodeList_t* next;
} NodeList_t;

Node_t* createNode(char* type, char* value);
void destroyNode(Node_t* node);
NodeList_t* createChild(Node_t* node);
void destroyChildren(NodeList_t* parent);
void destroyChild(NodeList_t* child);
void mergeChildren(NodeList_t* parent, NodeList_t* children);
void pushChildren(Node_t* node, NodeList_t* children);
void pushChild(Node_t* parent, Node_t* node);
void displayIdent(int size);
void display(Node_t* node, int deep);
Node_t* parseBlock(char* type, char* value, NodeList_t* children);
Node_t* parseBinaryOperation(char* operator, Node_t* x, Node_t* y);
Node_t* parseTernaryOperation(Node_t* condition, Node_t* a, Node_t* b);
Node_t* parseDeclaration(char* type, char* name, Node_t* value);
Node_t* parseStatement(NodeList_t* children);
Node_t* parseAssignment(char* name, char* type, NodeList_t* value);
Node_t* parseFunction(char* type, char* name, NodeList_t* args, Node_t* block);

#endif
