#ifndef INTEGER_NODE_H
#define INTEGER_NODE_H

#include <string>
#include <vector>
// #include <llvm/IR/Value.h>

namespace ast {
    template <typename T>
    class Node {
        public:
        T value;
        std::vector<Node> children;
        virtual ~Node() { };
        // virtual llvm::Value *codeGen(CodeGenContext &context) = 0
    };

    class Integer : public Node<long> {
        public:
        long value;
        Integer(long value);
        // virtual llvm::Value* codeGen(CodeGenContext& context);
    };

    class String : public Node<std::string> {
    public:
        std::string value;
        String(std::string value);
        // virtual llvm::Value* codeGen(CodeGenContext& context);
    };

    enum BinOpOperation {
            PLUS,
            MINUS,
            MULT,
            IDIV,
            AND,
            OR,
            NOT,
            EQUAL,
            NOT_EQUAL,
            GREATHER,
            GREATHER_EQUAL,
            LOWER,
            LOWER_EQUAL
        };

    class BinOp : public Node<BinOpOperation> {
        public:
        BinOpOperation value;
        BinOp(BinOpOperation value, Node& x, Node& y);
        // virtual llvm::Value* codeGen(CodeGenContext& context);
    };
}

#endif
