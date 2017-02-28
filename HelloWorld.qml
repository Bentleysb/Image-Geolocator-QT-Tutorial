/* Copyright 2015 Esri
 *
 * Licensed under the Apache License, Version 2.0 (the "License");
 * you may not use this file except in compliance with the License.
 * You may obtain a copy of the License at
 *
 *    http://www.apache.org/licenses/LICENSE-2.0
 *
 * Unless required by applicable law or agreed to in writing, software
 * distributed under the License is distributed on an "AS IS" BASIS,
 * WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
 * See the License for the specific language governing permissions and
 * limitations under the License.
 *
 */

import QtQuick 2.3
import QtQuick.Controls 1.2
import QtQuick.Layouts 1.1
import QtPositioning 5.3

import ArcGIS.AppFramework 1.0
import ArcGIS.AppFramework.Controls 1.0
import ArcGIS.AppFramework.Runtime 1.0
import ArcGIS.AppFramework.Runtime.Controls 1.0

import QtQuick.Controls 1.4
import QtQuick.Dialogs 1.2

//------------------------------------------------------------------------------

App {
    id: app
    width: 400
    height: 680

    Rectangle {
        id: titleRect

        anchors {
            left: parent.left
            right: parent.right
            top: parent.top
        }

        height: titleText.paintedHeight + titleText.anchors.margins * 2
        color: app.info.propertyValue("titleBackgroundColor", "darkblue")

        Text {
            id: titleText

            width: parent.width * 0.75
            anchors {
                left: parent.left
                //right: parent.right
                top: parent.top
                margins: 2 * AppFramework.displayScaleFactor
            }

            text: app.info.title
            color: app.info.propertyValue("titleTextColor", "white")
            font {
                pointSize: 22
            }
            wrapMode: Text.WrapAtWordBoundaryOrAnywhere
            maximumLineCount: 2
            elide: Text.ElideRight
            horizontalAlignment: Text.AlignHCenter
        }

        Button {
            id: menu
            text: "MENU"            //test to be displayed on the button
            menu: drop_menu         //declaring this is a menu and linking the "Menu" element with id "drop_menu"

            height: parent.height   //set size to fill the rest of the "Rectangle" element
            width: parent.height
            anchors {
                top: parent.top
                right: parent.right
            }
        }

        Menu {
            id: drop_menu

            MenuItem {                                  //button in the menu
                text: "Load Image"
                onTriggered: url_screen.visible = true  //action to be performed when the button is clicked
            }
        }

    }

    Map {
        id: map

        height: parent.height / 2 - titleRect.height
        anchors {
            left: parent.left
            right: parent.right
            top: titleRect.bottom
            //bottom: parent.bottom
        }

        wrapAroundEnabled: true
        rotationByPinchingEnabled: true
        magnifierOnPressAndHoldEnabled: true
        mapPanningByMagnifierEnabled: true
        zoomByPinchingEnabled: true

        positionDisplay {
            positionSource: PositionSource {
            }
        }

        ArcGISTiledMapServiceLayer {
            url: app.info.propertyValue("basemapServiceUrl", "http://server.arcgisonline.com/ArcGIS/rest/services/World_Street_Map/MapServer")
        }

        NorthArrow {
            anchors {
                right: parent.right
                top: parent.top
                margins: 10
            }

            visible: map.mapRotation != 0
        }

        ZoomButtons {
            anchors {
                right: parent.right
                verticalCenter: parent.verticalCenter
                margins: 10
            }
        }
    }

    ImageObject {
            id: arc_image
    }

    Rectangle {
        id: image_container
        color: "#000"               //sets the background color to black

        anchors {                   //sets the position of the element to fill the empty space at the bottom of the screen
            left: parent.left
            top: map.bottom
            right: parent.right
            bottom: parent.bottom
        }

        Image {
            id: image
            source: arc_image.url               //use the image stored in the "ImageObject" arc_image
            fillMode: Image.PreserveAspectFit   //don't strech the image

            anchors {                           //fill the rectangle
                left: parent.left
                top: parent.top
                right: parent.right
                bottom: parent.bottom
            }
        }
    }

    Rectangle {
        id: url_screen
        color: "#000"               //set the background color to black
        visible: false              //make it invisible at first

        anchors {                   //set it to take up the entire screen
            left: parent.left
            top: parent.top
            right: parent.right
            bottom: parent.bottom
        }

        Text {
            id: url_instructions
            text: "Select an Image to Locate."      //text to be displayed

            width: parent.width                     //set it to be as wide as the parent "Rectangle" element
            anchors {                               //set it to be at the top with small margin of 10
                left: parent.left
                top: parent.top + 10
            }
            color: "#fff"                           //set the text color to white
            font {
                pointSize: 20                       //set the font size, this will determin the height
            }
            horizontalAlignment: Text.AlignHCenter  //center the alignment
        }

        Rectangle {
            id: url_text_box
            color: "#444"                       //set thebacground to a medium gray

            height: 50                          //make it short, wide, and just under the instructions
            anchors {
                left: parent.left
                top: url_instructions.bottom
                right: url_browse.left          //leave room for a browse button
                margins: parent.width / 20
            }

            TextInput {
                id: url_text
                color: "#fff"                   //mak the text color white

                anchors {                       //fill the parent rectangle
                    left: parent.left
                    top: parent.top
                    right: parent.right
                    bottom: parent.bottom
                    margins: 2.5
                }
                font.pointSize: 20              //set the height using font size
                clip: true                      //if it overflows, don't show it
            }
        }

        Button {
            id: url_browse
            text: "Browse"                  //text that will be displayed on the button

            width: parent.width / 10        //set it to be 1/10 the width of the screen and the same height as the "TextInput" element
            anchors {
                top: url_text_box.top
                right: parent.right
                bottom: url_text_box.bottom
                margins: 5
            }

            onClicked: file_dialog.open()   //when clicked open the file dialog
        }

        Button {
            id: url_ok
            text: "ok"                      //text that will be displayed

            anchors {                       //but it on one side on the bootom of the screen
                left: parent.left
                bottom: parent.bottom
                margins: parent.width / 4
            }
            action: load_image              //do this sction that is defined elsewhere
        }

        Button {
            id: url_cancel
            text: "cancel"                  //text that will be displayed

            anchors {                       //put it opposite the ok button
                right: parent.right
                bottom: parent.bottom
                margins: parent.width / 4
            }
            onClicked: url_screen.visible = false   //make the url_screen invisisble again when clicked
        }
    }

    FileDialog{
        id: file_dialog
        nameFilters: [ "Image files (*.jpg *.png)", "All files (*)" ]   //guide the user to select an image file
        onAccepted: {                                                   //when they hit ok place the path to the file in the "TextInput" so we can add it to the "ImageObject"
            url_text.text = fileUrl
            url_text.remove(0,8)
        }
    }

    Action {
        id: load_image
        onTriggered: {                                          //when the ok button is clicked
            url_screen.visible = false                          //make the url_screen invisible
            arc_image.load(url_text.text)                       //load the image into the "ImageObject"
            position.x = arc_image.exifInfo.gpsLongitude        //get the longitude from the images exif tag, and add it to the point "position"
            position.y = arc_image.exifInfo.gpsLatitude         //get the latitude from the images exif tag, and add it to the point "position"
            map.zoomToResolution(1.5)                           //zoom the map
            map.panTo(position.project(map.spatialReference))   //pan the map to the image location
        }
    }

    Point {
        id: position
        spatialReference: SpatialReference {wkid:4326}  //gps uses this spatial reference so that's what phones use, and that is what we have to use
    }

}

//------------------------------------------------------------------------------
