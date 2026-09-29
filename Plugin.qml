import QtQuick 2.15

Rectangle {
    id: root
    width: 300
    height: 300
    color: "red"
    visible: false

    function open(payloadJson) {
        console.log("Omarchy triggered open()!")
        root.visible = true;
    }

    function close() {
        console.log("Omarchy triggered close()!")
        root.visible = false;
    }

    Text {
        anchors.centerIn: parent
        text: "IT WORKS"
        color: "white"
        font.pixelSize: 32
        font.bold: true
    }
}
