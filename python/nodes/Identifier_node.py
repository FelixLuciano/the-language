import typing as T
from dataclasses import dataclass, field

from the_language import nodes
from ..SymbolTable import SymbolTable


@dataclass
class Identifier_node(nodes.Node):
    value: str = field()

    def evaluate(self, context: SymbolTable):
        return context.get(self.value)
