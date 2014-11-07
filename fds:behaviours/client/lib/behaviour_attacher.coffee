'use strict'

class Pkg.BehaviourAttacher
  instance = null

  @attach: ->
    (instance ?= new BehaviourAttacherImpl).attach.apply instance, arguments


class BehaviourAttacherImpl
  BEHAVIOURS_NAME = '_behaviours'
  BUILDERS_NAME = '_behaviours'
  TAG = {}
  TAG_NAME = '_behavioursTag'

  attach: (factory, templateOrName) ->
    template = @getTemplate templateOrName
    @ensureFactoriesArray template
    builder = @createBuilder factory, template
    index = @pushBuilder builder, template
    @ensureCreatedBehaviourHook template
    @ensureRenderedBehaviourHook template
    @ensureDestroyedBehaviourHook template
    @mapHelpers factory, template, index
    @mapEvents factory, template, index
    return

  getTemplate: (templateOrName) ->
    if _.isString templateOrName
      name = templateOrName
      template = Template[name]
      throw new Error "No template named #{ name }." unless template?
    else
      template = templateOrName
      unless template instanceof Template
        throw new Error "#{ template } is not a template."
    template

  ensureFactoriesArray: (template) ->
    template[BUILDERS_NAME] ?= []

  createBuilder: (factory, template) ->
    (instance) ->
      behaviour = factory.create instance
      behaviour.attach instance
      behaviour.init()
      behaviour

  pushBuilder: (builder, template) ->
    builders = template[BUILDERS_NAME]
    builders.push builder
    builders.length - 1

  ensureCreatedBehaviourHook: (template) ->
    @ensureBehaviourHook template, 'created', ->
      @[BEHAVIOURS_NAME] = for builder in template[BUILDERS_NAME]
        builder this
      for behaviour in @[BEHAVIOURS_NAME]
        behaviour.context = this
        behaviour.created.apply behaviour, arguments
        behaviour.context = null
      return

  ensureRenderedBehaviourHook: (template) ->
    @ensureBehaviourHook template, 'rendered', ->
      for behaviour in @[BEHAVIOURS_NAME]
        behaviour.context = this
        behaviour.rendered.apply behaviour, arguments
        behaviour.context = null
      return

  ensureDestroyedBehaviourHook: (template) ->
    @ensureBehaviourHook template, 'destroyed', ->
      for behaviour in @[BEHAVIOURS_NAME]
        behaviour.context = this
        behaviour.destroyed.apply behaviour, arguments
        behaviour.context = null
      for behaviour in @[BEHAVIOURS_NAME]
        behaviour.detach()
      @[BEHAVIOURS_NAME] = null

  ensureBehaviourHook: (template, hookName, hook) ->
    original = @getOriginalHook template, hookName
    if original? or not template[hookName]?
      @attachBehaviourHook template, hookName, hook, original

  getOriginalHook: (template, hookName) ->
    original = template[hookName]
    if original? and original[TAG_NAME] == TAG
      original = null
    original

  attachBehaviourHook: (template, hookName, hook, original) ->
    wrapper = ->
      original.apply this, arguments if original?
      hook.apply this, arguments
      return  # Don't leak the hook's return value.
    wrapper[TAG_NAME] = TAG
    template[hookName] = wrapper

  mapHelpers: (factory, template, index) ->
    schema = @expandSchema factory, factory.helpers
    helpers = {}
    for helperName, methodName of schema
      helpers[helperName] = @createHelper methodName, index
    template.helpers helpers

  createHelper: (methodName, index) ->
    ->
      behaviour = Template.instance()._behaviours[index]
      behaviour.context = this
      helper = behaviour[methodName]
      result = if _.isFunction helper
        helper.apply behaviour, arguments
      else
        helper
      behaviour.context = null
      result

  mapEvents: (factory, template, index) ->
    schema = @expandSchema factory, factory.events
    events = {}
    for eventType, methodName of schema
      events[eventType] = @createEvent methodName, index
    template.events events

  createEvent: (methodName, index) ->
    (event, instance) ->
      behaviour = instance[BEHAVIOURS_NAME][index]
      behaviour.context = this
      behaviour[methodName].apply behaviour, arguments
      behaviour.context = null

  expandSchema: (factory, schema) ->
    if _.isFunction schema
      schema = schema.call factory
    schema

