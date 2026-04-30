/***************************************************************************
* Copyright (c) 2013 Abdurrahman AVCI <abdurrahmanavci@gmail.com>
*
* Permission is hereby granted, free of charge, to any person
* obtaining a copy of this software and associated documentation
* files (the "Software"), to deal in the Software without restriction,
* including without limitation the rights to use, copy, modify, merge,
* publish, distribute, sublicense, and/or sell copies of the Software,
* and to permit persons to whom the Software is furnished to do so,
* subject to the following conditions:
*
* The above copyright notice and this permission notice shall be included
* in all copies or substantial portions of the Software.
*
* THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS
* OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
* FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL
* THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR
* OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
* ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE
* OR OTHER DEALINGS IN THE SOFTWARE.
*
***************************************************************************/

import QtQuick 2.15
import SddmComponents 2.0

Rectangle {
    id: container
    width: 640
    height: 480

    LayoutMirroring.enabled: Qt.locale().textDirection == Qt.RightToLeft
    LayoutMirroring.childrenInherit: true

    property int sessionIndex: session.index

    TextConstants { id: textConstants }

    Connections {
        target: sddm

        onLoginSucceeded: {
            errorMessage.color = "steelblue"
            errorMessage.text = textConstants.loginSucceeded
        }

        onLoginFailed: {
            password.text = ""
            errorMessage.color = "red"
            errorMessage.text = textConstants.loginFailed
        }
        onInformationMessage: {
            errorMessage.color = "red"
            errorMessage.text = message
        }
    }

    Background {
        anchors.fill: parent
        source: config.background
        fillMode: Image.PreserveAspectCrop
        onStatusChanged: {
            if (status == Image.Error && source != config.defaultBackground) {
                source = config.defaultBackground
            }
        }
    }

    Rectangle {
        anchors.fill: parent
        color: 'transparent'
        //visible: primaryScreen

        Clock {
            id: clock
            anchors.margins: 5
            anchors.top: parent.top; anchors.right: parent.right

            color: "white"
            timeFont.family: "Oxygen"
        }

        Rectangle {
            id: rectangle
            anchors.centerIn: parent
            width: Math.max(320, mainColumn.implicitWidth + 50)
            height: Math.max(320, mainColumn.implicitHeight + 50)
            color: "#ffffff"
            radius: 24
            //source: "rectangle.png"

            Column {
                id: mainColumn
                anchors.centerIn: parent
                spacing: 12
                Text {
                    anchors.horizontalCenter: parent.horizontalCenter
                    color: "black"
                    verticalAlignment: Text.AlignVCenter
                    height: text.implicitHeight
                    width: parent.width
                    text: "Добро пожаловать!"//textConstants.welcomeText.arg(sddm.hostName)
                    wrapMode: Text.WordWrap
                    font.pixelSize: 24
                    elide: Text.ElideRight
                    horizontalAlignment: Text.AlignHCenter
                    font.weight: Font.Bold
                }

                Column {
                    width: parent.width
                    spacing: 4
                    Text {
                        id: lblName
                        width: parent.width
                        text: textConstants.userName
                        font.bold: true
                        font.pixelSize: 12
                    }

                    TextBox {
                        id: name
                        width: parent.width; height: 30
                        text: userModel.lastUser
                        font.pixelSize: 14
                        borderColor: "#000000"
                        focusColor: "#000000"
                        hoverColor: '#131313'
                        radius: 24

                        KeyNavigation.backtab: rebootButton; KeyNavigation.tab: password

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Column {
                    width: parent.width
                    spacing : 4
                    Text {
                        id: lblPassword
                        width: parent.width
                        text: textConstants.password
                        font.bold: true
                        font.pixelSize: 12
                    }

                    PasswordBox {
                        id: password
                        width: parent.width; height: 30
                        font.pixelSize: 14
                        borderColor: "#000000"
                        focusColor: "#000000"
                        hoverColor: '#131313'
                        radius: 24

                        KeyNavigation.backtab: name; KeyNavigation.tab: session

                        Keys.onPressed: {
                            if (event.key === Qt.Key_Return || event.key === Qt.Key_Enter) {
                                sddm.login(name.text, password.text, sessionIndex)
                                event.accepted = true
                            }
                        }
                    }
                }

                Row {
                    spacing: 4
                    width: parent.width / 2
                    z: 100

                    Column {
                        z: 100
                        width: parent.width * 2
                        spacing : 4
                        anchors.bottom: parent.bottom

                        Text {
                            id: lblSession
                            width: parent.width
                            text: textConstants.session
                            wrapMode: TextEdit.WordWrap
                            font.bold: true
                            font.pixelSize: 12
                        }

                        ComboBox {
                            id: session
                            width: parent.width; height: 30
                            font.pixelSize: 14
                            borderColor: "#000000"
                            hoverColor: '#ededed'

                            arrowIcon: "angle-down.png"

                            model: sessionModel
                            index: sessionModel.lastIndex

                            

                            KeyNavigation.backtab: password; KeyNavigation.tab: layoutBox
                        }
                    }

                    /*
                    Column {
                        z: 101
                        width: parent.width * 0.7
                        spacing : 4
                        anchors.bottom: parent.bottom

                        Text {
                            id: lblLayout
                            width: parent.width
                            text: textConstants.layout
                            wrapMode: TextEdit.WordWrap
                            font.bold: true
                            font.pixelSize: 12
                        }

                        LayoutBox {
                            id: layoutBox
                            width: parent.width; height: 30
                            font.pixelSize: 14

                            arrowIcon: "angle-down.png"

                            KeyNavigation.backtab: session; KeyNavigation.tab: loginButton
                        }
                    }*/
                }

                Column {
                    width: parent.width
                    Text {
                        id: errorMessage
                        anchors.horizontalCenter: parent.horizontalCenter
                        text: textConstants.prompt
                        font.pixelSize: 10
                    }
                }

                Row {
                    spacing: 4
                    anchors.horizontalCenter: parent.horizontalCenter
                    property int btnWidth: Math.max(loginButton.implicitWidth,
                                                    shutdownButton.implicitWidth,
                                                    rebootButton.implicitWidth, 80) + 8

                    Rectangle {
                        id: loginButton
                        width: parent.btnWidth
                        height: 30
                        radius: 24
                        
                        // Меняем цвет через MouseArea
                        color: hoverArea2.containsMouse ? '#1d1d1d' : (loginButton.focus ? "#222222" : "#000000")
                        
                        Text {
                            anchors.centerIn: parent
                            text: textConstants.login
                            color: "white"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                        }
                        
                        MouseArea {
                            id: hoverArea2
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                                sddm.login(name.text, password.text, sessionIndex)
                            }
                        }
                        
                        // Обработка фокуса с клавиатуры
                        focus: true
                        Keys.onReturnPressed: sddm.login(name.text, password.text, sessionIndex)
                        KeyNavigation.backtab: layoutBox; KeyNavigation.tab: shutdownButton
                        
                        // Визуальный индикатор фокуса
                        border.width: focus ? 2 : 0
                        border.color: focus ? "#ffffff" : "transparent"
                    }
                    Rectangle {
                        id: shutdownButton
                        width: parent.btnWidth
                        height: 30
                        radius: 24
                        
                        // Меняем цвет через MouseArea
                        color: hoverArea.containsMouse ? '#1d1d1d' : (shutdownButton.focus ? "#222222" : "#000000")
                        
                        Text {
                            anchors.centerIn: parent
                            text: textConstants.shutdown
                            color: "white"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                        }
                        
                        MouseArea {
                            id: hoverArea
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                                sddm.powerOff()
                            }
                        }
                        
                        // Обработка фокуса с клавиатуры
                        focus: true
                        Keys.onReturnPressed: sddm.powerOff()
                        KeyNavigation.backtab: loginButton
                        KeyNavigation.tab: rebootButton
                        
                        // Визуальный индикатор фокуса
                        border.width: focus ? 2 : 0
                        border.color: focus ? "#ffffff" : "transparent"
                    }
                    Rectangle {
                        id: rebootButton
                        width: parent.btnWidth
                        height: 30
                        radius: 24
                        
                        // Меняем цвет через MouseArea
                        color: hoverArea1.containsMouse ? '#1d1d1d' : (rebootButton.focus ? "#222222" : "#000000")
                        
                        Text {
                            anchors.centerIn: parent
                            text: textConstants.reboot
                            color: "white"
                            font.pixelSize: 12
                            font.weight: Font.Bold
                        }
                        
                        MouseArea {
                            id: hoverArea1
                            anchors.fill: parent
                            hoverEnabled: true
                            cursorShape: Qt.PointingHandCursor
                            
                            onClicked: {
                                sddm.reboot()
                            }
                        }
                        
                        // Обработка фокуса с клавиатуры
                        focus: true
                        Keys.onReturnPressed: sddm.reboot()
                        KeyNavigation.backtab: shutdownButton; KeyNavigation.tab: name
                        
                        // Визуальный индикатор фокуса
                        border.width: focus ? 2 : 0
                        border.color: focus ? "#ffffff" : "transparent"
                    }
                }
            }
        }
    }

    Component.onCompleted: {
        if (name.text == "")
            name.focus = true
        else
            password.focus = true
    }
}
