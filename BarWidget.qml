import QtQuick 2.15
import QtQuick.Layouts 1.15

Item {
    id: root

    // === Omarchy bar integration contract ===
    property QtObject bar: null
    property string moduleName: "selomrani.sysmon"
    property bool interactive: true
    property bool pressable: true

    // === Sizing (standard bar icon) ===
    implicitWidth: 24
    implicitHeight: 24
    width: 24
    height: 24
    Layout.preferredWidth: 24
    Layout.preferredHeight: 24
    Layout.fillHeight: true

    // === Internal state ===
    property bool panelOpen: false
    property bool _debouncing: false

    signal pressed(int button)

    // Debounce: prevents double-toggle if both modulePointer AND
    // fallback MouseArea fire on the same click
    Timer {
        id: debounceTimer
        interval: 250
        repeat: false
        onTriggered: root._debouncing = false
    }

    // =====================================================
    // Omarchy click contract: Bar.qml's ModuleSlot wraps
    // every widget in a mousePointer MouseArea that calls
    // pressModuleClickTarget → triggerPress(button).
    // This is the ONLY reliable click entry point.
    // =====================================================
    function triggerPress(button) {
        if (root._debouncing) return;
        root._debouncing = true;
        debounceTimer.restart();

        console.log("[sysmon] triggerPress, button=" + button + " panelOpen=" + panelOpen);
        root.pressed(button);

        root.panelOpen = !root.panelOpen;
        panelContainer.visible = root.panelOpen;

        if (panelLoader.item) {
            panelLoader.item.visible = root.panelOpen;
        }
    }

    // === Click target registration ===
    function syncRegistration() {
        if (root.bar && typeof root.bar.registerClickTarget === "function") {
            root.bar.registerClickTarget(root);
            console.log("[sysmon] click target registered");
        }
    }

    onBarChanged: syncRegistration()
    Component.onCompleted: {
        syncRegistration();
        console.log("[sysmon] BarWidget loaded, bar=" + root.bar);
    }
    Component.onDestruction: {
        if (root.bar && typeof root.bar.unregisterClickTarget === "function") {
            root.bar.unregisterClickTarget(root);
        }
    }

    // === Icon ===
    Image {
        id: iconImg
        anchors.centerIn: parent
        source: Qt.resolvedUrl("icon.png")
        width: 16
        height: 16
        sourceSize.width: 32
        sourceSize.height: 32
        fillMode: Image.PreserveAspectFit
        opacity: root.panelOpen ? 1.0 : 0.7
        Behavior on opacity { NumberAnimation { duration: 120 } }
    }



    // === Inline panel (managed by bar widget, not by shell) ===
    // With kinds: ["bar-widget"] only, the shell does NOT create a
    // panel entry. The bar widget manages its own panel internally,
    // exactly like the weather/clock first-party plugins.
    Item {
        id: panelContainer
        visible: false
        x: -148   // center 320px popup on 24px icon
        y: root.height + 6
        width: 320
        height: 148
        z: 99999

        Loader {
            id: panelLoader
            anchors.fill: parent
            source: Qt.resolvedUrl("Plugin.qml")
            active: true
            onLoaded: {
                console.log("[sysmon] Plugin.qml loaded");
                item.visible = false;  // start hidden, triggerPress controls visibility
                if (typeof item.closeRequested !== "undefined") {
                    item.closeRequested.connect(function() {
                        root.panelOpen = false;
                        panelContainer.visible = false;
                        if (panelLoader.item) panelLoader.item.visible = false;
                    });
                }
            }
        }
    }
}
