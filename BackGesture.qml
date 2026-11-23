import QtQuick
import QtQuick.Shapes
import Quickshell
import Quickshell.Wayland

PanelWindow {
    id: root
    anchors { left: true; top: true; bottom: true }
    exclusionMode: ExclusionMode.Ignore
    WlrLayershell.layer: WlrLayer.Overlay
    WlrLayershell.namespace: "quickshell-back-gesture"

    implicitWidth: (isDragging || bubble.pull > 1) ? 120 : 4
    color: "transparent"

    property bool isDragging: false
    property real startX: 0
    property real startY: 0
    property real fingerY: 0
    property real dragDistance: 0
    property bool thresholdReached: dragDistance >= 65
    property real followFactor: 0.1

    function goBack() {
        Quickshell.execDetached(["hyprctl", "dispatch", "sendshortcut", "ALT, Left, activewindow"])
    }

    Item {
        id: bubble
        x: 0
        y: Math.max(0, Math.min(root.height - height, root.startY + (root.fingerY - root.startY) * root.followFactor - height / 2))
        width: 90
        height: 160
        visible: root.isDragging || pull > 1

        property real pull: Math.min(root.dragDistance * 0.75, 70)

        Behavior on y {
            enabled: root.dragDistance > 0
            NumberAnimation { duration: 160; easing.type: Easing.OutQuad }
        }

        Behavior on pull {
            NumberAnimation {
                duration: root.isDragging ? 140 : 600
                easing.type: root.isDragging ? Easing.OutQuad : Easing.OutBack
                easing.overshoot: 1.4
            }
        }

        Shape {
            anchors.fill: parent
            antialiasing: true
            layer.enabled: true
            layer.samples: 4
            ShapePath {
                strokeWidth: 0
                fillColor: "#000000"
                startX: 0; startY: 0
                PathCubic { x: bubble.pull; y: 80; control1X: 0; control1Y: 45; control2X: bubble.pull; control2Y: 50 }
                PathCubic { x: 0; y: 160; control1X: bubble.pull; control1Y: 110; control2X: 0; control2Y: 115 }
            }
        }

        Shape {
            antialiasing: true
            x: bubble.pull * 0.45
            y: 80
            opacity: Math.min(bubble.pull / 40, 1)
            scale: root.thresholdReached ? 1.2 : 1
            Behavior on scale { NumberAnimation { duration: 120; easing.type: Easing.OutCubic } }
            ShapePath {
                strokeWidth: 3
                strokeColor: "#ffffff"
                fillColor: "transparent"
                capStyle: ShapePath.RoundCap
                joinStyle: ShapePath.RoundJoin
                startX: 4; startY: -9
                PathLine { x: -5; y: 0 }
                PathLine { x: 4; y: 9 }
            }
        }
    }

    MouseArea {
        anchors.fill: parent
        acceptedButtons: Qt.LeftButton
        onPressed: (m) => {
            root.isDragging = true
            root.startX = m.x
            root.startY = m.y
            root.fingerY = m.y
            root.dragDistance = 0
        }
        onPositionChanged: (m) => {
            if (!root.isDragging) return
            root.dragDistance = Math.max(0, m.x - root.startX)
            root.fingerY = m.y
        }
        onReleased: {
            if (!root.isDragging) return
            if (root.thresholdReached) root.goBack()
            root.isDragging = false
            root.dragDistance = 0
        }
        onCanceled: { root.isDragging = false; root.dragDistance = 0 }
    }
}
