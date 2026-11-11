import QtQuick
import QtQuick.Layouts
import Style 1.0
import "../Controls2/TextTypes"

ColumnLayout {
    id: root
    spacing: 8
    BeeBrandHeader {
        Layout.alignment: Qt.AlignHCenter
    }
    H1TextType {
        Layout.fillWidth: true
        Layout.leftMargin: 16
        Layout.rightMargin: 16
        Layout.topMargin: 8
        text: ConnectionController.isConnectionInProgress ? ConnectionController.connectionStateText
              : ConnectionController.isConnected ? qsTr("Ваше соединение\nпод защитой")
              : qsTr("Ваш личный\nвыход в интернет")
        font.pixelSize: root.height < 360 ? 24 : 30
        lineHeight: root.height < 360 ? 30 : 38
        horizontalAlignment: Text.AlignHCenter
    }
    Item {
        Layout.fillWidth: true
        Layout.fillHeight: true
        Layout.minimumHeight: 120
        ConnectButton {
            anchors.centerIn: parent
            width: Math.min(250, parent.width - 48, parent.height)
            height: width
        }
    }
    CaptionTextType {
        Layout.alignment: Qt.AlignHCenter
        text: ConnectionController.connectionStateText
        color: ConnectionController.isConnected ? AmneziaStyle.color.textAccent : AmneziaStyle.color.textSecondary
    }
}
