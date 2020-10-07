//
//  ViewController.swift
//  AIPM-iOS
//
//  Created by Joshua Dadson on 8/31/20.
//  Copyright © 2020 Joshua Dadson. All rights reserved.
//

import UIKit
import WebKit
import MQTTClient

class ViewController: UIViewController, UITableViewDelegate, UITableViewDataSource, MQTTSessionDelegate {
    //MQTT
    let session = MQTTSession()!
    var text = ""
    
    // Top Report
    //    let statusView = UIView()
    var vcTitle = "Robot Analytics and Data"
    
    //    var greeting = "Good-morning, \(UIDevice.current.name)"
    var greeting = "Good-morning..."
    let greetingLabel = UILabel()
    var date = Date()
    var timeString = ""
    let dateLabel = UILabel()
    
    
    
    //Predictive Tab View
    var healthScore = Int()
    var online = String()
    var upperTorque = Int()
    var middleTorque = Int()
    var lowerTorque = Int()
    
    //Equipment Data Variables
    var equipmentJSON : [[String: Any]]?
    var equipmentDescription = String()
    var equipmentID = String()
    var equipmentTime = String()
    var equipmentStatus = String()
    var equipmentLocation = String()
    var actionButton = UIButton(type: .roundedRect)
    
    //Table Views
    let predictiveTableView = UITableView()
    let visualTableView = UITableView()
    let equipmentTableView = UITableView()
    var cell = UITableViewCell()
    
    //View Controllers
    var predictiveVC : PredictiveDetailViewController?
    var visualVC : VisualDetailViewController?
    var equipmentVC: EquipmentDetailViewController?
    
    //Title Information
    let predictiveCellTitles = ["Yaskawa", "Kuka", "Replay", "Conveyor Belt"]
    let visualInsightsTitles = ["Line 3", "Line 7", "Line 2", "Line 4"]
    let secondaryVisualTitles = ["Yaskawa", "Kuka", "Replay", "RaisinReplay"]
    
    //Navigation Bar
    var showNavBar = true
    
