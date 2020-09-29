//
//  PredictiveDetailViewController.swift
//  AIPM-iOS
//
//  Created by Joshua Dadson on 8/31/20.
//  Copyright © 2020 Joshua Dadson. All rights reserved.
//

import UIKit
import MQTTClient

class VisualDetailViewController: UIViewController, MQTTSessionDelegate {
    //MQTT
    let session = MQTTSession()!
    var text = ""
    
    var robot = String()
    var image = UIImage()
    var itemName = String()
    var batch = String()
    var date = String()
    var time = String()
    var confidence = String()
    var classification = String()
    
    let imageView = UIImageView()
    let itemLabel = UILabel()
    let batchLabel = UILabel()
    let dateLabel = UILabel()
    let timeLabel = UILabel()
    let confidenceLabel = UILabel()
    
    var subscribeCreds = ["",""]
    
    var maximizeFlag = false
    var maxImageView : UIImageView?
    let touchScreenLabel = UILabel()
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        
        if maximizeFlag == false {
            maxImageView = imageView.maximize(image: imageView.image!, size: CGSize(width: view.frame.size.width, height: view.frame.size.height))
            view.addSubview(maxImageView!)
            maximizeFlag = true

        } else {
            maxImageView!.removeFromSuperview()
            maximizeFlag = false
        }
    }
    
    init(robot: String, image: UIImage, itemName : String, batch : String, date: String, time: String, confidence: String, classification: String) {
        super.init(nibName: nil, bundle: nil)
        self.robot = robot
        self.itemName = itemName
        self.batch = batch
        self.date = date
        self.time = time
        self.confidence = confidence
    }
    
    init(robot: String) {
        super.init(nibName: nil, bundle: nil)
        self.robot = robot
    }
    
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func updateUI() {
        
//        self.view.backgroundColor = UIColor(patternImage: self.image)
        imageView.image = self.image
        if UIDevice.current.model == "iPad" {
            itemLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
            batchLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
            dateLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
            timeLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
            confidenceLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
            touchScreenLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 30)
        } else {
            itemLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 14)
            batchLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 14)
            dateLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 14)
            timeLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 14)
            confidenceLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 14)
            touchScreenLabel.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
        }
        
        itemLabel.text = "Item/Classification: \(self.itemName.uppercased()) - \(self.classification.uppercased())"
        batchLabel.text = "Batch: \(self.batch) "
        dateLabel.text = "Date: \(self.date) "
        timeLabel.text = "Time: \(self.time)"
        confidenceLabel.text = "Confidence: \(self.confidence)"
        
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
    
    
     
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        
//        NSLayoutConstraint.deactivate(view.constraints)
//        NSLayoutConstraint.deactivate(imageView.constraints)
//        NSLayoutConstraint.deactivate(itemLabel.constraints)
//        NSLayoutConstraint.deactivate(batchLabel.constraints)
//        NSLayoutConstraint.deactivate(dateLabel.constraints)
//        NSLayoutConstraint.deactivate(timeLabel.constraints)
//        NSLayoutConstraint.deactivate(confidenceLabel.constraints)
        
        if self.maxImageView != nil {
            self.maxImageView!.removeFromSuperview()
        }
        
        imageView.removeFromSuperview()
        itemLabel.removeFromSuperview()
        batchLabel.removeFromSuperview()
        dateLabel.removeFromSuperview()
        timeLabel.removeFromSuperview()
        confidenceLabel.removeFromSuperview()
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        imageView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.5).isActive = true
//        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        imageView.frame.size.width = (imageView.image?.size.width) ?? 0
        imageView.frame.size.width = (imageView.image?.size.height) ?? 0
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        imageView.contentMode = .scaleAspectFit
        
        view.addSubview(itemLabel)
        itemLabel.text = "Item: \(self.itemName)"
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        itemLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        //        itemLabel.layer.borderWidth = 2
        
        view.addSubview(batchLabel)
        batchLabel.text = "Batch: \(self.batch) "
        batchLabel.translatesAutoresizingMaskIntoConstraints = false
        batchLabel.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 5).isActive = true
        batchLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        //        batchLabel.layer.borderWidth = 2
        
        view.addSubview(dateLabel)
        dateLabel.text = "Date: \(self.date) "
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: batchLabel.bottomAnchor, constant: 5).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        //        dateLabel.layer.borderWidth = 2
        
        view.addSubview(timeLabel)
        timeLabel.text = "Time: \(self.time)"
        timeLabel.translatesAutoresizingMaskIntoConstraints = false
    
        if UIDevice.current.orientation.isPortrait {
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
            timeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
            print("Portrait")
        } else {
            timeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            print("Landscape")
        }
        //        timeLabel.layer.borderWidth = 2
        
        view.addSubview(confidenceLabel)
        confidenceLabel.text = "Confidence: \(self.confidence)"
        confidenceLabel.translatesAutoresizingMaskIntoConstraints = false
        
        if UIDevice.current.orientation.isPortrait {
            confidenceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5).isActive = true
            confidenceLabel.leftAnchor.constraint(equalTo: timeLabel.leftAnchor).isActive = true
            print("Portrait")
        } else {
            confidenceLabel.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 5).isActive = true
            confidenceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            print("Landscape")
        }
    }

    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        if navigationController!.isNavigationBarHidden {
            navigationController?.setNavigationBarHidden(false, animated: true)
        }
        
        view.backgroundColor = UIColor.white
        title = "\(robot) Confidence Scores"
        
        if self.robot == "Yaskawa" {
            subscribeCreds[0] = "gsc-yaskawa-gw"
            subscribeCreds[1] = "gsc-yaskawa-01"
        } else if self.robot == "Kuka" {
            subscribeCreds[0] = "gsc-kuka-gw"
            subscribeCreds[1] = "gsc-kuka-01"
        }
        
        view.addSubview(imageView)
        imageView.translatesAutoresizingMaskIntoConstraints = false
        imageView.centerXAnchor.constraint(equalTo: view.layoutMarginsGuide.centerXAnchor).isActive = true
        imageView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
