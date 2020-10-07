//
//  PredictiveDetailViewController.swift
//  AIPM-iOS
//
//  Created by Joshua Dadson on 8/31/20.
//  Copyright © 2020 Joshua Dadson. All rights reserved.
//

import UIKit
import MQTTClient
import Charts

class PredictiveDetailViewController: UIViewController, MQTTSessionDelegate, ChartViewDelegate {
    //MQTT
    let session = MQTTSession()!
    var text = ""
    
    var vcTitle = String()
    var healthScore = Int()
    var upperTorque = Int()
    var middleTorque = Int()
    var lowerTorque = Int()
    
    var upperTemp = [Double]()
    var middleTemp = [Double]()
    var lowerTemp = [Double]()
    
    var xPos = [Double]()
    var yPos = [Double]()
    var zPos = [Double]()
    
    //Dials
    var healthDial: DialChartView!
    var upperTorqueDial: DialChartView!
    var middleTorqueDial: DialChartView!
    var lowerTorqueDial: DialChartView!
    
    //Health, Torque, Temp, Position
    var healthView = UIView()
    let healthTitle = UILabel()
    let healthValueLabel = UILabel()
    
    var torqueView = UIView()
    var upperTorqueLabel = UILabel()
    var upperTorqueTitle = UILabel()
    var middleTorqueLabel = UILabel()
    var middleTorqueTitle = UILabel()
    var lowerTorqueLabel = UILabel()
    var lowerTorqueTitle = UILabel()
    
    
    var temperatureView = UIView()
    var upperTempLabel = UILabel()
    var middleTempLabel = UILabel()
    var lowerTempLabel = UILabel()
    
    
    
    var positionView = UIView()
    var xPosLabel = UILabel()
    var yPosLabel = UILabel()
    var zPosLabel = UILabel()
    
    var temperatureGraph = LineChartView()
    var upperTempEntries = [ChartDataEntry]()
    var middleTempEntries = [ChartDataEntry]()
    var lowerTempEntries = [ChartDataEntry]()
    
    var positionGraph = LineChartView()
    var xEntries = [ChartDataEntry]()
    var yEntries = [ChartDataEntry]()
    var zEntries = [ChartDataEntry]()
    
    func updateGraph() {
//        upperTemp = []
        upperTempEntries = []
//        middleTemp = []
        middleTempEntries = []
//        lowerTemp = []
        lowerTempEntries = []
//        xPos = []
        xEntries = []
//        yPos = []
        yEntries = []
//        zPos = []
        zEntries = []
        
        for (key, value) in upperTemp.enumerated() {
            
                upperTempEntries.append(ChartDataEntry(x: Double(key), y: value))
//            print("Key: \(key)\n Value: \(value)")
     
        }
        
        
        if upperTemp.count > 10 {
            upperTemp.removeFirst()
            upperTempEntries.removeFirst()

        }
        
        for (key, value) in middleTemp.enumerated() {

                middleTempEntries.append(ChartDataEntry(x: Double(key), y: value))

        }
        
        if middleTemp.count > 10 {
            middleTemp.removeFirst()
            middleTempEntries.removeFirst()
        }
        
        for (key, value) in lowerTemp.enumerated() {

                lowerTempEntries.append(ChartDataEntry(x: Double(key), y: value))
        }
        
        if lowerTemp.count > 10 {
            lowerTemp.removeFirst()
            lowerTempEntries.removeFirst()
        }
        
        for (key, value) in xPos.enumerated() {

                xEntries.append(ChartDataEntry(x: Double(key), y: value))

        }
        
        if xPos.count > 10 {
            xPos.removeFirst()
            xEntries.removeFirst()
        }
        
        for (key, value) in yPos.enumerated() {

                yEntries.append(ChartDataEntry(x: Double(key), y: value))

        }
        
        if yPos.count > 10 {
            yPos.removeFirst()
            yEntries.removeFirst()
        }
        
        for (key, value) in zPos.enumerated() {

                zEntries.append(ChartDataEntry(x: Double(key), y: value))

        }
        
        if zPos.count > 10 {
            zPos.removeFirst()
            zEntries.removeFirst()
        }
        
        let set1 = LineChartDataSet(entries: upperTempEntries, label: "Upper Temperature")
        set1.setDrawHighlightIndicators(false)
        set1.drawValuesEnabled = false
        set1.setColor(.red)
        set1.setCircleColor(.red)
        let set2 = LineChartDataSet(entries: middleTempEntries, label: "Middle Temperature")
        set2.setDrawHighlightIndicators(false)
        set2.drawValuesEnabled = false
        set2.setColor(.blue)
        set2.setCircleColor(.blue)
        let set3 = LineChartDataSet(entries: lowerTempEntries, label: "Lower Temperature")
        set3.setDrawHighlightIndicators(false)
        set3.drawValuesEnabled = false
        set3.setColor(.green)
        set3.setCircleColor(.green)
        let data = LineChartData(dataSets: [set1, set2, set3])
        temperatureGraph.data = data
        
        let set4 = LineChartDataSet(entries: xEntries, label: "X Position")
        set4.setDrawHighlightIndicators(false)
        set4.drawValuesEnabled = false
        set4.setColor(.red)
        set4.setCircleColor(.red)
        let set5 = LineChartDataSet(entries: yEntries, label: "Y Position")
        set5.setDrawHighlightIndicators(false)
        set5.drawValuesEnabled = false
        set5.setColor(.blue)
        set5.setCircleColor(.blue)
        let set6 = LineChartDataSet(entries: zEntries, label: "Z Position")
        set6.setDrawHighlightIndicators(false)
        set6.drawValuesEnabled = false
        set6.setColor(.green)
        set6.setCircleColor(.green)
        let data2 = LineChartData(dataSets: [set4, set5, set6])
        positionGraph.data = data2
    }
    

    
    init(vcTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.vcTitle = vcTitle
    }
    
