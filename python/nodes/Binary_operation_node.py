import typing as T
from dataclasses import dataclass, field

from the_language import nodes
from ..SymbolTable import SymbolTable, Typed_value


@dataclass
class Binary_operation_node(nodes.Node):
    value: str = field()

    OPERATIONS: T.Dict[str, T.Callable[[T.Any, T.Any], T.Any]] = field(init=False, repr=False)

    def evaluate(self, context: SymbolTable):
        a, b = self.children
        x, y = a.evaluate(context), b.evaluate(context)

        try:
            method = Binary_operation_node.OPERATIONS[self.value]

            if x.type != y.type:
                if self.value != ".":
                    raise TypeError(f"Invalid operation {self.value.name} between {x.type.name} and {y.type.name}")

            return Typed_value(
                type=x.type,
                value=method(x.value, y.value),
            )
        except KeyError:
            raise ValueError(f"{self.value} is not an Valid operation!")


Binary_operation_node.OPERATIONS = {
    "+": lambda x, y: x + y,
    "-": lambda x, y: x - y,
    "*": lambda x, y: x * y,
    "/": lambda x, y: x // y,
    "%": lambda x, y: x % y,
    "^": lambda x, y: x ** y,
    ".": lambda x, y: "".join(map(str, [x, y])),
    "&&": lambda x, y: 1 if x and y else 0,
    "||": lambda x, y: 1 if x or y else 0,
    "==": lambda x, y: 1 if x == y else 0,
    "!=": lambda x, y: 1 if x != y else 0,
    ">": lambda x, y: 1 if x > y else 0,
    "<": lambda x, y: 1 if x < y else 0,
    ">=": lambda x, y: 1 if x >= y else 0,
    "<=": lambda x, y: 1 if x <= y else 0,
}
