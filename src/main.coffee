#conf = require('./config.coffee')
trx = require('tiny-rx')
key = require('keycode')
_ = require('lodash')
h = require('./helper.coffee')
Canvas = require('./canvas')
Brush = require('./brush')

canvas = new Canvas
brushes = []
selectedBrush = undefined

eventHost = document.body

isDrawing = trx.fromDomEvent(['mousedown', 'mouseup'], eventHost).createProperty((memo, e)->
    isMouseDown = e.type == 'mousedown'
    memo = isMouseDown if isMouseDown != memo
, false)

isShift = trx.fromDomEvent(['keydown'], eventHost).createProperty((memo, e)->
    isShiftDown = key(e.keyCode) == 'shift'
    memo = isShiftDown if isShiftDown != memo
)

#USE KEY COMBINATIONS FOR COMMANDS
keyCombinations = trx.fromDomEvent('keyup', eventHost).map((e)-> key(e.keyCode)).createHistory(2)

keyCombinations.filter((e)-> 
        console.log e.join('') 
        e.join('') == 'nb')
    .subscribe((e)-> 
        console.log 'new brush'
        keyCombinations.reset()
        brush = new Brush
        brushes.push(brush)
        selectedBrush = brush
    )

#DRAW ON BRUSH
trx.fromDomEvent('mousemove', eventHost)
    .filter(()-> isDrawing.value() && selectedBrush)
    .subscribe((e)->
        console.log e.clientX, e.clientY
    )

#
#keys = trx.fromDomEvent(['keydown', 'keyup'], document.body)
#lastKey = keys.createProperty((memo, e)-> e )
#
#mouse = trx.fromDomEvent(['mousedown', 'mouseup', 'mousemove'], conf.$canvas)
#mouseUpOrDown = trx.fromDomEvent(['mousedown', 'mouseup'], conf.$canvas).extract('type').createProperty((memo,e)-> e)
#
#brush = trx.fromDomEvent(['mousedown', 'mousemove'], conf.$canvas).map((e)->
#    [e.x, e.y] if mouseUpOrDown.value() == 'mousedown'
#, []).truethy().createHistory(100)
#
#selection = new Layer
#renderer.addLayer(selection)
#window.s = selection
#
#brush.subscribe((coords)->
#    selection.put(coords, [0,200,0,100])
#)