    init(vcTitle: String, healthScore: Int, upperTorque: Int, middleTorque: Int, lowerTorque: Int) {
        super.init(nibName: nil, bundle: nil)
        self.vcTitle = vcTitle
        self.healthScore = healthScore
        self.upperTorque = upperTorque
        self.middleTorque = middleTorque
        self.lowerTorque = lowerTorque
        
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        healthValueLabel.text = String(healthScore)
        healthDial.score = CGFloat(healthScore)
        
        upperTorqueLabel.text = String(upperTorque)
        upperTorqueDial.score = CGFloat(upperTorque)
        
        middleTorqueLabel.text = String(middleTorque)
        middleTorqueDial.score = CGFloat(middleTorque)
        
        lowerTorqueLabel.text = String(lowerTorque)
        lowerTorqueDial.score = CGFloat(lowerTorque)
        
//        updateGraph()
        
    }
    
    
    func getRobotData() {    //Handle IOT Data Subscription
        let randomHEX = String(Float.random(in: 0..<1).bitPattern, radix: 16)
        let startIndex = randomHEX.index(randomHEX.startIndex, offsetBy: 2)
        let endIndex = randomHEX.index(randomHEX.endIndex, offsetBy: -3)
        let range = startIndex...endIndex
        let hexSubString = randomHEX[range]
        let clientID = "a:vrvzh6:" + hexSubString
        
        DispatchQueue.global(qos: .userInteractive).async {  //Handles subscription in a background thread
            self.session.delegate = self
            self.session.transport = MQTTCFSocketTransport()
            self.session.transport.host = "vrvzh6.messaging.internetofthings.ibmcloud.com"
            self.session.transport.port = 1883
            self.session.userName = "a-vrvzh6-lmttnkzxht"
            self.session.password = "LRVitW+(soqXuZdJT!"
            self.session.clientId = clientID
            self.session.connect()
            
        }
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        view.backgroundColor = UIColor.white
        title = vcTitle
        
        //Health
        view.addSubview(healthView)
        healthView.translatesAutoresizingMaskIntoConstraints = false
        healthView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        healthView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25).isActive = true
        healthView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        healthView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        healthView.layer.borderWidth = 1.5
        healthView.layer.borderColor = UIColor.black.cgColor
        
        healthDial = DialChartView(score: CGFloat(healthScore), type: "Health")
        healthView.addSubview(healthDial)
        healthDial.translatesAutoresizingMaskIntoConstraints = false
        healthDial.centerXAnchor.constraint(equalTo: healthView.centerXAnchor).isActive = true
        healthDial.centerYAnchor.constraint(equalTo: healthView.centerYAnchor, constant: 10).isActive = true
        healthDial.widthAnchor.constraint(equalTo: healthView.widthAnchor, multiplier: 0.3).isActive = true
        healthDial.heightAnchor.constraint(equalTo: healthView.heightAnchor, multiplier: 0.7).isActive = true
        healthDial.backgroundColor = .clear
        
