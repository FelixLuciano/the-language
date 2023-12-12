#include <stdlib.h>
#include <stdio.h>
#include "ast.h"

Node_t* createNode(char* type, char* value) {
    Node_t* node = (Node_t*)malloc(sizeof(Node_t));

    node->type = type;
    node->value = value;
    node->children = NULL;

    return node;
}

void destroyNode(Node_t* node) {
    destroyChildren(node->children);
    free(node);
}

NodeList_t* createChild(Node_t* node) {
    NodeList_t* children = (NodeList_t*)malloc(sizeof(NodeList_t));

    children->node = node;
    children->next = NULL;

    return children;
}

void destroyChildren(NodeList_t* parent) {
    if (parent == NULL) return;

    destroyChildren(parent->next);
    destroyChild(parent);
}

void destroyChild(NodeList_t* child) {
    destroyNode(child->node);
    free(child);
}

void mergeChildren(NodeList_t* parent, NodeList_t* children) {
    for (; parent->next != NULL; parent = parent->next);

    parent->next = children;
}

void pushChildren(Node_t* node, NodeList_t* children) {
    if (node->children == NULL) {
        node->children = children;

        return;
    }

    return mergeChildren(node->children, children);
}

void pushChild(Node_t* parent, Node_t* node) {
    NodeList_t* children = createChild(node);

    return pushChildren(parent, children);
}

void scriptIdent(int size, FILE* output) {
    for (; size > 0; size--) fprintf(output, "  ");
}

void buildScript(Node_t* node, int deep, FILE* output) {
    // scriptIdent(deep, output);
    fprintf(output, "%s(", node->type);

    if (node->value == NULL) fprintf(output, "None");
    else fprintf(output, "\"%s\"", node->value);

    // if (node->children != NULL) fprintf(output, ", [\n");
    if (node->children != NULL) fprintf(output, ",[");

    for (NodeList_t* children = node->children; children != NULL; children = children->next) {
        buildScript(children->node, deep+1, output);

        if (children->next != NULL) {
            // fprintf(output, ",\n");
            fprintf(output, ",");
        }
        else {
            // fprintf(output, "\n");
            // scriptIdent(deep, output);
        }
    }

    if (node->children != NULL) fprintf(output, "]");

    fprintf(output, ")");

    // if (deep == 0) fprintf(output, "\n");
}

Node_t* parseBlock(char* type, char* value, NodeList_t* children) {
    Node_t* node = createNode(type, value);
    
    node->children = children;

    return node;
}

Node_t* parseBinaryOperation(char* operator, Node_t* x, Node_t* y) {
    Node_t* node = createNode("Binary_operation", operator);

    pushChild(node, x);
    pushChild(node, y);

    return node;
}

Node_t* parseTernaryOperation(Node_t* condition, Node_t* a, Node_t* b) {
    Node_t* node = createNode("Ternary_operation", NULL);

    pushChild(node, condition);
    pushChild(node, a);
    pushChild(node, b);

    return node;
}

Node_t* parseDeclaration(char* type, char* name, Node_t* value) {
    Node_t* node = createNode("Declaration", type);

    pushChild(node, createNode("Identifier", name));

    if (value != NULL) {
        pushChild(node, value);
    }

    return node;
}

Node_t* parseStatement(NodeList_t* children) {
    Node_t* node = createNode("Statement", NULL);
    
    pushChildren(node, children);

    return node;
}

Node_t* parseAssignment(char* name, char* type, NodeList_t* value) {
    Node_t* node = createNode("Assignment", name);
    Node_t* statement = parseStatement(value);
    
    if (type != NULL) {
        Node_t* operation = parseBinaryOperation(type, createNode("Identifier", name), statement);

        pushChild(node, operation);
    }
    else {
        pushChild(node, statement);
    }

    return node;
}

Node_t* parseFunction(char* type, char* name, NodeList_t* args, Node_t* block) {
    Node_t* node = createNode("Function", NULL);

    pushChildren(node, args);
    pushChild(node, block);

    return parseDeclaration(type, name, node);
}
