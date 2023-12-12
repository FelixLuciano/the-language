from dataclasses import dataclass, field

from the_language import nodes
from ..SymbolTable import SymbolTable, Typed_value


@dataclass
class Integer_node(nodes.Node):
    value: str = field()

    def evaluate(self, context: SymbolTable):
        return Typed_value(
            type=Typed_value.types.INT,
            value=int(self.value)
        )
