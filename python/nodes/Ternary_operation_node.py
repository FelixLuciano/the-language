from dataclasses import dataclass, field

from the_language import nodes
from ..SymbolTable import SymbolTable, Typed_value


@dataclass
class Ternary_operation_node(nodes.Node):
    value: None = field(default=None)

    def evaluate(self, context: SymbolTable):
        value: Typed_value = self.children[0].evaluate(context)

        return self.children[1].evaluate(context) if Typed_value.is_true(value) else self.children[2].evaluate(context)
