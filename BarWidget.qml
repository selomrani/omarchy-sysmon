import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: root

    property QtObject bar: null
    property string moduleName: "selomrani.sysmon"
    property bool interactive: true
    property bool pressable: true

    implicitWidth: 24
    implicitHeight: 24
    width: 24
    height: 24
    Layout.preferredWidth: 24
    Layout.preferredHeight: 24
    Layout.fillHeight: true

    signal pressed(int button)

    // Omarchy bar click contract: Bar.qml dispatches clicks via triggerPress()
    function triggerPress(button) {
        root.pressed(button);

        // 1. Trigger via Omarchy shell IPC
        if (root.bar && typeof root.bar.run === "function") {
            root.bar.run("omarchy-shell shell toggle selomrani.sysmon");
        }

        // 2. Direct toggle on nested panel if loaded
        if (panelLoader.item) {
            panelLoader.item.toggle();
        }
    }

    // Register with Omarchy bar's click dispatcher
    function syncRegistration() {
        if (root.bar && typeof root.bar.registerClickTarget === "function") {
            root.bar.registerClickTarget(root);
        }
    }

    onBarChanged: syncRegistration()
    Component.onCompleted: syncRegistration()
    Component.onDestruction: {
        if (root.bar && typeof root.bar.unregisterClickTarget === "function") {
            root.bar.unregisterClickTarget(root);
        }
    }

    // 100% transparent icon with NO background box or border
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
        acceptedButtons: Qt.LeftButton | Qt.RightButton

        onClicked: root.triggerPress(mouse.button)
        onPressed: root.triggerPress(mouse.button)
    }

    Loader {
        id: panelLoader
        source: Qt.resolvedUrl("Plugin.qml")
        active: true
        visible: false
    }
}
