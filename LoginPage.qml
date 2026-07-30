import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import QtQuick.Shapes
import Turista

Rectangle {
    id: root

    property StackView pageStack
    property var appWindow

    GridLayout {
        id: grid
        columns: width < 400 ? 1 : 2
        rowSpacing: 0
        columnSpacing: 0
        anchors.fill: parent

        Rectangle {
            id: rectangleLeft
            color: "#fbf3e6"
            Layout.fillHeight: true
            Layout.fillWidth: true



            ColumnLayout {
                anchors.fill: parent
                Layout.alignment: Qt.AlignHCenter | Qt.AlignTop

                Item {
                    id: logoWrap
                    Layout.fillWidth: true
                    Layout.fillHeight: true
                    Layout.margins: 16
                    clip: true

                    Item {
                        id: logoMark
                        width: 520
                        height: 220
                        anchors.centerIn: parent
                        scale: Math.min(logoWrap.width / width, logoWrap.height / height) * 1.8

                        Shape {
                            anchors.fill: parent
                            ShapePath {
                                strokeColor: "#ff6b4a"
                                strokeWidth: 7
                                fillColor: "transparent"
                                capStyle: ShapePath.RoundCap
                                startX: 330
                                startY: 108
                                PathArc {
                                    x: 196
                                    y: 182
                                    radiusX: 95
                                    radiusY: 95
                                    direction: PathArc.Counterclockwise
                                }
                            }
                        }

                        Item {
                            x: 196
                            y: 182
                            rotation: 208
                            scale: 1.3

                            Shape {
                                ShapePath {
                                    fillColor: "#ff6b4a"
                                    strokeColor: "transparent"
                                    startX: 0
                                    startY: -16
                                    PathLine { x: 3; y: -6 }
                                    PathLine { x: 16; y: -1 }
                                    PathLine { x: 16; y: 2 }
                                    PathLine { x: 3; y: 4 }
                                    PathLine { x: 3; y: 13 }
                                    PathLine { x: 7; y: 17 }
                                    PathLine { x: 7; y: 20 }
                                    PathLine { x: 0; y: 17 }
                                    PathLine { x: -7; y: 20 }
                                    PathLine { x: -7; y: 17 }
                                    PathLine { x: -3; y: 13 }
                                    PathLine { x: -3; y: 4 }
                                    PathLine { x: -16; y: 2 }
                                    PathLine { x: -16; y: -1 }
                                    PathLine { x: -3; y: -6 }
                                    PathLine { x: 0; y: -16 }
                                }
                            }
                        }

                        Text {
                            anchors.horizontalCenter: parent.horizontalCenter
                            anchors.top: parent.top
                            anchors.topMargin: 78
                            text: qsTr("Turista")
                            font.pixelSize: 64
                            font.bold: true
                            font.letterSpacing: 1
                            color: root.appWindow.dark
                            horizontalAlignment: Text.AlignHCenter
                        }
                    }
                }
            }
        }

        Rectangle {
            id: rectangleRight
            color: root.appWindow.light
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

                Label {
                    id: loginError
                    color: "red"
                    font.pixelSize: 14
                    visible: false
                    Layout.alignment: Qt.AlignCenter
                }

                Button {
                    id: login
                    text: "Login"

                    Layout.topMargin: -8
                    Layout.alignment: Qt.AlignHCenter

                    contentItem: Text {
                        text: login.text
                        font: login.font
                        color: "#2b1a12"
                        horizontalAlignment: Text.AlignHCenter
                        verticalAlignment: Text.AlignVCenter
                    }

                    background: Rectangle {
                        implicitWidth: 120
                        implicitHeight: 36
                        radius: 8

                        color: login.down ? "#e1502f" : "#ff6b4a"

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

                    onClicked: {
                        loginError.visible = false

                        if (!UserManager.authenticate(username.text, password.text))
                        {
                            loginError.text = "Username or password is incorrect"
                            loginError.visible = true
                            return
                        }

                        User.username = username.text
                        root.appWindow.lightMode = !root.appWindow.lightMode
                        root.pageStack.push("SearchPage.qml", { pageStack: root.pageStack, appWindow: root.appWindow })
                    }
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
                            color: "#c64524"
                            font.pixelSize: 14
                            horizontalAlignment: Text.AlignHCenter
                            verticalAlignment: Text.AlignVCenter

                            scale: createAccount.down ? 0.97 : 1
                        }

                        onClicked: {
                            root.pageStack.push("AccountCreation.qml", { pageStack: root.pageStack, appWindow: root.appWindow })
                        }
                    }

                }
            }
        }
    }

}
