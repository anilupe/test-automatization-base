@REQ_HU-12345A @HU12345A @marvel_character_crud @marvel_characters_api @Agente2 @E2 @iniciativa_marvel
Feature: HU-12345A CRUD de personajes Marvel (microservicio para gestión de personajes)

  Background:
    * configure ssl = { trustAll: true }
    * url 'http://bp-se-test-cabcd9b246a5.herokuapp.com'
    * path '/testuser/api/characters'
    * def generarHeaders =
      """
      function() {
        return {
          "Content-Type": "application/json"
        };
      }
      """
    * def headers = generarHeaders()
    * headers headers

  @id:1 @obtenerPersonajes @solicitudExitosa200
  Scenario: T-API-HU-12345A-CA01-Obtener todos los personajes exitosamente 200 - karate
    When method GET
    Then status 200
    # And match response == []
    # And match response[0].id != null

  @id:2 @obtenerPersonajePorId @solicitudExitosa200
  Scenario: T-API-HU-12345A-CA02-Obtener personaje por ID exitosamente 200 - karate
    * path '16'
    When method GET
    Then status 200
    # And match response.id == 1
    # And match response.name == 'Iron Man'

  @id:3 @obtenerPersonajePorId @noEncontrado404
  Scenario: T-API-HU-12345A-CA03-Obtener personaje por ID no existente 404 - karate
    * path '999'
    When method GET
    Then status 404
    # And match response.error contains 'not found'
    # And match response.error != null

  @id:4 @crearPersonaje @creacionExitosa201
  Scenario: T-API-HU-12345A-CA04-Crear personaje exitosamente 201 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_crear_personaje_valido.json')
    And request jsonData
    When method POST
    Then status 201
    # And match response.id != null
    # And match response.name == jsonData.name

  @id:5 @crearPersonaje @errorNombreDuplicado400
  Scenario: T-API-HU-12345A-CA05-Crear personaje con nombre duplicado 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_crear_personaje_duplicado.json')
    And request jsonData
    When method POST
    Then status 400
    # And match response.error contains 'already exists'
    # And match response.error != null

  @id:6 @crearPersonaje @errorCamposRequeridos400
  Scenario: T-API-HU-12345A-CA06-Crear personaje con campos requeridos vacíos 400 - karate
    * def jsonData = read('classpath:data/marvel_characters_api/request_crear_personaje_campos_vacios.json')
    And request jsonData
    When method POST
    Then status 400
    # And match response.name contains 'required'
    # And match response.powers contains 'required'

  @id:7 @actualizarPersonaje @actualizacionExitosa200
  Scenario: T-API-HU-12345A-CA07-Actualizar personaje exitosamente 200 - karate
    * path '1'
    * def jsonData = read('classpath:data/marvel_characters_api/request_actualizar_personaje_valido.json')
    And request jsonData
    When method PUT
    Then status 200
    # And match response.description == jsonData.description
    # And match response.id == 1

  @id:8 @actualizarPersonaje @noEncontrado404
  Scenario: T-API-HU-12345A-CA08-Actualizar personaje no existente 404 - karate
    * path '999'
    * def jsonData = read('classpath:data/marvel_characters_api/request_actualizar_personaje_valido.json')
    And request jsonData
    When method PUT
    Then status 404
    # And match response.error contains 'not found'
    # And match response.error != null

  @id:9 @eliminarPersonaje @eliminacionExitosa204
  Scenario: T-API-HU-12345A-CA09-Eliminar personaje exitosamente 204 - karate
    * path '1'
    When method DELETE
    Then status 204
    # And match response == null
    # And match response == ''

  @id:10 @eliminarPersonaje @noEncontrado404
  Scenario: T-API-HU-12345A-CA10-Eliminar personaje no existente 404 - karate
    * path '999'
    When method DELETE
    Then status 404
    # And match response.error contains 'not found'
    # And match response.error != null
