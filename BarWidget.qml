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

    Rectangle {
        id: badge
        anchors.centerIn: parent
        width: 28
        height: 28
        radius: 7
        color: mouseArea.containsMouse ? Qt.rgba(1, 1, 1, 0.18) : Qt.rgba(0, 0, 0, 0.3)
        border.color: Qt.rgba(1, 1, 1, 0.15)
        border.width: 1

        Image {
            id: iconImg
            anchors.centerIn: parent
            source: Qt.resolvedUrl("icon.svg")
            width: 18
            height: 18
            sourceSize.width: 18
            sourceSize.height: 18
            fillMode: Image.PreserveAspectFit
        }

        // Fail-safe visual: If SVG fails to render or is missing, show high-contrast native QML icon
        Row {
            anchors.centerIn: parent
            spacing: 3
            visible: iconImg.status === Image.Error || iconImg.status === Image.Null

            Rectangle {
                width: 5
                height: 5
                radius: 2.5
                color: "#22c55e"
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 3
                height: 10
                radius: 1.5
                color: "#3b82f6"
                anchors.verticalCenter: parent.verticalCenter
            }

            Rectangle {
                width: 3
                height: 14
                radius: 1.5
                color: "#8b5cf6"
                anchors.verticalCenter: parent.verticalCenter
            }
        }
    }

    MouseArea {
        id: mouseArea
        anchors.fill: parent
        hoverEnabled: true
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
