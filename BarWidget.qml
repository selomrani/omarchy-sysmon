import QtQuick 2.15

Item {
    width: 24
    height: 24

    Image {
        anchors.centerIn: parent
        source: "icon.svg"
        width: 18
        height: 18
        sourceSize.width: 18
        sourceSize.height: 18
        fillMode: Image.PreserveAspectFit
    }

    MouseArea {
        anchors.fill: parent
        cursorShape: Qt.PointingHandCursor
        onClicked: {
            // Attempt standard API calls to trigger the overlay
            if (typeof Omarchy !== "undefined" && Omarchy.toggleOverlay) {
                Omarchy.toggleOverlay("selomrani.sysmon")
            } else if (typeof Shell !== "undefined" && Shell.toggleOverlay) {
                Shell.toggleOverlay("selomrani.sysmon")
            } else {
                console.log("Sysmon BarWidget clicked.")
            }
        }
    }
}
