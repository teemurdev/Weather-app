import QtQuick 2.15
import QtQuick.Controls 2.15

Item {
    property var modelData

    ScrollView {
        id: hourlyData
        width: parent.width
        height: parent.height
        ScrollBar.vertical.policy: ScrollBar.AlwaysOff
        ScrollBar.horizontal.policy: ScrollBar.AlwaysOff

        Column {
            width: parent.width
            height: parent.height
            spacing: 15

            Repeater {
                model: modelData

                Row {
                    width: parent.width
                    height: hourlyData.height / 7
                    spacing: parent.width / 50

                    Rectangle {
                        width: parent.width / 8
                        height: parent.height
                        color: "grey"

                        Text {
                            anchors.centerIn: parent
                            width: parent.width
                            height: parent.height
                            text: modelData.Time + ":00"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 16
                        }
                    }

                    Rectangle {
                        width: parent.width / 7
                        height: parent.height
                        color: "grey"

                        /*Text {
                            anchors.centerIn: parent
                            width: parent.width
                            height: parent.height
                            text: modelData.WeatherSymbol
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 16
                        }*/

                        Image {
                            anchors.centerIn: parent
                            source: "qrc:/resources/symbols/light/" + modelData.WeatherSymbol + ".svg"
                            width: parent.width
                            height: parent.height
                        }
                    }

                    Rectangle {
                        width: parent.width / 5
                        height: parent.height
                        color: "grey"

                        Text {
                            anchors.centerIn: parent
                            width: parent.width
                            height: parent.height
                            text: modelData.Temperature + " °C\n" +
                                  modelData.PrecipitationAmount + " mm"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 16
                        }
                    }

                    Rectangle {
                        width: parent.width / 4
                        height: parent.height
                        color: "grey"

                        Text {
                            anchors.centerIn: parent
                            width: parent.width
                            height: parent.height
                            text: modelData.WindDirection + " °\n" +
                                  modelData.WindSpeed + " m/s\n" +
                                  "(" + modelData.WindGust + " m/s)"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 16
                        }
                    }

                    Rectangle {
                        width: parent.width / 5
                        height: parent.height
                        color: "grey"

                        Text {
                            anchors.centerIn: parent
                            width: parent.width
                            height: parent.height
                            text: modelData.TotalCloudCover + " %\n" +
                                  modelData.Humidity + " %"
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                            font.pixelSize: 16
                        }
                    }
                }
            }
        }
    }
}