        healthView.addSubview(healthValueLabel)
        healthValueLabel.translatesAutoresizingMaskIntoConstraints = false
        healthValueLabel.centerXAnchor.constraint(equalTo: healthView.centerXAnchor).isActive = true
        healthValueLabel.centerYAnchor.constraint(equalTo: healthView.centerYAnchor, constant: -7).isActive = true
        if UIDevice.current.model == "iPad" {
            healthValueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            healthValueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 15)
        }
        
    
        
        healthView.addSubview(healthTitle)
        healthTitle.translatesAutoresizingMaskIntoConstraints = false
        healthTitle.topAnchor.constraint(equalTo: healthView.topAnchor, constant: 10).isActive = true
        healthTitle.leftAnchor.constraint(equalTo: healthView.layoutMarginsGuide.leftAnchor).isActive = true
        healthTitle.text = "MAHI Health"
        if UIDevice.current.model == "iPad" {
            healthTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            healthTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 15)
        }
        
        //Upper Torque
        view.addSubview(torqueView)
        torqueView.translatesAutoresizingMaskIntoConstraints = false
        torqueView.topAnchor.constraint(equalTo: healthView.bottomAnchor).isActive = true
        torqueView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25).isActive = true
        torqueView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        torqueView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        torqueView.layer.borderWidth = 1.5
        torqueView.layer.borderColor = UIColor.black.cgColor
        
        torqueView.addSubview(upperTorqueTitle)
        upperTorqueTitle.translatesAutoresizingMaskIntoConstraints = false
        upperTorqueTitle.topAnchor.constraint(equalTo: torqueView.topAnchor, constant: 10).isActive = true
        upperTorqueTitle.leftAnchor.constraint(equalTo: torqueView.layoutMarginsGuide.leftAnchor).isActive = true
        upperTorqueTitle.text = "Upper Torque"
        if UIDevice.current.model == "iPad" {
            upperTorqueTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            upperTorqueTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 15)
        }
        
        torqueView.addSubview(middleTorqueTitle)
        middleTorqueTitle.translatesAutoresizingMaskIntoConstraints = false
        middleTorqueTitle.topAnchor.constraint(equalTo: torqueView.topAnchor, constant: 10).isActive = true
        middleTorqueTitle.centerXAnchor.constraint(equalTo: torqueView.centerXAnchor).isActive = true
        middleTorqueTitle.text = "Middle Torque"
        if UIDevice.current.model == "iPad" {
            middleTorqueTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            middleTorqueTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 15)
        }
        
        torqueView.addSubview(lowerTorqueTitle)
        lowerTorqueTitle.translatesAutoresizingMaskIntoConstraints = false
        lowerTorqueTitle.topAnchor.constraint(equalTo: torqueView.topAnchor, constant: 10).isActive = true
        lowerTorqueTitle.rightAnchor.constraint(equalTo: torqueView.layoutMarginsGuide.rightAnchor).isActive = true
        lowerTorqueTitle.text = "Lower Torque"
        if UIDevice.current.model == "iPad" {
            lowerTorqueTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            lowerTorqueTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 15)
        }
        
        

        
        upperTorqueDial = DialChartView(score: CGFloat(upperTorque), type: "Upper")
        torqueView.addSubview(upperTorqueDial)
        upperTorqueDial.translatesAutoresizingMaskIntoConstraints = false
        upperTorqueDial.centerXAnchor.constraint(equalTo: upperTorqueTitle.centerXAnchor).isActive = true
        upperTorqueDial.topAnchor.constraint(equalTo: upperTorqueTitle.bottomAnchor, constant: 5).isActive = true
        upperTorqueDial.widthAnchor.constraint(equalTo: torqueView.widthAnchor, multiplier: 0.3).isActive = true
        upperTorqueDial.heightAnchor.constraint(equalTo: torqueView.heightAnchor, multiplier: 0.7).isActive = true
        upperTorqueDial.backgroundColor = .clear
        
        torqueView.addSubview(upperTorqueLabel)
        upperTorqueLabel.translatesAutoresizingMaskIntoConstraints = false
        upperTorqueLabel.centerXAnchor.constraint(equalTo: upperTorqueTitle.centerXAnchor).isActive = true
        upperTorqueLabel.centerYAnchor.constraint(equalTo: torqueView.centerYAnchor, constant: 6).isActive = true
        if UIDevice.current.model == "iPad" {
            upperTorqueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            upperTorqueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
        }
        
        middleTorqueDial = DialChartView(score: CGFloat(middleTorque), type: "Middle")
        torqueView.addSubview(middleTorqueDial)
        middleTorqueDial.translatesAutoresizingMaskIntoConstraints = false
        middleTorqueDial.centerXAnchor.constraint(equalTo: middleTorqueTitle.centerXAnchor).isActive = true
        middleTorqueDial.topAnchor.constraint(equalTo: middleTorqueTitle.bottomAnchor, constant: 6).isActive = true
        middleTorqueDial.widthAnchor.constraint(equalTo: torqueView.widthAnchor, multiplier: 0.3).isActive = true
        middleTorqueDial.heightAnchor.constraint(equalTo: torqueView.heightAnchor, multiplier: 0.7).isActive = true
        middleTorqueDial.backgroundColor = .clear
        
        
        torqueView.addSubview(middleTorqueLabel)
        middleTorqueLabel.translatesAutoresizingMaskIntoConstraints = false
        middleTorqueLabel.centerXAnchor.constraint(equalTo: middleTorqueTitle.centerXAnchor).isActive = true
        middleTorqueLabel.centerYAnchor.constraint(equalTo: torqueView.centerYAnchor, constant: 6).isActive = true
        if UIDevice.current.model == "iPad" {
            middleTorqueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            middleTorqueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 15)
        }
        
        lowerTorqueDial = DialChartView(score: CGFloat(lowerTorque), type: "Lower")
        torqueView.addSubview(lowerTorqueDial)
        lowerTorqueDial.translatesAutoresizingMaskIntoConstraints = false
        lowerTorqueDial.centerXAnchor.constraint(equalTo: lowerTorqueTitle.centerXAnchor).isActive = true
        lowerTorqueDial.topAnchor.constraint(equalTo: lowerTorqueTitle.bottomAnchor, constant: 5).isActive = true
        lowerTorqueDial.widthAnchor.constraint(equalTo: torqueView.widthAnchor, multiplier: 0.3).isActive = true
        lowerTorqueDial.heightAnchor.constraint(equalTo: torqueView.heightAnchor, multiplier: 0.7).isActive = true
        lowerTorqueDial.backgroundColor = .clear
        
        torqueView.addSubview(lowerTorqueLabel)
        lowerTorqueLabel.translatesAutoresizingMaskIntoConstraints = false
        lowerTorqueLabel.centerXAnchor.constraint(equalTo: lowerTorqueTitle.centerXAnchor).isActive = true
        lowerTorqueLabel.centerYAnchor.constraint(equalTo: torqueView.centerYAnchor, constant: 5).isActive = true
        if UIDevice.current.model == "iPad" {
            lowerTorqueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            lowerTorqueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 15)
        }

        
        //Temp
        view.addSubview(temperatureView)
        temperatureView.translatesAutoresizingMaskIntoConstraints = false
        temperatureView.topAnchor.constraint(equalTo: torqueView.bottomAnchor).isActive = true
        temperatureView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25).isActive = true
        temperatureView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        temperatureView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        temperatureView.layer.borderWidth = 1.5
        temperatureView.layer.borderColor = UIColor.black.cgColor
