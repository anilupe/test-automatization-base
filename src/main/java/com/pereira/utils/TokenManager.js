/**
 * Utilidad para gestionar tokens de autenticación.
 * 
 * Este archivo contiene funciones para validar, renovar y gestionar tokens de autenticación.
 * @author Pichincha QA
 * @version 1.0
 */

/**
 * Verifica si un token está próximo a expirar.
 * Decodifica el token JWT para obtener el tiempo de expiración y lo compara con el tiempo actual.
 * 
 * @param {string} token - El token JWT a verificar
 * @param {number} bufferSeconds - Segundos de buffer antes de la expiración para considerar que el token está por expirar
 * @returns {boolean} - true si el token está por expirar, false en caso contrario
 */
function isTokenExpiring(token, bufferSeconds) {
  try {
    // Extrae la parte payload del token JWT (segunda parte)
    var parts = token.split('.');
    if (parts.length !== 3) return true; // Si no es un JWT válido, asumimos que está expirado
    
    // Decodifica el payload
    var payload = JSON.parse(java.lang.String(java.util.Base64.getDecoder().decode(parts[1])));
    var expiryTime = payload.exp * 1000; // exp está en segundos, lo convertimos a milisegundos
    var currentTime = new Date().getTime();
    var bufferMillis = bufferSeconds * 1000;
    
    // Si el tiempo actual + buffer es mayor que el tiempo de expiración, el token está por expirar
    return (currentTime + bufferMillis) > expiryTime;
  } catch (e) {
    // Si hay algún error al procesar el token, asumimos que está expirado
    karate.log('Error al verificar expiración del token:', e);
    return true;
  }
}

/**
 * Verifica si es necesario renovar un token según la configuración.
 * 
 * @param {string} token - El token JWT a verificar
 * @param {object} config - Configuración para la verificación del token
 * @returns {boolean} - true si se debe renovar el token, false en caso contrario
 */
function shouldRenewToken(token, config) {
  if (!config || !config.tokenExpiryCheckConfig || !config.tokenExpiryCheckConfig.checkTokenExpiry) {
    return false;
  }
  
  var bufferSeconds = config.tokenExpiryCheckConfig.tokenExpiryBuffer || 300;
  var shouldRenew = config.tokenExpiryCheckConfig.renewTokenOnExpiry !== false;
  
  return shouldRenew && isTokenExpiring(token, bufferSeconds);
}

/**
 * Añade o actualiza el token en los headers.
 * 
 * @param {object} headers - Los headers actuales
 * @param {string} token - El nuevo token
 * @returns {object} - Los headers actualizados con el nuevo token
 */
function updateAuthHeader(headers, token) {
  headers['Authorization'] = 'Bearer ' + token;
  return headers;
}
