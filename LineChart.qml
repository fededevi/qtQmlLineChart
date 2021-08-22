import QtQuick 2.12

Canvas {
    property var data
    property int seriesLineWidth: 10
    property color seriesLineColor: "#ff9900"
    property int margin: seriesLineWidth

    // Properties that maps 0-1 space to visible area
    property int minXpx: margin
    property int minYpx: margin
    property int maxXpx: width - margin
    property int maxYpx: height - margin
    property int widthPx: maxXpx - minXpx
    property int heightPx: maxYpx - minYpx

    // Properties that maps the visible area to the input values
    property real minXscale: 0
    property real maxXscale: 100
    property real minYscale: 0
    property real maxYscale: 150
    property real widthScale: maxXscale - minXscale
    property real heightScale: maxYscale - minYscale

    // Context - updated on paint
    property var ctx;

    // Functions to map normalized coordinates to draw area
    function nX( x )  { return x * widthPx + minXpx }
    function nY( y )  { return height - (y * heightPx + minYpx) }

    // Functions to map input data coordinates to draw area based on Scale properties
    function fX( x )  { return nX(((x-minXscale) / widthScale)) }
    function fY( y )  { return nY(((y-minYscale) / heightScale)) }

    onPaint: {
        ctx = getContext("2d");
        adaptAreaToInputSerie();
        drawBackground()
        drawBorder()
        drawSeries()
    }

    property bool seriesUseBezierCurve : true
    property var seriesStyle: {
        'lineWidth' : 5,
        'lineCap' : 'round',
        'lineJoin' : 'round',
        'strokeStyle' : "#FFFFFF"
    }

    function drawSeries(){
        ctx.beginPath();
        contextSetLineStyle(seriesStyle);

        if (seriesUseBezierCurve) {
            ctx.moveTo(fX(data[0][0]), fY(data[0][1]));
            for ( var i = 1; i < data.length-2; i++ ) {
                var X0 = fX(data[i+0][0])
                var X1 = fX(data[i+1][0])
                var Y0 = fY(data[i+0][1])
                var Y1 = fY(data[i+1][1])
                var xc = (X0 + X1) * 0.5;
                var yc = (Y0 + Y1) * 0.5;
                ctx.quadraticCurveTo(X0, Y0, xc, yc);
            }
            ctx.quadraticCurveTo(fX(data[i+0][0]), fY(data[i+0][1]), fX(data[i+1][0]), fY(data[i+1][1]));
        } else {
            ctx.moveTo(fX(data[0][0]), fY(data[0][1]));
            for (var j = 0; j < data.length; j++) {
                ctx.lineTo(fX(data[j][0]), fY(data[j][1]));
            }
        }
        ctx.stroke();
    }

    property color backgroundColor: "#11000000"
    function drawBackground(){
        ctx.fillStyle = backgroundColor
        ctx.fillRect(0, 0, width, height);
    }

    property var borderStyle: {
        'lineWidth' : 5,
        'lineCap' : 'round',
        'lineJoin' : 'round',
        'strokeStyle' : "#55FFFFFF"
    }
    function drawBorder(){
        ctx.beginPath();
        contextSetLineStyle(borderStyle);
        ctx.moveTo(nX(0), nY(1));
        ctx.lineTo(nX(0), nY(0));
        ctx.lineTo(nX(1), nY(0));
        //ctx.lineTo(nX(0), nY(1));
        //ctx.lineTo(nX(0), nY(0));
        ctx.stroke();
    }

    property bool autoAdaptArea: true
    function adaptAreaToInputSerie(){
        if (!autoAdaptArea)
            return;

        var minX = Number.MAX_VALUE;
        var minY = Number.MAX_VALUE;
        var maxX = Number.MIN_VALUE;
        var maxY = Number.MIN_VALUE;

        for (var i = 0; i < data.length; i++) {
            var x = data[i][0];
            var y = data[i][1];

            minX = Math.min(minX, x);
            maxX = Math.max(maxX, x);

            minY = Math.min(minY, y);
            maxY = Math.max(maxY, y);
        }

        minXscale = minX -0;
        maxXscale = maxX +0;
        minYscale = minY -0;
        maxYscale = maxY +0;

        console.log("minXscale " + minX)
        console.log("maxXscale " + maxX)

        console.log("minYscale " + minY)
        console.log("maxYscale " + maxY)
    }

    function contextSetLineStyle( style ){
        ctx.lineWidth = style.lineWidth
        ctx.lineCap = style.lineCap
        ctx.lineJoin = style.lineJoin
        ctx.strokeStyle = style.strokeStyle
    }

}
