import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    width: 1366
    height: 768
    visible: true
    title: qsTr("Hello World")

    Rectangle {
        anchors.fill: parent
        color: "#000000"
    }

    Item {
        x:150
        y:150
        width: 650
        height: 270

        LineChart {
            anchors.fill: parent
            id: lineChart
            data: lineData
            border_lineJoin: 'round'
            backgroundColor: '#00000000'
            series_lineWidth: 6
            series_strokeStyle: '#ff9900'
            averageValue: 72
        }

        Text {
            id: zeroKw
            anchors.right: lineChart.left
            anchors.rightMargin: 10
            y: lineChart.nY(0.1) - font.pixelSize * 0.5
            text: "0 kW"
            color: "#8aaddf"
            font.pixelSize: 24
        }

        Text {
            id: maxKw
            anchors.right: lineChart.left
            anchors.rightMargin: 10
            y: lineChart.nY(0.9) - font.pixelSize
            text: lineChart.maxYscale.toFixed(0) + " kW"
            color: "#8aaddf"
            font.pixelSize: 24
        }

        Text {
            id: averageKw
            anchors.right: lineChart.left
            anchors.rightMargin: 10
            y: lineChart.fY(lineChart.averageValue) - font.pixelSize * 0.75
            text: lineChart.averageValue.toFixed(0) + " kW"
            color: "#ff9900"
            font.pixelSize: 24
            visible: zeroKw.y > averageKw.y + averageKw.height && maxKw.y + maxKw.height < averageKw.y
        }

        Text {
            anchors.top: lineChart.bottom
            x: lineChart.fX(lineData[0][0]) - width * 0.5
            text: lineChart.minXscale.toFixed(0) + "%"
            color: "#8aaddf"
            font.pixelSize: 24
        }

        Text {
            anchors.top: lineChart.bottom
            x: lineChart.fX(lineData[lineData.length-1][0]) - width * 0.5
            text: lineChart.maxXscale.toFixed(0) + "%"
            color: "#8aaddf"
            font.pixelSize: 24
        }
    }

}
