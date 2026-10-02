import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: widget
    property QtObject bar: null
    property string moduleName: "selomrani.sysmon"

    // Standard Omarchy bar slot dimensions
    implicitWidth: 26
    implicitHeight: 26
    width: 26
    height: 26
    Layout.preferredWidth: 26
    Layout.preferredHeight: 26
    Layout.fillHeight: true

    Image {
        id: iconImg
        anchors.centerIn: parent
        source: Qt.resolvedUrl("icon.png")
        width: 16
        height: 16
        sourceSize.width: 32
        sourceSize.height: 32
        fillMode: Image.PreserveAspectFit
        opacity: mouseArea.containsMouse ? 1.0 : 0.8
        Behavior on opacity { NumberAnimation { duration: 150 } }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        preventStealing: false
        propagateComposedEvents: true

        onClicked: {
            if (bar && typeof bar.run === "function") {
                bar.run("omarchy-shell shell summon selomrani.sysmon");
            }
            if (panelLoader.item) {
                panelLoader.item.toggle();
            }
        }
    }

    Loader {
        id: panelLoader
        source: Qt.resolvedUrl("Plugin.qml")
        active: true
        visible: false
    }
}
