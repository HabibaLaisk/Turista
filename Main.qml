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
    property color reallyDark: "#f0e4d0"
    property color dark: "#2b211a"
    property color reallyLight: "#fbf3e6"
    property color light: "#f0e4d0"

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
