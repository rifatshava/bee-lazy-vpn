#include <QGuiApplication>
#include <QQmlContext>
#include <QQmlEngine>
#include <QQmlComponent>
#include <QQuickView>
#include <QTimer>
#include <QDir>
#include <QTranslator>
#include <QFontDatabase>
#include <QQmlError>
#include <iostream>

int main(int argc, char **argv)
{
    QGuiApplication app(argc, argv);
    app.setOrganizationName("BeeLazyPreview");
    app.setApplicationName("BeeLazyPreview");
    if (argc != 5) return 2;
    QQuickView view;
    QFontDatabase::addApplicationFont(":/fonts/pt-root-ui_vf.ttf");
    QObject::connect(view.engine(), &QQmlEngine::warnings, [&](const QList<QQmlError> &warnings) {
        for (const auto &warning : warnings) {
            const auto text = warning.toString();
            if (text.contains("ReferenceError") || text.contains("TypeError") || text.contains("Unable to assign") || text.contains("Binding loop")) {
                std::cerr << text.toStdString();
                std::exit(9);
            }
        }
    });
    view.engine()->addImportPath("qrc:/ui/qml/Modules");
    for (const auto *module : {"PageEnum", "ContainerProps"}) qmlRegisterModule(module, 1, 0);
    qmlRegisterModule("SortFilterProxyModel", 0, 2);
    auto mock = [&](const char *name, const QByteArray &body) {
        QQmlComponent component(view.engine());
        component.setData("import QtQuick\nQtObject {" + body + "}", QUrl());
        auto *object = component.create();
        if (!object) { std::cerr << component.errorString().toStdString(); std::exit(3); }
        object->setParent(&view);
        view.rootContext()->setContextProperty(name, object);
        return object;
    };
    const bool connected = QString(argv[1]) == "connected";
    const bool progress = QString(argv[1]) == "connecting";
    auto *connection = mock("ConnectionController", R"(
        property bool isConnected: false
        property bool isConnectionInProgress: false
        property string connectionStateText: "Подключиться"
        signal preparingConfig()
        function connectButtonClicked() {}
    )");
    connection->setProperty("isConnected", connected);
    connection->setProperty("isConnectionInProgress", progress);
    connection->setProperty("connectionStateText", connected ? "Подключено" : progress ? "Подключение…" : "Подключиться");
    mock("LanguageUiController", "function getLineHeightAppend() { return 0 }");
    mock("PageController", R"(
        property int safeAreaTopMargin: 16
        property int safeAreaBottomMargin: 16
        property int imeHeight: 0
        function closePage() {}
        function goToPage(page) {}
        function showNotificationMessage(text) {}
        function showBusyIndicator(value) {}
        function showErrorMessage(code) {}
        function closeApplication() {}
    )");
    mock("ApiNewsController", R"(
        signal fetchNewsFinished()
        signal errorOccurred(int errorCode, bool showError)
    )");
    mock("ServersUiController", R"(
        property bool hasServersFromGatewayApi: false
        property string defaultServerId: "preview"
        function serverHasOutdatedAwgContainer(id) { return false }
        function getAllInstalledServicesName(index) { return ["AmneziaWG"] }
        function isServerFromApi(id) { return false }
    )");
    mock("SettingsController", R"(
        property bool isDevModeEnabled: false
        function isNewsNotificationsEnabled() { return false }
    )");
    mock("NewsModel", "property bool hasUnread: false");
    QQmlComponent model(view.engine());
    model.setData(R"(import QtQuick
        ListModel { ListElement { serverId: "preview"; name: "Семейный VPN"; hostName: "Личный сервер"; serverDescription: "" } })", QUrl());
    auto *servers = model.create();
    if (!servers) return 4;
    servers->setParent(&view);
    view.rootContext()->setContextProperty("ServersModel", servers);
    QQmlComponent theme(view.engine());
    theme.setData(QByteArray("import QtQuick\nimport Style 1.0\nQtObject { Component.onCompleted: AmneziaStyle.lightTheme = ")
                  + (QString(argv[2]) == "light" ? "true" : "false") + " }", QUrl());
    auto *themeObject = theme.create();
    if (!themeObject) { std::cerr << theme.errorString().toStdString(); return 5; }
    themeObject->setParent(&view);
    QTranslator translator;
    if (translator.load("client/translations/amneziavpn_ru.qm")) app.installTranslator(&translator);
    const QString page = argv[3];
    view.setResizeMode(QQuickView::SizeRootObjectToView);
    view.resize(390, 760);
    if (page == "home") {
        auto *component = new QQmlComponent(view.engine(), &view);
        component->setData(R"(import QtQuick
            import QtQuick.Layouts
            import Style 1.0
            import "qrc:/ui/qml/Components"
            import "qrc:/ui/qml/Controls2"
            Rectangle {
                width: 390; height: 760; color: AmneziaStyle.color.bgBase
                BeeBackdrop { anchors.fill: parent }
                ColumnLayout {
                    anchors.fill: parent; anchors.margins: 20; spacing: 16
                    BeeConnectionHero { Layout.fillWidth: true; Layout.fillHeight: true }
                    BeeCardItem { Layout.fillWidth: true; text: "Семейный VPN"; subtitle: "AmneziaWG"; selected: true; icon.source: "qrc:/images/controls/server.svg" }
                    TabBarType {
                        Layout.fillWidth: true
                        TabBarButtonType { text: "Главная"; icon.source: "qrc:/images/controls/home.svg" }
                        TabBarButtonType { text: "Серверы"; icon.source: "qrc:/images/controls/server.svg" }
                        TabBarButtonType { text: "Настройки"; icon.source: "qrc:/images/controls/settings.svg" }
                    }
                }
            })", QUrl());
        auto *root = component->create();
        if (!root) { std::cerr << component->errorString().toStdString(); return 6; }
        view.setContent(QUrl(), component, root);
    } else {
        view.setSource(QUrl("qrc:/ui/qml/Pages2/" + page + ".qml"));
        if (view.status() == QQuickView::Error) return 7;
    }
    view.show();
    QTimer::singleShot(1500, [&]() {
        const auto picture = view.grabWindow();
        app.exit(picture.save(argv[4]) ? 0 : 8);
    });
    return app.exec();
}
