from dataclasses import dataclass, field

from the_language import nodes
from ..SymbolTable import SymbolTable, Typed_value


@dataclass
class Assignment_node(nodes.Node):
    value: str = field()

    def evaluate(self, context: SymbolTable):
        if isinstance(self.children[0], nodes.Function):
            type_ = context.get(self.value).type
            value = Typed_value(type_, self.children[0])
        else:
            value = self.children[0].evaluate(context)

        context.set(self.value, value)

        return value