//
//        temperatureView.addSubview(upperTempLabel)
        temperatureView.addSubview(middleTempLabel)
//        temperatureView.addSubview(lowerTempLabel)
//        upperTempLabel.numberOfLines = 2
        middleTempLabel.numberOfLines = 2
//        lowerTempLabel.numberOfLines = 2
        
        if UIDevice.current.model == "iPad" {
//            upperTempLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
            middleTempLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
//            lowerTempLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
//            upperTempLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
            middleTempLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
//            lowerTempLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
        }
        
//        upperTempLabel.text = "Upper Temperature"
        middleTempLabel.text = "Temperature"
//        lowerTempLabel.text = "Lower Temperature"
        
//        upperTempLabel.translatesAutoresizingMaskIntoConstraints = false
        middleTempLabel.translatesAutoresizingMaskIntoConstraints = false
//        lowerTempLabel.translatesAutoresizingMaskIntoConstraints = false
        
//        upperTempLabel.topAnchor.constraint(equalTo: temperatureView.topAnchor, constant: 10).isActive = true
//        upperTempLabel.leftAnchor.constraint(equalTo: temperatureView.layoutMarginsGuide.leftAnchor).isActive = true
        middleTempLabel.topAnchor.constraint(equalTo: temperatureView.topAnchor, constant: 10).isActive = true
        middleTempLabel.centerXAnchor.constraint(equalTo: temperatureView.centerXAnchor).isActive = true
