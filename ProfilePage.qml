pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Rectangle {
    id: root
    color: appWindow ? appWindow.reallyDark : "#f0e4d0"

    property StackView pageStack
    property var appWindow

    ListModel {
        id: favoritesModel
    }

    function refreshFavorites() {
        favoritesModel.clear()
        var favorites = UserManager.getFavorites(User.username)
        for (var i = 0; i < favorites.length; i++) {
            favoritesModel.append(favorites[i])
        }
    }

    Component.onCompleted: refreshFavorites()

    ScrollView {
        anchors.fill: parent
        contentWidth: availableWidth

        ColumnLayout {
            width: parent.width
            spacing: 20

            Label {
                text: qsTr("My Profile")
                font.pixelSize: 28
                color: "#2b211a"
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 20
            }

            Label {
                text: User.username
                font.pixelSize: 20
                color: "#2b211a"
                Layout.alignment: Qt.AlignHCenter
            }

            Label {
                text: qsTr("Favorited Events")
                font.pixelSize: 18
                color: "#2b211a"
                Layout.leftMargin: 20
            }

            ListView {
                id: favoritesList
                Layout.fillWidth: true
                Layout.preferredHeight: 300
                Layout.leftMargin: 20
                Layout.rightMargin: 20
                model: favoritesModel
                spacing: 8

                delegate: Rectangle {
                    id: favItem
                    required property string id
                    required property string title
                    required property string location
                    required property string date
                    required property string price
                    required property string url

                    width: favoritesList.width
                    height: 60
                    color: "#fbf3e6"
                    border.color: "#e6d7c0"
                    radius: 5

                    RowLayout {
                        anchors.fill: parent
                        anchors.margins: 10

                        ColumnLayout {
                            Layout.fillWidth: true
                            spacing: 2

                            Label {
                                text: favItem.title
                                color: "#2b211a"
                                font.pixelSize: 14
                                font.bold: true
                            }
                            Label {
                                text: favItem.location + " · " + favItem.date
                                color: "#8a7563"
                                font.pixelSize: 11
                            }
                        }
                        Label {
                                                    text: favItem.price
                                                    color: "#8a7563"
                                                }

                                                Text {
                                                    text: "View ↗"
                                                    color: "#c64524"
                                                    font.pixelSize: 11
                                                    font.bold: true
                                                    visible: favItem.url.length > 0

                                                    MouseArea {
                                                        anchors.fill: parent
                                                        cursorShape: Qt.PointingHandCursor
                                                        onClicked: Qt.openUrlExternally(favItem.url)
                                                    }
                                                }

                                                Button {
                                                    text: "Remove"
                                                    onClicked: {
                                                        UserManager.removeFavorite(User.username, favItem.id)
                                                        root.refreshFavorites()
                                                    }
                                                }

                    }
                }
            }

            Button {
                text: "Back"
                Layout.alignment: Qt.AlignHCenter
                Layout.topMargin: 10
                Layout.bottomMargin: 20
                onClicked: pageStack.pop()
            }
        }
    }
}