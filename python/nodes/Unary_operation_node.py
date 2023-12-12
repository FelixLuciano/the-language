import math
import typing as T
from dataclasses import dataclass, field

from the_language import nodes
from ..SymbolTable import SymbolTable, Typed_value


@dataclass
class Unary_operation_node(nodes.Node):
    value: str = field()

    OPERATIONS: T.Dict[str, T.Callable[[T.Any], T.Any]] = field(init=False, repr=False)

    def evaluate(self, context: SymbolTable):
        x = self.children[0].evaluate(context)

        if x.type != Typed_value.types.INT:
            raise ValueError(f"Invalid unary operation {self.value.name} for type {x.type.name}")

        try:
            method = Unary_operation_node.OPERATIONS[self.value]
            
            return Typed_value(
                type=x.type,
                value=method(x.value),
            )
        except KeyError:
            raise ValueError(f"{self.value} is not an Valid operation!")


Unary_operation_node.OPERATIONS = {
    "+": lambda x: x,
    "-": lambda x: -x,
    "!": lambda x: 0 if x == 1 else 1,
    "!": lambda x: math.factorial(x),
}
