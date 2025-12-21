import QtQuick 2.15
import QtQuick.Controls 2.15
import QtQuick.Controls.Basic
import QtQuick.Layouts
import weather_app 1.0

ApplicationWindow {
    id: root
    visible: true;
    width: 800 //1440
    height: 600 //900
    minimumWidth: 400
    minimumHeight: 300
    title: "Weather App"

    DataFetcher {
        id: fetcher
    }

    property bool isSearched: false
    property bool isDarkMode: false

    property var todayData: []
    property var tomorrowData: []
    property var in2DaysData: []

    Connections {
        target: fetcher
        function onCurrentDataReady(payload) {
            isSearched = true
            // Update info
            // First row
            currentFirst.currentData = [
                {
                    InfoText: "Place and time",
                    Text: payload.Place + "\n" + Qt.formatDateTime(new Date(), "dd MMM"),
                    IsSymbol: false
                },
                {
                    InfoText: "Weather symbol",
                    Text: payload.WeatherSymbol,
                    IsSymbol: true
                },
                {
                    InfoText: "Temperature",
                    Text: payload.Temperature + " °C",
                    IsSymbol: false
                }
            ]

            // Second row
            currentSecond.currentData = [
                {
                    InfoText: "Wind direction, speed and gust",
                    Text: payload.WindDirection + " °\n" +
                          payload.WindSpeed + " m/s\n" +
                          "(" + payload.WindGust + " m/s)",
                    IsSymbol: false
                },
                {
                    InfoText: "Cloud coverage",
                    Text: "Clouds:\n" + payload.TotalCloudCover + " %",
                    IsSymbol: false
                },
                {
                    InfoText: "Humidity",
                    Text: "Humidity:\n" + payload.Humidity + " %",
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
            isSearched = false
        }
    }

    Image {
        anchors.fill: parent
        source: isDarkMode
            ? "qrc:/resources/backgrounds/dark.jpg"
            : "qrc:/resources/backgrounds/light.jpg"
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
            color: isDarkMode ? "white" : "black"
            horizontalAlignment: Text.AlignLeft
            font.pixelSize: Math.min(parent.height * 0.5, 25)
        }

        TextField {
            id: cityInput
            anchors.verticalCenter: parent.verticalCenter
            anchors.left: appName.right
            anchors.right: dateAndMode.left
            height: parent.height * .5
            placeholderText: "Write city here"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Math.min(height * 0.6, 25)
            onAccepted: fetcher.fetchWeather(cityInput.text)
        }

        Column {
            id: dateAndMode
            anchors.right: parent.right
            anchors.rightMargin: width * 0.1
            anchors.verticalCenter: parent.verticalCenter
            width: parent.width * 0.25
            height: parent.height

            Text{
                id: dateText
                width: parent.width
                height: parent.height / 2
                text: Qt.formatDateTime(new Date(), "dd.MM.yyyy")
                color: isDarkMode ? "white" : "black"
                horizontalAlignment: Text.AlignRight
                verticalAlignment: Text.AlignVCenter
                font.pixelSize: Math.min(parent.height * 0.25, 25)
            }

            Item {
                width: parent.width
                height: parent.height / 2

                ToolButton {
                    id: switchMode
                    checkable: true
                    checked: isDarkMode
                    onCheckedChanged: isDarkMode = checked
                    width: parent.width * .5
                    height: parent.height * .8
                    anchors.right: parent.right
                    anchors.verticalCenter: parent.verticalCenter

                    contentItem: Text {
                        text: switchMode.checked ? "Dark mode" : "Light mode"
                        color: switchMode.checked ? "white" : "black"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                        font.pixelSize: Math.min(parent.height * 0.5, 25)
                    }
                }
            }
        }
    }
    Rectangle {
        anchors.top: topPart.bottom
        anchors.horizontalCenter: parent.horizontalCenter
        width: parent.width / 2
        height: parent.height / 3
        radius: 10
        color: Qt.rgba(1, 1, 1, 0.7)
        visible: !isSearched

        Text{
            id: infoText
            anchors.centerIn: parent
            text: "Welcome to Weather App\n\n" +
                  "Start by typing a city name into text field\n" +
                  "Supports Nordic (and some European) cities\n" +
                  "Weather will be shown if the city is found\n" +
                  "If not, this page will remain visible"
            horizontalAlignment: Text.AlignHCenter
            font.pixelSize: Math.min(parent.height * 0.1, 25)
        }
    }

    Column {
        id: leftPart
        anchors.top: topPart.bottom
        anchors.left: parent.left
        anchors.right: parent.horizontalCenter
        anchors.bottom: parent.bottom
        visible: isSearched

        CurrentView {
            id: currentFirst
            title: "Current Weather"
            mode: isDarkMode
        }

        CurrentView {
            id: currentSecond
            title: "Air Conditions"
            mode: isDarkMode
        }

        Next12hView {
            id: next12h
            mode: isDarkMode
        }
    }

    Column {
        id: rightPart
        anchors.top: topPart.bottom
        anchors.left: parent.horizontalCenter
        anchors.right: parent.right
        anchors.bottom: parent.bottom
        visible: isSearched

        Item {
            anchors.horizontalCenter: parent.horizontalCenter
            width: parent.width
            height: parent.height * 0.1

            Text {
                anchors.centerIn: parent
                text: "Forecast"
                color: isDarkMode ? "white" : "black"
                font.pixelSize: Math.min(parent.height * 0.5, 25)
            }
        }

        RowLayout {
            id: dayButtons
            anchors.left: parent.left
            anchors.right: parent.right
            height: parent.height * 0.1

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1

                Button {
                    id: todayButton
                    anchors.centerIn: parent
                    width: parent.width * .9
                    height: parent.height
                    text: "Today"
                    font.pixelSize: Math.min(parent.height * 0.3, 25)
                    background: Rectangle {
                        color: parent.hovered ? Qt.rgba(0.5, 0.5, 0.5, 0.7) : Qt.rgba(1, 1, 1, 0.7)
                        radius: 8
                        border.color: Qt.rgba(0, 0, 0, 0.7)
                        border.width: 2
                    }
                    onClicked: stack.replace([
                        "ForecastView.qml",
                        { modelData: todayData }
                    ])
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1

                Button {
                    id: tomorrowButton
                    anchors.centerIn: parent
                    width: parent.width * .9
                    height: parent.height
                    text: "Tomorrow"
                    font.pixelSize: Math.min(parent.height * 0.3, 25)
                    background: Rectangle {
                        color: parent.hovered ? Qt.rgba(0.5, 0.5, 0.5, 0.7) : Qt.rgba(1, 1, 1, 0.7)
                        radius: 8
                        border.color: Qt.rgba(0, 0, 0, 0.7)
                        border.width: 2
                    }
                    onClicked: stack.replace([
                        "ForecastView.qml",
                        { modelData: tomorrowData }
                    ])
                }
            }

            Item {
                Layout.fillWidth: true
                Layout.fillHeight: true
                Layout.preferredWidth: 1

                Button {
                    id: in2daysButton
                    anchors.centerIn: parent
                    width: parent.width * .9
                    height: parent.height
                    text: "In 2 Days"
                    font.pixelSize: Math.min(parent.height * 0.3, 25)
                    background: Rectangle {
                        color: parent.hovered ? Qt.rgba(0.5, 0.5, 0.5, 0.7) : Qt.rgba(1, 1, 1, 0.7)
                        radius: 8
                        border.color: Qt.rgba(0, 0, 0, 0.7)
                        border.width: 2
                    }
                    onClicked: stack.replace([
                        "ForecastView.qml",
                        { modelData: in2DaysData }
                    ])
                }
            }
        }

        Item {
            width: parent.width
            height: parent.height * .8

            StackView {
                id: stack
                anchors.bottom: parent.bottom
                anchors.horizontalCenter: parent.horizontalCenter
                width: parent.width * .95
                height: parent.height
                initialItem: { "ForecastView.qml" }
                clip: true
            }
        }
    }
}
