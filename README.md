# Behaviours

Reuse, inherit, and extend your Meteor templates.


## Install

Behaviours is a Meteor package and can be install by running;

```ShellSession
$ meteor add fds:behaviours
```

inside a meteor application. It's designed for use with CoffeeScript, which can installed by running;

```ShellSession
$ meteor add coffeescript
```


## Quick start

Create your templates as normal;

**example.html**
```Handlebars
<body>{{> upper "hello"}} {{> lower "WORLD"}}</body>
<template name="lower"><button>{{text}}</button></template>
<template name="upper"><button>{{text}}</button></template>
```

**example.coffee**
```CoffeeScript
class MyBehaviour extends FDS.Behaviours
  init: (@_process) ->
    # Called just after instantiation, arguments come from [1].

  # Like Template hooks.
  created: ->
  rendered: ->
  destroyed: ->

  _getText: ->
    # this is allow the MyBehaviour instance, even in helpers.
    # The _normal_ this is always available via @context.
    @_process @data.text

  _onClick: (event, template) ->
    # Direct access to the Template instance API.
    @findAll 'button'

   @helpers:
     text: '_getText'

   @events:
     click: '_onClick'

# For every upper instance, an instance of MyBehaviour with an upper
# case function will be created add attached to the template instance.
MyBehaviour.attach 'upper', (text) -> text.toUpperCase()  # [1]

# Same as above but with the lower template and a lower case function.
MyBehaviour.attach 'lower', (text) -> text.toLowerCase()
```


## Documentation


### FDS.Behaviour

The base class that users should `extend`. E.g.;

```CoffeeScript
class MyBehaviour extends FDS.Behaviour
```


#### _Subclass_.attach(templateOrName, initArgs...)

* Architectures: Client
* Overridable: No
* Reactive: No
* `this`: _Subclass_


##### Parameters

* `templateOrName` (`Template` or `String`): Ether a `Template` or the name of a template to attach the bahviour `Subclass` to.

*   `initArgs...` (_Any_): Arguments to be passed to `instance.init()`, `Subclass.events()`, and `Subclass.helpers()`.

    These arguments can be used to alter a `Behaviour` without subclassing.


##### Returns

_Nothing_


#### _Subclass_.helpers(initArgs...) or _Subclass_.helpers = {_HelperName_: _MethodName_}

* Architectures: Client
* Overridable: Yes
* Reactive: No
* `this`: _Subclass_

Map template helpers (e.g. `{{text}}`) to _Subclass_ instance methods. Either a map or a function that returns a map from template helper names to _Subclass_ method names.


##### Parameters _(if function)_

*   `initArgs...` (_Any_): Arguments to be passed to `Subclass.atach()`.


##### Returns _(if function)_

A map from template helper names to _Subclass_ method names.


#### _Subclass_.events(initArgs...) or _Subclass_.events = {_EventType_: _MethodName_}

* Architectures: Client
* Overridable: Yes
* Reactive: No
* `this`: _Subclass_

Map DOM events (e.g. click) to _Subclass_ instance methods. Either a map or function that returns a map from Meteor _event types_ to _Subclass_ method names.


##### Parameters _(if function)_

*   `initArgs...` (_Any_): Arguments to be passed to `Subclass.atach()`.


##### Returns _(if function)_

A map from Meteor _event types_ to _Subclass_ method names.


#### _instance_.instance

The `Template` instance attached to this `Behaviour` subclass instance. `null` until `instance.attach()` returns and after `instance.detach()` is called.


#### _instance_.constructor()

* Architectures: Client
* Overridable: Yes (`super` call required)
* Reactive: No
* `this`: _instance_


#### _instance_.attach(template)

* Architectures: Client
* Overridable: Yes (`super` call optional)
* Reactive: No
* `this`: _instance_

Attaches a `Template` instance, `template`, with this `Behaviour` instance. Most users will not need to override this method.


##### Parameters

* `template` (`Template` instance): The `Template` instance associated with this    `Behaviour` instance.


##### Returns

_Nothing_


#### _instance_.init(initArgs...)

* Architectures: Client
* Overridable: Yes (`super` call optional)
* Reactive: No
* `this`: _instance_

A hook method called just after instantiation. It's passed the arguments that where passed to `Subclass.attach()`. Use this method to do initialiation that doesn't require access to the `Template` instance.

##### Parameters

*   `initArgs...` (_Any_): Arguments passed to `Subclass.attach()`.


##### Returns

_Nothing_


#### _instance_.created()

* Architectures: Client
* Overridable: Yes (`super` call optional)
* Reactive: No
* `this`: _instance_

A hook method called when the attathced `Template` instance's `created` hook is called.


##### Parameters

_None_


##### Returns

_Nothing_


#### _instance_.rendered()

* Architectures: Client
* Overridable: Yes (`super` call optional)
* Reactive: No
* `this`: _instance_

A hook method called when the attached `Templates` instance's `rendered` hook is called.


#### _instance_.destroyed()

* Architectures: Client
* Overridable: Yes (`super` call optional)
* Reactive: No
* `this`: _instance_

A hook method called when the attached `Template` instance's `destroyed` hook is called.


##### Parameters

_None_


##### Returns

_Nothing_



#### _instance_.detach()

* Architectures: Client
* Overridable: Yes (`super` call required)
* Reactive: No
* `this`: _instance_

Detatches _instance_ from the `Template` instance. Normally, this shouldn't be overrided.


##### Parameters

_None_


##### Returns

_Nothing_


### Delegates

See Meteor documentation.

* Attributes
  * _instance_.data
  * _instance_.firstNode
  * _instance_.lastNode
  * _instance_.view
* Methods
  * _instance_.$()
  * _instance_.autorun()
  * _instance_.find()
  * _instance_.findAll()
  * _instance_.parentData()
