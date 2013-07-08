'use strict';

#
# A generic collection data type with ID awareness
#

angular.module('neo4jApp.services')
  .factory 'Collection', [
    () ->
      class Collection
        constructor: (items) ->
          @items = []
          @_byId = {}
          @add(items) if items?

        add: (items) ->
          items = [items] unless items instanceof Array
          for i in items
            if i.id?
              if not @_byId[i.id]
                @_byId[i.id] = i
                @items.push i
            else
              @items.push i

        all: ->
          @items

        get: (id) ->
          id = parseInt(id, 10)
          return null unless id?
          @_byId[id]

        reset: (items) ->
          @_reset()
          @add(items)

        _reset: ->
          @items = []
          @_byId = {}

      Collection
]
