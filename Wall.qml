import QtQuick 2.0
import Box2D 2.0

ImageBoxBody {
    height: 20
    width: 20

    source: "images/wall.jpg"
    fillMode: Image.Tile

    world: physicsWorld

    friction: 1
    density: 1
//    restitution: 8
}
