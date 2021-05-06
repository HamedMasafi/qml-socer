import QtQuick 2.0

Item {
    id: item1
    width: units.dp(60)
    height: units.dp(60)

    property int size: 0
    property int nutSize : 40
    property real angle: 0
    property int power: 0

    rotation: angle * 180 / Math.PI

    function shootPoint(){
        return Qt.point(
                    10 * size * Math.cos(angle),
                    10 * size * Math.sin(angle)
                    )
    }

    function show(elm){
        var center = elm.body.getWorldCenter()
        x = center.x - (width / 2)
        y = center.y - (height / 2)
        visible = true
    }

    Rectangle{
        anchors.centerIn: parent
        width: size
        height: size
        radius: size / 2
        border.color: "#a0a0d7"
        color: "#80dcde8f"
    }

    Image{
        source: "qrc:/arrow.png"
        fillMode: Image.Stretch
        x: item1.width/ 2 + (nutSize / 2)
//        transformOrigin: Item.Right

//        anchors.right: parent.right
//        anchors.rightMargin: 0
        anchors.verticalCenter: parent.verticalCenter
        height: 15
        width: size / 2
    }
}
