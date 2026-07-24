pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Rectangle {
    id: root
    color: appWindow ? appWindow.reallyDark : "#1f1f1f"

    property StackView pageStack
    property var appWindow

    property var popularCities: [
        "Austin, TX", "New York, NY", "New Orleans, LA", "Seattle, WA"
    ]

    ColumnLayout {
        anchors.centerIn: parent
        spacing: 15
        width: Math.min(parent.width - 80, 420)

        Label {
            text: qsTr("Discover the trip that fits you")
            color: "white"
            font.pixelSize: 28
            wrapMode: Text.WordWrap
            horizontalAlignment: Text.AlignHCenter
            Layout.fillWidth: true
        }

        TextField {
            id: destination
            placeholderText: "Destination city (e.g. Austin, TX)"
            Layout.fillWidth: true

            background: Rectangle {
                radius: 5
                border.color: "gray"
                border.width: 1
                color: "white"
            }
        }

        TextField {
            id: arrive
            placeholderText: "Arrive date"
            Layout.fillWidth: true

            background: Rectangle {
                radius: 5
                border.color: "gray"
                border.width: 1
                color: "white"
            }
        }

        TextField {
            id: depart
            placeholderText: "Depart date"
            Layout.fillWidth: true

            background: Rectangle {
                radius: 5
                border.color: "gray"
                border.width: 1
                color: "white"
            }
        }

        TextField {
            id: budget
            text: "500"
            placeholderText: "Budget (USD)"
            Layout.fillWidth: true

            background: Rectangle {
                radius: 5
                border.color: "gray"
                border.width: 1
                color: "white"
            }
        }

        RowLayout {
            Layout.alignment: Qt.AlignHCenter
            spacing: 10

            Button {
                id: backButton
                text: "Back"

                contentItem: Text {
                    text: backButton.text
                    font: backButton.font
                    color: "White"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    implicitWidth: 120
                    implicitHeight: 36
                    radius: 8

                    color: backButton.down ? "#333333" : "black"
                    scale: backButton.down ? 0.97 : 1.0

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 100 }
                    }
                }

                onClicked: root.pageStack.pop()
            }

            Button {
                id: searchButton
                text: "Search"

                contentItem: Text {
                    text: searchButton.text
                    font: searchButton.font
                    color: "White"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    implicitWidth: 120
                    implicitHeight: 36
                    radius: 8

                    color: searchButton.down ? "#333333" : "black"
                    scale: searchButton.down ? 0.97 : 1.0

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 100 }
                    }
                }

                onClicked: {
                    console.log("Search requested:")
                    console.log("City:", destination.text)
                    console.log("Arrive:", arrive.text)
                    console.log("Depart:", depart.text)
                    console.log("Budget:", budget.text)
                }
            }
        }

        Flow {
            Layout.fillWidth: true
            Layout.topMargin: 10
            spacing: 8

            Repeater {
                model: root.popularCities

                Button {
                    id: cityButton
                    required property string modelData
                    text: modelData

                    contentItem: Text {
                        text: cityButton.modelData
                        color: "#0077CC"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        color: "transparent"
                    }

                    onClicked: destination.text = modelData
                }
            }
        }
    }
}
