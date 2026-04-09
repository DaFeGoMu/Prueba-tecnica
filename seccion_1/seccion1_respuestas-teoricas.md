# Sección 1 – Conocimientos Técnicos

---

## 1. ¿Cuál es la diferencia entre `==` y `===` en PHP?

- `==` es el operador de igualdad débil: compara los valores después de hacer una conversión de tipos automática. Por ejemplo, `0 == "0"` devuelve `true` porque PHP convierte la cadena `"0"` al entero `0` antes de comparar.

- `===` es el operador de igualdad estricta: compara tanto el valor como el tipo de dato. No realiza ninguna conversión. Por ejemplo, `0 === "0"` devuelve `false` porque uno es `int` y el otro es `string`.

```php
var_dump(0 == "0");   // bool(true)  — mismo valor tras conversión
var_dump(0 === "0");  // bool(false) — distinto tipo
var_dump(1 == true);  // bool(true)
var_dump(1 === true); // bool(false) — int vs bool
```
---

## 2. ¿Qué valor retorna `NaN == NaN` en JavaScript y por qué?

Retorna `false`.

`NaN` (Not a Number) es el único valor en JavaScript que no es igual a sí mismo. Esto es parte del estándar IEEE 754 para aritmética de punto flotante, que establece que cualquier comparación que involucre `NaN` debe ser falsa, incluida la comparación consigo mismo.

```js
console.log(NaN == NaN);   // false
console.log(NaN === NaN);  // false
console.log(NaN != NaN);   // true  ← forma clásica de detectar NaN
```

Para verificar si un valor es `NaN` se deben usar:
- `Number.isNaN(valor)` → forma moderna y precisa.
- `isNaN(valor)` → función global (convierte el valor a número primero, puede dar falsos positivos).

---

## 3. ¿Qué hace `.on('click', ...)` comparado con `.click()` en jQuery?

Ambos sirven para manejar el evento `click`, pero difieren en flexibilidad y comportamiento con elementos dinámicos:

- `.click(handler)` es un atajo: solo funciona para elementos que ya existen en el DOM en el momento de la ejecución. No soporta delegación de eventos.

- `.on('click', handler)` es el método genérico: equivalente a `.click()` para elementos existentes, pero además permite delegación de eventos pasando un selector intermedio, lo que lo hace funcionar también para elementos añadidos dinámicamente al DOM.

```js
// Solo para elementos ya existentes
$('#btn').click(function() { ... });

// Equivalente con .on()
$('#btn').on('click', function() { ... });

// Con delegación: captura clics en .btn-dinamico aunque se creen después
$('#contenedor').on('click', '.btn-dinamico', function() { ... });
```
---

## 4. ¿Qué diferencia hay entre `INNER JOIN` y `LEFT JOIN` en SQL?

- `INNER JOIN`: devuelve solo las filas que tienen coincidencia en ambas tablas. Si un registro no tiene par en la otra tabla, se excluye del resultado.

- `LEFT JOIN`: devuelve todas las filas de la tabla izquierda, y para las que no tienen coincidencia en la tabla derecha, rellena esas columnas con `NULL`.

---

## 5. ¿Qué es una condición falsy? Da tres ejemplos en PHP y JavaScript.

Un valor falsy es aquel que, al evaluarse en un contexto booleano (ej. un `if`), se comporta como `false` aunque no sea literalmente `false`.

### PHP:

```php
$a = 0;       // entero cero → falsy
$b = "";      // cadena vacía → falsy
$c = null;    // null → falsy
// También son falsy: 0.0, "0", [], false
```

### JavaScript:

```js
let a = 0;         // número cero → falsy
let b = "";        // cadena vacía → falsy
let c = undefined; // variable no asignada → falsy
// También son falsy: null, NaN, false, -0, 0n
```