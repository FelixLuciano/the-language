from dataclasses import dataclass, field

from the_language import nodes
from ..SymbolTable import SymbolTable, Typed_value


@dataclass
class Block_node(nodes.Node):
    value: None = field(default=None)

    def evaluate(self, parent_context: SymbolTable):
        context = SymbolTable(parent=parent_context)

        for child in self.children:
            value = child.evaluate(context)

            if isinstance(child, nodes.Return):
                return value

        return Typed_value.NULL
