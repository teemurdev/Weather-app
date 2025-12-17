import QtQuick 2.15
import QtQuick.Controls 2.15
import weather_app 1.0

ApplicationWindow {
    id: root
    visible: true;
    width: 800 //1440
    height: 600 //900
    title: "Weather App"

    DataFetcher {
        id: fetcher
    }

    property var todayData: []
    property var tomorrowData: []
    property var in2DaysData: []

    Connections {
        target: fetcher
        function onCurrentDataReady(payload) {
            // Update info
            // First row
            currentFirst.leftText = payload.Place + "\n" +
                             Qt.formatDateTime(new Date(), "dd MMM")
            currentFirst.centerText = payload.WeatherSymbol
            currentFirst.rightText = payload.Temperature + " °C"

            // Second row
            currentSecond.leftText = payload.WindDirection + " °\n" +
                            payload.WindSpeed + " m/s\n" +
                            "(" + payload.WindGust + " m/s)"
            currentSecond.centerText = payload.TotalCloudCover + " %"
            currentSecond.rightText = payload.Humidity + " %"

            // Third row
            in3hours.text = "In 3 h:\n" +
                            payload.In3hours.WeatherSymbol + "\n" +
                            payload.In3hours.Temperature + " °C"
            in6hours.text = "In 6 h:\n" +
                            payload.In6hours.WeatherSymbol + "\n" +
                            payload.In6hours.Temperature + " °C"
            in9hours.text = "In 9 h:\n" +
                            payload.In9hours.WeatherSymbol + "\n" +
                            payload.In9hours.Temperature + " °C"
            in12hours.text = "In 12 h:\n" +
                             payload.In12hours.WeatherSymbol + "\n" +
                             payload.In12hours.Temperature + " °C"
        }
        function onForecastDataReady(payload) {
            todayData = payload.Today
            tomorrowData = payload.Tomorrow
            in2DaysData = payload.In2Days

            // Update view
            stack.replace([
                "ForecastView.qml",
                { modelData: todayData }
            ])
        }
        function onErrorOccured(errorString) {
            weatherData = errorString
        }
    }

    Item {
        id: topPart
        width: parent.width
        height: parent.height * 0.10

        Text {
            id: appName
            anchors.left: parent.left
            anchors.leftMargin: width * 0.1
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * 0.25
            text: "Weather App"
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: 18
        }

        TextField {
            id: cityInput
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: appName.right
            anchors.right: dateText.left
            placeholderText: "Write city here"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 18
            onAccepted: fetcher.fetchWeather(cityInput.text)
        }

        Text{
            id: dateText
            anchors.right: parent.right
            anchors.rightMargin: width * 0.1
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * 0.25
            text: Qt.formatDateTime(new Date(), "dd.MM.yyyy")
            horizontalAlignment: Text.AlignRight
            font.pixelSize: 18
        }
    }

    Column {
        id: leftPart
        anchors.top: topPart.bottom
        anchors.left: parent.left
        anchors.right: parent.horizontalCenter
        anchors.bottom: parent.bottom

        CurrentView {
            id: currentFirst
            // @disable-check M16
            title: "Current Weather"
        }

        CurrentView {
            id: currentSecond
            // @disable-check M16
            title: "Air Conditions"
        }

        Item {
            id: leftPartThird
            width: parent.width
            height: parent.height / 3

            Text {
                anchors.horizontalCenter: parent.horizontalCenter
                text: "Next 12h Forecast"
                font.pixelSize: 18
                padding: parent.height * 0.1
            }

            Row {
                width: parent.width
                height: parent.height
                spacing: parent.width / 15

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width * .2
                    height: parent.height * .7
                    color: "grey"

                    Text {
                        id: in3hours
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 18
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width * .2
                    height: parent.height * .7
                    color: "grey"

                    Text {
                        id: in6hours
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 18
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width * .2
                    height: parent.height * .7
                    color: "grey"

                    Text {
                        id: in9hours
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 18
                    }
                }

                Rectangle {
                    anchors.bottom: parent.bottom
                    width: parent.width * .2
                    height: parent.height * .7
                    color: "grey"

                    Text {
                        id: in12hours
                        anchors.centerIn: parent
                        width: parent.width
                        height: parent.height
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: 18
                    }
                }
            }
        }
    }

    Column {
        id: rightPart
        anchors.top: topPart.bottom
        anchors.left: parent.horizontalCenter
        anchors.right: parent.right
        anchors.bottom: parent.bottom

        Text {
            width: parent.width;
            height: parent.height * 0.1
            text: "Forecast"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: 18
            padding: parent.height / 3 * 0.1 // From leftPart
        }

        Row {
            id: dayButtons
            width: parent.width
            height: parent.height * 0.1
            spacing: parent.width * 0.05

            Button {
                id: todayButton
                width: parent.width * .3
                height: parent.height * .7
                text: "Today"
                font.pixelSize: 18
                onClicked: stack.replace([
                    "ForecastView.qml",
                    { modelData: todayData }
                ])
            }

            Button {
                id: tomorrowButton
                width: parent.width * .3
                height: parent.height * .7
                text: "Tomorrow"
                font.pixelSize: 18
                onClicked: stack.replace([
                    "ForecastView.qml",
                    { modelData: tomorrowData }
                ])
            }

            Button {
                id: in2daysButton
                width: parent.width * .3
                height: parent.height * .7
                text: "In 2 Days"
                font.pixelSize: 18
                onClicked: stack.replace([
                    "ForecastView.qml",
                    { modelData: in2DaysData }
                ])
            }
        }

        StackView {
            id: stack
            width: parent.width
            height: parent.height * 0.8
            initialItem: { "ForecastView.qml" }
            clip: true
        }
    }
}
