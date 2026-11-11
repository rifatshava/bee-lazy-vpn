import QtQuick
import QtQuick.Layouts
import Style 1.0
import "../Controls2/TextTypes"

RowLayout {
    spacing: 10
    Image {
        Layout.preferredWidth: 34
        Layout.preferredHeight: 34
        source: "qrc:/images/bee-lazy-logo.jpg"
        fillMode: Image.PreserveAspectFit
        mipmap: true
    }
    H3TextType {
        text: "Bee Lazy"
        color: AmneziaStyle.color.textPrimary
    }
}
