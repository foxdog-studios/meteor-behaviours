# Behaviours

**Inherit, extend, and reuse the code behind your Meteor templates.**

```Handlebars
<template name="input"><input type="{{type}}"></template>
```

```CoffeeScript
class AbstractInputBehaviour extends FDS.Behaviour
  onInput: (event, instance) ->
    console.log @parse event.target.value

class NumberInputBehaviour extends FDS.Behaviour
  parse: (value) -> parseInt value, 10

class DateInputBehaviour extends FDS.Behaviour
  parse: (value) -> moment value.trim(), 'YYYY-DD-MM'

class InputBehaviourFactory extends FDS.AbstractBehaviourFactroy
  create: (instance) ->
    switch instance.data.type
      when 'date'   then new DateInputBehaviour
      when 'number' then new NumberInputBehaviour
  events:
    input: 'onInput'

InputBehaviourFactory.attach 'input'
```

## Install

Behaviours is a Meteor package and can be install by running;

```ShellSession
$ meteor add fds:behaviours
```

in a Meteor application. It's designed for use with CoffeeScript, which can
installed by running;

```ShellSession
$ meteor add coffeescript
```

in the same directory.

