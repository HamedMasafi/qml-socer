import QtQuick 2.0
import Box2D 2.0

Rectangle {
    id: chainBall

    width: size
    height: size
    color: isWhite ? "white" : "black"
    radius: size / 2
    border.color: 'gray'

    property Body body: circleBody

    property int size: units.dp(40)
    property alias restitution: circleBody.restitution
    property alias density: circleBody.density
    property alias friction: circleBody.friction
    property bool isWhite: true
    property bool isActive: false

    signal moveStarted()
    signal moveEnded()

    signal mousePressed();
    signal mouseMoved();
    signal mouseReleased();

    Image{
        id: selection
        visible: isActive
        opacity: 0.5
        source: "qrc:/glow.png"
        fillMode: Image.Stretch
        rotation: Math.random() * 360

        anchors{
            fill: parent
            leftMargin: -10
            rightMargin: -10
            topMargin: -10
            bottomMargin: -10
        }
    }

    PropertyAnimation{
        running: true
        target: selection
        property: 'rotation'
        duration: 4000
        from: 0
        to: 360
        loops: Animation.Infinite
    }

    CircleBody {
        id: circleBody
        target: chainBall
//        world: physicsWorld
        linearDamping: 1
        angularDamping: 2
        bodyType: Body.Dynamic
        radius: chainBall.radius
        restitution: 0.2        // بازگشت
        friction: 50            // اصطکال
        density: 60             // تراکم

//        onLinearVelocityChanged: console.log("linearVelocity")
//        onLinearDampingChanged: console.log(linearDamping)

    }
}
