trx = require('tiny-rx')
Base = require('./base')
class Brush extends Base
    init: =>
        @x = 0
        @y = 0
        @moveX = 0
        @moveY = 0

    update: ->
        @x+=@moveX
        @y+=@moveY

module.exports = Brush
