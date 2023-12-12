import typing as T
from dataclasses import dataclass, field

from the_language import nodes
from ..SymbolTable import SymbolTable, Typed_value


@dataclass
class Declaration_node(nodes.Node):
    value: str = field()

    def evaluate(self, context: SymbolTable):
        type_str = self.value

        if type_str == "int":
            type_ = Typed_value.types.INT
        elif type_str == "string":
            type_ = Typed_value.types.STRING
        else:
            raise TypeError(f"{type_str} is not an valid type!")

        context.declare(self.children[0].value, type_)

        if len(self.children) == 2:
            if isinstance(self.children[1], nodes.Function):
                value = Typed_value(type_, self.children[1])
            else:
                value = self.children[1].evaluate(context)

            context.set(self.children[0].value, value)

            return value

        return Typed_value.NULL
