import QtQuick 2.12
import QtQuick.Controls 2.12
import QtQuick.Layouts 1.12
import QtCharts 2.3

import Qt.labs.settings 1.0

import OpenHD 1.0

import "../ui" as Ui

import "../ui/elements"

Rectangle {
    id: element2
    width: 504
    height: 300

    Label {
        id: ohdLabel
        color: "black"
        text: "Last openhd telemetry: " + (openHDTelemetry.last_heartbeat !== undefined ? openHDTelemetry.last_heartbeat : "N/A")
        font.pixelSize: 12
        anchors.bottom: parent.bottom
        anchors.left: parent.left
        anchors.bottomMargin: 12
        anchors.leftMargin: 12

        z: 1.1
    }

    Label {
        id: mavLabel
        color: "black"
        text: "Last mavlink heartbeat: " + (mavlinkTelemetry.last_heartbeat !== undefined ? mavlinkTelemetry.last_heartbeat : "N/A")
        font.pixelSize: 12
        anchors.bottom: parent.bottom
        anchors.right: parent.right
        anchors.bottomMargin: 12
        anchors.rightMargin: 12

        z: 1.1
    }


    GridLayout {
        id: topRow
        columnSpacing: 0
        rowSpacing: 0

        anchors {
            top: parent.top
            topMargin: 6
            left: parent.left
            leftMargin: 12
            right: parent.right
            rightMargin: 12
        }

        //Column {
            ColoredCheckbox {
                padding: 0
                Layout.row: 0
                Layout.column: 0
                text: "Air CPU"
                boxColor: airCPUAxis.color
                checked: airCPUAxis.visible
                onCheckedChanged: airCPUAxis.visible = checked
            }

            ColoredCheckbox {
                padding: 0
                Layout.row: 0
                Layout.column: 1
                text: "Air Temp"
                boxColor: airTempAxis.color
                checked: airTempAxis.visible
                onCheckedChanged: airTempAxis.visible = checked
            }

        //}

        //Column {
            ColoredCheckbox {
                padding: 0
                Layout.row: 0
                Layout.column: 2
                text: "Ground CPU"
                boxColor: gndCPUAxis.color
                checked: gndCPUAxis.visible
                onCheckedChanged: gndCPUAxis.visible = checked
            }
            ColoredCheckbox {
                padding: 0
                Layout.row: 1
                Layout.column: 0
                text: "Ground Temp"
                boxColor: gndTempAxis.color
                checked: gndTempAxis.visible
                onCheckedChanged: gndTempAxis.visible = checked
            }
        //}

        //Column {
            ColoredCheckbox {
                padding: 0
                Layout.row: 1
                Layout.column: 1
                text: "Lost Packets"
                boxColor: lostPacketAxis.color
                checked: lostPacketAxis.visible
                onCheckedChanged: lostPacketAxis.visible = checked
            }

            ColoredCheckbox {
                padding: 0
                Layout.row: 1
                Layout.column: 2
                text: "Damaged Blocks"
                boxColor: damagedBlockAxis.color
                checked: damagedBlockAxis.visible
                onCheckedChanged: damagedBlockAxis.visible = checked
            }

            ColoredCheckbox {
                padding: 0
                Layout.row: 1
                Layout.column: 3
                text: "Downlink RSSI"
                boxColor: downlinkRSSIAxis.color
                checked: downlinkRSSIAxis.visible
                onCheckedChanged: downlinkRSSIAxis.visible = checked
            }

            ColoredCheckbox {
                padding: 0
                Layout.row: 0
                Layout.column: 3
                text: "Uplink RSSI"
                boxColor: uplinkRSSIAxis.color
                checked: uplinkRSSIAxis.visible
                onCheckedChanged: uplinkRSSIAxis.visible = checked
            }

            ColoredCheckbox {
                padding: 0
                Layout.row: 0
                Layout.column: 4
                text: "Injection Fail"
                boxColor: injectionFailAxis.color
                checked: injectionFailAxis.visible
                onCheckedChanged: injectionFailAxis.visible = checked
            }

            ColoredCheckbox {
                padding: 0
                Layout.row: 1
                Layout.column: 4
                text: "Skipped Packets"
                boxColor: skippedPacketAxis.color
                checked: skippedPacketAxis.visible
                onCheckedChanged: skippedPacketAxis.visible = checked
            }
        //}
    }

    ChartView {
        id: chart
        legend.visible: false

        anchors {
            top: topRow.bottom
            topMargin: 0
            left: parent.left
            right: parent.right
            bottom: parent.bottom
        }

        antialiasing: true


        property int chartData: 0


        property int lostPacketsLast: 0
        property int lostPacketsMax: 0

        property int damagedBlocksLast: 0
        property int damagedBlocksMax: 0

        property int injectionFailLast: 0
        property int injectionFailMax: 0

        property int skippedPacketsLast: 0
        property int skippedPacketsMax: 0

        ValueAxis {
            id: valueAxis
            min: 0
            max: 300
            labelsVisible: false
            color: "black"
        }

        ValueAxis {
            id: dbYAxis
            min: -90
            max: 0
            labelFormat: "%d dB"
            tickCount: 11
            color: "black"
        }

        ValueAxis {
            id: tempYAxis
            min: 0
            max: 100
            labelFormat: "%d&deg;C"
            tickCount: 11
            color: "black"
        }

        ValueAxis {
            id: countYAxis
            min: 0
            max: 100
            tickCount: 11
            labelFormat: "%d"
            color: "black"
        }

        LineSeries {
            id: airCPUAxis
            name: "Air CPU"
            axisX: valueAxis
            axisY: countYAxis
            color: "green"
            width: 2
            useOpenGL: true
        }

        LineSeries {
            id: gndCPUAxis
            name: "Ground CPU"
            axisX: valueAxis
            axisY: countYAxis
            color: "blue"
            width: 2
            useOpenGL: true
        }

        LineSeries {
            id: gndTempAxis
            name: "Ground Temp"
            axisX: valueAxis
            axisYRight: tempYAxis
            color: "red"
            width: 2
            useOpenGL: true
        }

        LineSeries {
            id: airTempAxis
            name: "Air Temp"
            axisX: valueAxis
            axisYRight: tempYAxis
            color: "orange"
            width: 2
            useOpenGL: true
        }

        LineSeries {
            id: lostPacketAxis
            name: "Lost Packets"
            axisX: valueAxis
            axisY: countYAxis
            color: "purple"
            width: 2
            useOpenGL: true
        }

        LineSeries {
            id: damagedBlockAxis
            name: "Damaged Blocks"
            axisX: valueAxis
            axisY: countYAxis
            color: "brown"
            width: 2
            useOpenGL: true
        }

        LineSeries {
            id: downlinkRSSIAxis
            name: "Downlink RSSI"
            axisX: valueAxis
            axisY: dbYAxis
            color: "lime"
            width: 2
            useOpenGL: true
        }

        LineSeries {
            id: uplinkRSSIAxis
            name: "Uplink RSSI"
            axisX: valueAxis
            axisY: dbYAxis
            color: "tan"
            width: 2
            useOpenGL: true
        }


        LineSeries {
            id: injectionFailAxis
            name: "Injection Fail"
            axisX: valueAxis
            axisY: countYAxis
            color: "teal"
            width: 2
            useOpenGL: true
        }

        LineSeries {
            id: skippedPacketAxis
            name: "Skipped packets"
            axisX: valueAxis
            axisY: countYAxis
            color: "violet"
            width: 2
            useOpenGL: true
        }

        Connections {
            target: OpenHD

            onLost_packet_cnt_changed: {
                if (chart.lostPacketsLast != 0) {
                    var lostPacketsDifference = OpenHD.lost_packet_cnt - chart.lostPacketsLast;
                    lostPacketAxis.append(chart.chartData, lostPacketsDifference);
                }
                chart.lostPacketsLast = OpenHD.lost_packet_cnt;

                if (chart.damagedBlocksLast != 0) {
                    var damagedBlocksDifference = OpenHD.damaged_block_cnt - chart.damagedBlocksLast;
                    damagedBlockAxis.append(chart.chartData, damagedBlocksDifference);
                }
                chart.damagedBlocksLast = OpenHD.damaged_block_cnt;

                if (chart.injectionFailLast != 0) {
                    var injectionFailDifference = OpenHD.injection_fail_cnt - chart.injectionFailLast;
                    injectionFailAxis.append(chart.chartData, injectionFailDifference);
                }
                chart.injectionFailLast = OpenHD.injection_fail_cnt;

                if (chart.skippedPacketsLast != 0) {
                    var skippedPacketDifference = OpenHD.skipped_packet_cnt - chart.skippedPacketsLast;
                    skippedPacketAxis.append(chart.chartData, skippedPacketDifference);
                }
                chart.skippedPacketsLast = OpenHD.skipped_packet_cnt;

                airCPUAxis.append(chart.chartData, OpenHD.cpuload_air);
                gndCPUAxis.append(chart.chartData, OpenHD.cpuload_gnd);
                airTempAxis.append(chart.chartData, OpenHD.temp_air);
                gndTempAxis.append(chart.chartData, OpenHD.temp_gnd);
                downlinkRSSIAxis.append(chart.chartData, OpenHD.downlink_rssi);
                uplinkRSSIAxis.append(chart.chartData, OpenHD.current_signal_joystick_uplink);

                chart.chartData++;

                if (chart.chartData > 300) {
                    valueAxis.min++;
                    valueAxis.max++;

                    lostPacketAxis.remove(1);
                    damagedBlockAxis.remove(1);

                    airCPUAxis.remove(1);
                    gndCPUAxis.remove(1);
                    airTempAxis.remove(1);
                    gndTempAxis.remove(1);

                    downlinkRSSIAxis.remove(1);
                    uplinkRSSIAxis.remove(1);

                    injectionFailAxis.remove(1);
                    skippedPacketAxis.remove(1);
                }
            }
        }
    }
}
