_ = require('lodash')
conf = require('./config.coffee')
r = require('./renderer.coffee')

class Layer
    constructor: () ->
        @imageData = new Uint8ClampedArray(conf.width * conf.height * 4)

    put: (coords, rgba)->
        self = @
        _(coords).each((coord)->
            i = (coord[0] - 1 + (coord[1] * conf.width)) * 4

            for x in [0..3]
                self.imageData[i+x] = rgba[x]
        )

module.exports = Layer
