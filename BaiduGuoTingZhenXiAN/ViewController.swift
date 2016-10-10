//
//  ViewController.swift
//  BaiDu_XA_GTZ_iOS
//
//  Created by AnChar on 16/9/22.
//  Copyright © 2016年 GG. All rights reserved.
//

import UIKit

class ViewController: UIViewController {

    var mapView:BMKMapView?
    var tab : TableView?
    var customSearchBar : UISearchBar?
    var search : BMKSuggestionSearch?
    var rSearch : BMKRouteSearch?
    var op : BMKSuggestionSearchOption?
    lazy var dataArray=[String]()
    lazy var ptLiat = [NSValue]()
    var tabView : UITableView?
    var poiKeyword:String?
    lazy var annoList = [BMKPointAnnotation]()
    lazy var corr = [39.915, 116.404]
    var seacherPoi : BMKPoiSearch?
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        NotificationCenter.default.addObserver(self, selector: #selector(programme(_:)), name: NSNotification.Name(rawValue: "导航"), object: nil)
        NotificationCenter.default.addObserver(self, selector: #selector(programme1(_:)), name: NSNotification.Name(rawValue: "搜周边"), object: nil)
        self.title = "地图"
        self.mapView=BMKMapView(frame: self.view.bounds)
        self.mapView?.delegate=self
        self.view.addSubview(self.mapView!)
        self.setCustomSearchBar()
        self.customSearchBar?.delegate = self
        
        self.tab = TableView()
        
        
        self.search=BMKSuggestionSearch()
        self.op = BMKSuggestionSearchOption()
        self.search!.delegate=self
        self.perpareTableView()
        
        let title = ["搜周边","导航","未定义","地图"]
        let seg = UISegmentedControl(items: title)
        seg.frame = CGRect(x: 0, y: self.view.frame.size.height-36,width: self.view.frame.size.width, height: 36)
        seg.addTarget(self, action: #selector(segAcion(_:)), for: .valueChanged)
        seg.selectedSegmentIndex = 3
        seg.backgroundColor=UIColor.white
        self.view.addSubview(seg)
    }
    override func viewWillAppear(_ animated: Bool) {
    self.navigationController?.view.addSubview(self.customSearchBar!)
    }
//    搜周边通知
    func programme1(_ noti:Notification){
        let dict = (noti as NSNotification).userInfo as![String:String]
        self.seacherPoi = BMKPoiSearch()
        self.seacherPoi!.delegate=self
        let op = BMKNearbySearchOption()
        op.location = CLLocationCoordinate2DMake(self.corr[0], self.corr[1])
        op.keyword = dict["keyword"]
        op.radius = 1000
        print(op.keyword)
        if self.seacherPoi!.poiSearchNear(by: op) == true {
            print("成功")
        }
    }
//    导航通知
    func programme(_ noti:Notification){
        print((noti as NSNotification).userInfo)
        self.rSearch = BMKRouteSearch()
        let start = BMKPlanNode()
        let end = BMKPlanNode()
        for (key,value) in (noti as NSNotification).userInfo!{
            let key = key as! Double
            let value = value as! Double
            start.pt = CLLocationCoordinate2DMake(key, value)
            end.pt = CLLocationCoordinate2DMake(key, value)
        }
        
        
        let transitRouteSearchOption = BMKTransitRoutePlanOption()
        transitRouteSearchOption.city = "北京市"
        transitRouteSearchOption.from = start
        transitRouteSearchOption.to = end
        if  rSearch?.transitSearch(transitRouteSearchOption) == true {
            print("嘎嘎嘎嘎嘎嘎")
        }
        rSearch?.delegate = self
        
    }
    
    func segAcion(_ seg:UISegmentedControl){
        switch seg.selectedSegmentIndex {
        case 0:
            self.customSearchBar?.removeFromSuperview()
            let svc = XQDViewController()
            svc.title = "搜周边"
            self.navigationController?.pushViewController(svc, animated: true)
        case 1:
            self.customSearchBar?.removeFromSuperview()
            let dvc = DHViewController()
            dvc.title = "导航"
            self.navigationController?.pushViewController(dvc, animated: true)
        case 2:
            self.customSearchBar?.removeFromSuperview()
            let dvc = DHViewController()
            dvc.title = "导航"
            self.navigationController?.pushViewController(dvc, animated: true)
        default:
            break
        }
    }
    func perpareTableView(){
        self.tabView = UITableView(frame: self.tab!.bounds, style: .plain)
        self.tabView?.delegate=self
        self.tabView?.dataSource=self
        self.tab?.addSubview(self.tabView!)
    }
    
    func setCustomSearchBar(){
        let mainNavigationBounds = self.navigationController?.view.bounds
        self.customSearchBar=UISearchBar()
        self.customSearchBar?.frame=CGRect(x: mainNavigationBounds!.width/2-((mainNavigationBounds!.width-10)/2), y: mainNavigationBounds!.minY+22, width: mainNavigationBounds!.width-10,height: 40)
    }

    override func viewDidAppear(_ animated: Bool) {
        self.mapView?.viewWillAppear()
    }
    override func viewWillDisappear(_ animated: Bool) {
        self.mapView?.viewWillDisappear()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}

extension ViewController : UISearchBarDelegate{

    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        self.customSearchBar?.resignFirstResponder()
        self.customSearchBar?.showsCancelButton = false
    }
//    点击搜索框时
    func searchBarShouldBeginEditing(_ searchBar: UISearchBar) -> Bool {
        self.customSearchBar?.showsCancelButton = true
        self.dataArray.removeAll()
        self.ptLiat.removeAll()
        self.tabView?.reloadData()
        self.mapView?.reloadInputViews()
        self.customSearchBar?.text=""
        self.view.addSubview(self.tab!)
        return true
    } 
//    当文字发生变化时
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if self.customSearchBar?.text != ""{
            
            op?.keyword = self.customSearchBar?.text
            self.search?.suggestionSearch(op)
            self.dataArray.removeAll()
            self.ptLiat.removeAll()
        }
    }
    //取消按钮
    func searchBarCancelButtonClicked(_ searchBar: UISearchBar) {
        self.tab?.removeFromSuperview()
        self.customSearchBar?.resignFirstResponder()
        self.customSearchBar?.showsCancelButton = false
    }
}
extension ViewController : UISearchResultsUpdating{
    func updateSearchResults(for searchController: UISearchController) {
    }
}

extension ViewController : BMKSuggestionSearchDelegate{
    func onGetSuggestionResult(_ searcher: BMKSuggestionSearch!, result: BMKSuggestionResult!, errorCode error: BMKSearchErrorCode) {
        if BMK_SEARCH_NO_ERROR == error {
            for i in 0..<result.cityList.count{
                let str = (result.cityList[i] as! String) + (result.districtList[i] as! String)+(result.keyList[i]as!String)
                self.dataArray.append(str)
                self.ptLiat.append(result.ptList[i] as! NSValue)
            }
            self.tabView?.reloadData()
        }else{
            print("未找到")
        }
    }
}

extension ViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        
        self.customSearchBar?.text = self.dataArray[(indexPath as NSIndexPath).row]
        let poi = (self.ptLiat[(indexPath as NSIndexPath).row]).cgPointValue
        self.tab?.removeFromSuperview()
        self.customSearchBar?.resignFirstResponder()
        
        
        let anno = BMKPointAnnotation()
        anno.coordinate = CLLocationCoordinate2DMake(Double(poi.x), Double(poi.y))
        anno.title = self.dataArray[(indexPath as NSIndexPath).row]
        self.annoList.append(anno)
        self.mapView?.region = BMKCoordinateRegion(center: anno.coordinate, span: BMKCoordinateSpan(latitudeDelta: 0.01, longitudeDelta: 0.01))
        self.mapView?.addAnnotation(anno)
        
    }
    
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        var cell = self.tabView?.dequeueReusableCell(withIdentifier: "cell")
        if cell == nil {
            cell = UITableViewCell(style: .default, reuseIdentifier: "cell")
        }
        cell?.textLabel?.text = self.dataArray[(indexPath as NSIndexPath).row]
        return cell!
    }
}
extension ViewController : BMKMapViewDelegate{
    func mapView(_ mapView: BMKMapView!, viewFor annotation: BMKAnnotation!) -> BMKAnnotationView! {
        let annoViewId = "annoId"
        var annoView = self.mapView!.dequeueReusableAnnotationView(withIdentifier: annoViewId)
        if nil == annoView {
            
            annoView = BMKPinAnnotationView(annotation: annotation, reuseIdentifier: annoViewId)
        }
        
        annoView?.canShowCallout = true
        annoView?.isSelected = true
        return annoView
    }
}
extension ViewController : BMKRouteSearchDelegate{
    func onGetTransitRouteResult(_ searcher: BMKRouteSearch!, result: BMKTransitRouteResult!, errorCode error: BMKSearchErrorCode) {
        
            if (error == BMK_SEARCH_NO_ERROR) {
                //在此处理正常结果
                print(result.taxiInfo)
                print(result.suggestAddrResult)
                print(result.routes)
            }
            else if (error == BMK_SEARCH_AMBIGUOUS_ROURE_ADDR){
                //当路线起终点有歧义时通，获取建议检索起终点
                //result.routeAddrResult
                print("当路线起终点有歧义时通，获取建议检索起终点")
            }
            else {
               print(error.rawValue)
            }
    }
}

extension ViewController : BMKPoiSearchDelegate{
    func onGetPoiResult(_ searcher: BMKPoiSearch!, result poiResult: BMKPoiResult!, errorCode: BMKSearchErrorCode) {
        if (errorCode == BMK_SEARCH_NO_ERROR) {
            //在此处理正常结果
            if errorCode == BMK_SEARCH_NO_ERROR {
                var annotations = [BMKPointAnnotation]()
                for i in 0..<poiResult.poiInfoList.count {
                    let poi = poiResult.poiInfoList[i] as! BMKPoiInfo
                    let item = BMKPointAnnotation()
                    item.coordinate = poi.pt
                    item.title = poi.name
                    annotations.append(item)
                }
                mapView!.addAnnotations(annotations)
                mapView!.showAnnotations(annotations, animated: true)
            } else if errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD {
                print("检索词有歧义")
            } else {
                // 各种情况的判断……
            }
        }
        else if (errorCode == BMK_SEARCH_AMBIGUOUS_KEYWORD){
            //当在设置城市未找到结果，但在其他城市找到结果时，回调建议检索城市列表
            // result.cityList;
        } else {
        }
    }
    
}

