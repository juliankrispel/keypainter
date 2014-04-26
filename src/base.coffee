class Base
    constructor: (@width,@height, @canvas)->
        if !@width || !@height
            @width = window.innerWidth
            @height = window.innerHeight

        @canvas = document.createElement('canvas') if !@canvas
        document.body.appendChild(@canvas)

        if(!@canvas) 
            throw new Error('No canvas element selected')

        @canvas.width = @width
        @canvas.height = @height

        @context = @canvas.getContext('2d')
        @init()

module.exports = Base
