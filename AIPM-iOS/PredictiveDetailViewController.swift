//
//  PredictiveDetailViewController.swift
//  AIPM-iOS
//
//  Created by Joshua Dadson on 8/31/20.
//  Copyright © 2020 Joshua Dadson. All rights reserved.
//

import UIKit
import MQTTClient

class PredictiveDetailViewController: UIViewController, MQTTSessionDelegate {
    //MQTT
    let session = MQTTSession()!
    var text = ""
    
    var vcTitle = String()
    var healthScore = Int()
    var upperTorque = Int()
    var middleTorque = Int()
    var lowerTorque = Int()
    
    //Health Views
    var healthView = UIView()
    let healthTitle = UILabel()
    let healthValueLabel = UILabel()
    let healthBackgroundBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let healthBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    //Torque Views
    let torqueBackgroundBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let torqueBackgroundBar2 = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    let torqueBackgroundBar3 = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var upperTorqueLabel = UILabel()
    var upperTorqueView = UIView()
    var upperTorqueTitle = UILabel()
    let upperTorqueBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var middleTorqueLabel = UILabel()
    var middleTorqueView = UIView()
    var middleTorqueTitle = UILabel()
    let middleTorqueBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
    var lowerTorqueLabel = UILabel()
    var lowerTorqueView = UIView()
    var lowerTorqueTitle = UILabel()
    let lowerTorqueBar = UIView(frame: CGRect(x: 0, y: 0, width: 0, height: 0))
    
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
        var healthMult = (CGFloat(healthScore)/100)
        var upperTorqueMult = (CGFloat(upperTorque)/2500)
        var middleTorqueMult = (CGFloat(middleTorque)/5000)
        var lowerTorqueMult = (CGFloat(lowerTorque)/5000)
//
        if healthMult == 0/100 {
            healthMult = 0.01
        }

        if upperTorqueMult == 0/100 {
            upperTorqueMult = 0.01
        }

        if middleTorqueMult == 0/100 {
            middleTorqueMult = 0.01
        }
        if lowerTorqueMult == 0/100 {
            lowerTorqueMult = 0.01
        }
        
        healthValueLabel.text = String(healthScore)
        healthBar.widthAnchor.constraint(equalTo: healthBackgroundBar.widthAnchor, multiplier: healthMult).isActive = true
        
        upperTorqueLabel.text = String(upperTorque)
        upperTorqueBar.widthAnchor.constraint(equalTo: torqueBackgroundBar.widthAnchor, multiplier: upperTorqueMult).isActive = true
        
        middleTorqueLabel.text = String(middleTorque)
        middleTorqueBar.widthAnchor.constraint(equalTo: torqueBackgroundBar2.widthAnchor, multiplier: middleTorqueMult).isActive = true
        
        lowerTorqueLabel.text = String(lowerTorque)
        lowerTorqueBar.widthAnchor.constraint(equalTo: torqueBackgroundBar3.widthAnchor, multiplier: lowerTorqueMult).isActive = true
       
        
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
//        healthView.backgroundColor = UIColor(displayP3Red: 221/255, green: 225/255, blue: 230/255, alpha: 1.0)
        healthView.translatesAutoresizingMaskIntoConstraints = false
        healthView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 0).isActive = true
        healthView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25).isActive = true
        healthView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        healthView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        healthView.backgroundColor = UIColor.white
        healthView.layer.borderWidth = 1.5
        healthView.layer.borderColor = UIColor.black.cgColor
        //        healthView.layer.cornerRadius = 10.0
        
        healthView.addSubview(healthValueLabel)
        healthValueLabel.translatesAutoresizingMaskIntoConstraints = false
        healthValueLabel.centerXAnchor.constraint(equalTo: healthView.centerXAnchor).isActive = true
        healthValueLabel.centerYAnchor.constraint(equalTo: healthView.centerYAnchor).isActive = true
        if UIDevice.current.model == "iPad" {
            healthValueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            healthValueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
        }
        
        healthBackgroundBar.backgroundColor = UIColor.lightGray
        healthView.addSubview(healthBackgroundBar)
        healthBackgroundBar.translatesAutoresizingMaskIntoConstraints = false
        healthBackgroundBar.centerXAnchor.constraint(equalTo: healthView.centerXAnchor).isActive = true
        healthBackgroundBar.widthAnchor.constraint(equalTo: healthView.widthAnchor, multiplier: 0.85).isActive = true
        healthBackgroundBar.heightAnchor.constraint(equalTo: healthView.heightAnchor, multiplier: 0.2).isActive = true
        healthBackgroundBar.bottomAnchor.constraint(equalTo: healthView.bottomAnchor, constant: -15.0 ).isActive = true
        healthBackgroundBar.layer.borderWidth = 3
        
        healthBar.backgroundColor = UIColor.green
        healthBackgroundBar.addSubview(healthBar)
        healthBar.translatesAutoresizingMaskIntoConstraints = false
        healthBar.leftAnchor.constraint(equalTo: healthBackgroundBar.leftAnchor).isActive = true
        healthBar.widthAnchor.constraint(equalTo: healthBackgroundBar.widthAnchor).isActive = true
        healthBar.heightAnchor.constraint(equalTo: healthBackgroundBar.heightAnchor).isActive = true
        healthBar.bottomAnchor.constraint(equalTo: healthBackgroundBar.bottomAnchor).isActive = true
        
        healthView.addSubview(healthTitle)
        healthTitle.translatesAutoresizingMaskIntoConstraints = false
        healthTitle.topAnchor.constraint(equalTo: healthView.topAnchor, constant: 10).isActive = true
        healthTitle.leftAnchor.constraint(equalTo: healthView.layoutMarginsGuide.leftAnchor).isActive = true
        healthTitle.text = "MAHI Health"
        if UIDevice.current.model == "iPad" {
            healthTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            healthTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
        }
        
        
        //Upper Torque
        view.addSubview(upperTorqueView)
