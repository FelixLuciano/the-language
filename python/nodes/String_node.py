from dataclasses import dataclass, field

from the_language import nodes
from ..SymbolTable import SymbolTable, Typed_value


@dataclass
class String_node(nodes.Node):
    value: str = field()

    def evaluate(self, context: SymbolTable) -> Typed_value:
        return Typed_value(
            type=Typed_value.types.STRING,
            value=self.value
        )
