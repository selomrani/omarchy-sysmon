import QtQuick 2.15

Item {
    width: 24
    height: 24

    Image {
        anchors.centerIn: parent
        source: Qt.resolvedUrl("icon.svg")
        width: 18
        height: 18
        sourceSize.width: 18
        sourceSize.height: 18
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        acceptedButtons: Qt.LeftButton
        
        // CRITICAL FIX: These allow the parent Omarchy Bar to "steal" the mouse
        // event if the user is trying to click-and-drag the widget to move it!
        preventStealing: false
        propagateComposedEvents: true

        onClicked: {
            if (typeof Omarchy !== "undefined" && Omarchy.toggleOverlay) {
                Omarchy.toggleOverlay("selomrani.sysmon")
            } else if (typeof Shell !== "undefined" && Shell.toggleOverlay) {
                Shell.toggleOverlay("selomrani.sysmon")
            }
        }
    }
}
