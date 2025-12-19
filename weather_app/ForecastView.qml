import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Layouts

Item {
    property var modelData

    ScrollView {
        id: hourlyData
        width: parent.width
        height: parent.height
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        Column {
            width: hourlyData.width
            spacing: hourlyData.height / 50

            Repeater {
                model: modelData

                RowLayout {
                    anchors.left: parent.left
                    anchors.right: parent.right
                    height: hourlyData.height / 6
                    spacing: width / 50

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 10
                        color: Qt.rgba(0.5, 0.5, 0.5, 0.7)

                        Text {
                            anchors.centerIn: parent
                            width: parent.width
                            height: parent.height
                            text: modelData.Time + ":00"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: Math.min(parent.height * 0.25, 25)
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 1
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 10
                        color: Qt.rgba(0.5, 0.5, 0.5, 0.7)

                        Item {
                            anchors.centerIn: parent
                            width: Math.min(parent.width, parent.height)
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

                    Rectangle {
                        Layout.preferredWidth: 2
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 10
                        color: Qt.rgba(0.5, 0.5, 0.5, 0.7)

                        Text {
                            anchors.centerIn: parent
                            width: parent.width
                            height: parent.height
                            text: modelData.Temperature + " °C\n" +
                                  modelData.PrecipitationAmount + " mm"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: Math.min(parent.height * 0.25, 25)
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 2
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 10
                        color: Qt.rgba(0.5, 0.5, 0.5, 0.7)
                        Text {
                            anchors.centerIn: parent
                            width: parent.width
                            height: parent.height
                            text: modelData.WindDirection + " °\n" +
                                  modelData.WindSpeed + " m/s\n" +
                                  "(" + modelData.WindGust + " m/s)"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: Math.min(parent.height * 0.25, 25)
                        }
                    }

                    Rectangle {
                        Layout.preferredWidth: 2
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        radius: 10
                        color: Qt.rgba(0.5, 0.5, 0.5, 0.7)

                        Text {
                            anchors.centerIn: parent
                            width: parent.width
                            height: parent.height
                            text: modelData.TotalCloudCover + " %\n" +
                                  modelData.Humidity + " %"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: Math.min(parent.height * 0.25, 25)
                        }
                    }
                }
            }
        }
    }
}
