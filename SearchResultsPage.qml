pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

Rectangle {
    id: root
    color: appWindow ? appWindow.reallyDark : "#1f1f1f"

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

            Label {
                text: root.results.length + " results found"
                color: "white"
                font.pixelSize: 20
                font.bold: true
                Layout.fillWidth: true
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

            width: GridView.view ? GridView.view.cellWidth - 12 : 220
            height: GridView.view ? GridView.view.cellHeight - 12 : 240
            radius: 10
            color: "#2a2a2a"
            border.color: "#3a3a3a"
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
                        color: card.source === "Yelp" ? "#d32323" : "#0077CC"
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
                        color: "#e3ac3a"
                        font.pixelSize: 12
                        visible: card.rating > 0
                    }
                }

                Text {
                    text: card.title
                    color: "white"
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
                    color: "#9a9a9a"
                    font.pixelSize: 11
                    wrapMode: Text.WordWrap
                    Layout.fillWidth: true
                    visible: text.length > 0
                }

                Text {
                    text: card.date
                    color: "#9a9a9a"
                    font.pixelSize: 11
                    visible: card.date.length > 0
                    Layout.fillWidth: true
                }

                Text {
                    text: card.location
                    color: "#9a9a9a"
                    font.pixelSize: 11
                    wrapMode: Text.WordWrap
                    maximumLineCount: 2
                    elide: Text.ElideRight
                    Layout.fillWidth: true
                }

                Item { Layout.fillHeight: true }

                Text {
                    text: "View ↗"
                    color: "#0077CC"
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
