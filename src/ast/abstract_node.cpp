#include <string>
#include "abstract_node.h"

ast::Integer::Integer(long value) {
    this->value = value;
}

ast::String::String(std::string value) {
    this->value = value;
}

ast::BinOp::BinOp(ast::BinOpOperation value, Node& x, Node& y) {
    this->value = value;

    children.push_back(x);
    children.push_back(y);
}
