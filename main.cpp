
#include <QGuiApplication>
#include <QQmlApplicationEngine>
#include <QQmlContext>

int main(int argc, char *argv[])
{
    QGuiApplication app(argc, argv);

    QQmlApplicationEngine engine;

    const QUrl url(QStringLiteral("qrc:/main.qml"));

    QVariantList data;
/*
    for (double x = 0; x < 12.0; x = x + 0.1) {
        data.append(QVariant(QVariantList{x, 50 + 50 *sin(x)}));
    }*/

    data.append(QVariant(QVariantList{32, 0  }));
    data.append(QVariant(QVariantList{33, 58 }));
    data.append(QVariant(QVariantList{34, 98 }));
    data.append(QVariant(QVariantList{35, 105 }));
    data.append(QVariant(QVariantList{36, 108 }));
    data.append(QVariant(QVariantList{37, 103 }));
    data.append(QVariant(QVariantList{38, 103 }));
    data.append(QVariant(QVariantList{39, 104 }));
    data.append(QVariant(QVariantList{40, 105 }));
    data.append(QVariant(QVariantList{41, 104 }));
    data.append(QVariant(QVariantList{42, 103 }));
    data.append(QVariant(QVariantList{43, 104 }));
    data.append(QVariant(QVariantList{44, 104 }));
    data.append(QVariant(QVariantList{45, 105 }));
    data.append(QVariant(QVariantList{46, 103 }));
    data.append(QVariant(QVariantList{47, 103 }));
    data.append(QVariant(QVariantList{48, 103 }));
    data.append(QVariant(QVariantList{49, 102 }));
    data.append(QVariant(QVariantList{50, 101 }));
    data.append(QVariant(QVariantList{51, 102 }));
    data.append(QVariant(QVariantList{52, 103 }));
    data.append(QVariant(QVariantList{53, 104 }));
    data.append(QVariant(QVariantList{54, 103 }));
    data.append(QVariant(QVariantList{55, 90 }));
    data.append(QVariant(QVariantList{56, 85 }));
    data.append(QVariant(QVariantList{57, 73 }));
    data.append(QVariant(QVariantList{58, 57 }));
    data.append(QVariant(QVariantList{59, 48 }));
    data.append(QVariant(QVariantList{60, 50 }));
    data.append(QVariant(QVariantList{61, 51 }));
    data.append(QVariant(QVariantList{62, 52 }));
    data.append(QVariant(QVariantList{63, 54 }));
    data.append(QVariant(QVariantList{64, 52 }));
    data.append(QVariant(QVariantList{65, 51 }));
    data.append(QVariant(QVariantList{66, 48 }));
    data.append(QVariant(QVariantList{67, 0 }));

    engine.rootContext()->setContextProperty("lineData", data);


    engine.load(url);

    return app.exec();
}
