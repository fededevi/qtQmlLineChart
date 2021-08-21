import QtQuick 2.12

Canvas {
    property var data

    property int seriesLineWidth: 10
    property color seriesLineColor: "#ff9900"
    property int margin: seriesLineWidth

    property int minXpx: margin
    property int minYpx: margin
    property int maxXpx: width - margin
    property int maxYpx: height - margin
    property int widthPx: maxXpx - minXpx
    property int heightPx: maxYpx - minYpx

    property real minXscale: 0
    property real maxXscale: 100

    property real minYscale: 0
    property real maxYscale: 150

    property real widthScale: maxXscale - minXscale
    property real heightScale: maxYscale - minYscale

    // Context updated on paint
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

    function drawSeries(){
        ctx.beginPath();
        ctx.lineWidth = seriesLineWidth;
        ctx.strokeStyle = seriesLineColor;
        context.lineCap = 'round'
        context.lineJoin = 'round';

        ctx.moveTo(fX(data[0][0]), fY(data[0][1]));
        for (var i = 1; i < data.length; i++) {
            ctx.lineTo(fX(data[i][0]), fY(data[i][1]));
        }

        ctx.stroke();
    }

    property color backGroundColor: "#33000000"
    function drawBackground(){
        var ctx = getContext("2d");
        ctx.fillStyle = backGroundColor
        ctx.fillRect(0, 0, width, height);
    }

    function drawBorder(){
        var ctx = getContext("2d");
        ctx.beginPath();
        ctx.lineWidth = 5
        context.lineCap = 'round'
        ctx.strokeStyle = "#55FFFFFF";
        ctx.moveTo(nX(0), nY(1));
        ctx.lineTo(nX(0), nY(0));
        ctx.lineTo(nX(1), nY(0));
        //ctx.lineTo(nX(0), nY(1));
        //ctx.lineTo(nX(0), nY(0));
        ctx.stroke();
    }

    property bool autoAdaptArea: false
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

        minXscale = minX -1;
        maxXscale = maxX +2;
        minYscale = minY -1;
        maxYscale = maxY +1;

        console.log("minXscale " + minX)
        console.log("maxXscale " + maxX)

        console.log("minYscale " + minY)
        console.log("maxYscale " + maxY)
    }

}
