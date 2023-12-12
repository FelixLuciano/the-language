from dataclasses import dataclass, field

from the_language import nodes
from ..SymbolTable import SymbolTable, Typed_value


@dataclass
class Function_node(nodes.Node):
    value: None = field()

    def evaluate(self, context: SymbolTable) -> Typed_value:
        return self.children[-1].evaluate(context)
    
    def before_evaluate(self, parent_context: SymbolTable, *params) -> SymbolTable:
        *args, block = self.children
        context = SymbolTable(parent=parent_context)

        if len(params) > len(args)+1:
            raise ValueError(f"Expected {len(args)} params, given {len(params)}.")

        for index, arg in enumerate(args):
            arg.evaluate(context)

            if index < len(params):
                context.set(arg.children[0].value, params[index])

        return context
