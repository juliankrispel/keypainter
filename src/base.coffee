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
        @imgData = @context.getImageData 0, 0, @width, @height
        @init()

    drawPixel: (x,y,r=0,g=0,b=0,a=255)->
        @context.fillStyle = 'rgba('+r+','+g+','+b+','+a+')'
        @context.fillRect(x,y,1,1)
        @imgData = @context.getImageData 0, 0, @width, @height

    getPixelData: (x = 0, y = 0, width = @width, height = @height) ->
        imgData = {
            width: width
            height: height
            data: new Uint8ClampedArray(width * height * 4)
        }
        row = 0
        srcoffset = (x + (y * @width)) * 4
        dstoffset = 0
        while row < height
            imgData.data.set( @imgData.data.subarray(srcoffset, srcoffset + width * 4), dstoffset )
            srcoffset += @width*4
            dstoffset += width*4
            ++row
        imgData

    putPixelData: (src, x = 0, y = 0, width, height) =>
        row = 0
        srcoffset = 0
        dstoffset = (x + (y * @width)) * 4
        while row < height
            @imgData.data.set(src.data.subarray(srcoffset, srcoffset + width * 4) , dstoffset )
            dstoffset += @width * 4
            srcoffset += width * 4
            ++row
        @

module.exports = Base
