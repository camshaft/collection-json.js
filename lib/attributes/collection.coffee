_ = require "../underscore"
http = require "../http"

Function::define = (prop, desc) ->
  Object.defineProperty @prototype, prop, desc

module.exports = class Collection
  constructor: (collection)->
    @_collection = collection.collection
    @_links = null
    @_queries = null
    @_commands = null
    @_items = null
    @_template = null
    @error = @_collection.error

  @define "href"
    get: ->
      @_collection.href
      
  @define "version"
    get: ->
      @_collection.version

  @define "links",
    get: ->
      return @_links if @_links

      @_links = links = []
      Link = require "./link"

      _.each @_collection.links, (link)->
        links.push new Link link
      @_links

  link: (rel)->
    _.find @links, (link)-> link.rel is rel

  @define "items",
    get: ->
      return @_items if @_items

      @_items = items = []
      Item = require "./item"

      _.each @_collection.items, (item)->
        items.push new Item item
      @_items

  item: (href)->
    _.find @items, (item)-> item.href is href

  @define "queries",
    get: ->
      queries = []
      Query = require "./query"

      _.each @_collection.queries||[], (query)->
        queries.push new Query query
      queries

  query: (rel)->
    query = _.find @_collection.queries||[], (query)->
      query.rel is rel
    return null if not query

    Query = require "./query"
    # Don't cache it since we allow you to set parameters and submit it
    new Query query

  @define "commands",
    get: ->
      commands = []
      Command = require "./query"

      _.each @_collection.commands||[], (command)->
        commands.push new Command command
      commands

  command: (rel)->
    command = _.find @_collection.commands||[], (command)->
      command.rel is rel
    return null if not command

    Command = require "./query"
    # Don't cache it since we allow you to set parameters and submit it
    new Query command
	
  # TODO support multiple templates:
  # https://github.com/mamund/collection-json/blob/master/extensions/templates.md

  template: (name)->
    Template = require "./template"
    new Template @_collection.href, @_collection.template