[Raul Ikeda Gomes da Silva](http://lattes.cnpq.br/5935139039430914). Lógica de Computação. [Insper](https://github.com/Insper), 2023.

<p align="center">
    <img src="assets/image/logo.svg" alt="logo" height="128" />
</p>
<h1 align="center">
    The Language
</h1>

```c
int a = NULL
int b = 2
int c = a b
// Expression fallback -> c = 2

int d = {
    return 10
}

int if(int condition = false) {
    return condition ? block : NULL
}

int else() {
    return block
}

{
    int e = if(true) {
        return 1
    } else() {
        return 0
    }

    // stdout "1"
    Println(e)
}
// stderr: "ERROR: 3 was not defined"
Println(e)

int while(ref int condition) {
    int value = block
    return condition ? while(condition) : value
}

int for(int declare; ref int condition; ref int step) {
    return while(condition) {
        step
        return block
    }
}

for(int i = 0; i < 5; i = i + 1) {
    Println(i);
}
```

## Dependencies

- [CMake](https://cmake.org/download/)
- [Flex](https://github.com/westes/flex)
- [Bison](https://www.gnu.org/software/bison/)

## Getting Started

```sh
$ mkdir build
$ cd build
$ cmake..
$ make
```

## Execute

```sh
$ ./build/the-language ./example/calculator.txt
```

## License

This project is MIT licensed. [See more](LICENSE).
