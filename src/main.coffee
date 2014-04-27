#conf = require('./config.coffee')
trx = require('tiny-rx')
key = require('keycode')
_ = require('lodash')
h = require('./helper.coffee')
Canvas = require('./canvas')
Brush = require('./brush')

canvas = new Canvas
#canvas.imgData.data.set(p.data)
brushes = []
selectedBrush = undefined

imgd = canvas.context.createImageData(canvas.width, canvas.height)

eventHost = document.body

isDrawing = trx.fromDomEvent(['mousedown', 'mouseup'], eventHost).createProperty((memo, e)->
    isMouseDown = e.type == 'mousedown'
    memo = isMouseDown if isMouseDown != memo
, false)

isShift = trx.fromDomEvent(['keydown'], eventHost).createProperty((memo, e)->
    isShiftDown = key(e.keyCode) == 'shift'
    memo = isShiftDown if isShiftDown != memo
)

keys = trx.fromDomEvent('keyup', eventHost).map((e)-> key(e.keyCode))
keypress = trx.fromDomEvent('keypress', eventHost).map((e)-> key(e.keyCode))
paste = trx.fromDomEvent('paste', eventHost).map((e)-> 
    if(e.clipboardData && e.clipboardData.items)
        console.log e.clipboardData.items[0].getAsString()
)

#USE KEY COMBINATIONS FOR COMMANDS
keyCombinations = keys.createHistory(2)

keyCombinations.filter((e)-> 
        e.join('') == 'nb')
    .subscribe((e)-> 
        keyCombinations.reset()
        selectedBrush = canvas.createBrush()
    )

#DRAW ON BRUSH
trx.fromDomEvent('mousemove', eventHost)
    .filter(()-> 
        isDrawing.value() && selectedBrush
    ).subscribe((e)->
        selectedBrush.drawPixel(e.clientX, e.clientY)
    )

keypress.filter((key)-> 
    key == 'f1' && canvas.brushes.length > 0
).subscribe(()->
    canvas.paint()
)

keys.filter((key)-> 
    selectedBrush &&
    key == 'up' ||
    key == 'down' ||
    key == 'left' ||
    key == 'right'
).subscribe((key)->
    switch key
        when 'up' then selectedBrush.moveY--
        when 'down' then selectedBrush.moveY++
        when 'left' then selectedBrush.moveX--
        when 'right' then selectedBrush.moveX++
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
