/**
 * Punto 4 – FizzBuzz Extendido
 * Imprime los números del 1 al 100 con las siguientes reglas:
 *   - Múltiplo de 3 y 5 → "FizzBuzz"
 *   - Múltiplo de 3 → "Fizz"
 *   - Múltiplo de 5 → "Buzz"
 *   - Ninguna regla aplica → el número mismo
 * Solo se procesan números positivos (aunque el rango 1-100 ya lo garantiza).
 */

function fizzBuzz(limite = 100) {
  for (let i = 1; i <= limite; i++) {
    // Solo positivos — aunque el bucle arranca en 1, dejamos la guarda explícita
    if (i <= 0) continue;

    const esMult3 = i % 3 === 0;
    const esMult5 = i % 5 === 0;

    if (esMult3 && esMult5) {
      console.log("FizzBuzz");
    } else if (esMult3) {
      console.log("Fizz");
    } else if (esMult5) {
      console.log("Buzz");
    } else {
      console.log(i);
    }
  }
}

fizzBuzz();
