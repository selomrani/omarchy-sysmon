import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: root
    width: 320
    height: 140

    // SystemPalette allows us to automatically adapt to Omarchy's current light/dark theme colors
    SystemPalette { id: theme; colorGroup: SystemPalette.Active }

    // Properties for our animated mocked data (until wired to Omarchy's backend)
    property real cpuUsage: 0.45
    property real ramUsage: 0.60
    property real netUsage: 0.30

    // Timer to simulate live data breathing
    Timer {
        interval: 2000; running: true; repeat: true
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
        
        // Semi-transparent background for a modern glass look, adapting to system theme
        color: Qt.rgba(theme.window.r, theme.window.g, theme.window.b, 0.85)
        
        // Subtle border
        border.color: Qt.rgba(theme.text.r, theme.text.g, theme.text.b, 0.15)
        border.width: 1

        ColumnLayout {
            anchors.fill: parent
            anchors.margins: 20
            spacing: 12

            // Header
            RowLayout {
                Layout.fillWidth: true
                Text {
                    text: "SYSTEM MONITOR"
                    font.pixelSize: 12
                    font.bold: true
                    letterSpacing: 1.5
                    color: Qt.rgba(theme.text.r, theme.text.g, theme.text.b, 0.6)
                }
                Item { Layout.fillWidth: true }
                // Pulsing dot indicator
                Rectangle {
                    width: 8; height: 8; radius: 4
                    color: "#22c55e"
                    SequentialAnimation on opacity {
                        loops: Animation.Infinite
                        NumberAnimation { to: 0.3; duration: 1000 }
                        NumberAnimation { to: 1.0; duration: 1000 }
                    }
                }
            }

            // CPU Bar
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
                        color: "#3b82f6" // Sleek Blue
                        Behavior on width { NumberAnimation { duration: 800; easing.type: Easing.OutCubic } }
                    }
                }
                Text { text: Math.round(root.cpuUsage * 100) + "%"; color: theme.text; font.pixelSize: 12; Layout.preferredWidth: 35; horizontalAlignment: Text.AlignRight }
            }

            // RAM Bar
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
                        color: "#8b5cf6" // Sleek Purple
                        Behavior on width { NumberAnimation { duration: 800; easing.type: Easing.OutCubic } }
                    }
                }
                Text { text: Math.round(root.ramUsage * 100) + "%"; color: theme.text; font.pixelSize: 12; Layout.preferredWidth: 35; horizontalAlignment: Text.AlignRight }
            }
        }
    }
}