//        upperTorqueView.backgroundColor = UIColor(displayP3Red: 221/255, green: 225/255, blue: 230/255, alpha: 1.0)
        upperTorqueView.addSubview(upperTorqueTitle)
        upperTorqueTitle.translatesAutoresizingMaskIntoConstraints = false
        upperTorqueTitle.topAnchor.constraint(equalTo: upperTorqueView.topAnchor, constant: 10).isActive = true
        upperTorqueTitle.leftAnchor.constraint(equalTo: upperTorqueView.layoutMarginsGuide.leftAnchor).isActive = true
        upperTorqueTitle.text = "Upper Torque"
        if UIDevice.current.model == "iPad" {
            upperTorqueTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            upperTorqueTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
        }
        
        upperTorqueView.addSubview(upperTorqueLabel)
        upperTorqueLabel.translatesAutoresizingMaskIntoConstraints = false
        upperTorqueLabel.centerXAnchor.constraint(equalTo: upperTorqueView.centerXAnchor).isActive = true
        upperTorqueLabel.centerYAnchor.constraint(equalTo: upperTorqueView.centerYAnchor).isActive = true
        if UIDevice.current.model == "iPad" {
            upperTorqueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            upperTorqueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
        }
        
        upperTorqueView.translatesAutoresizingMaskIntoConstraints = false
        upperTorqueView.topAnchor.constraint(equalTo: healthView.bottomAnchor).isActive = true
        //        upperTorqueView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -5).isActive = true
        upperTorqueView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25).isActive = true
        upperTorqueView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        upperTorqueView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        upperTorqueView.backgroundColor = UIColor.white
        upperTorqueView.layer.borderWidth = 1.5
        upperTorqueView.layer.borderColor = UIColor.black.cgColor
        //        torqueView.layer.cornerRadius = 10.0
        
        torqueBackgroundBar.backgroundColor = UIColor.lightGray
        upperTorqueView.addSubview(torqueBackgroundBar)
        torqueBackgroundBar.translatesAutoresizingMaskIntoConstraints = false
        torqueBackgroundBar.centerXAnchor.constraint(equalTo: upperTorqueView.centerXAnchor).isActive = true
        torqueBackgroundBar.widthAnchor.constraint(equalTo: upperTorqueView.widthAnchor, multiplier: 0.85).isActive = true
        torqueBackgroundBar.heightAnchor.constraint(equalTo: upperTorqueView.heightAnchor, multiplier: 0.2).isActive = true
        torqueBackgroundBar.bottomAnchor.constraint(equalTo: upperTorqueView.safeAreaLayoutGuide.bottomAnchor, constant: -15.0 ).isActive = true
        torqueBackgroundBar.layer.borderWidth = 3
        
        upperTorqueBar.backgroundColor = UIColor.green
        torqueBackgroundBar.addSubview(upperTorqueBar)
        upperTorqueBar.translatesAutoresizingMaskIntoConstraints = false
        upperTorqueBar.leftAnchor.constraint(equalTo: torqueBackgroundBar.leftAnchor).isActive = true
        upperTorqueBar.widthAnchor.constraint(equalTo: torqueBackgroundBar.widthAnchor, multiplier: (CGFloat(upperTorque))/2500).isActive = true
        upperTorqueBar.heightAnchor.constraint(equalTo: torqueBackgroundBar.heightAnchor).isActive = true
        upperTorqueBar.bottomAnchor.constraint(equalTo: torqueBackgroundBar.bottomAnchor).isActive = true
        
        
        
        
        
        //Middle Torque
        view.addSubview(middleTorqueView)
