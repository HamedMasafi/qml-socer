import QtQuick 2.0

Nut{
    id: root
    size: units.dp(20)
    friction: 20
    density: 10
    restitution: .9

    Timer{
        running: true
        repeat: true
        interval: 200
        onTriggered: {
            var p = root.body.linearVelocity;
            var l = Math.sqrt(
                        Math.pow(p.x, 2) +
                        Math.pow(p.y, 2));

            if(l === 0){
                anim.pause()
            }else{
                anim.resume()
                anim.frameRate = l * 20;
            }
        }
    }

    AnimatedSprite{
        id: anim
        source: "qrc:/ball.png"
        anchors.fill: parent
        frameWidth: 51
        frameHeight: 51
        frameCount: 7
        frameRate: 1
        paused: true
    }
}
