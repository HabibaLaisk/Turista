pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Rectangle {
    id: root
    color: appWindow ? appWindow.reallyDark : "#f0e4d0"

    property StackView pageStack
    property var appWindow
    property var results: []

    ColumnLayout {
        anchors.fill: parent
        anchors.margins: 24
        spacing: 16

        RowLayout {
            Layout.fillWidth: true
            spacing: 14

            Button {
                id: backButton
                text: "Back"

                contentItem: Text {
                    text: backButton.text
                    font: backButton.font
                    color: "#2b211a"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    implicitWidth: 120
                    implicitHeight: 36
                    radius: 8
                    border.color: "#d8c6ac"
                    border.width: 1

                    color: backButton.down ? "#d8c6ac" : "#e4d6c3"
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

            Label {
                text: root.results.length + " results found"
                color: "#2b211a"
                font.pixelSize: 20
                font.bold: true
                Layout.fillWidth: true
            }

            Button {
                id: profileButton
                text: "Profile"

                contentItem: Text {
                    text: profileButton.text
                    font: profileButton.font
                    color: "#2b1a12"
                    horizontalAlignment: Text.AlignHCenter
                    verticalAlignment: Text.AlignVCenter
                }

                background: Rectangle {
                    implicitWidth: 120
                    implicitHeight: 36
                    radius: 8

                    color: profileButton.down ? "#e1502f" : "#ff6b4a"
                    scale: profileButton.down ? 0.97 : 1.0

                    Behavior on color {
                        ColorAnimation { duration: 100 }
                    }

                    Behavior on scale {
                        NumberAnimation { duration: 100 }
                    }
                }
                onClicked: root.pageStack.push("ProfilePage.qml", { pageStack: root.pageStack, appWindow: root.appWindow })
            }
        }

        GridView {
            id: resultsView
            Layout.fillWidth: true
            Layout.fillHeight: true
            clip: true
            cellWidth: 236
            cellHeight: 256
            model: root.results
            delegate: resultCardComponent
        }
    }

    Component {
        id: resultCardComponent

        Rectangle {
            id: card
            required property string id
            required property string title
            required property string category
            required property string location
            required property string date
            required property string price
            required property string description
            required property string imageUrl
            required property string source
            required property string url
            required property real rating
            property bool isFavorited: false

            width: GridView.view ? GridView.view.cellWidth - 12 : 220
            height: GridView.view ? GridView.view.cellHeight - 12 : 240
            radius: 10
            color: "#fbf3e6"
            border.color: "#e6d7c0"
            border.width: 1
            clip: true

            ColumnLayout {
                anchors.fill: parent
                anchors.margins: 12
                spacing: 4

                Image {
                    Layout.fillWidth: true
                    Layout.preferredHeight: 80
                    source: card.imageUrl
                    fillMode: Image.PreserveAspectCrop
                    asynchronous: true
                    visible: card.imageUrl.length > 0
                    clip: true
                }

                RowLayout {
                    Layout.fillWidth: true
                    spacing: 6

                    Rectangle {
                        radius: 4
                        color: card.source === "Yelp" ? "#d32323" : "#1b7a72"
                        implicitWidth: sourceLabel.implicitWidth + 10
                        implicitHeight: sourceLabel.implicitHeight + 4

                        Text {
                            id: sourceLabel
                            anchors.centerIn: parent
                            text: card.source
                            color: "white"
                            font.pixelSize: 10
                            font.bold: true
                        }
                    }

                    Item { Layout.fillWidth: true }

                    Text {
                        text: "★ " + card.rating.toFixed(1)
                        color: "#8c6a1f"
                        font.pixelSize: 12
                        font.bold: true
                        visible: card.rating > 0
                    }
                    Text {
                                        text: card.isFavorited ? "♥" : "♡"
                                        color: card.isFavorited ? "#d32323" : "#8a7563"
                                        font.pixelSize: 16

                                        MouseArea {
                                            anchors.fill: parent
                                            cursorShape: Qt.PointingHandCursor
                                            onClicked: {
                                           if (card.isFavorited) {
                                           UserManager.removeFavorite(User.username, card.id)
                                           card.isFavorited = false
                                         } else {
                                           UserManager.addFavorite(User.username, card.id, card.title,
                                           card.category, card.location, card.date, card.price,
                                           card.description, card.imageUrl, card.source, card.url, card.rating)
                                           card.isFavorited = true
                                        }
                                        console.log("Favorites now:", JSON.stringify(UserManager.getFavorites(User.username)))
                                                }
                                        }
                                    }

                }

                Text {
                    text: card.title
                    color: "#2b211a"
                    font.pixelSize: 14
                    font.bold: true
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Text {
                    text: [card.category, card.price]
                        .filter(function (s) { return s.length > 0 })
                        .join(" · ")
                    color: "#8a7563"
                    font.pixelSize: 11
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    visible: text.length > 0
                }

                Text {
                    text: card.date
                    color: "#8a7563"
                    font.pixelSize: 11
                    visible: card.date.length > 0
                    Layout.fillWidth: true
                }

                Text {
                    text: card.location
                    color: "#8a7563"
                    font.pixelSize: 11
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Item { Layout.fillHeight: true }

                Text {
                    text: "View ↗"
                    color: "#c64524"
                    font.pixelSize: 11
                    font.bold: true
                    visible: card.url.length > 0

                    MouseArea {
                        anchors.fill: parent
                        cursorShape: Qt.PointingHandCursor
                        onClicked: Qt.openUrlExternally(card.url)
                    }
                }
            }
        }
    }
}
