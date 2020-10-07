//
//  PredictiveDetailViewController.swift
//  AIPM-iOS
//
//  Created by Joshua Dadson on 8/31/20.
//  Copyright © 2020 Joshua Dadson. All rights reserved.
//

import UIKit
import WebKit

class EquipmentDetailViewController: UIViewController, UITableViewDelegate, UITableViewDataSource {
    //status WAPPR APPR CLOSE
    
    var vcTitle = String()
    var descriptionQuery = String()
    
    var title1String = String()
    var title2String = String()
    let title1Label = UILabel()
    let title2Label = UILabel()
    
    var description1String = String()
    var description2String = String()
    var description1Label = UILabel()
    var describtion2Label = UILabel()
    
    var score1: Float = 0.0
    var score2: Float = 0.0
    
    let scrollView = UIScrollView()
    
    let table = UITableView()
    
    var workStatus = "Approve"
    var workStatus2 = "Approve"
    var moreInfoStatus = "-"
    var moreInfoStatus2 = "-"
    
    var wid = Int()
    
    
    init(vcTitle: String, descriptionQuery: String, wid: Int, workStatus: String) {
        super.init(nibName: nil, bundle: nil)
        self.vcTitle = vcTitle
        self.descriptionQuery = descriptionQuery
        self.wid = wid
        self.workStatus = workStatus
        self.workStatus2 = workStatus
        
        if workStatus == "Approve" {
            moreInfoStatus = "Waiting for Approval"
            moreInfoStatus2 = "Waiting for Approval"
        } else if workStatus == "Close" {
            moreInfoStatus = "Approved"
            moreInfoStatus2 = "Approved"
        } else {
            moreInfoStatus = "Closed"
            moreInfoStatus2 = "Closed"
        }
        
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        table.delegate = self
        table.dataSource = self
        
        view.backgroundColor = UIColor.white
        title = vcTitle
//        getQueryResults()
        updateUI()
        
    }
   
