_ = require('lodash')
conf = require('./config.coffee')

unless window.requestAnimationFrame
    window.requestAnimationFrame = (callback) ->
        currTime = new Date().getTime()
        timeToCall = Math.max(0, 16 - (currTime - lastTime))
        id = window.setTimeout
        (->
          callback currTime + timeToCall
            , timeToCall
        )
        lastTime = currTime + timeToCall
        id

class Renderer
    constructor: () ->
        @context = conf.$canvas.getContext('2d')
        @ctxImageData = @context.getImageData(0,0,conf.width,conf.height)
        @layerData = []
        @render()

    addLayer: (l) ->
        @layerData.push(l.imageData)

    render: =>
        for x, i in @ctxImageData.data
            values = [0]
            self = @
            if (@layerData.length > 0)
                for data in @layerData
                    values.push(data[i])

            @ctxImageData.data[i] = _(values).reduce((sum, num) -> sum+num)

        @context.putImageData(@ctxImageData, 0, 0)

        setTimeout(@render, 100)
        #requestAnimationFrame(@render)

module.exports = new Renderer