//        lowerTempLabel.topAnchor.constraint(equalTo: temperatureView.topAnchor, constant: 10).isActive = true
//        lowerTempLabel.rightAnchor.constraint(equalTo: temperatureView.layoutMarginsGuide.rightAnchor).isActive = true
        
//        let temperatureGraph = TemperatureLineGraph()
        temperatureView.addSubview(temperatureGraph)
        temperatureGraph.translatesAutoresizingMaskIntoConstraints = false
        temperatureGraph.leftAnchor.constraint(equalTo: temperatureView.leftAnchor).isActive = true
        temperatureGraph.rightAnchor.constraint(equalTo: temperatureView.rightAnchor).isActive = true
        temperatureGraph.topAnchor.constraint(equalTo: middleTempLabel.bottomAnchor).isActive = true
        temperatureGraph.bottomAnchor.constraint(equalTo: temperatureView.bottomAnchor).isActive = true
        
        temperatureGraph.rightAxis.drawLabelsEnabled = false
        temperatureGraph.rightAxis.drawZeroLineEnabled = false
        temperatureGraph.rightAxis.drawGridLinesEnabled = false
        temperatureGraph.xAxis.drawLabelsEnabled = false
        temperatureGraph.xAxis.drawGridLinesEnabled = false
        temperatureGraph.leftAxis.drawGridLinesEnabled = false
    
        
        
        
        view.addSubview(positionView)
        positionView.translatesAutoresizingMaskIntoConstraints = false
        positionView.topAnchor.constraint(equalTo: temperatureView.bottomAnchor).isActive = true
        positionView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25).isActive = true
        positionView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        positionView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        positionView.layer.borderWidth = 1.5
        positionView.layer.borderColor = UIColor.black.cgColor
        
        positionView.addSubview(xPosLabel)
        positionView.addSubview(yPosLabel)
        positionView.addSubview(zPosLabel)
        xPosLabel.numberOfLines = 2
        yPosLabel.numberOfLines = 2
        zPosLabel.numberOfLines = 2
        
        if UIDevice.current.model == "iPad" {
            xPosLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
            yPosLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
            zPosLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            xPosLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
            yPosLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
            zPosLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
        }
        
//        xPosLabel.text = "X Position"
        yPosLabel.text = "Position"
