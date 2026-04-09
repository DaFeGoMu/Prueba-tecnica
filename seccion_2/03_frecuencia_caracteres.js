/**
 * Punto 3 – Frecuencia de caracteres
 * Cuenta cuántas veces aparece cada letra en una cadena.
 */

/**
 * @param {string} cadena
 * @returns {Object} 
 */
function frecuenciaCaracteres(cadena) {
  if (!cadena) return {};

  const frecuencia = {};

  for (const char of cadena.toLowerCase()) {
    // Solo letras (a-z, incluidas letras con tilde mediante rango Unicode)
    if (/[a-záéíóúüñ]/.test(char)) {
      frecuencia[char] = (frecuencia[char] || 0) + 1;
    }
  }

  // Ordenar por frecuencia descendente
  return Object.fromEntries(
    Object.entries(frecuencia).sort(([, a], [, b]) => b - a)
  );
}

// --- Pruebas ---
const resultado = frecuenciaCaracteres("Hola Mundo");
console.log(resultado);
// { o: 2, h: 1, l: 1, a: 1, m: 1, u: 1, n: 1, d: 1 }

const resultado2 = frecuenciaCaracteres("Programación");
console.log(resultado2);
// { r: 2, o: 2, a: 2, p: 1, g: 1, m: 1, c: 1, i: 1, n: 1 }

console.log(frecuenciaCaracteres(""));  // {}
