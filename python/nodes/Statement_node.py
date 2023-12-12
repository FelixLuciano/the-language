from dataclasses import dataclass, field

from the_language import nodes
from ..SymbolTable import SymbolTable, Typed_value


@dataclass
class Statement_node(nodes.Node):
    value: None = field(default=None)

    def evaluate(self, context: SymbolTable) -> Typed_value:
        for child in self.children:
            value = child.evaluate(context)

            if value.type != Typed_value.types.NULL:
                return value

        return Typed_value.NULL
