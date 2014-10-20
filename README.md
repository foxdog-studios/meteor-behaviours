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

```Handlebars
<body>{{> input type="number"}}</body>
```


## Install

```ShellSession
$ meteor add coffeescript fds:behaviours
```
