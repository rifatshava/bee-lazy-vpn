import QtQuick
import QtQuick.Controls
import QtQuick.Layouts

import Style 1.0

import "../Controls2"
import "../Controls2/TextTypes"

Button {
    id: root

    property bool connected: ConnectionController.isConnected
    property bool inProgress: ConnectionController.isConnectionInProgress

    implicitWidth: 190
    implicitHeight: 190

    padding: 0
    hoverEnabled: true

    text: ConnectionController.connectionStateText

    Connections {
        target: ConnectionController

        function onPreparingConfig() {
            PageController.showNotificationMessage(qsTr("Unable to disconnect during configuration preparation"))
        }
    }

    QtObject {
        id: d

        readonly property real ringRadius: (Math.min(root.width, root.height) - 2) / 2
        readonly property color ringColor: root.connected && !root.inProgress ? AmneziaStyle.color.accentLight
                                                                               : AmneziaStyle.color.borderEmphasis
        readonly property int glowMargin: 24
    }

    background: Rectangle {
        color: AmneziaStyle.color.bgSurface
        radius: width / 2
        border.width: 1
        border.color: d.ringColor

        Rectangle {
            anchors.fill: parent
            anchors.margins: 9
            radius: width / 2
            color: AmneziaStyle.color.transparent
            border.width: 1
            border.color: AmneziaStyle.color.borderAccent
            opacity: root.connected || root.inProgress ? 0.75 : 0.25
        }
        Rectangle {
            anchors.fill: parent
            anchors.margins: 21
            radius: width / 2
            border.width: 2
            border.color: root.connected ? AmneziaStyle.color.accentLight : AmneziaStyle.color.borderMedium
            gradient: Gradient {
                GradientStop { position: 0; color: root.connected ? AmneziaStyle.color.accentLight : AmneziaStyle.color.bgPanel }
                GradientStop { position: 0.6; color: root.connected ? AmneziaStyle.color.accentDefault : AmneziaStyle.color.bgSurfaceAlt }
                GradientStop { position: 1; color: root.connected ? AmneziaStyle.color.accentDeep : AmneziaStyle.color.bgBase }
            }
            opacity: root.down ? 0.75 : 1
        }
        RingGlowType {
            anchors.fill: parent
            anchors.margins: -d.glowMargin
            color: d.ringColor
            radius: d.ringRadius
            startAngle: 100
            sweepAngle: 140
            visible: root.inProgress
            RotationAnimator on rotation {
                running: root.inProgress && root.visible
                from: 0
                to: 360
                loops: Animation.Infinite
                duration: 1800
            }
        }
        FocusRingType {
            radius: root.width / 2
            visible: root.visualFocus
        }
    }

    contentItem: Item {
        ColumnLayout {
            anchors.centerIn: parent
            width: parent.width - 48
            spacing: 6
            Image {
                Layout.alignment: Qt.AlignHCenter
                Layout.preferredWidth: root.width * 0.3
                Layout.preferredHeight: root.width * 0.3
                source: "qrc:/images/bee-lazy-logo.jpg"
                fillMode: Image.PreserveAspectFit
                mipmap: true
            }
            ButtonTextType {
                Layout.fillWidth: true
                text: root.text

                color: root.connected && !root.inProgress ? AmneziaStyle.color.textInverted : AmneziaStyle.color.textPrimary
                lineHeight: 30 + LanguageUiController.getLineHeightAppend()
                font.pixelSize: root.width < 190 ? 13 : 16
                font.weight: 700

                leftPadding: 16
                rightPadding: 16

                horizontalAlignment: Text.AlignHCenter
                verticalAlignment: Text.AlignVCenter
            }
        }
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    onClicked: {
        ConnectionController.connectButtonClicked()
    }

    Keys.onEnterPressed: root.clicked()
    Keys.onReturnPressed: root.clicked()
}
