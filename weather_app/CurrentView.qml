import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    property string title
    property var currentData: []

    width: parent.width
    height: parent.height / 3
    visible: currentData && currentData.length > 0

    Item {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: parent.height * 0.3

        Text {
            anchors.centerIn: parent
            text: title
            font.pixelSize: Math.min(parent.height * 0.5, 25)
        }
    }

    RowLayout {
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height * .7

        Repeater {
            model: currentData

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * .9
                    height: parent.height
                    radius: 10
                    color: Qt.rgba(0.5, 0.5, 0.5, 0.7)

                    Button {
                        text: "i️"
                        anchors.top: parent.top
                        anchors.right: parent.right
                        width: parent.width * .2
                        height: parent.height * .2
                        background: Rectangle {
                            color: parent.hovered ? Qt.rgba(0.5, 0.5, 0.5, 0.7) : Qt.rgba(1, 1, 1, 0.7)
                            radius: 8
                            border.color: Qt.rgba(0, 0, 0, 0.7)
                            border.width: 2
                        }
                        font.pixelSize: Math.min(parent.height * 0.1, 25)

                        ToolTip.visible: hovered
                        ToolTip.text: modelData.InfoText
                        ToolTip.delay: 300
                        ToolTip.timeout: 3000
                    }

                    Text {
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                        text: modelData.Text
                        visible: !modelData.IsSymbol
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Math.min(parent.height * 0.2, 25)
                    }

                    Loader {
                        anchors.centerIn: parent
                        width: Math.min(parent.width, parent.height)
                        height: width
                        active: modelData.IsSymbol
                        sourceComponent:

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/resources/symbols/light/"
                                    + modelData.Text + ".svg"
                            sourceSize.width: parent.width
                            sourceSize.height: parent.height
                            smooth: false
                        }
                    }
                }
            }
        }
    }
}
