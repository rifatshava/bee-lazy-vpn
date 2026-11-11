import QtQuick
import Style 1.0

Item {
    clip: true
    enabled: false
    Rectangle {
        width: parent.width * 1.5
        height: parent.height * 0.45
        x: -width * 0.3
        y: -height * 0.65
        radius: height * 0.5
        rotation: -24
        gradient: Gradient {
            GradientStop { position: 0; color: AmneziaStyle.color.bgAccentSubtle }
            GradientStop { position: 1; color: AmneziaStyle.color.bgBase }
        }
    }
    Rectangle {
        width: parent.width * 1.7
        height: parent.height * 0.28
        x: -width * 0.15
        y: parent.height * 0.9
        radius: height * 0.5
        rotation: -18
        opacity: 0.6
        gradient: Gradient {
            GradientStop { position: 0; color: AmneziaStyle.color.bgAccentSubtle }
            GradientStop { position: 1; color: AmneziaStyle.color.bgBase }
        }
    }
}
