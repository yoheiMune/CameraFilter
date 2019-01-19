//
//  ViewController.swift
//  CameraFilter
//
//  Created by Munesada Yohei on 2019/01/18.
//  Copyright © 2019 Munesada Yohei. All rights reserved.
//

import UIKit

/**
 * アプリ起動したら呼び出される画面.
 */
class ViewController: UIViewController {

    // 画面が読み込まれた時の処理.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ページタイトルを指定します.
        self.title = "写真を選択しよう"
    }

    // 「カメラを起動する」ボタンがタップされた時.
    @IBAction func onTapCamera() {
        
        // カメラ機能が使えるかをチェックし、使えない場合はエラーメッセージを表示する.
        // （例えば、エミュレーターの場合にはカメラは使えない）
        if UIImagePickerController.isSourceTypeAvailable(.camera) == false {
            self.showAlert(message: "カメラは利用できません")
            return
        }
        
        // カメラを表示する ViewController を作成.
        let picker = UIImagePickerController()
        // 表示タイプをカメラにする.
        picker.sourceType = .camera
        // カメラ撮影後の処理を行えるように、delegate 設定を行う,
        picker.delegate = self
        // カメラ画面を表示する.
        self.present(picker, animated: true, completion: nil)
    }
    
    // 「写真を起動する」ボタンがタップされた時.
    @IBAction func onTapPhoto() {

        // 写真機能が使えるかをチェックし、使えない場合はエラーメッセージを表示する.
        // （エミュレーターでも利用できる）
        if UIImagePickerController.isSourceTypeAvailable(.photoLibrary) == false {
            self.showAlert(message: "写真は利用できません")
            return
        }
        
        // 写真を表示する ViewController を作成.
        let picker = UIImagePickerController()
        // 表示タイプを写真にする.
        picker.sourceType = .photoLibrary
        // 写真選択後に処理ができるように、delegate を設定する.
        picker.delegate = self
        // 写真選択を表示する.
        self.present(picker, animated: true, completion: nil)
    }
    
    // 画面遷移時に呼び出される.
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        
        // 遷移先の指定（=segue）が フィルター画面の場合.
        if segue.identifier == "filterImage" {
            // 遷移先の ViewController を取得する.
            if let vc = segue.destination as? FilterViewController {
                // フィルター処理する画像を、遷移先の ViewController に渡す.
                if let image =  sender as? UIImage {
                    vc.image = image
                }
            }
        }
    }
}

// カメラ撮影後や写真選択後に、処理ができるように、Delegate を実装する.
extension ViewController : UIImagePickerControllerDelegate {
    
    // カメラ撮影後や写真選択後に呼び出される.
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        
        // カメラ画面や写真画面を閉じる.
        picker.dismiss(animated: true, completion: nil)
        
        // 選択した画像を取得する.
        if let image = info[.originalImage] as? UIImage {
            // フィルター画面に遷移し、取得した画像を遷移先に共有する.
            self.performSegue(withIdentifier: "filterImage", sender: image)
        }
    }
}

// カメラ起動や写真起動に必要な Delegateを実装する.
// 正し、特に処理を書く必要がないので、中身は空っぽでOK.
extension ViewController: UINavigationControllerDelegate {}
