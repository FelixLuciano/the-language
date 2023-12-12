from dataclasses import dataclass, field

from the_language import nodes
from ..SymbolTable import SymbolTable, Typed_value


@dataclass
class Reference_node(nodes.Node):
    value: None = field(default=None)

    def evaluate(self, context: SymbolTable) -> Typed_value:
        return self.children[0].evaluate(context)
