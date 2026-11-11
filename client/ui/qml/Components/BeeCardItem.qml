import QtQuick
import Style 1.0
import "../Controls2"

ListItemType {
    id: root
    property bool selected: false
    verticalPadding: 10
    background: Rectangle {
        radius: 20
        color: root.selected ? AmneziaStyle.color.bgAccentSubtle : AmneziaStyle.color.bgSurfaceAlt
        border.width: root.selected || root.visualFocus ? 2 : 1
        border.color: root.selected ? AmneziaStyle.color.borderAccent : AmneziaStyle.color.borderSoft
        opacity: root.down ? 0.7 : 1
    }
}
