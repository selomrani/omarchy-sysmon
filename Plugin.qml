import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    width: 320
    height: 140

    // Signal for parent (BarWidget) to handle closing
    signal closeRequested()

    // Shell compatibility (kept for forward-compat, not used in bar-widget-only mode)
    function open(payloadJson) { root.visible = true; }
    function close() { root.visible = false; }
    function toggle() { root.visible = !root.visible; }

    // Start hidden — BarWidget.triggerPress controls visibility
    visible: false

    SystemPalette { id: theme; colorGroup: SystemPalette.Active }

    property real cpuUsage: 0.45
    property real ramUsage: 0.60
    property real netUsage: 0.30

    Timer {
        interval: 2000; running: root.visible; repeat: true
        onTriggered: {
            cpuUsage = Math.max(0.1, Math.min(0.95, cpuUsage + (Math.random() * 0.2 - 0.1)))
            ramUsage = Math.max(0.2, Math.min(0.90, ramUsage + (Math.random() * 0.1 - 0.05)))
            netUsage = Math.max(0.0, Math.min(1.0, Math.random()))
        }
    }

    Rectangle {
        id: background
        anchors.fill: parent
        radius: 16
        color: Qt.rgba(theme.window.r, theme.window.g, theme.window.b, 0.90)
        border.color: Qt.rgba(theme.text.r, theme.text.g, theme.text.b, 0.15)
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 18
            spacing: 12

            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "SYSTEM MONITOR"
                    font.pixelSize: 12
                    font.bold: true
                    font.letterSpacing: 1.5
                    color: Qt.rgba(theme.text.r, theme.text.g, theme.text.b, 0.6)
                }
                Item { Layout.fillWidth: true }
                Rectangle {
                    width: 8; height: 8; radius: 4
                    color: "#22c55e"
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        running: root.visible
                        NumberAnimation { to: 0.3; duration: 1000 }
                        NumberAnimation { to: 1.0; duration: 1000 }
                    }
                }
                Item { width: 4 }
                MouseArea {
                    width: 20
                    height: 20
                    cursorShape: Qt.PointingHandCursor
                    onClicked: root.closeRequested()
                    Text {
                        anchors.centerIn: parent
                        text: "✕"
                        font.pixelSize: 12
                        color: Qt.rgba(theme.text.r, theme.text.g, theme.text.b, 0.5)
                    }
                }
            }

            RowLayout {
                Layout.fillWidth: true
                Text { text: "CPU"; color: theme.text; font.pixelSize: 14; font.bold: true; Layout.preferredWidth: 40 }
                Rectangle {
                    Layout.fillWidth: true
                    height: 8
                    radius: 4
                    color: Qt.rgba(theme.text.r, theme.text.g, theme.text.b, 0.1)
                    Rectangle {
                        width: parent.width * root.cpuUsage
                        height: parent.height
                        radius: 4
                        color: "#3b82f6"
                        Behavior on width { NumberAnimation { duration: 800; easing.type: Easing.OutCubic } }
                    }
                }
                Text { text: Math.round(root.cpuUsage * 100) + "%"; color: theme.text; font.pixelSize: 12; Layout.preferredWidth: 35; horizontalAlignment: Text.AlignRight }
            }

            RowLayout {
                Layout.fillWidth: true
                Text { text: "RAM"; color: theme.text; font.pixelSize: 14; font.bold: true; Layout.preferredWidth: 40 }
                Rectangle {
                    Layout.fillWidth: true
                    height: 8
                    radius: 4
                    color: Qt.rgba(theme.text.r, theme.text.g, theme.text.b, 0.1)
                    Rectangle {
                        width: parent.width * root.ramUsage
                        height: parent.height
                        radius: 4
                        color: "#8b5cf6"
                        Behavior on width { NumberAnimation { duration: 800; easing.type: Easing.OutCubic } }
                    }
                }
                Text { text: Math.round(root.ramUsage * 100) + "%"; color: theme.text; font.pixelSize: 12; Layout.preferredWidth: 35; horizontalAlignment: Text.AlignRight }
            }
        }
    }
}