//        zPosLabel.text = "Z Position"
        
        xPosLabel.translatesAutoresizingMaskIntoConstraints = false
        yPosLabel.translatesAutoresizingMaskIntoConstraints = false
        zPosLabel.translatesAutoresizingMaskIntoConstraints = false
        
        xPosLabel.topAnchor.constraint(equalTo: positionView.topAnchor, constant: 10).isActive = true
        xPosLabel.leftAnchor.constraint(equalTo: positionView.layoutMarginsGuide.leftAnchor).isActive = true
        yPosLabel.topAnchor.constraint(equalTo: positionView.topAnchor, constant: 10).isActive = true
        yPosLabel.centerXAnchor.constraint(equalTo: positionView.centerXAnchor).isActive = true
        zPosLabel.topAnchor.constraint(equalTo: positionView.topAnchor, constant: 10).isActive = true
        zPosLabel.rightAnchor.constraint(equalTo: positionView.layoutMarginsGuide.rightAnchor).isActive = true
        
        positionView.addSubview(positionGraph)
        positionGraph.translatesAutoresizingMaskIntoConstraints = false
        positionGraph.leftAnchor.constraint(equalTo: positionView.leftAnchor).isActive = true
        positionGraph.rightAnchor.constraint(equalTo: positionView.rightAnchor).isActive = true
        positionGraph.topAnchor.constraint(equalTo: yPosLabel.bottomAnchor).isActive = true
        positionGraph.bottomAnchor.constraint(equalTo: positionView.bottomAnchor).isActive = true
        
        positionGraph.rightAxis.drawLabelsEnabled = false
        positionGraph.rightAxis.drawZeroLineEnabled = false
        positionGraph.xAxis.drawLabelsEnabled = false
        positionGraph.leftAxis.drawZeroLineEnabled = false
        positionGraph.xAxis.drawGridLinesEnabled = false
        positionGraph.rightAxis.drawGridLinesEnabled = false
        positionGraph.leftAxis.drawGridLinesEnabled = false
        

        
        getRobotData()
        updateUI()
        
        
        
    }
    
    func handleEvent(_ session: MQTTSession!, event eventCode: MQTTSessionEvent, error: Error!) {
        switch eventCode {
        case .connected:
            print("Connected")
            session.subscribe(toTopics: [
                "iot-2/type/gsc-yaskawa-gw/id/gsc-yaskawa-01/evt/health/fmt/json" : 1,
                "iot-2/type/gsc-yaskawa-gw/id/gsc-yaskawa-01/evt/update/fmt/json" : 1,
                "iot-2/type/gsc-yaskawa-gw/id/gsc-yaskawa-01/evt/scoring/fmt/json" : 1,
                "iot-2/type/gsc-yaskawa-gw/id/gsc-yaskawa-01/evt/image/fmt/json" : 1
            ])
        case .connectionClosed:
            print("Closed")
        case .connectionClosedByBroker:
            print("Closed by Broker")
        case .connectionError:
            print("Error")
        case .connectionRefused:
            print("Refused")
        case .protocolError:
            print("Protocol Error")
        @unknown default:
            print("Unknown")
        }
    }
    
    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
            print("JSON: \(json)")
            if topic! == "iot-2/type/gsc-yaskawa-gw/id/gsc-yaskawa-01/evt/health/fmt/json" {
                DispatchQueue.main.async { [weak self] in
                    if let healthScore = (json["health"] as? Int) {
                        self?.healthScore = healthScore
                        self?.updateUI()
                    } else {
                        print("Error getting health score")
                    }
                }
            }  else if topic! == "iot-2/type/gsc-yaskawa-gw/id/gsc-yaskawa-01/evt/update/fmt/json" {
                DispatchQueue.main.async { [weak self] in
                    if let upperTorque = (json["bTorque"] as? String) {
                        self?.upperTorque = abs(Int(upperTorque)!)
//                        self?.updateUI()
                    } else {
                        print("Error getting upper torque")
                    }
 
                    if let middleTorque = (json["uTorque"] as? String) {
                        self?.middleTorque = abs(Int(middleTorque)!)
//                        self?.updateUI()
                    } else {
                        print("Error getting middle torque")
                    }
                    
                    if let lowerTorque = (json["sTorque"] as? String) {
                        self?.lowerTorque = abs(Int(lowerTorque)!)
//                        self?.updateUI()
                    } else {
                        print("Error getting middle torque")
                    }
                    
                    if let upperTemp = json["bTemp"] as? String {
                        //was btemp
                        self?.upperTemp.append(abs(Double(upperTemp)!))
//                        self?.updateUI()
                    }
                    
                    if let middleTemp = json["uTemp"] as? String {
                        self?.middleTemp.append(abs(Double(middleTemp)!))
//                        self?.updateUI()
                    }
                    
                    if let lowerTemp = json["sTemp"] as? String {
                        self?.lowerTemp.append(abs(Double(lowerTemp)!))
//                        self?.updateUI()
                    }
                    
                    if let xPos = json["xPos"] as? String {
                        self?.xPos.append(abs(Double(xPos)!))
//                        self?.updateUI()
                    }
                    
                    if let yPos = json["yPos"] as? String {
                        self?.yPos.append(abs(Double(yPos)!))
//                        self?.updateUI()
                    }
                    
                    if let zPos = json["zPos"] as? String {
                        self?.zPos.append(abs(Double(zPos)!))
//                        self?.updateUI()
                    }
                    self?.updateGraph()
                }
            } 
        }
        
    }
    
    func subAckReceived(_ session: MQTTSession!, msgID: UInt16, grantedQoss qoss: [NSNumber]!) {
        print("Subscription Status: Subscribed")
    }
    
    func unsubAckReceived(_ session: MQTTSession!, msgID: UInt16) {
        print("Subscription Status Unsubscribed")
    }
    
}