//        middleTorqueView.backgroundColor = UIColor(displayP3Red: 221/255, green: 225/255, blue: 230/255, alpha: 1.0)
        middleTorqueView.addSubview(middleTorqueTitle)
        middleTorqueTitle.translatesAutoresizingMaskIntoConstraints = false
        middleTorqueTitle.topAnchor.constraint(equalTo: middleTorqueView.topAnchor, constant: 10).isActive = true
        middleTorqueTitle.leftAnchor.constraint(equalTo: middleTorqueView.layoutMarginsGuide.leftAnchor).isActive = true
        middleTorqueTitle.text = "Middle Torque"
        if UIDevice.current.model == "iPad" {
            middleTorqueTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            middleTorqueTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
        }
        
        
        middleTorqueView.addSubview(middleTorqueLabel)
        middleTorqueLabel.translatesAutoresizingMaskIntoConstraints = false
        middleTorqueLabel.centerXAnchor.constraint(equalTo: middleTorqueView.centerXAnchor).isActive = true
        middleTorqueLabel.centerYAnchor.constraint(equalTo: middleTorqueView.centerYAnchor).isActive = true
        if UIDevice.current.model == "iPad" {
            middleTorqueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            middleTorqueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
        }
        
        middleTorqueView.translatesAutoresizingMaskIntoConstraints = false
        middleTorqueView.topAnchor.constraint(equalTo: upperTorqueView.bottomAnchor).isActive = true
        //        upperTorqueView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -5).isActive = true
        middleTorqueView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25).isActive = true
        middleTorqueView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        middleTorqueView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        middleTorqueView.backgroundColor = UIColor.white
        middleTorqueView.layer.borderWidth = 1.5
        middleTorqueView.layer.borderColor = UIColor.black.cgColor
        //        torqueView.layer.cornerRadius = 10.0
        
        torqueBackgroundBar2.backgroundColor = UIColor.lightGray
        middleTorqueView.addSubview(torqueBackgroundBar2)
        torqueBackgroundBar2.translatesAutoresizingMaskIntoConstraints = false
        torqueBackgroundBar2.centerXAnchor.constraint(equalTo: middleTorqueView.centerXAnchor).isActive = true
        torqueBackgroundBar2.widthAnchor.constraint(equalTo: middleTorqueView.widthAnchor, multiplier: 0.85).isActive = true
        torqueBackgroundBar2.heightAnchor.constraint(equalTo: middleTorqueView.heightAnchor, multiplier: 0.2).isActive = true
        torqueBackgroundBar2.bottomAnchor.constraint(equalTo: middleTorqueView.safeAreaLayoutGuide.bottomAnchor, constant: -15.0 ).isActive = true
        torqueBackgroundBar2.layer.borderWidth = 3
        
        middleTorqueBar.backgroundColor = UIColor.green
        torqueBackgroundBar2.addSubview(middleTorqueBar)
        middleTorqueBar.translatesAutoresizingMaskIntoConstraints = false
        middleTorqueBar.leftAnchor.constraint(equalTo: torqueBackgroundBar2.leftAnchor).isActive = true
        middleTorqueBar.widthAnchor.constraint(equalTo: torqueBackgroundBar2.widthAnchor, multiplier: (CGFloat(middleTorque))/5000).isActive = true
        middleTorqueBar.heightAnchor.constraint(equalTo: torqueBackgroundBar2.heightAnchor).isActive = true
        middleTorqueBar.bottomAnchor.constraint(equalTo: torqueBackgroundBar2.bottomAnchor).isActive = true
        
        
        
        //Lower Torque
        view.addSubview(lowerTorqueView)
