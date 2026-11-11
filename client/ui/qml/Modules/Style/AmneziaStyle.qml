pragma Singleton

import QtQuick
import QtCore

QtObject {
    id: root
    property alias lightTheme: appearance.lightTheme
    property QtObject preferences: Settings {
        id: appearance
        category: "BeeLazyAppearance"
        property bool lightTheme: false
    }
    property QtObject color: QtObject {
        readonly property color transparent: 'transparent'

        readonly property color textPrimary: root.lightTheme ? '#23251D' : '#FAFAFA'
        readonly property color textSecondary: root.lightTheme ? '#414637' : '#E4E4E7'
        readonly property color textTertiary: root.lightTheme ? '#626955' : '#A1A1AA'
        readonly property color textQuaternary: root.lightTheme ? '#737A65' : '#86868F'
        readonly property color textInverted: '#09090B'
        readonly property color textAccent: root.lightTheme ? '#4A620E' : '#C8E65A'
        readonly property color textInfoInverse: '#0369A1'
        readonly property color textStaticWhite: '#FFFFFF'

        readonly property color bgBase: root.lightTheme ? '#F6F4EA' : '#101012'
        readonly property color bgSurface: root.lightTheme ? '#FFFEF8' : '#18181B'
        readonly property color bgSurfaceAlt: root.lightTheme ? '#ECECDD' : '#1F1F23'
        readonly property color bgSheet: root.lightTheme ? '#F2F0E5' : '#313136'
        readonly property color bgPanel: root.lightTheme ? '#DDDFCD' : '#3F3F46'
        readonly property color bgPanelAlt: root.lightTheme ? '#CDD1B9' : '#52525B'
        readonly property color bgOverlay: '#8009090B'
        readonly property color bgStateLayer: '#14FAFAFA'
        readonly property color bgStateLayerPressed: '#1AFAFAFA'
        readonly property color bgStateLayerAccent: '#14C8E65A'
        readonly property color bgSurfaceInverse: '#E4E4E7'
        readonly property color bgSurfaceInverseAlt: '#D4D4D8'
        readonly property color bgControlTrack: root.lightTheme ? '#D8DEC6' : '#1F1F23'
        readonly property color bgField: root.lightTheme ? '#FFFEF8' : '#1F1F23'
        readonly property color bgSelected: root.lightTheme ? '#E6EDCF' : '#1F1F23'
        readonly property color bgAccentSubtle: root.lightTheme ? '#DDE7B7' : '#4D8FAE16'
        readonly property color bgStaticWhite: '#FFFFFF'

        readonly property color bgAction: root.lightTheme ? '#C8E65A' : '#E4E4E7'
        readonly property color bgActionHover: root.lightTheme ? '#BDDA4D' : '#D4D4D8'
        readonly property color bgActionPress: root.lightTheme ? '#A9CC24' : '#A1A1AA'

        readonly property color borderFaint: root.lightTheme ? '#E2E2D4' : '#313136'
        readonly property color borderSoft: root.lightTheme ? '#D3D8C1' : '#3F3F46'
        readonly property color borderMedium: root.lightTheme ? '#ACB596' : '#52525B'
        readonly property color borderBold: root.lightTheme ? '#707C59' : '#A1A1AA'
        readonly property color borderEmphasis: root.lightTheme ? '#707C59' : '#E4E4E7'
        readonly property color borderAccent: '#C8E65A'
        readonly property color borderField: root.lightTheme ? '#A2AC8C' : '#52525B'
        readonly property color borderFocus: root.lightTheme ? '#617A1D' : '#E4E4E7'

        readonly property color accentLight: '#C8E65A'
        readonly property color accentDefault: '#A9CC24'
        readonly property color accentDark: '#779414'
        readonly property color accentDeep: '#43550B'

        readonly property color statusDestructive: '#F87171'
        readonly property color statusWarning: '#EAB308'
        readonly property color statusSuccess: '#4ADE80'

        readonly property color promoRecommendation: '#A78BFA'
        readonly property color promoUpdate: '#38BDF8'
        readonly property color promoOverlay: '#148B5CF6'
        readonly property color promoPink: '#DB2777'
        readonly property color promoPinkDeep: '#9D174D'

        readonly property color iconDefault: root.lightTheme ? '#424D31' : '#E4E4E7'
        readonly property color iconSecondary: root.lightTheme ? '#66734F' : '#A1A1AA'
        readonly property color iconTertiary: root.lightTheme ? '#B6C0A3' : '#3F3F46'
        readonly property color iconInverted: '#09090B'

        readonly property color shadowLayer1: '#26000000'
        readonly property color shadowLayer2: '#4D000000'
        readonly property color shadowGlow: '#B8D842'
    }
}
