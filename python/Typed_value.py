import typing as T
from enum import Enum, auto
from dataclasses import dataclass, field


@dataclass
class Typed_value:
    class types(Enum):
        NULL = auto()
        AUTO = auto()
        INT = auto()
        STRING = auto()

    type: types = field()
    value: T.Any = field()

    NULL: "Typed_value" = field(init=False, repr=False)
    TRANSFORM_MAP: T.Dict["types", T.Dict["types", T.Callable[["Typed_value"], T.Any]]] = field(init=False, repr=False)

    @staticmethod
    def is_true(value: "Typed_value"):
        if value.type == Typed_value.types.INT:
            return value.value == 1
        elif value.type == Typed_value.types.STRING:
            return len(value.value) > 0
    
        return False
    
    def transform(self, type_: "types"):
        try:
            method = Typed_value.TRANSFORM_MAP[self.type][type_]
        except KeyError:
            raise TypeError(f"Couldn't transform {self.type.name} into {type_.name}")

        return Typed_value(
            type=type_,
            value=method(self)
        )


Typed_value.NULL = Typed_value(Typed_value.types.NULL, None)

Typed_value.TRANSFORM_MAP = {
    Typed_value.types.NULL: {
        Typed_value.types.INT: lambda self: 0,
        Typed_value.types.STRING: lambda self: "",
    },
    Typed_value.types.INT: {
        Typed_value.types.STRING: lambda self: str(self.value),
    },
}