//        imageView.heightAnchor.constraint(equalTo: view.layoutMarginsGuide.heightAnchor, multiplier: 0.5).isActive = true
//        imageView.widthAnchor.constraint(equalTo: view.widthAnchor, multiplier: 1.0).isActive = true
        imageView.frame.size.width = (imageView.image?.size.width) ?? 0
        imageView.frame.size.width = (imageView.image?.size.height) ?? 0
        imageView.layer.borderWidth = 5
        imageView.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1)
        imageView.contentMode = .scaleAspectFit

        view.addSubview(itemLabel)
        itemLabel.text = "Item: \(self.itemName)"
        itemLabel.translatesAutoresizingMaskIntoConstraints = false
        itemLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
        itemLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        //        itemLabel.layer.borderWidth = 2

        view.addSubview(batchLabel)
        batchLabel.text = "Batch: \(self.batch) "
        batchLabel.translatesAutoresizingMaskIntoConstraints = false
        batchLabel.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 5).isActive = true
        batchLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        //        batchLabel.layer.borderWidth = 2

        view.addSubview(dateLabel)
        dateLabel.text = "Date: \(self.date) "
        dateLabel.translatesAutoresizingMaskIntoConstraints = false
        dateLabel.topAnchor.constraint(equalTo: batchLabel.bottomAnchor, constant: 5).isActive = true
        dateLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
        //        dateLabel.layer.borderWidth = 2
