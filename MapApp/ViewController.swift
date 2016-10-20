//
//  ViewController.swift
//  MapApp
//
//  Created by Work on 2016/10/19.
//  Copyright © 2016年 sparta-asano.jp. All rights reserved.
//

import UIKit
import MapKit

class ViewController: UIViewController, MKMapViewDelegate {

    @IBOutlet weak var mapView: MKMapView!
    
    // UserDefaultsの保存・読み込み時に使う名前
    let userDefName = "pins"
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // マップでロングタップイベントが反応するようにジェスチャーを登録します
        let gesture = UILongPressGestureRecognizer(target: self, action: #selector(ViewController.longTapMapView(_:)));
        mapView.addGestureRecognizer(gesture)
        
        // 保存されているピンを配置
        loadPins()
    }
    
    // マップ上をロングタップした際にピンを登録
    func longTapMapView(_ gesture: UILongPressGestureRecognizer) {
        // ロングタップイベントは「ロングタップと認識した時」と「ロングタップが終了したとき」の2回呼ばれます。
        // 1回だけ呼ばれればよいので、認識時の呼び出しで以外は何もしないようにしています。
        if (gesture.state != UIGestureRecognizerState.began) {
            // ロングタップ認識時以外では何もしない
            return
        }
        
        // 位置情報を取得します。
        let point = gesture.location(in: view)
        let geo = mapView.convert(point, toCoordinateFrom: mapView)
        
        // アラートの作成
        let alert = UIAlertController(title: "スポット登録", message: "この場所に残すメッセージを入力してください。", preferredStyle: .alert)
        alert.addAction(UIAlertAction(title: "キャンセル", style: .cancel, handler: nil))
        alert.addAction(UIAlertAction(title: "登録", style: .default, handler: { (action) -> Void in
            // 登録ボタンのアクション
            
            let pin = Pin(geo: geo, text: alert.textFields?.first?.text)
            self.mapView.addAnnotation(pin)
            
            self.savePin(pin)
        }))

        // ピンに登録するテキスト用の入力フィールドをアラートに追加します。
        alert.addTextField(configurationHandler: { (textField) in
            textField.placeholder = "メッセージ"
        })
        
        // アラートの表示
        present(alert, animated: true, completion: nil)
    }
    
    // 既に保存されているピンを取得
    func loadPins() {
        let userDefaults = UserDefaults.standard
        
        if let savedPins = userDefaults.object(forKey: userDefName) as? [[String: Any]] {
                
            // 現在のピンを削除
            self.mapView.removeAnnotations(self.mapView.annotations)
            
            for pinInfo in savedPins {
                let newPin = Pin(dictionary: pinInfo)
                self.mapView.addAnnotation(newPin)
            }
        }
    }
    
    // ピンの保存
    func savePin(_ pin: Pin) {
        let userDefaults = UserDefaults.standard
        
        // 保存するピンをUserDefaults用に変換します。
        let pinInfo = (pin.toDictionary())
        
        if var savedPins = userDefaults.object(forKey: userDefName) as? [[String: Any]] {
            // すでにピン保存データがある場合、それに追加する形で保存します。
            savedPins.append(pinInfo)
            userDefaults.set(savedPins, forKey: userDefName)
            
        } else {
            // まだピン保存データがない場合、新しい配列として保存します。
            let newSavedPins: [[String: Any]] = [pinInfo]
            userDefaults.set(newSavedPins, forKey: userDefName)
        }
    }
}

