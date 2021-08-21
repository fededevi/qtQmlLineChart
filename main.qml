import QtQuick 2.12
import QtQuick.Window 2.12

Window {
    width: 1280
    height: 800
    visible: true
    title: qsTr("Hello World")

    Rectangle {
        width: 512
        height: 512
        color: "#00FF00"
        anchors.fill: parent
    }

    //Component.onCompleted: console.log("lineData " + lineData[0])

    LineChart {
        data: lineData
        anchors.fill: parent
        anchors.margins: 50
    }
}
