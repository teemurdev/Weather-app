import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property string title
    property string leftText
    property string centerText
    property string rightText

    width: parent.width
    height: parent.height / 3

    Text {
        id: titleBox
        anchors.horizontalCenter: parent.horizontalCenter
        text: title
        font.pixelSize: 18
        padding: parent.height * 0.1
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        width: parent.width * .3
        height: parent.height * .7
        color: "grey"

        Text {
            id: leftBox
            anchors.centerIn: parent
            text: leftText
            width: parent.width
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 16
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width * .3
        height: parent.height * .7
        color: "grey"

        Text {
            id: centerBox
            anchors.centerIn: parent
            text: centerText
            width: parent.width
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 16
        }
    }

    Rectangle {
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        width: parent.width * .3
        height: parent.height * .7
        color: "grey"

        Text {
            id: rightBox
            anchors.centerIn: parent
            text: rightText
            width: parent.width
            height: parent.height
            horizontalAlignment: Text.AlignHCenter
            verticalAlignment: Text.AlignVCenter
            font.pixelSize: 16
        }
    }
}
