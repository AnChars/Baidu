//
//  XQDViewController.swift
//  BaiduGuoTingZhenXiAN
//
//  Created by AnChar on 16/9/27.
//  Copyright © 2016年 GG. All rights reserved.
//

import UIKit

class XQDViewController: UIViewController {

    let w = UIScreen.main.bounds.width
    let h = UIScreen.main.bounds.height
    var collection : UICollectionView?
    fileprivate lazy var dataArray = ["小吃","酒店","旅游","书店","超市","网吧","酒吧","KTV","肯德基","车站","小吃","小吃","小吃","小吃","小吃","小吃",]
    fileprivate lazy var nameArray = ["pin_green@2x","pin_purple@2x","pin_red@2x"]
    override func viewDidLoad() {
        super.viewDidLoad()
        self.view.backgroundColor=UIColor.white
        let layout = UICollectionViewFlowLayout()
        layout.minimumInteritemSpacing = 30
        layout.minimumLineSpacing = 30
        layout.sectionInset = UIEdgeInsetsMake(30, 30, 30, 30)
        layout.itemSize = CGSize(width: 80, height: 100)
        self.collection=UICollectionView(frame: CGRect(x: 100, y: 0, width: w-200, height: h), collectionViewLayout: layout)
        self.view.addSubview(self.collection!)
        self.collection?.register(UINib(nibName: "XQDCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "cell")
        self.collection?.backgroundColor=UIColor.white
        self.collection?.delegate=self
        self.collection?.dataSource=self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
extension XQDViewController : UICollectionViewDelegate,UICollectionViewDataSource{
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.dataArray.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = self.collection?.dequeueReusableCell(withReuseIdentifier: "cell", for: indexPath)as! XQDCollectionViewCell
        cell.namLable.text=self.dataArray[(indexPath as NSIndexPath).row]
        cell.nameImageView.image=UIImage(named: self.nameArray[(indexPath as NSIndexPath).row%3])
        return cell
    }
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        NotificationCenter.default.post(name: Notification.Name(rawValue: "搜周边"), object: nil, userInfo: ["keyword":self.dataArray[(indexPath as NSIndexPath).row]])
        self.navigationController!.popViewController(animated: true)
    }
}
