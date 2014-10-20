if Meteor.isClient
  Template.body.helpers
    date:   -> Session.get 'dateKey'
    number: -> Session.get 'numberKey'

  class AbstractInputBehaviour extends FDS.Behaviour
    onInput: (event, instance) =>
      value = @clean event.target.value
      if @isValid value
          @set @parse value
      else
        @set()

    clean:   (value) => value.trim()
    isValid: (value) => true
    parse:   (value) => value


  class SessionInputBehaviour extends AbstractInputBehaviour
    init: (@_key) =>
    get: => Session.get @_key
    set: (value) => Session.set @_key, value


  class DateSessionInputBehaviour extends SessionInputBehaviour
    type:    'date'
    clean:   (value) => moment super(value), 'YYYY-MM-DD'
    isValid: (value) => value.isValid()
    parse:   (value) => value.format 'DD MMM YY'


  class NumberSessionInputBehaviour extends SessionInputBehaviour
    type:    'number'
    clean:   (value) => parseInt value, 10
    isValid: (value) => _.isNumber(value) and not _.isNaN value


  class InputBehaviourFactory extends FDS.AbstractBehaviourFactory
    create: (instance) ->
      type = instance.data.type
      switch type
        when 'date'   then @_createDate()
        when 'number' then @_createNumber()
        else throw new Error "Unknown input type #{ type }."

    _createDate:   -> @_create DateSessionInputBehaviour, 'dateKey'
    _createNumber: -> @_create NumberSessionInputBehaviour, 'numberKey'

    _create: (klass, initArgs...) ->
      behaviour = new klass
      behaviour.init initArgs...
      behaviour

    events: ->
      input: 'onInput'

  InputBehaviourFactory.attach 'input'
