'use strict'

describe 'Directive: outputRaw', () ->
  beforeEach module 'neo4jApp.directives'

  element = {}

  it 'should only set the first content', inject ($rootScope, $compile) ->
    scope = $rootScope.$new()
    element = angular.element '<div output-raw="val"></div>'
    element = $compile(element)(scope)
    scope.val = "hello"
    scope.$apply()
    expect(element.text()).toBe 'hello'
    scope.val = "world"
    scope.$apply()
    expect(element.text()).toBe 'hello'

