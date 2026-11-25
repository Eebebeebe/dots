import QtQuick
import Caelestia.Config
import qs.components
import qs.services

Item {
    id: root
    // Slim mode: only when a (per-monitor) shell-tokens.json narrows the bar
    readonly property bool slim: Tokens.sizes.bar.innerWidth < 32

    required property ScreenState screenState

    implicitWidth: icon.implicitHeight + Tokens.padding.small
    implicitHeight: icon.implicitHeight

    StateLayer {
        // Cursed workaround to make the height larger than the parent
        anchors.fill: undefined
        anchors.centerIn: parent
        implicitWidth: implicitHeight
        implicitHeight: icon.implicitHeight + Tokens.padding.small
        radius: Tokens.rounding.full
        onClicked: root.screenState.session = !root.screenState.session
    }

    MaterialIcon {
        id: icon

        anchors.centerIn: parent

        text: "power_settings_new"
        color: Colours.palette.m3error
        fontStyle: root.slim ? Tokens.font.icon.builders.small.size(12).weight(Font.Bold).build() : Tokens.font.icon.builders.small.weight(Font.Bold).build()
    }
}
