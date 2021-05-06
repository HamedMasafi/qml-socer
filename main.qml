import QtQuick 2.3
import QtQuick.Layouts 1.1
import QtQuick.Controls 1.2
import QtQuick.Window 2.2
import Box2D 2.0

import "Utils.js" as Utils

Window {
    id: root

    width: 800
    height: 600

    visible: true

    property int team1goals: 0
    property int team2goals: 0

    property var activeNut: false
    property int turn: 1
    property int goalSize: 80

    QtObject{
        id: __private
        property var nuts: []
        property var pool: []

        function findNut(pt){
            var i
            for(i = 0; i < nuts.length; i++){
                var nutCenter = nuts[i].body.getWorldCenter()
                var l = Math.sqrt(
                            Math.pow(nutCenter.x - pt.x, 2) +
                            Math.pow(nutCenter.y - pt.y, 2));

                if(l < 30)
                    return nuts[i];
            }
            return false;
        }
    }

    function addNut(objX, objY, color){
        //        var com = Qt.createComponent("Nut.qml")
        //        var obj = com.createObject(root);
        var obj = __private.pool.pop();

        if(color)
            obj.x = (objX / 100) * (area.width / 2)
        else
            obj.x = area.width - ((objX / 100) * (area.width / 2))

        obj.visible = true;
        obj.isWhite = color;
        obj.y = (objY / 100) * area.height
        obj.x += area.x - obj.width / 2
        obj.y += area.y - obj.height / 2
        obj.isActive = Qt.binding(function(){ return getColorByTurn() === obj.isWhite; } )
        __private.nuts.push(obj)
    }

    function restart(){
        var i
        for( i = 0; i < 10; i++){
            var n = __private.nuts.pop();
            //            n.visible = true;
            __private.pool.push(n);
        }
        start()
    }

    function start(){
        var createTeam = function(color){
            addNut(5 , 50, color)
            addNut(30, 30, color)
            addNut(30, 70, color)
            addNut(80, 42, color)
            addNut(80, 58, color)
        };

        createTeam(true);
        createTeam(false);
        ball.x = area.x + (area.width / 2) - (ball.width / 2)
        ball.y = area.y + (area.height / 2) - (ball.height / 2)
        ball.visible = true
    }

    function getColorByTurn(){
        if(turn === 1)
            return true;
        else if(turn === -1)
            return false;
        else
            return 0;
    }

    Component.onCompleted: {
        var i
        for( i = 0; i < 10; i++){
            var com = Qt.createComponent("Nut.qml")
            var obj = com.createObject(root);
            obj.visible = false
            obj.x = obj.y = 200

            obj.density = Qt.binding(function(){ return nutDensity.text} )
            obj.restitution = Qt.binding(function(){ return nutRestitution.text} )
            obj.friction = Qt.binding(function(){ return nutFriction.text} )
            __private.pool.push(obj)
        }
    }

    World {
        id: physicsWorld
        gravity: Qt.point(0, 0)


    }

    Item{
        Image{
            anchors.fill: parent
            source: 'qrc:/football_pitch.jpg'
        }
        id: area
        //        color: "#93eaac"
        anchors{
            fill: parent
            leftMargin: 30
            rightMargin: 30
            topMargin: 70
            bottomMargin: 30
        }
    }

    Timer{
        id: timerCheckStop
        repeat: true
        interval: 300
        onTriggered: {
            var i
            var isActive = false
            for(i = 0; i < __private.nuts.length; i++)
                if(__private.nuts[i].body.linearVelocity !== Qt.point(0, 0)){
                    isActive = true;
                    break;
                }

            if(!isActive){
                console.log("Stopped")
                timerCheckStop.running = false
                turn /= -Math.abs(turn)
            }
        }
    }

    PointArrow{
        id: arrow
        x: 100
        y: 100
        size: 80

        visible: activeNut !== false
    }
    MultiPointTouchArea{
        anchors.fill: parent

        touchPoints: [
            TouchPoint { id: point1 },
            TouchPoint { id: point2 }
        ]

        onUpdated: {
            if(activeNut !== false){
                var c = activeNut.body.getWorldCenter();
                var l = Utils.lenght(c.x, point1.x, c.y, point1.y) * 2
                var a = Utils.angle(c.x, point1.x, c.y, point1.y) - Math.PI

                if(l >= 100)
                    l = 100

                arrow.angle = a
                arrow.size = l
            }
        }
        onPressed: {
            var n = __private.findNut(point1);
            activeNut = n

            if(n !== false && n.isWhite === getColorByTurn())
                arrow.show(n);
            else
                activeNut = false;
        }

        onReleased: {
            if(activeNut !== false){
//                activeNut.body.applyForce(10, arrow.shootPoint())
                activeNut.body.applyLinearImpulse(
                            arrow.shootPoint(),
                            activeNut.body.getWorldCenter());

                arrow.visible = false
                activeNut = false
                timerCheckStop.running = true;
                turn *= 2;
            }
        }
        Ball{
            x: 200
            y: 300
            id: ball
            visible: false

            friction: ballFriction.text
            density: ballDensity.text
            restitution: ballRestitution.text

            onXChanged: {
                if(Math.abs(turn) === 2){
                    var c = ball.body.getWorldCenter();
                    if(c.x < area.x){
                        team2goals++;
                        turn *= -3;
                        goalAnim.start()
                    }else if(c.x > area.x + area.width){
                        team1goals++;
                        turn *= -3;
                        goalAnim.start()
                    }
                }
            }
        }


        Wall {
            id: topWall
            x: area.x
            y: area.y - 20
            width: area.width

            friction: wallFriction.text
            density: wallDensity.text
        }

        Wall {
            id: leftWallTop
            y: area.y
            x: area.x - 20
            height: (area.height / 2) - goalSize

            friction: wallFriction.text
            density: wallDensity.text
        }
        Wall {
            id: leftWallBotton
            y: area.y + (area.height / 2) + goalSize
            x: area.x - 20
            height: (area.height / 2) - goalSize

            friction: wallFriction.text
            density: wallDensity.text
        }
        Wall {
            id: leftWall
            y: area.y
            x: area.x - 40
            height: area.height
            restitution: .0001
        }

        Wall {
            id: rightWallTop
            y: area.y
            x: area.x + area.width
            height: (area.height / 2) - goalSize

            friction: wallFriction.text
            density: wallDensity.text
        }
        Wall {
            id: rightWallBotton
            y: area.y + (area.height / 2) + goalSize
            x: area.x + area.width
            height: (area.height / 2) - goalSize

            friction: wallFriction.text
            density: wallDensity.text
        }
        Wall {
            id: rightWall
            y: area.y
            x: area.x + area.width + 20
            height: area.height
            restitution: .0001
        }

        Wall {
            id: bottonWall
            y: area.y + area.height
            x: area.x
            width: area.width

            friction: wallFriction.text
            density: wallDensity.text
        }

        Item{
            visible: goalAnim.running

            SequentialAnimation{
                id: goalAnim
                PropertyAnimation{
                    target: goalBG
                    property: 'height'
                    from: 0
                    to: 160
                    duration: 1600
                }
                SequentialAnimation{
                    loops: 3
                    PropertyAnimation{
                        target: goalText
                        property: 'opacity'
                        from: 0
                        to: 1
                        duration: 300
                    }
                    PropertyAnimation{
                        target: goalText
                        property: 'opacity'
                        from: 1
                        to: 0
                        duration: 300
                    }
                }

                PropertyAnimation{
                    target: goalText
                    property: 'opacity'
                    from: 0
                    to: 1
                    duration: 300
                }
                PauseAnimation {
                    duration: 2000
                }
                ScriptAction{
                    script: {
                        turn /= -Math.abs(turn)
                        root.restart()
                    }
                }
            }

            anchors{
                verticalCenter: parent.verticalCenter
                left: parent.left
                right: parent.right
            }
            height: 160

            Rectangle{
                id: goalBG
                anchors{
                    verticalCenter: parent.verticalCenter
                    left: parent.left
                    right: parent.right
                }
                opacity: .3
            }

            Text {
                id: goalText
                anchors.centerIn: parent
                color: "#76bde0"
                styleColor: "#a5b94a"
                font.family: 'B Yekan'
                text: "گل"
                font.bold: true
                style: Text.Outline
                font.pointSize: 36
            }
        }

    }

    Text {
        id: name
        text: turn
    }
    Button{
        anchors.centerIn: parent
        text: 'شروع'
        onClicked: {
            visible = false;
            root.start();
        }
    }
    RowLayout{
        anchors.horizontalCenter: parent.horizontalCenter
        Text {
            color: "#76bde0"
            styleColor: "#a5b94a"
            text: team1goals
            font.bold: true
            style: Text.Outline
            font.pointSize: 14
        }
        Item {
            width: 20
        }
        Text {
            color: "#76bde0"
            styleColor: "#a5b94a"
            text: team2goals
            font.bold: true
            style: Text.Outline
            font.pointSize: 14
        }
    }

    Button{
        anchors{
            topMargin: 15
            rightMargin: 15
            right: parent.right
        }
        text: "تنظیمات"
        onClicked: optionsWindow.visible = !optionsWindow.visible
    }

    Rectangle{
        id: optionsWindow
        anchors.centerIn: parent
        width: options.width + 30
        height: options.height + 30
        visible: false
        z: 10000
        GridLayout{
            id: options
            columns: 2
            layoutDirection: Qt.RightToLeft
            anchors.centerIn: parent

            Text {text: "اصطکاک مهره"}
            TextField{id: nutFriction; text: '50'}

            Text {text: "بازتاب مهره"}
            TextField{id: nutRestitution; text: '0.2'}

            Text {text: "تراکم مهره"}
            TextField{id: nutDensity; text: '60'}

            Text {text: "اصطکاک توپ"}
            TextField{id: ballFriction; text: '20'}

            Text {text: "بازتاب توپ"}
            TextField{id: ballRestitution; text: '0.9'}

            Text {text: "تراکم توپ"}
            TextField{id: ballDensity; text: '10'}

            Text {text: "تراکم دیوار"}
            TextField{id: wallDensity; text: '1'}

            Text {text: "اصطکاک دیوار"}
            TextField{id: wallFriction; text: '1'}
        }
    }

}
