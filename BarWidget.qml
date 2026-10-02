import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: widget
    implicitWidth: 32
    implicitHeight: 32
    width: 32
    height: 32
    Layout.preferredWidth: 32
    Layout.preferredHeight: 32
    Layout.fillHeight: true

    Image {
        anchors.centerIn: parent
        source: Qt.resolvedUrl("icon.svg")
        width: 20
        height: 20
        sourceSize.width: 20
        sourceSize.height: 20
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        
        // Allow parent bar to handle drag/reposition events
        preventStealing: false
        propagateComposedEvents: true

        onClicked: {
            if (typeof Omarchy !== "undefined") {
                if (typeof Omarchy.summon === "function") {
                    Omarchy.summon("selomrani.sysmon");
                } else if (typeof Omarchy.summonOverlay === "function") {
                    Omarchy.summonOverlay("selomrani.sysmon");
                } else if (typeof Omarchy.toggleOverlay === "function") {
                    Omarchy.toggleOverlay("selomrani.sysmon");
                }
            } else if (typeof Shell !== "undefined") {
                if (typeof Shell.summon === "function") {
                    Shell.summon("selomrani.sysmon");
                } else if (typeof Shell.toggleOverlay === "function") {
                    Shell.toggleOverlay("selomrani.sysmon");
                }
            }
        }
    }
}
