from dataclasses import dataclass, field

from the_language import nodes
from ..SymbolTable import SymbolTable, Typed_value


@dataclass
class No_operation_node(nodes.Node):
    value: None = field(default=None)

    def evaluate(self, context: SymbolTable):
        return Typed_value.NULL
