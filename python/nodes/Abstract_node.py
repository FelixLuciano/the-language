import typing as T
from dataclasses import dataclass, field
from abc import ABC, abstractmethod

from ..SymbolTable import SymbolTable, Typed_value


@dataclass
class Abstract_node(ABC):
    value: T.Any = field()
    children: T.List["Abstract_node"] = field(default_factory=list)

    @abstractmethod
    def evaluate(self, context: SymbolTable) -> Typed_value:
        pass
