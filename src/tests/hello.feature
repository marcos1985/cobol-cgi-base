Feature: Integração do Karate DSL
Scenario: Testa chamada passando query string
    Given url "http://localhost/cobweb/exemplo/chamada-query-string?id=10&nome=Marcos"
    When method get
    Then status 200
    And match response["http-status"] == 200
    And match response.data.id == 10


