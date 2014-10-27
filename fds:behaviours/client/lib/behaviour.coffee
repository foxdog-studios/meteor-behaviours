'use strict'

class FDS.Behaviour
  constructor: ->
    @context   = null
    @data      = null
    @firstNode = null
    @instance  = null
    @lastNode  = null
    @view      = null

  attach: (instance) ->
    @data      = instance.data
    @firstNode = instance.firstNode
    @instance  = instance
    @lastNode  = instance.lastNode
    @view      = instance.view
    return

  init: ->

  created: ->

  rendered: ->

  destroyed: ->

  detach: ->
    @data      = null
    @firstNode = null
    @instance  = null
    @lastNode  = null
    @view      = null
    return

  $: =>
    @instance.$.apply @instance, arguments

  autorun: =>
    @instance.autorun.apply @instance, arguments

  find: =>
    @instance.find.apply @instance, arguments

  findAll: =>
    @instance.findAll.apply @instance, arguments

  parentData: ->
    Template.parentData.apply null, arguments

