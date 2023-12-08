from cob_compiler import karateTestManager

test_manager = karateTestManager()

test_manager.add_karate_dsl_test(code="T0001", name="Testa rodar karate DSL", source="src/tests/hello.feature")

test_manager.run_karate_dsl_test()