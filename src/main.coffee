conf = require('./config.coffee')
trx = require('tiny-rx')
_ = require('lodash')
h = require('./helper.coffee')
Canvas = require('./canvas')

keys = trx.fromDomEvent(['keydown', 'keyup'], document.body)
lastKey = keys.createProperty((memo, e)-> e )

mouse = trx.fromDomEvent(['mousedown', 'mouseup', 'mousemove'], conf.$canvas)
mouseUpOrDown = trx.fromDomEvent(['mousedown', 'mouseup'], conf.$canvas).extract('type').createProperty((memo,e)-> e)

brush = trx.fromDomEvent(['mousedown', 'mousemove'], conf.$canvas).map((e)->
    [e.x, e.y] if mouseUpOrDown.value() == 'mousedown'
, []).truethy().createHistory(100)

selection = new Layer
renderer.addLayer(selection)
window.s = selection

brush.subscribe((coords)->
    selection.put(coords, [0,200,0,100])
)
