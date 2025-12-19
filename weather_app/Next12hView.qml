import QtQuick 2.15
import QtQuick.Layouts

Item {
    property var next12hData: []

    width: parent.width
    height: parent.height / 3
    visible: next12hData && next12hData.length > 0

    Item {
        anchors.top: parent.top
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width
        height: parent.height * 0.3

        Text {
            anchors.centerIn: parent
            text: "Next 12h Forecast"
            font.pixelSize: Math.min(parent.height * 0.5, 25)
        }
    }

    RowLayout {
        anchors.bottom: parent.bottom
        width: parent.width
        height: parent.height * .7

        Repeater {
            model: next12hData

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true

                Rectangle {
                    anchors.centerIn: parent
                    width: parent.width * .9
                    height: parent.height * .9
                    radius: 10
                    color: Qt.rgba(0.5, 0.5, 0.5, 0.7)

                    Item {
                        anchors.top: parent.top
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: parent.width
                        height: parent.height / 2

                        Text {
                            anchors.centerIn: parent
                            width: parent.width
                            text: modelData.Hours + "\n" +
                                  modelData.Temperature
                            horizontalAlignment: Text.AlignHCenter
                            font.pixelSize: Math.min(parent.height * 0.3, 25)
                        }
                    }

                    Item {
                        anchors.top: parent.verticalCenter
                        anchors.horizontalCenter: parent.horizontalCenter
                        width: Math.min(parent.width, parent.height / 2)
                        height: width

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/resources/symbols/light/"
                                    + modelData.WeatherSymbol + ".svg"
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
