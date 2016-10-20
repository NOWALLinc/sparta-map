//
//  Pin.swift
//  MapApp
//
//  Created by Work on 2016/10/20.
//  Copyright © 2016年 sparta-asano.jp. All rights reserved.
//

import UIKit
import MapKit

// ピン情報の保持とUserDefaultsとの変換を行うクラス
class Pin: NSObject, MKAnnotation {
    
    // 位置情報
    var coordinate: CLLocationCoordinate2D = CLLocationCoordinate2D()
    
    // 追加時の入力テキスト
    var title: String?
    
    // 位置情報とテキストを格納した状態のオブジェクトを返します
    init(geo:CLLocationCoordinate2D, text: String?){
        coordinate = geo
        title = text
    }
    
    // UserDefaultsから取り出した各値を変換したオブジェクトを返します
    init(dictionary: [String: Any]) {
        if let geo = dictionary["geo"] as? [String: CLLocationDegrees] {
            if let latitude = geo["latitude"], let longitude = geo["longitude"] {
                coordinate = CLLocationCoordinate2D(latitude: latitude, longitude: longitude)
            }
        }
        
        if let tit = dictionary["title"] as? String {
            title = tit
        }
    }
    
    // 保持中の値をUserDefaultsに登録できるように変換
    func toDictionary() -> [String: Any] {
        var dict: [String: Any] = [:]
        
        let geo: [String: Any] = [
            "latitude": coordinate.latitude,
            "longitude": coordinate.longitude
        ]
        
        dict["geo"] = geo
        
        if let tit = title {
            dict["title"] = tit
        }
        
        return dict
    }
}