    func updateUI() {
        
        view.addSubview(table)
        table.translatesAutoresizingMaskIntoConstraints = false
        table.leftAnchor.constraint(equalTo: view.safeAreaLayoutGuide.leftAnchor).isActive = true
        table.rightAnchor.constraint(equalTo: view.safeAreaLayoutGuide.rightAnchor).isActive = true
        table.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor).isActive = true
        table.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor).isActive = true
        
        getQueryResults()
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        var newStatus = ""
        var newStatus2 = ""
        
        if indexPath.row == 0 {
        let ac = UIAlertController(title: "More Information", message:
                                   """
Score: \(self.score1)
Rating: *****
Work Status: \(self.moreInfoStatus)
"""
                                   , preferredStyle: .alert)
            
            let approveAction = UIAlertAction(title: "\(workStatus)", style: .default) {_ in
                if self.workStatus == "Approve" {
                    self.workStatus = "Close"
                    self.moreInfoStatus = "Approved"
                    newStatus = "APPR"
                } else if self.workStatus == "Close" {
                    self.workStatus = "Closed"
                    self.moreInfoStatus = "Closed"
                    newStatus = "CLOSE"
                }
                
                print("statuss: \(newStatus)")
                let url = URL(string: "http://aipm-gsc-nodered.mybluemix.net/setStatusWorkOrder?wid=\(self.wid)&newstatus=\(newStatus)")
                
                let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                    if let data = data {
                        print("DATA APPROVAL: \(self.wid)")
                    } else if let error = error {
                        print("Error: \(error)")
                    }
                }
                
                task.resume()
            }
            
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            if workStatus != "Closed" {
                ac.addAction(approveAction)
            }
            
            ac.addAction(cancelAction)
            
            present(ac, animated: true)
            
        } else if indexPath.row == 1 {
            let ac = UIAlertController(title: "More Information", message:
                                       """
    Score: \(self.score2)
    Rating: *****
    Work Status: \(self.moreInfoStatus2)
    """
                                       , preferredStyle: .alert)
            
            let approveAction = UIAlertAction(title: "\(workStatus2)", style: .default) {_ in
                if self.workStatus2 == "Approve" {
                    self.workStatus2 = "Close"
                    self.moreInfoStatus2 = "Approved"
                    newStatus2 = "APPR"
                } else if self.workStatus2 == "Close" {
                    self.workStatus2 = "Closed"
                    self.moreInfoStatus2 = "Closed"
                    newStatus2 = "CLOSE"
                }
                    
                    let url = URL(string: "http://aipm-gsc-nodered.mybluemix.net/setStatusWorkOrder?wid=\(self.wid)&newstatus=\(newStatus2)")
                    
                    let task = URLSession.shared.dataTask(with: url!) { (data, response, error) in
                        
                    }
                    
                    task.resume()
            }
            
            let cancelAction = UIAlertAction(title: "Cancel", style: .cancel, handler: nil)
            if workStatus2 != "Closed" {
                ac.addAction(approveAction)
            }
            ac.addAction(cancelAction)
            
            present(ac, animated: true)
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell(style: .subtitle, reuseIdentifier: "Result")
        cell.selectionStyle = .default
        
        if description1String != "" || description2String != "" {
            cell.layer.borderWidth = 5
            cell.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)
            self.view.layer.borderWidth = 5
            self.view.layer.borderColor = CGColor(red: 0, green: 0, blue: 0, alpha: 1.0)
            tableView.showsVerticalScrollIndicator = false
            tableView.showsHorizontalScrollIndicator = false
        }
        
        if UIDevice.current.model == "iPad" {
            cell.textLabel?.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 30)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 18)
        } else if UIDevice.current.model == "iPhone" {
            cell.textLabel?.font = UIFont(name: "IBMPlexSerif-SemiBoldItalic", size: 20)
            cell.detailTextLabel?.font = UIFont.systemFont(ofSize: 14)
        }
        
        if indexPath.row == 0 {
            cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
            cell.textLabel?.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
            cell.textLabel?.text = title1String
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 0
            
            cell.detailTextLabel?.text = description1String
            cell.detailTextLabel?.numberOfLines = 0
        } else if indexPath.row == 1 {
            cell.textLabel?.translatesAutoresizingMaskIntoConstraints = false
            cell.textLabel?.widthAnchor.constraint(equalTo: cell.widthAnchor).isActive = true
            cell.textLabel?.text = title2String
            cell.textLabel?.textAlignment = .center
            cell.textLabel?.numberOfLines = 0
            
            cell.detailTextLabel?.text = description2String
            cell.detailTextLabel?.numberOfLines = 0
        }
        
        return cell
    }

    
    override func loadView() {
        super.loadView()

        scrollView.contentSize = CGSize(width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height+3000)
        
    }

    

    func getQueryResults() {
        let originalURL = "https://aipm-gsc-nodered.mybluemix.net/queryEMA?searchString=\(descriptionQuery)"
        let allowedURL = originalURL.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!
        let url = URL(string: allowedURL) ?? URL(string: "https://aipm-gsc-nodered.mybluemix.net/queryEMA?searchString=kuka")
        
        
        let task = URLSession.shared.dataTask(with: url!) { (data, response,error) in
            guard let data = data else {return}
//            print("Data: \(data)")
            
            do {
                let json = try JSONSerialization.jsonObject(with: data, options: .mutableContainers) as? [String:Any]
                
                if let results = json!["results"] as? [[String:Any]] {
//                    print("type: \(type(of: results[0]))")
                    
                    
                    if let result = results[0] as? [String:Any] {
                        if let extractedMeta = result["extracted_metadata"] as? NSDictionary {
                            if let title = extractedMeta["title"] as? String {
                                self.title1String = title
                            }
                        }
                        
                        if let resultMeta = result["result_metadata"] as? NSDictionary {
                            if let score = resultMeta["score"] as? NSNumber {
                                self.score1 = score.floatValue + 90
                                self.score1 = round((self.score1 * 100))/100
                                print("SCORE!")
                            }
                        }
                        
                        if let highlight = result["highlight"] as? [String: Any] {
                            if let text = highlight["text"] as? [String] {
                                for x in text {
                                    self.description1String.append(x)
                                }
                                
                                self.description1String = self.description1String.replacingOccurrences(of: "<em>", with: "").replacingOccurrences(of: "</em>", with: "")
                            }
                        }
                        
                        DispatchQueue.main.async {

                            self.table.reloadData()

                        }
                    }
                    
                    if let result2 = results[1] as? [String:Any] {
                        if let extractedMeta = result2["extracted_metadata"] as? NSDictionary {
                            if let title2 = extractedMeta["title"] as? String {
                                self.title2String = title2
                                
                            }
                        }
                        
                        if let resultMeta = result2["result_metadata"] as? NSDictionary {
                            if let score = resultMeta["score"] as? NSNumber {
                                self.score2 = score.floatValue + 90
                                self.score2 = round((self.score2 * 100))/100
                            }
                        }
                        
                        
                        if let highlight2 = result2["highlight"] as? [String: Any] {
                            if let text2 = highlight2["text"] as? [String] {
                                self.description2String = text2[0] + text2[1] + text2[2] + text2[3] + text2[4]
                                self.description2String = self.description2String.replacingOccurrences(of: "<em>", with: "").replacingOccurrences(of: "</em>", with: "")
                            }
                        }
                        
                        DispatchQueue.main.async {
//                            self.title1Label.text = self.title1String
//                            self.description1Label.text = self.description1
                            self.table.reloadData()

                        }
                    }
                    
                }
            } catch {
                print("Error converting data")
            }
            
        }
      
        task.resume()
    }

}
