import QtQuick
import QtQuick.Layouts
import QtQuick.Controls.Basic

ColumnLayout {
    id: profilePage
    property StackView pageStack

    spacing: 20

    // Placeholder account data — replace with real data later
    property string username: "Jane Doe"
    property string email: "jane@example.com"

    Label {
        text: qsTr("My Profile")
        font.pixelSize: 28
        color: window.light
        Layout.alignment: Qt.AlignHCenter
        Layout.topMargin: 20
    }

    // --- Account Info Section ---
    ColumnLayout {
        Layout.alignment: Qt.AlignHCenter
        spacing: 6

        Label {
            text: profilePage.username
            font.pixelSize: 20
            color: window.light
        }
        Label {
            text: profilePage.email
            font.pixelSize: 14
            color: "gray"
        }
    }

    // --- Bookmarked Future Travels ---
    Label {
        text: qsTr("Bookmarked Trips")
        font.pixelSize: 18
        Layout.leftMargin: 20
    }

    ListView {
        id: bookmarkedList
        Layout.fillWidth: true
        Layout.preferredHeight: 150
        model: ListModel {
            ListElement { city: "Tokyo"; dateRange: "Aug 12 - Aug 20" }
            ListElement { city: "Paris"; dateRange: "Sep 5 - Sep 10" }
        }
        delegate: Rectangle {
            width: bookmarkedList.width
            height: 50
            color: "white"
            border.color: "gray"
            radius: 5

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                Label { text: city; font.pixelSize: 16; color: "black" }
                Label { text: dateRange; color:"#555555" }
            }
        }
    }

    // --- Past Travels ---
    Label {
        text: qsTr("Past Travels")
        font.pixelSize: 18
        Layout.leftMargin: 20
    }

    ListView {
        id: pastTravelsList
        Layout.fillWidth: true
        Layout.preferredHeight: 150
        model: ListModel {
            ListElement { city: "Rome"; dateRange: "Jan 3 - Jan 10" }
        }
        delegate: Rectangle {
            width: pastTravelsList.width
            height: 50
            color: "#f0f0f0"
            radius: 5

            RowLayout {
                anchors.fill: parent
                anchors.margins: 10
                Label { text: city; font.pixelSize: 16 }
                Label { text: dateRange; color: "gray" }
            }
        }
    }

    Button {
        text: "Back"
        Layout.alignment: Qt.AlignHCenter
        onClicked: pageStack.pop()
    }
}