import QtQuick 2.0
import Qt.labs.controls 1.0

Rectangle {
    width: 100
    height: 62

    function scale(){
        //children = o
        var i
        for(i = 0; i < children.length; i++){
            var child = children[i];

            var scaleSize = Math.min(width / child.width, height / child.height);
            child.x = (width - child.width) / 2
            child.y = (height - child.height) / 2
            child.scale = scaleSize;
        }
    }

    onWidthChanged: scale()
    onHeightChanged: scale()
}

