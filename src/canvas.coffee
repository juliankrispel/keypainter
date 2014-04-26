trx = require('tiny-rx')
class Canvas
    constructor: (@width,@height, @brushes = [], canvasSelector = '.canvas')->
        @canvas = document.querySelector(canvasSelector)
        if(!@canvas) throw new Error('No canvas element selected')
        @context = @canvas.getContext('2d')
        @bindEvents()

    bindEvents: ->
        isDrawing = trx.fromDomEvent(['mousedown', 'mouseup'], @canvas).createProperty((memo, e)->
            isMouseDown = e.type == 'mousedown'
            memo = isMouseDown if isMouseDown != memo
        , false)

        drawEvents = trx.fromDomEvent('mousemove', @canvas).filter(()-> isDrawing.value())

        isDrawing.subscribe((val)->
            console.log val
        )

module.exports = Canvas
