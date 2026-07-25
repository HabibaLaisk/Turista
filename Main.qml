pragma ComponentBehavior: Bound
import QtQuick
import QtQuick.Controls.Basic


ApplicationWindow {
    id: window
    width: 840
    height: 480
    minimumWidth: 200
    minimumHeight: 250
    visible: true
    title: "Turista"
    property bool lightMode: Application.styleHints.colorScheme === Qt.Light
    property color reallyDark: "#1f1f1f"
    property color dark: "#262626"
    property color reallyLight: "#e7e7e7"
    property color light: "#e0e0e0"

    StackView {
        id: stackView
        anchors.fill: parent

        initialItem: loginComponent
    }

    Component {
        id: loginComponent

        LoginPage {
            pageStack: stackView
            appWindow: window
        }
    }
}
