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
            currentFirst.currentData = [
                {
                    Text: payload.Place + "\n" + Qt.formatDateTime(new Date(), "dd MMM"),
                    IsSymbol: false
                },
                {
                    Text: payload.WeatherSymbol,
                    IsSymbol: true
                },
                {
                    Text: payload.Temperature + " °C",
                    IsSymbol: false
                }
            ]

            // Second row
            currentSecond.currentData = [
                {
                    Text: payload.WindDirection + " °\n" +
                          payload.WindSpeed + " m/s\n" +
                          "(" + payload.WindGust + " m/s)",
                    IsSymbol: false
                },
                {
                    Text: payload.TotalCloudCover + " %",
                    IsSymbol: false
                },
                {
                    Text: payload.Humidity + " %",
                    IsSymbol: false
                }
            ]

            // Third row
            next12h.next12hData = [
                {
                    Hours: "In 3 h:",
                    WeatherSymbol: payload.In3hours.WeatherSymbol,
                    Temperature: payload.In3hours.Temperature + " °C"
                },
                {
                    Hours: "In 6 h:",
                    WeatherSymbol: payload.In6hours.WeatherSymbol,
                    Temperature: payload.In6hours.Temperature + " °C"
                },
                {
                    Hours: "In 9 h:",
                    WeatherSymbol: payload.In9hours.WeatherSymbol,
                    Temperature: payload.In9hours.Temperature + " °C"
                },
                {
                    Hours: "In 12 h:",
                    WeatherSymbol: payload.In12hours.WeatherSymbol,
                    Temperature: payload.In12hours.Temperature + " °C"
                }
            ]
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
        function onErrorOccurred(errorString) {
            weatherData = errorString
        }
    }

    Image {
        anchors.fill: parent
        source: "qrc:/resources/backgrounds/light.jpg"
        fillMode: Image.Stretch
        smooth: true
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
            title: "Current Weather"
        }

        CurrentView {
            id: currentSecond
            title: "Air Conditions"
        }

        Next12hView {
            id: next12h
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
