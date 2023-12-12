from dataclasses import dataclass, field

from the_language import nodes
from ..SymbolTable import SymbolTable, Typed_value


@dataclass
class Call_node(nodes.Node):
    value: str = field()

    def evaluate(self, context: SymbolTable):
        func = context.get(self.value)
        args = (child.evaluate(context) for child in self.children[:-1])

        if isinstance(func.value, nodes.Function):
            child_context = func.value.before_evaluate(context, *args)

            context.declare("block", Typed_value.types.AUTO)
            context.set("block", Typed_value(Typed_value.types.AUTO, nodes.Function(None, [self.children[-1]])))

            value =  func.value.evaluate(child_context)

            if value.type != func.type and value.type != Typed_value.types.NULL and func.type != Typed_value.types.AUTO:
                raise TypeError(f"Function of type {func.type.name} cannot return type {value.type.name}!")

            return value
        elif callable(func.value):
            return func.value(*args)

        raise ValueError(f"{self.value} is not a function!")
