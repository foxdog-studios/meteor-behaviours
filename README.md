# Behaviours

Inherit, extend, and reuse the code behind your Meteor templates. Here's an
example that's too simple to justify the use of Behaviours, but think about
larger, more complex templates. [See it live][1].


1.  Create some templates:

    ```Handlebars
    <template name="input">
      <input type="{{type}}" class="form-control">
    </template>

    <template name="dateInput">{{> input inputData}}</template>

    <template name="numberInput">{{> input inputData}}</template>
    ```

1.  Encapsulate behaviour in CoffeeScript classes that extend `FDS.Behaviour`.

    ```CoffeeScript
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
      format: (value) => value
      clean: (value) => value.trim()
      isValid: (value) => true
      parse:  (value) => value
      @helpers: 'inputData': '_makeInputData'
      @events: 'input input': '_onChange'


    class SessionInputBehaviour extends AbstractInputBehaviour
      init: (type, @_key) => super type
      get: => Session.get @_key
      set: (value) => Session.set @_key, value

    class DateSessionInputBehaviour extends SessionInputBehaviour
      clean: (value) => moment super(value), 'YYYY-MM-DD'
      isValid: (value) => value.isValid()
      parse: (value) => value.format 'DD MMM YY'

    class NumberSessionInputBehaviour extends SessionInputBehaviour
      clean: (value) => parseInt value, 10
      isValid: (value) => _.isNumber(value) and not _.isNaN value

    ```

3.  Attach your behaviours to your templates.

    ```CoffeeScript
    DateSessionInputBehaviour.attach 'dateInput', 'date', 'dateKey'
    NumberSessionInputBehaviour.attach 'numberInput', 'number', 'numberKey'
    ```


## Install

Behaviours is a Meteor package and can be install by running;

```ShellSession
$ meteor add fds:behaviours
```

inside a meteor application. It's designed for use with CoffeeScript, which can installed by running;

```ShellSession
$ meteor add coffeescript
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


[1]: http://behaviours.meteor.com/