    override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?) {
        if showNavBar {
            navigationController?.setNavigationBarHidden(true, animated: true)
            showNavBar = false
        } else {
            navigationController?.setNavigationBarHidden(false, animated: true)
            showNavBar = true
        }
    }
    
    override func viewWillTransition(to size: CGSize, with coordinator: UIViewControllerTransitionCoordinator) {
        equipmentTableView.reloadData()
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        for family in UIFont.familyNames.sorted() {
            let names = UIFont.fontNames(forFamilyName: family)
            print("Family: \(family) Font names: \(names)")
        }
        
        
        getEquipmentData()
        
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "MMM dd, yyyy"
        timeString = dateformatter.string(from: date)
        
        initialUI()
        retrieveMQTTData()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        if navigationController?.tabBarItem.tag == 2 {
            getEquipmentData()
            //            equipmentTableView.reloadData()
        }
    }
    
    func getEquipmentData() {
        //Get Equipment Table Data
        if navigationController?.tabBarItem.tag == 2 {
            
            guard let url = URL(string: "https://aipm-gsc-nodered.mybluemix.net/getWorkOrdersMaximo") else {return}
            
            let task = URLSession.shared.dataTask(with: url) {(data, response, error) in
                //                guard let data = data else { return }
                
                if let jsonData =  try? JSONSerialization.jsonObject(with: data!, options:[]) as? [String: Any]  {
                    //                    print("Type of \(type(of: jsonData))")
                    self.equipmentJSON = jsonData["rdfs:member"] as! [[String: Any]]
                    
                    var sortedEquipmentJSON = [[String: Any]]()
                    
                    for workOrder in self.equipmentJSON! {
                        if let status = workOrder["spi:status"] {
                            if status as! String == "WAPPR" {
                                sortedEquipmentJSON.append(workOrder)
                            }
                        }
                        
                    }
                    
                    for workOrder in self.equipmentJSON! {
                        if let status = workOrder["spi:status"] {
                            if status as! String == "APPR" {
                                sortedEquipmentJSON.append(workOrder)
                            }
                        }
                        
                    }
                    
                    for workOrder in self.equipmentJSON! {
                        if let status = workOrder["spi:status"] {
                            if status as! String == "CLOSE" {
                                sortedEquipmentJSON.append(workOrder)
                            }
                        }
                    }
                    
                    self.equipmentJSON = sortedEquipmentJSON
                    
                    DispatchQueue.main.async {
                        self.equipmentTableView.reloadData()
                    }
                    
                }
                
                
            }
            
            task.resume()
        }
    }
    
    func initialUI() {
        
        
        predictiveTableView.delegate = self
        predictiveTableView.dataSource = self
        
        visualTableView.delegate = self
        visualTableView.dataSource = self
        
        equipmentTableView.delegate = self
        equipmentTableView.dataSource = self
        
        if navigationController?.tabBarItem.tag == 0 {
            self.navigationItem.title = "Predictive Maintenance"
            self.navigationController?.tabBarItem.title = "Predictive Maintenance"
            
            
            view.addSubview(predictiveTableView)
            predictiveTableView.translatesAutoresizingMaskIntoConstraints = false
            predictiveTableView.backgroundColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            predictiveTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            predictiveTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            predictiveTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            predictiveTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            
            //            view.backgroundColor = UIColor(displayP3Red: 0.0, green: 0.1137, blue: 0.4235, alpha: 1.0)
            
        } else if navigationController?.tabBarItem.tag == 1 {
            self.navigationItem.title = "Visual Insights"
            
            view.addSubview(visualTableView)
            visualTableView.translatesAutoresizingMaskIntoConstraints = false
            visualTableView.backgroundColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            visualTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            visualTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            visualTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            visualTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
            
        } else if navigationController?.tabBarItem.tag == 2 {
            self.navigationItem.title = "Equipment Maintenance Advisor"
            
            view.addSubview(equipmentTableView)
            equipmentTableView.translatesAutoresizingMaskIntoConstraints = false
            equipmentTableView.backgroundColor = UIColor(displayP3Red: 0.9, green: 0.9, blue: 0.9, alpha: 1.0)
            equipmentTableView.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
            equipmentTableView.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
            equipmentTableView.leftAnchor.constraint(equalTo: view.leftAnchor).isActive = true
            equipmentTableView.rightAnchor.constraint(equalTo: view.rightAnchor).isActive = true
        }
    }
    
    
    func retrieveMQTTData() {    //Handle IOT Data Subscription
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
    
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        if navigationController?.tabBarItem.tag == 0 {
            return predictiveTableView.frame.size.height/4
        } else if navigationController?.tabBarItem.tag == 1 {
            return visualTableView.frame.size.height/4
        } else {
            return equipmentTableView.frame.size.height/3.5
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.navigationController?.tabBarItem.tag == 0 {
            if indexPath.row == 0 {
                self.vcTitle = "Yaskawa"
            } else if indexPath.row == 1 {
                self.vcTitle = "Kuka"
            } else if indexPath.row == 2 {
                self.vcTitle = "Replay"
            } else if indexPath.row == 3 {
                self.vcTitle = "Conveyor"
            }
            
            predictiveVC = PredictiveDetailViewController(vcTitle: self.vcTitle, healthScore: self.healthScore, upperTorque: self.upperTorque, middleTorque: self.middleTorque, lowerTorque: self.lowerTorque)
            navigationController?.pushViewController(predictiveVC!, animated: true)
            
        } else if self.navigationController?.tabBarItem.tag == 1 {
            visualVC = VisualDetailViewController(robot: secondaryVisualTitles[indexPath.row])
            navigationController?.pushViewController(visualVC!, animated: true)
            
        } else if self.navigationController?.tabBarItem.tag == 2 {
            if cell.textLabel?.text == "Loading" {
                return
            } else {
                var workStatus = ""
                
                if self.equipmentJSON?[indexPath.row]["spi:status"] as! String == "WAPPR" {
                    workStatus = "Approve"
                } else if self.equipmentJSON?[indexPath.row]["spi:status"] as! String == "APPR" {
                    workStatus = "Close"
                } else {
                    workStatus = "Closed"
                }
                
                equipmentVC = EquipmentDetailViewController(vcTitle: "Equipment Maintenance Advisor", descriptionQuery: self.equipmentJSON?[indexPath.row]["spi:description"] as! String, wid: self.equipmentJSON?[indexPath.row]["spi:workorderid"] as! Int,
                                                            workStatus: workStatus)
                navigationController?.pushViewController(equipmentVC!, animated: true)
            }
            
        }
        
        
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        switch self.navigationController?.tabBarItem.tag {
        case 0:
            return 4
        case 1:
            return 4
        case 2:
            return equipmentJSON?.count ?? 11
        default:
            return 1
        }
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        switch self.navigationController?.tabBarItem.tag {
        case 0:
            let robotImage: UIImage!
            
            
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Predictive")
            cell.layer.borderWidth = 2
            //        let cell = tableView.dequeueReusableCell(withIdentifier: "Predictive", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            //            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            if UIDevice().localizedModel == "iPad"  {
                cell.textLabel?.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 30)
            } else {
                cell.textLabel?.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 18)
            }
            
            cell.textLabel?.text = predictiveCellTitles[indexPath.row]
            
            if UIDevice().localizedModel == "iPad"  {
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 20)
            } else {
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
            }
            
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = """
            Health Score: \(healthScore)
            Online: \(online)
            """
            
            cell.imageView?.layer.cornerRadius = 33
            //            cell.imageView?.layer.borderWidth = 1
            cell.imageView?.layer.masksToBounds = false
            cell.imageView?.clipsToBounds = true
            
            if(indexPath.row == 0) {
                robotImage = UIImage(named: "r1")
                cell.imageView?.image = robotImage
            } else if indexPath.row == 1 {
                robotImage = UIImage(named: "r2")
                cell.imageView?.image = robotImage
            } else if indexPath.row == 2 {
                robotImage = UIImage(named: "r3")
                cell.imageView?.image = robotImage
            } else if indexPath.row == 3 {
                robotImage = UIImage(named: "r3")
                cell.imageView?.image = robotImage
            } else {
                robotImage = UIImage(named: "r1")
                cell.imageView?.image = robotImage
            }
            return cell
            
        case 1:
            let robotImage : UIImage!
            
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Visual")
            cell.layer.borderWidth = 2
            cell.accessoryType = .disclosureIndicator
            //            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 18)
            if UIDevice().localizedModel == "iPad"  {
                cell.textLabel?.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 30)
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
            } else {
                cell.textLabel?.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 18)
                cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 12)
            }
            //            cell.textLabel?.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 18)
            cell.textLabel?.text = visualInsightsTitles[indexPath.row]
            
            cell.imageView?.layer.cornerRadius = 33
            //            cell.imageView?.layer.borderWidth = 1
            cell.imageView?.layer.masksToBounds = false
            cell.imageView?.clipsToBounds = true
            
            if(indexPath.row == 0) {
                robotImage = UIImage(named: "r1")
                cell.imageView?.image = robotImage
            } else if indexPath.row == 1 {
                robotImage = UIImage(named: "r2")
                cell.imageView?.image = robotImage
            } else if indexPath.row == 2 {
                robotImage = UIImage(named: "r3")
                cell.imageView?.image = robotImage
            } else if indexPath.row == 3 {
                robotImage = UIImage(named: "r3")
                cell.imageView?.image = robotImage
            } else {
                robotImage = UIImage(named: "r1")
                cell.imageView?.image = robotImage
            }
            cell.detailTextLabel?.numberOfLines = 0
            cell.detailTextLabel?.text = """
            \(secondaryVisualTitles[indexPath.row])
            Images
            """
            return cell
        case 2:
            cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Equipment")
            cell.layer.borderWidth = 2
            //        let cell = tableView.dequeueReusableCell(withIdentifier: "Predictive", for: indexPath)
            cell.accessoryType = .disclosureIndicator
            //            cell.textLabel?.font = UIFont.boldSystemFont(ofSize: 12)
            //            cell.textLabel?.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 14)
            
            cell.textLabel?.numberOfLines = 0
            cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
            cell.textLabel?.leftAnchor.constraint(equalTo: cell.leftAnchor).isActive = true
            cell.textLabel?.rightAnchor.constraint(equalTo: cell.rightAnchor).isActive = true
            cell.textLabel?.text = "\(self.equipmentJSON?[indexPath.row]["spi:description"] ?? "Loading")"
            
            cell.textLabel?.textAlignment = .center
            cell.detailTextLabel?.numberOfLines = 0
            
            if UIDevice().localizedModel == "iPad"  {
                if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
                    cell.textLabel?.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 30)
                    cell.detailTextLabel?.font = UIFont(name: "IBMPlexSerif-Medium", size: 18)
                } else {
                    cell.textLabel?.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 30)
                    cell.detailTextLabel?.font = UIFont(name: "IBMPlexSerif-Medium", size: 18)
                }
            } else {
                if UIScreen.main.bounds.height < UIScreen.main.bounds.width {
                    cell.textLabel?.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 14)
                    cell.detailTextLabel?.font = UIFont(name: "IBMPlexSerif-Medium", size: 10)
                } else {
                    cell.textLabel?.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
                    cell.detailTextLabel?.font = UIFont(name: "IBMPlexSerif-Medium", size: 13)
                }
            }
            
            
            
            let idString = "ID: "
            let timeString = "Time: "
            let statusString = "Status: "
            let locationString = "Location: "
            //            let actionString = "Action: "
            
            cell.detailTextLabel?.text = """
            \(idString)\(self.equipmentJSON?[indexPath.row]["spi:workorderid"] ?? "Loading")
            \(timeString)\(self.equipmentJSON?[indexPath.row]["spi:reportdate"] ?? "Loading")
            \(statusString)\(self.equipmentJSON?[indexPath.row]["spi:status"] ?? "Loading")
            \(locationString)\(self.equipmentJSON?[indexPath.row]["spi:location"] ?? "Loading")
            
            """
            //            actionButton.setTitle("Approve", for: .normal)
            //            cell.addSubview(actionButton)
            
            return cell
        default:
            cell.imageView?.layer.cornerRadius = 45
            cell.imageView?.layer.borderWidth = 2
            cell.imageView?.layer.masksToBounds = false
            cell.imageView?.clipsToBounds = true
            return UITableViewCell(style: .subtitle, reuseIdentifier: "Predictive")
        }
        
        
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
        }
    }
    
    func newMessage(_ session: MQTTSession!, data: Data!, onTopic topic: String!, qos: MQTTQosLevel, retained: Bool, mid: UInt32) {
        
        if let json = try? JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any] {
            if topic! == "iot-2/type/gsc-yaskawa-gw/id/gsc-yaskawa-01/evt/health/fmt/json" {
                DispatchQueue.main.async { [weak self] in
                    if let healthScore = (json["health"] as? Int) {
                        self?.healthScore = healthScore
                    }
                    self?.predictiveTableView.reloadData()
                }
            }  else if topic! == "iot-2/type/gsc-yaskawa-gw/id/gsc-yaskawa-01/evt/update/fmt/json" {
                DispatchQueue.main.async { [weak self] in
                    
                    self?.predictiveTableView.reloadData()
                }
            } else if topic! == "iot-2/type/gsc-yaskawa-gw/id/gsc-yaskawa-01/evt/scoring/fmt/json" {
                DispatchQueue.main.async { [weak self] in
                    
                    self?.visualTableView.reloadData()
                }
            } else if topic! == "iot-2/type/gsc-yaskawa-gw/id/gsc-yaskawa-01/evt/image/fmt/json" {
                DispatchQueue.main.async { [weak self] in
                    
                    self?.visualTableView.reloadData()
                }
            }
        }
        
    }
    
    func subAckReceived(_ session: MQTTSession!, msgID: UInt16, grantedQoss qoss: [NSNumber]!) {
        print("Subscription Status: Subscribed")
        online = "YES"
    }
    
    func unsubAckReceived(_ session: MQTTSession!, msgID: UInt16) {
        print("Subscription Status Unsubscribed")
        online = "NO"
    }
    
    
}



