# language: en
Feature: Cucumber Colors Settings Page
  In order to customize Gherkin language (*.feature files) highlighting
  Our users can use this settings preview pane

  @wip
  Scenario Outline: Different Gherkin language structures
    Given Some feature file with content
    """
    Feature: Some feature
      Scenario: Some scenario
    """
    And I want to add new cucumber step
    And Also a step with "regexp" parameter
    When I open <ruby_ide>
    Then Steps autocompletion feature will help me with all these tasks

  Examples:
    | ruby_ide |
    | RubyMine |
