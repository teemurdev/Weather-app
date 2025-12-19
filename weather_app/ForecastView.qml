import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import QtQuick.Layouts

Item {
    property var modelData

    ScrollView {
        id: hourlyData
        width: parent.width
        height: parent.height
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff        
        ScrollBar.vertical: ScrollBar {
            id: scrollBar
            policy: ScrollBar.AlwaysOn
            anchors.right: parent.right
            anchors.bottom: parent.bottom
            anchors.top: parent.top
            contentItem: Rectangle {
                implicitWidth: 10
                radius: 5
                color: "white"
            }
        }

        Column {
            width: hourlyData.width - scrollBar.width
            spacing: hourlyData.height / 50

            RowLayout {
                anchors.left: parent.left
                anchors.right: parent.right
                height: hourlyData.height / 15
                spacing: width / 50

                Repeater {
                    model: [
                        {Width: 1, Text: "Time", InfoText: "Local time"},
                        {Width: 1, Text: "Symbol", InfoText: "Weather symbol"},
                        {Width: 2, Text: "Temperature/Rain", InfoText: "Temperature and rain"},
                        {Width: 2, Text: "Wind", InfoText: "Wind direction, speed and gust"},
                        {Width: 2, Text: "Clouds/Humudity", InfoText: "Cloud coverage and humudity"},
                    ]

                    Item {
                        Layout.fillWidth: true
                        Layout.fillHeight: true
                        Layout.preferredWidth: modelData.Width

                        Button {
                            text: modelData.Text
                            anchors.centerIn: parent
                            width: parent.width * .9
                            height: parent.height * .9
                            background: Rectangle {
                                color: parent.hovered ? Qt.rgba(0.5, 0.5, 0.5, 0.7) : Qt.rgba(1, 1, 1, 0.7)
                                radius: 8
                                border.color: Qt.rgba(0, 0, 0, 0.7)
                                border.width: 2
                            }
                            font.pixelSize: Math.min(parent.height * 0.25, 25)

                            ToolTip.visible: hovered
                            ToolTip.text: modelData.InfoText
                            ToolTip.delay: 300
                            ToolTip.timeout: 3000
                        }
                    }
                }
            }

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
