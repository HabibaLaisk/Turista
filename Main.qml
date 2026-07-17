import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic


ApplicationWindow {
    id: window
    width: 840
    height: 480
    minimumWidth: 200
    minimumHeight: 250
    visible: true
    title: qsTr("Turista")
    property bool lightMode: Application.styleHints.colorScheme === Qt.Light
    property color reallyDark: "#1f1f1f"
    property color dark: "#262626"
    property color reallyLight: "#e7e7e7"
    property color light: "#e0e0e0"

    GridLayout {
        id: grid
        columns: width < 400 ? 1 : 2
        rowSpacing: 0
        columnSpacing: 0
        anchors.fill: parent

        Rectangle {
            id: rectangleLeft
            color: "white"
            Layout.fillHeight: true
            Layout.fillWidth: true



            ColumnLayout {
                anchors.fill: parent
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                Label {
                    id: text1
                    color: window.dark
                    font.pixelSize: 120
                    fontSizeMode: Text.Fit
                    text: qsTr("Welcome")
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 16
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }
            }
        }

        Rectangle {
            id: rectangleRight
            color: window.light
            Layout.fillHeight: true
            Layout.fillWidth: true


            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 70
                spacing: 10


                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10


                    Label {
                    text: "Username"
                    font.pixelSize: 16
                    }

                    TextField {
                    id: username
                    placeholderText: "Username"

                    Layout.preferredWidth: 148
                    Layout.preferredHeight: 35

                    background: Rectangle {
                        radius: 5
                        border.color: "gray"
                        border.width: 1
                        color: "white"
                    }
                }
                    }

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10

                    Label {
                        text: "Password "
                        font.pixelSize: 16
                    }

                    TextField {
                        id: password
                        echoMode: TextInput.Password
                        placeholderText: "Password"

                        Layout.preferredWidth: 150
                        Layout.preferredHeight: 35

                        background: Rectangle {
                            radius: 5
                            border.color: "gray"
                            border.width: 1
                            color: "white"
                        }
                    }
                }

                Button {
                    id: login
                    text: "Login"
                    Layout.bottomMargin: 16
                    Layout.alignment: Qt.AlignHCenter | Qt.AlignBottom

                    contentItem: Text {
                        text: login.text
                        font: login.font
                        color: "White"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitWidth: 120
                        implicitHeight: 36
                        radius: 8

                        color: login.down ? "#333333" : "black"

                        scale: login.down ? 0.97 : 1.0

                        Behavior on color {
                            ColorAnimation {
                                duration: 100
                            }
                        }

                        Behavior on scale {
                            NumberAnimation {
                                duration: 100
                            }
                        }
                    }

                    onClicked: window.lightMode = !window.lightMode
                }
            }
        }
    }

}
