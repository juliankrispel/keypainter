trx = require('tiny-rx')
Base = require('./base')
Brush = require('./brush')

class Canvas extends Base
    init: ->
        @brushes = []

    alphablend: (src, dst, alpha) ->
        alpha * src + (1 - alpha) * dst | 0

    avgblend: (src, dst) ->
        (src+dst)/2.0 | 0

    scrblend: (src, dst) ->
        255.0*(1-(1-src/255.0)*(1-dst/255.0)) | 0

    opacityBlend: (src, dst) ->
        r = src+dst
        if r > 255
            255
        else 
            r

    createBrush: (width = 100, height = 100) =>
        b = new Brush(width,height)
        b.x = @width/2 - b.width/2
        b.y = @height/2 - b.height/2
        @brushes.push(b)
        b


    compositeBlock: (src, dst, bmode) ->
        for i in [0..src.length] by 4
            dst[i] = bmode(src[i],dst[i])
            dst[i+1] = bmode(src[i+1],dst[i+1])
            dst[i+2] = bmode(src[i+2],dst[i+2])
            dst[i+3] = @opacityBlend(src[i+3],dst[i+3])
        @

    paint: () ->
        for b in @brushes
            x = b.x
            y = b.y
            src = b.getPixelData()
            dst = @getPixelData(x, y, b.width, b.height)
            @compositeBlock src.data, dst.data, @avgblend
            console.log b.width, b.height
            @putPixelData dst, x, y, b.width, b.height
            console.log dst
            b.update()

        @context.putImageData(@imgData, 0, 0)
module.exports = Canvas
