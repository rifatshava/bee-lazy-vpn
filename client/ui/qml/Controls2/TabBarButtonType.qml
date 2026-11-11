import QtQuick
import QtQuick.Controls
import QtQuick.Controls.impl
import "TextTypes"

import Style 1.0

TabButton {
    id: root

    property bool showBadge: false

    implicitWidth: 84
    implicitHeight: 54
    width: Math.min(84, Math.max(44, (parent && parent.parent ? parent.parent.width - 24 : 280) / 4))
    height: 54

    hoverEnabled: true

    padding: 0

    icon.width: 24
    icon.height: 24
    icon.color: root.checked ? AmneziaStyle.color.textAccent : AmneziaStyle.color.iconDefault

    Accessible.name: root.text

    background: Rectangle {
        radius: 18
        color: root.checked ? AmneziaStyle.color.bgAccentSubtle : AmneziaStyle.color.transparent
        FocusRingType {
            radius: 12
            visible: root.visualFocus
        }
    }

    contentItem: Item {
        implicitWidth: 84
        implicitHeight: 54

        IconImage {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.top: parent.top
            anchors.topMargin: 5

            width: root.icon.width
            height: root.icon.height

            source: root.icon.source
            sourceSize: Qt.size(root.icon.width, root.icon.height)
            color: root.icon.color

            DotBadgeType {
                anchors.horizontalCenter: parent.left
                anchors.horizontalCenterOffset: 20.5
                anchors.verticalCenter: parent.top
                anchors.verticalCenterOffset: 3.5

                visible: root.showBadge
                color: AmneziaStyle.color.accentLight
            }
        }
        CaptionTextType {
            anchors.horizontalCenter: parent.horizontalCenter
            anchors.bottom: parent.bottom
            anchors.bottomMargin: 4
            text: root.text
            font.pixelSize: 10
            color: root.checked ? AmneziaStyle.color.textAccent : AmneziaStyle.color.textSecondary
        }
    }

    HoverHandler {
        cursorShape: Qt.PointingHandCursor
    }

    Keys.onEnterPressed: {
        root.checked = true
        root.clicked()
    }
    Keys.onReturnPressed: {
        root.checked = true
        root.clicked()
    }
}
