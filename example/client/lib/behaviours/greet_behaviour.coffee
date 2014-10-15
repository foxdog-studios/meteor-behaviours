class GreetBehaviour extends FDS.Behaviour
  init: (@_prefix, @_suffix) ->
    @_clicks = 0

  _makeGreeting: ->
    [@_prefix, @data.name, @_suffix].join ''

  _onClick: (event, template) ->
    alert "#{ @data.name }, you've click this #{ ++@_clicks } times."

  @helpers:
    greeting: '_makeGreeting'

  @events:
    click: '_onClick'


GreetBehaviour.attach 'greetLarge', 'Hello, ', '!'
GreetBehaviour.attach 'greetSmall', 'Go away ', '.'

