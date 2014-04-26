$canv = document.getElementById('canvas')

bodybox = document.body.getBoundingClientRect()
$canv.width = 400 #bodybox.width
$canv.height = 400 #bodybox.height
module.exports = {
    $canvas: $canv
    width: $canv.width
    height: $canv.height
}
