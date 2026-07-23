import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic
import Turista


GridLayout {
    id: grid
    columns: width < 400 ? 1 : 2
    rowSpacing: 0
    columnSpacing: 0

    property StackView pageStack


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
                text: qsTr("Account Creation")
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
                id: createUsername
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
                    text: "Create Password "
                    font.pixelSize: 16
                }

                TextField {
                    id: createPassword
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

            RowLayout {
                Layout.alignment: Qt.AlignHCenter
                spacing: 10

                Label {
                    text: "Re-Enter Password "
                    font.pixelSize: 16
                }

                TextField {
                    id: reenterPassword
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
                id:formError
                color: "red"
                font.pixelSize: 14
                visible: false
                Layout.alignment: Qt.AlignCenter
            }


            Button {
                id: login
                text: "Create Account"

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

                onClicked: {
                    formError.visible = false
                    if (createPassword.text.trim().length === 0 && createUsername.text.trim().length === 0)
                    {
                        formError.text = "Enter username and password"
                        formError.visible = true
                        return
                    }

                    else if (createPassword.text !== reenterPassword.text)
                    {
                        formError.text = "Passwords do not match"
                        formError.visible = true
                        return
                    }
                    else if (createPassword.text.trim().length === 0)
                    {
                        formError.text = "Enter a password"
                        formError.visible = true
                        return
                    }
                    else if (createUsername.text.trim().length === 0)
                    {
                        formError.text = "Enter a username"
                        formError.visible = true
                        return
                    }

                    User.setUsername(createUsername.text)
                    User.setPassword(createPassword.text)

                    window.lightMode = !window.lightMode
                    pageStack.pop()
                }

            }
        }
    }


}
