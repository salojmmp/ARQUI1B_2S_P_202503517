# Calculadora de Números Enteros en Ensamblador ARM64

## Descripción

Programa de consola desarrollado completamente en lenguaje ensamblador ARM64 para realizar operaciones con números enteros.

## Operaciones

El programa implementa las siguientes operaciones:

1. Suma
2. Resta
3. Multiplicación
4. División entera
5. Potencia
6. Factorial
7. Salir

## Validaciones

El programa valida:

* Opciones inválidas del menú.
* División entre cero.
* Exponentes negativos.
* Factoriales negativos.

## Implementación

La calculadora utiliza:

* Registros ARM64.
* Instrucciones aritméticas.
* Comparaciones.
* Saltos condicionales.
* Ciclos iterativos.
* Subrutinas mediante `bl` y `ret`.
* Syscalls de Linux para entrada y salida.

La potencia se implementa mediante multiplicación repetida y el factorial mediante un ciclo iterativo.

## Compilación

En un sistema x86_64 con herramientas ARM64:

```bash
aarch64-linux-gnu-as -o calculadora.o calculadora.s
aarch64-linux-gnu-ld -o calculadora calculadora.o
```

## Ejecución con QEMU

```bash
qemu-aarch64 ./calculadora
```

## Depuración

Para la depuración se utilizó `gdb-multiarch` junto con QEMU y conexión remota mediante el puerto 1234.

## Archivos

* `calculadora.s`: código fuente ARM64.
* `calculadora.o`: archivo objeto.
* `calculadora`: ejecutable.
* `README.md`: documentación del proyecto.
