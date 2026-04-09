/**
 * Punto 1 – Palabra más larga
 */
/**
 * @param {string} cadena - La cadena de entrada
 * @returns {string} La palabra más larga encontrada
 */
function palabraMasLarga(cadena) {
  if (!cadena || cadena.trim() === "") return "";

  const palabras = cadena.trim().split(/\s+/);

  return palabras.reduce((masLarga, actual) => {
    return actual.length > masLarga.length ? actual : masLarga;
  }, "");
}

// --- Pruebas ---
console.log(palabraMasLarga("Hola mundo"));// "mundo"
console.log(palabraMasLarga("El cielo es rojo"));// "cielo"