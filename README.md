[Raul Ikeda Gomes da Silva](http://lattes.cnpq.br/5935139039430914). Lógica de Computação. [Insper](https://github.com/Insper), 2023.

# The Language Project

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
```

## License

This project is MIT licensed. [See more](LICENSE).