//
        view.addSubview(timeLabel)
        timeLabel.text = "Time: \(self.time)"
        timeLabel.translatesAutoresizingMaskIntoConstraints = false

        if UIDevice.current.orientation == .portrait {
            timeLabel.topAnchor.constraint(equalTo: dateLabel.bottomAnchor, constant: 5).isActive = true
            timeLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor, constant: 10).isActive = true
            print("Portrait")
        } else {
            timeLabel.topAnchor.constraint(equalTo: imageView.bottomAnchor, constant: 10).isActive = true
            timeLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            print("Landscape")
        }
        //        timeLabel.layer.borderWidth = 2

        view.addSubview(confidenceLabel)
        confidenceLabel.text = "Confidence: \(self.confidence)"
        confidenceLabel.translatesAutoresizingMaskIntoConstraints = false

        if UIDevice.current.orientation == .portrait {
            confidenceLabel.topAnchor.constraint(equalTo: timeLabel.bottomAnchor, constant: 5).isActive = true
            confidenceLabel.leftAnchor.constraint(equalTo: timeLabel.leftAnchor).isActive = true
            print("Portrait")
        } else {
            confidenceLabel.topAnchor.constraint(equalTo: itemLabel.bottomAnchor, constant: 5).isActive = true
            confidenceLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor).isActive = true
            print("Landscape")
        }
        
        //        confidenceLabel.layer.borderWidth = 2
        
//        view.addSubview(touchScreenLabel)
//        touchScreenLabel.text = "Tap screen to enlarge picture. Tap screen again in order to minimize picture."
//        touchScreenLabel.numberOfLines = 2
//        touchScreenLabel.translatesAutoresizingMaskIntoConstraints = false
//        touchScreenLabel.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
//        touchScreenLabel.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
//        touchScreenLabel.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
//        touchScreenLabel.centerXAnchor.constraint(equalTo: view.safeAreaLayoutGuide.centerXAnchor).isActive = true
        
        
        getRobotData()
        updateUI()
        
        
    }
    
    func handleEvent(_ session: MQTTSession!, event eventCode: MQTTSessionEvent, error: Error!) {
        switch eventCode {
        case .connected:
            print("Connected")
            //            session.subscribe(toTopic: "iot-2/type/gsc-yaskawa-gw/id/gsc-yaskawa-01/evt/health/fmt/json", at: .atMostOnce)
            
            
            session.subscribe(toTopics: [
                "iot-2/type/\(subscribeCreds[0])/id/\(subscribeCreds[1])/evt/health/fmt/json" : 1,
                "iot-2/type/\(subscribeCreds[0])/id/\(subscribeCreds[1])/evt/update/fmt/json" : 1,
                "iot-2/type/\(subscribeCreds[0])/id/\(subscribeCreds[1])/evt/scoring/fmt/json" : 1,
                "iot-2/type/\(subscribeCreds[0])/id/\(subscribeCreds[1])/evt/image/fmt/json" : 1
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
            if topic! == "iot-2/type/\(subscribeCreds[0])/id/\(subscribeCreds[1])/evt/scoring/fmt/json" {
                DispatchQueue.main.async { [weak self] in
                    if let robotSource = json["robotSource"] as? String {
                        self?.itemName = robotSource
                        
                    }
                    
                    if let classification = json["speakingClassification"] as? String {
                        self?.classification = classification
                        
                    }
                    
                    if let batch = json["batch"] as? String {
                        self?.batch = batch
                    }
                    
                    if let date = json["date"] as? String {
                        self?.date = date
                        
                        let date = Date()
                        let formatter = DateFormatter()
                        formatter.timeZone = TimeZone.current
                        formatter.dateFormat = "hh:mm:ss a"
                        let timeString = formatter.string(from: date)
                        
                        self?.time = timeString
                        
                    }
                    
                    if let confidence = json["confidence"] {
                        self?.confidence = String(describing: confidence)
                    }
                    
                    self?.updateUI()
                    
                }
            } else if topic! == "iot-2/type/\(subscribeCreds[0])/id/\(subscribeCreds[1])/evt/image/fmt/json" {
                //                print("JSON: \(json)" )
                DispatchQueue.main.async { [weak self] in
                    if let imageString = json["image"] as? String {
                        print("Image Received")
                        
                        let imageData = Data(base64Encoded: imageString)
                        if let decodedImage = UIImage(data: imageData!) {
                            self?.image = decodedImage
                            self?.updateUI()
                        } else {
                            print("Conversion Error")
                        }
                        
                    } else {
                        print("NO IMAGE")
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

extension UIImageView {
    func maximize(image: UIImage, size: CGSize) -> UIImageView {
        let imageView = UIImageView(image: image)
        imageView.frame.size = size
        return imageView
    }
}
