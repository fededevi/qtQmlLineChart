/**
* @author Federico Devigili - federicodevigili@gmail.com
*
* This component draws a line chart in a js canvas so it does not need additional dependencies
* Lines styles can be modified by changing the relative xyzStyle properties
*/

import QtQuick 2.12


Canvas {
    property var data
    property int margin: border_lineWidth + 1 //Margin change to fit border width

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
    function nX( x )  { return 0.5 + Math.round(x * widthPx + minXpx) }
    function nY( y )  { return 0.5 + Math.round(height - (y * heightPx + minYpx)) }

    // Functions to map input data coordinates to draw area based on Scale properties
    function fX( x )  { return nX(((x-minXscale) / widthScale)) }
    function fY( y )  { return nY(((y-minYscale) / heightScale)) }

    onPaint: {
        ctx = getContext("2d");
        adaptAreaToInputSerie();
        drawBackground()
        drawGrid()
        drawBeginEndLines()
        drawSeries()
        drawBorder()
    }

    property color backgroundColor: "#22FFFFFF"
    function drawBackground() {
        ctx.fillStyle = backgroundColor
        ctx.fillRect(0, 0, width, height);
    }

    property bool seriesInterpolate : true
    property int series_lineWidth : 3
    property string series_lineCap : 'round';
    property string series_lineJoin : 'round'
    property color series_strokeStyle : "#FFFFFF"
    function drawSeries() {
        ctx.beginPath();
        contextSetLineStyle(series_lineWidth, series_lineCap, series_lineJoin, series_strokeStyle);

        if (seriesInterpolate) {
            ctx.moveTo(fX(data[0][0]), fY(data[0][1]));
            for ( var i = 1; i < data.length-2; i++ ) {
                var X0 = fX(data[i+0][0]);
                var X1 = fX(data[i+1][0]);
                var Y0 = fY(data[i+0][1]);
                var Y1 = fY(data[i+1][1]);
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

    property int border_lineWidth : 3
    property string border_lineCap : 'butt'
    property string border_lineJoin : 'miter'
    property color border_strokeStyle : "#FFCCCCCC"
    function drawBorder(){
        ctx.beginPath();
        contextSetLineStyle(border_lineWidth, border_lineCap, border_lineJoin, border_strokeStyle);
        ctx.moveTo(nX(0), nY(1));
        ctx.lineTo(nX(0), nY(0));
        ctx.lineTo(nX(1), nY(0));
        ctx.lineTo(nX(1), nY(1));
        ctx.lineTo(nX(0), nY(1));
        ctx.stroke();
    }

    property int grid_lineWidth : 1
    property string grid_lineCap : 'round'
    property string grid_lineJoin : 'round'
    property color grid_strokeStyle : "#44444444"
    property int gridSizeX: 100
    property int gridSizeY: 100
    function drawGrid(){
        ctx.beginPath();
        contextSetLineStyle(grid_lineWidth, grid_lineCap, grid_lineJoin, grid_strokeStyle);
        for (var x = gridSizeX; x < widthPx; x = x + gridSizeX ) {
            ctx.moveTo(0.5 + minXpx + x, nY(0));
            ctx.lineTo(0.5 + minXpx + x, nY(1));
        }
        for (var y = gridSizeY; y < widthPx; y = y + gridSizeY ) {
            ctx.moveTo(nX(0), 0.5 + height - (minYpx + y));
            ctx.lineTo(nX(1), 0.5 + height - (minYpx + y));
        }
        ctx.stroke();
    }

    property int beginEnd_lineWidth : 1
    property string beginEnd_lineCap : 'round'
    property string beginEnd_lineJoin : 'round'
    property color beginEnd_strokeStyle : "#666666"
    property double averageValue : 0
    function drawBeginEndLines(){
        ctx.beginPath();
        contextSetLineStyle(beginEnd_lineWidth, beginEnd_lineCap, beginEnd_lineJoin, beginEnd_strokeStyle);
        var x_begin = fX(data[0][0]);
        var x_end = fX(data[data.length-1][0]);
        var y_end = fY(data[data.length-1][1]);
        ctx.moveTo(x_begin, nY(0));
        ctx.lineTo(x_begin, nY(1));
        ctx.moveTo(x_end, nY(0));
        ctx.lineTo(x_end, nY(1));
        ctx.moveTo(nX(0), y_end);
        ctx.lineTo(nX(1), y_end);

        //Draw max horizontal line
        var maxY = Number.MIN_VALUE;
        for (var i = 0; i < data.length; i++) {
            maxY = Math.max(maxY, data[i][1]);
        }
        ctx.moveTo(nX(0), fY(maxY) );
        ctx.lineTo(nX(1), fY(maxY) );

        //Draw average horizontal line
        ctx.moveTo(nX(0), fY(averageValue) );
        ctx.lineTo(nX(1), fY(averageValue) );

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

        minXscale = minX;
        maxXscale = maxX;
        minYscale = minY;
        maxYscale = maxY;

        var xSize = Math.abs(minXscale - maxXscale)
        var ySize = Math.abs(minYscale - maxYscale)

        minXscale -= xSize * 0.05;
        maxXscale += xSize * 0.05;
        minYscale -= ySize * 0.1;
        maxYscale += ySize * 0.1;

        minX = Math.min(0, x);
        maxX = Math.max(100, x);
        minY = Math.min(0, y);
    }

    function contextSetLineStyle( lineWidth, lineCap, lineJoin, strokeStyle ){
        ctx.lineWidth = lineWidth
        ctx.lineCap = lineCap
        ctx.lineJoin = lineJoin
        ctx.strokeStyle = strokeStyle
    }

}
