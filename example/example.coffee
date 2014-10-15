if Meteor.isClient
  Template.body.helpers
    date: ->
      Session.get 'dateKey'

    number: ->
      Session.get 'numberKey'

  class AbstractInputBehaviour extends FDS.Behaviour
    _makeInputData: =>
      id: @data.id
      labelText: @data.labelText
      type: @_type

    _onChange: (event, instance) =>
      value = event.target.value
      value = @clean value
      if @isValid value
          @set @parse value
      else
        @set()

    init: (@_type) =>

    format: (value) =>
      value

    clean: (value) =>
      value.trim()

    isValid: (value) =>
      true

    parse: (value) =>
      value

    @helpers:
      'inputData': '_makeInputData'

    @events:
      'input input': '_onChange'


  class SessionInputBehaviour extends AbstractInputBehaviour
    init: (type, @_key) =>
      super type

    get: =>
      Session.get @_key

    set: (value) =>
      Session.set @_key, value


  class DateSessionInputBehaviour extends SessionInputBehaviour
    clean: (value) =>
      moment super(value), 'YYYY-MM-DD'

    isValid: (value) =>
      value.isValid()

    parse: (value) =>
      value.format 'DD MMM YY'


  class NumberSessionInputBehaviour extends SessionInputBehaviour
    clean: (value) =>
      parseInt value, 10

    isValid: (value) =>
      _.isNumber(value) and not _.isNaN value


  DateSessionInputBehaviour.attach 'dateInput', 'date', 'dateKey'
  NumberSessionInputBehaviour.attach 'numberInput', 'number', 'numberKey'

