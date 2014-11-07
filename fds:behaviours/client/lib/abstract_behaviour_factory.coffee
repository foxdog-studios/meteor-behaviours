'use strict'

class FDS.AbstractBehaviourFactory
  init: ->

  create: (instance) ->
    throw new Error 'Subclass must implement create() but does not'

  helpers: {}

  events: {}

  @attach: (template, initArgs...) ->
    factory = new this
    factory.init initArgs...
    Pkg.BehaviourAttacher.attach factory, template
    return