//        lowerTorqueView.backgroundColor = UIColor(displayP3Red: 221/255, green: 225/255, blue: 230/255, alpha: 1.0)
        lowerTorqueView.addSubview(lowerTorqueTitle)
        lowerTorqueTitle.translatesAutoresizingMaskIntoConstraints = false
        lowerTorqueTitle.topAnchor.constraint(equalTo: lowerTorqueView.topAnchor, constant: 10).isActive = true
        lowerTorqueTitle.leftAnchor.constraint(equalTo: lowerTorqueView.layoutMarginsGuide.leftAnchor).isActive = true
        lowerTorqueTitle.text = "Lower Torque"
        if UIDevice.current.model == "iPad" {
            lowerTorqueTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            lowerTorqueTitle.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
        }
        
        lowerTorqueView.addSubview(lowerTorqueLabel)
        lowerTorqueLabel.translatesAutoresizingMaskIntoConstraints = false
        lowerTorqueLabel.centerXAnchor.constraint(equalTo: lowerTorqueView.centerXAnchor).isActive = true
        lowerTorqueLabel.centerYAnchor.constraint(equalTo: lowerTorqueView.centerYAnchor).isActive = true
        if UIDevice.current.model == "iPad" {
            lowerTorqueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 25)
        } else {
            lowerTorqueLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
        }
        
        lowerTorqueView.translatesAutoresizingMaskIntoConstraints = false
        lowerTorqueView.topAnchor.constraint(equalTo: middleTorqueView.bottomAnchor).isActive = true
        //        upperTorqueView.bottomAnchor.constraint(equalTo: view.layoutMarginsGuide.bottomAnchor, constant: -5).isActive = true
        lowerTorqueView.heightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.25).isActive = true
        lowerTorqueView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
        lowerTorqueView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
//        lowerTorqueView.backgroundColor = UIColor.white
        lowerTorqueView.layer.borderWidth = 1.5
        lowerTorqueView.layer.borderColor = UIColor.black.cgColor
        //        torqueView.layer.cornerRadius = 10.0
        
        torqueBackgroundBar3.backgroundColor = UIColor.lightGray
        lowerTorqueView.addSubview(torqueBackgroundBar3)
        torqueBackgroundBar3.translatesAutoresizingMaskIntoConstraints = false
        torqueBackgroundBar3.centerXAnchor.constraint(equalTo: lowerTorqueView.centerXAnchor).isActive = true
        torqueBackgroundBar3.widthAnchor.constraint(equalTo: lowerTorqueView.widthAnchor, multiplier: 0.85).isActive = true
        torqueBackgroundBar3.heightAnchor.constraint(equalTo: lowerTorqueView.heightAnchor, multiplier: 0.2).isActive = true
        torqueBackgroundBar3.bottomAnchor.constraint(equalTo: lowerTorqueView.safeAreaLayoutGuide.bottomAnchor, constant: -15.0 ).isActive = true
        torqueBackgroundBar3.layer.borderWidth = 3
        
        lowerTorqueBar.backgroundColor = UIColor.green
        torqueBackgroundBar3.addSubview(lowerTorqueBar)
        lowerTorqueBar.translatesAutoresizingMaskIntoConstraints = false
        lowerTorqueBar.leftAnchor.constraint(equalTo: torqueBackgroundBar3.leftAnchor).isActive = true
        lowerTorqueBar.widthAnchor.constraint(equalTo: torqueBackgroundBar3.widthAnchor, multiplier: (CGFloat(middleTorque))/10000).isActive = true
        lowerTorqueBar.heightAnchor.constraint(equalTo: torqueBackgroundBar3.heightAnchor).isActive = true
        lowerTorqueBar.bottomAnchor.constraint(equalTo: torqueBackgroundBar3.bottomAnchor).isActive = true
        
        
        
        getRobotData()
        updateUI()
        
        
    }
    
    func handleEvent(_ session: MQTTSession!, event eventCode: MQTTSessionEvent, error: Error!) {
        switch eventCode {
        case .connected:
            print("Connected")
            //            session.subscribe(toTopic: "iot-2/type/gsc-yaskawa-gw/id/gsc-yaskawa-01/evt/health/fmt/json", at: .atMostOnce)
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
                        self?.updateUI()
                    } else {
                        print("Error getting upper torque")
                    }
                    
                    if let middleTorque = (json["uTorque"] as? String) {
                        self?.middleTorque = abs(Int(middleTorque)!)
                        self?.updateUI()
                    } else {
                        print("Error getting middle torque")
                    }
                    
                    if let lowerTorque = (json["sTorque"] as? String) {
                        self?.lowerTorque = abs(Int(lowerTorque)!)
                        self?.updateUI()
                    } else {
                        print("Error getting middle torque")
                    }
                    
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
