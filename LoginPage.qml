import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Rectangle {
    id: root

    property StackView pageStack

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

                    Layout.topMargin: -8
                    Layout.alignment: Qt.AlignHCenter

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

                RowLayout {
                    Layout.alignment: Qt.AlignHCenter
                    spacing: 10

                    Button {
                        id: createAccount
                        text: "Create an account"

                        Layout.alignment: Qt.AlignHCenter

                        background: Rectangle {
                            color: "transparent"
                        }

                        contentItem: Text {
                            text: createAccount.text
                            color: "#0077CC"
                            font.pixelSize: 14
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            scale: createAccount.down ? 0.97 : 1
                        }

                        onClicked: {
                            pageStack.push("AccountCreation.qml", { pageStack: pageStack })
                        }
                    }

                    // --- TEMP: for testing ProfilePage, remove before merging ---
                    Button {
                        id: viewProfile
                        text: "View Profile (test)"
                        Layout.alignment: Qt.AlignHCenter

                        background: Rectangle {
                            color: "transparent"
                        }

                        contentItem: Text {
                            text: viewProfile.text
                            color: "#0077CC"
                            font.pixelSize: 14
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter
                        }

                        onClicked: {
                            pageStack.push("ProfilePage.qml", { pageStack: pageStack })
                        }
                    }
                }
            }
        }
    }
}