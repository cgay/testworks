Module:       dylan-user
Synopsis:     TestWorks - a test harness library for dylan
Author:       Andrew Armstrong, James Kirsch
Copyright:    Original Code is Copyright (c) 1995-2004 Functional Objects, Inc.
              All rights reserved.
License:      See License.txt in this distribution for details.
Warranty:     Distributed WITHOUT WARRANTY OF ANY KIND

define library testworks
  use command-line-parser;
  use common-dylan,
    import: { common-dylan, simple-random, threads };
  use json;
  use io,
    import: { format, print, standard-io, streams };
  use coloring-stream;
  use strings;
  use system,
    import: { date, file-system, locators, operating-system };
  use memory-manager;

  export
    testworks,
    %testworks;
end library testworks;


// Public API
define module testworks

  // Top level and test runners
  create
    run-test-application,
    run-tests,
    *runner*,
    <test-runner>,
    debug-runner?,
    runner-options,
    runner-output-stream,
    runner-progress,
    runner-skip,
    runner-tags;

  // Checks (deprecated, use assertions)
  create
    check,
    check-condition,
    check-no-condition,
    check-equal,
    check-equal-failure-detail,
    check-false,
    check-no-errors,
    check-instance?,
    check-true;

  // Assertions
  create
    assert-equal,
    assert-not-equal,
    assert-signals,
    assert-no-errors,
    assert-instance?,
    assert-not-instance?,
    assert-true,
    assert-false;

  // Components
  create
    suite-definer,
    test-definer,
    benchmark-definer,
    with-test-unit;

  // Benchmarks
  create
    benchmark-repeat;

  // Output
  create
    test-output,
    test-temp-directory;

  // Options
  create
    test-option;

  // Specs
  create
    interface-specification-suite-definer,
    interface-specification-classes,
    interface-specification-class-instantiable?,
    make-test-instance,
    destroy-test-instance;
end module testworks;


// Internals, for use by test suite.
define module %testworks
  use coloring-stream,
    rename: { $reset-attributes => $reset-text-attributes };
  use command-line-parser;
  use common-dylan, exclude: { format-to-string };
  use date,
    import: { current-date => date/now,
              format-date => date/format };
  use file-system,
    prefix: "fs/";
  use format;
  use json,
    import: { print-json, do-print-json };
  use locators,
    import: { <directory-locator>,
              <file-locator>,
              locator-base,
              subdirectory-locator };
  use operating-system,
    prefix: "os/";
  use print, import: { print-object };
  use simple-random,
    import: { random };
  use standard-io;
  use streams;
  use strings, import: { char-compare-ic, starts-with?, string-equal? };
  use testworks;
  use threads,
    import: { dynamic-bind };
  use memory-manager, import: { collect-garbage };

  // Debugging options
  export
    debug-failures?,
    debug?;

  // Formatting
  export
    plural;

  // Components
  export
    <component>,
    $components,
    *component*,
    register-component,
    execute-component?,
    component-name,
    status-name;

  // Tests and benchmarks
  export
    <runnable>,
    <benchmark>,
    <test>,
    <test-unit>,
    test-function,
    test-requires-assertions?,
    test-tags;

  // Suites
  export
    <suite>,
    make-suite,   //--- Needed for macro hygiene problems
    suite-setup-function, suite-cleanup-function,
    suite-components;

  // Result objects
  export
    <result>,
    result-name,
    result-type-name,
    <result-status>,
    result-status,
      $passed, $failed, $skipped, $not-implemented, $crashed,
      $expected-failure, $unexpected-success,
    result-seconds,
    result-microseconds,
    result-time,
    result-bytes,

    <component-result>,
    result-subresults,

    <metered-result>,
    <test-result>,
    <benchmark-result>,
    <benchmark-iteration-result>,
    <suite-result>,
    <unit-result>,
    result-reason,
    do-results,

    <check-result>,
    <test-unit-result>;

  // Report functions
  export
    print-null-report,
    print-summary-report,
    print-failures-report,
    print-full-report,
    print-xml-report,
    print-surefire-report;

  // Progress
  export
    show-progress,
    $default, $verbose;

  // Command line handling
  export
    make-runner-from-command-line,
    parse-args;

  export
    $xml-version-header,
    *check-recording-function*;

  // Tags
  export
    <tag>,
    parse-tags,
    tags-match?;

  // Specs classes
  export <definition-spec>,
         <constant-spec>,
         <variable-spec>,
         <class-spec>,
         <function-spec>;

  // Specs accessors
  export spec-name,
         spec-title;

end module %testworks;
