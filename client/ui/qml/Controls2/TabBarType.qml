import QtQuick
import QtQuick.Controls

import Style 1.0

TabBar {
    id: root

    spacing: 8

    topPadding: 10
    bottomPadding: PageController.safeAreaBottomMargin > 0 ? PageController.safeAreaBottomMargin : 4
    leftPadding: 16
    rightPadding: 16

    contentItem: Item {
        implicitWidth: tabsRow.implicitWidth
        implicitHeight: tabsRow.implicitHeight

        Row {
            id: tabsRow

            anchors.centerIn: parent

            spacing: root.spacing

            Repeater {
                model: root.contentModel
            }
        }
    }

    background: Rectangle {
        color: AmneziaStyle.color.bgSurfaceAlt
        radius: 24
        border.width: 1
        border.color: AmneziaStyle.color.borderSoft

        Rectangle {
            anchors.top: parent.top
            anchors.left: parent.left
            anchors.right: parent.right

            height: 0
            color: AmneziaStyle.color.borderSoft
        }
    }
}
