Feature: Fresher core
  In order to write better software
  Developers should be able to execute requirements as tests

  Scenario: Run single scenario with missing step definition, allow undefined
    When I run nose --fresher-allow-undefined examples/self_test/features/sample.feature:1
    Then it should pass with
        """
        U
        ----------------------------------------------------------------------
        Ran 1 test in {time}

        OK (UNDEFINED=1)
        """

  Scenario: Run single scenario with missing step definition
    When I run nose examples/self_test/features/sample.feature:1
    Then it should fail with
        """
        U
        ======================================================================
        UNDEFINED: Sample: Missing
        ----------------------------------------------------------------------
        UndefinedStepImpl: "missing" # examples/self_test/features/sample.feature:7

        ----------------------------------------------------------------------
        Ran 1 test in {time}

        FAILED (UNDEFINED=1)
        """

  Scenario: Specify the 1-based index of a scenario
    When I run nose examples/self_test/features/sample.feature:2
    Then it should pass with
        """
        .
        ----------------------------------------------------------------------
        Ran 1 test in {time}

        OK
        """

  Scenario: Run all with verbose formatter
    When I run nose -v --fresher-allow-undefined examples/self_test/features/sample.feature
    Then it should fail with
        """
        Sample: Missing ... UNDEFINED: "missing" # examples{sep}self_test{sep}features{sep}sample.feature:7
        Sample: Passing ... ok
        Sample: Failing ... ERROR

        ======================================================================
        ERROR: Sample: Failing
        ----------------------------------------------------------------------
        Traceback (most recent call last):
          File "{cwd}{sep}examples{sep}self_test{sep}features{sep}steps.py", line 15, in failing
            flunker()
          File "{cwd}{sep}examples{sep}self_test{sep}features{sep}steps.py", line 7, in flunker
            raise Exception("FAIL")
        Exception: FAIL

        @one
        Feature: Sample
            @four
            Scenario: Failing
                given failing                            # examples{sep}self_test{sep}features{sep}sample.feature:19

        ----------------------------------------------------------------------
        Ran 3 tests in {time}

        FAILED (UNDEFINED=1, errors=1)
        """

  Scenario: Run scenario outline steps only
    When I run nose -v --fresher-allow-undefined examples/self_test/features/outline_sample.feature:2:3:4:5
    Then it should fail with
        """
        Outline Sample: Test state ... UNDEFINED: "missing without a table" # examples{sep}self_test{sep}features{sep}outline_sample.feature:6
        Outline Sample: Test state ... ok
        Outline Sample: Test state ... ERROR
        Outline Sample: Test state ... ok

        ======================================================================
        ERROR: Outline Sample: Test state
        ----------------------------------------------------------------------
        Traceback (most recent call last):
          File "{cwd}{sep}examples{sep}self_test{sep}features{sep}steps.py", line 27, in fail_without_table
            flunker()
          File "{cwd}{sep}examples{sep}self_test{sep}features{sep}steps.py", line 7, in flunker
            raise Exception("FAIL")
        Exception: FAIL

        Feature: Outline Sample
            Scenario: Test state
                given failing without a table            # examples/self_test/features/outline_sample.feature:6
                given passing without a table            # examples/self_test/features/outline_sample.feature:7

        ----------------------------------------------------------------------
        Ran 4 tests in {time}

        FAILED (UNDEFINED=1, errors=1)
        """

  Scenario: Find feature files in nested directories
    When I run nose -v --fresher-allow-undefined --fresher-tags nested examples/self_test/features
    Then it should pass with
        """
        A feature in a subdirectory: Passing ... ok
        A feature in a subdirectory (indirect import): Passing ... ok
        A feature in a subdirectory (undefined): Passing ... UNDEFINED: "passing without a table" # examples{sep}self_test{sep}features{sep}nested_two{sep}nested.feature:4

        ----------------------------------------------------------------------
        Ran 3 tests in {time}

        OK (UNDEFINED=1)
        """
  Scenario: Run non-ascii steps without issue
    When I run nose -v examples/self_test/features/non-ascii.feature
    Then it should fail with
        """
        Non-ascii: Non-ascii ... ok
        Non-ascii: Non-ascii failure ... ERROR

        ======================================================================
        ERROR: Non-ascii: Non-ascii failure
        ----------------------------------------------------------------------
        Traceback (most recent call last):
          File "{cwd}{sep}examples{sep}self_test{sep}features{sep}steps.py", line 89, in echoue
            flunker()
          File "{cwd}{sep}examples{sep}self_test{sep}features{sep}steps.py", line 7, in flunker
            raise Exception("FAIL")
        Exception: FAIL

        Feature: Non-ascii
            Scenario: Non-ascii failure
                then échoue                              # examples/self_test/features/non-ascii.feature:7

        ----------------------------------------------------------------------
        Ran 2 tests in {time}

        FAILED (errors=1)
        """
