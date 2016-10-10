//
//  DHViewController.swift
//  BaiduGuoTingZhenXiAN
//
//  Created by AnChar on 16/9/23.
//  Copyright © 2016年 GG. All rights reserved.
//

import UIKit

class DHViewController: UIViewController {

    let k = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.width
    var okButton : UIButton?
    var backButton:UIButton?
    lazy var dataArray = [String]()
    var tableView:UITableView?
    var subview:UIView?
    lazy var ptLiat = [NSValue]()
    var search : BMKSuggestionSearch?
    var op : BMKSuggestionSearchOption?
    var customSearchBar1:UITextField?
    var customSearchBar2:UITextField?
    var x:(Double,Double) = (0.01,0.01)
    var y:(Double,Double) = (0.01,0.01)
    override func viewDidLoad() {
        super.viewDidLoad()
        self.search=BMKSuggestionSearch()
        self.op = BMKSuggestionSearchOption()
        self.search!.delegate=self
        self.subview = UIView(frame: CGRect(x: 0, y: 114, width: k, height: h))
        
        self.view.backgroundColor=UIColor.white
        let title = ["🚌","🚘","🚶"]
        let seg = UISegmentedControl(items: title)
        seg.frame = CGRect(x: 0, y: 64, width: k, height: 50)
        seg.addTarget(self, action: #selector(segAcion(_:)), for: .valueChanged)
        seg.selectedSegmentIndex = 2
        seg.backgroundColor=UIColor.white
        self.view.addSubview(seg)
        
        let label1 = UILabel(frame: CGRect(x: 20, y: 250, width: (k-30)/3, height: 50))
        label1.text = "出发地:"
        self.view.addSubview(label1)
        let label2 = UILabel(frame: CGRect(x: 20, y: 350, width: (k-30)/3, height: 50))
        label2.text = "目的地:"
        self.view.addSubview(label2)
        self.customSearchBar1 = self.customSearchBar(CGRect(x: 20+(k-30)/3, y: 250, width: (k-30)*2/3, height: 50), string: "icon_nav_start@2x.png")
        customSearchBar1!.delegate=self
        self.view.addSubview(customSearchBar1!)
        
        customSearchBar2 = self.customSearchBar(CGRect(x: 20+(k-30)/3, y: 350, width: (k-30)*2/3, height: 50), string: "icon_nav_end@2x.png")
        customSearchBar2!.delegate=self
        self.view.addSubview(customSearchBar2!)
        
        self.okButton=UIButton(type: .system)
        self.okButton?.frame=CGRect(x: 207, y: 500, width: 200, height: 50)
        self.okButton?.setTitle("规划路线", for:UIControlState())
        self.okButton?.addTarget(self, action: #selector(okButtonAction), for: .touchUpInside)
        self.view.addSubview(self.okButton!)
        self.backButton=UIButton(type: .system)
        self.backButton?.frame=CGRect(x: 7, y: 500, width: 200, height: 50)
        self.backButton?.setTitle("返回地图", for:UIControlState())
        self.backButton?.addTarget(self, action: #selector(backButtonAction), for: .touchUpInside)
        self.view.addSubview(self.backButton!)
    }
    
    func perpareTableView(_ frame:CGRect){
        self.tableView=UITableView(frame: frame, style: .plain)
        self.tableView?.delegate=self
        self.tableView?.dataSource=self
        if self.subview != nil {
            self.view!.addSubview(self.tableView!)
        }
    }

    func backButtonAction(){
        self.navigationController!.popViewController(animated: true)
    }
    
    func okButtonAction(){
        if self.customSearchBar1?.text != "" && self.customSearchBar2?.text != ""{
            if self.customSearchBar2?.text != self.customSearchBar1?.text{
                NotificationCenter.default.post(name: Notification.Name(rawValue: "导航"), object: nil, userInfo: [self.x.0:self.x.1,self.y.0:self.y.1])
                self.navigationController!.popViewController(animated: true)
            }
        }
    }
    
    func customSearchBar(_ frame:CGRect,string:String)->UITextField{
        let customSearchBar = UITextField()
        customSearchBar.frame=frame
        customSearchBar.rightView=UIImageView(image: UIImage(named: string))
        customSearchBar.autocorrectionType = .no
        customSearchBar.autocapitalizationType = .none
        customSearchBar.borderStyle = .roundedRect
        customSearchBar.rightViewMode = .always
        customSearchBar.clearsOnBeginEditing = true
        return customSearchBar
    }
    
    func segAcion(_ seg:UISegmentedControl){
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func dismissSubView(){
        if self.subview != nil {
            self.tableView?.removeFromSuperview()
            self.view.frame.origin.y = 0
        }
    }
    
}


extension DHViewController : UITextFieldDelegate{
    
    func textFieldShouldBeginEditing(_ textField: UITextField) -> Bool {
        
        
        self.dataArray.removeAll()
        self.ptLiat.removeAll()
        self.dataArray.append("我的位置")
        self.tableView?.reloadData()
        self.ptLiat.append(NSValue(cgPoint: CGPoint(x: 0.01, y: 0.01)))
        textField.text = ""
        if textField == self.customSearchBar1{
            self.view.frame.origin.y = -190
//            self.view.addSubview(subview!)
            self.perpareTableView(CGRect(x: 0, y: 290, width: 414, height: 736))
        }else if textField == self.customSearchBar2{
            self.view.frame.origin.y = -290
            self.perpareTableView(CGRect(x: 0, y: 390, width: 414, height: 736))
        }
        return true
    }
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
            if textField.text != ""{
                op?.keyword = textField.text
                self.search?.suggestionSearch(op)
                self.dataArray.removeAll()
                self.ptLiat.removeAll()
            }
        return true
    }
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
       
        if textField.text != ""{
            op?.keyword = textField.text
            self.search?.suggestionSearch(op)
            self.dataArray.removeAll()
            self.ptLiat.removeAll()
        }
        textField.resignFirstResponder()
        return true
    }
}
extension DHViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tableView?.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = self.dataArray[(indexPath as NSIndexPath).row]
        return cell!
    }
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        if self.view.frame.origin.y > -250 {
            self.customSearchBar1?.text = self.dataArray[(indexPath as NSIndexPath).row]
            self.customSearchBar1?.resignFirstResponder()
            self.x.0 = Double((self.ptLiat[(indexPath as NSIndexPath).row].cgPointValue).x)
            self.y.0 = Double((self.ptLiat[(indexPath as NSIndexPath).row].cgPointValue).y)
        }else{
            self.customSearchBar2?.text = self.dataArray[(indexPath as NSIndexPath).row]
            self.customSearchBar2?.resignFirstResponder()
            self.x.1 = Double((self.ptLiat[(indexPath as NSIndexPath).row].cgPointValue).x)
            self.y.1 = Double((self.ptLiat[(indexPath as NSIndexPath).row].cgPointValue).y)
        }
        self.dismissSubView()
    }
}
extension DHViewController : BMKSuggestionSearchDelegate{
    func onGetSuggestionResult(_ searcher: BMKSuggestionSearch!, result: BMKSuggestionResult!, errorCode error: BMKSearchErrorCode) {
        if BMK_SEARCH_NO_ERROR == error {
            
            for i in 0..<result.cityList.count{
                let str = (result.cityList[i] as! String) + (result.districtList[i] as! String)+(result.keyList[i]as!String)
                self.dataArray.append(str)
                self.ptLiat.append(result.ptList[i] as! NSValue)
            }
            self.tableView?.reloadData()
        }else{
            print("未找到")
        }
    }
}
