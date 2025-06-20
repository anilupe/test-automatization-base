function fn() {
  var env = karate.env || 'local';

  // Configuración base para todos los entornos
  var config = {
    baseUrl: 'http://localhost:8080',
    port_marvel_characters_api: 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
  };

  // Configuración específica por entorno
  if (env == 'dev') {
    config.baseUrl = 'http://api-dev.empresa.com';
    config.port_marvel_characters_api = 'http://api-dev-marvel.herokuapp.com';
  } 
  else if (env == 'qa') {
    config.baseUrl = 'http://api-qa.empresa.com';
    config.port_marvel_characters_api = 'http://api-qa-marvel.herokuapp.com';
  }

  return config;
}
