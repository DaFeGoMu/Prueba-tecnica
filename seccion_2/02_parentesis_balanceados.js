/**
 * Punto 2 – Paréntesis balanceados
 * Retorna true si los paréntesis en la cadena están correctamente balanceados.
 */

/**
 * @param {string} cadena
 * @returns {boolean}
 */
function parentesisBalanceados(cadena) {
  const pila = [];

  // Mapa de cierre → apertura correspondiente
  const pares = {
    ')': '(',
    ']': '[',
    '}': '{'
  };

  for (const char of cadena) {
    if ('([{'.includes(char)) {
      // Es apertura: la apilamos
      pila.push(char);
    } else if (')]}'.includes(char)) {
      // Es cierre: verificamos que coincida con el último abierto
      if (pila.length === 0 || pila[pila.length - 1] !== pares[char]) {
        return false;
      }
      pila.pop();
    }
    // Cualquier otro carácter se ignora
  }

  // Si la pila quedó vacía, todos los abiertos fueron cerrados
  return pila.length === 0;
}

// --- Pruebas ---
console.log(parentesisBalanceados("(hola)"));          // true
console.log(parentesisBalanceados("({[]})"));          // true
console.log(parentesisBalanceados("([]"));             // false — falta cierre
console.log(parentesisBalanceados(")("));              // false — cierre antes de apertura
console.log(parentesisBalanceados("([)]"));            // false — orden incorrecto
console.log(parentesisBalanceados(""));                // true  — cadena vacía es válida
console.log(parentesisBalanceados("sin agrupadores")); // true
