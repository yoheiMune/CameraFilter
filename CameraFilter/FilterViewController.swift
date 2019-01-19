//
//  FilterViewController.swift
//  CameraFilter
//
//  Created by Munesada Yohei on 2019/01/18.
//  Copyright © 2019 Munesada Yohei. All rights reserved.
//

import UIKit

/**
 * 画像にフィルタをかける画面.
 * カメラ撮影後や写真選択後に、本画面が表示される.
 */
class FilterViewController : UIViewController {
    
    // フィルター処理対象の画像.
    // 遷移元の画面（ViewController）から渡される.
    var image: UIImage!
    
    // 暖かみフィルターを利用する場合は、true
    // 暖かみフィルターボタンをタップするごとに、true/false が切り替わる.
    var warmFilterEnabled = false
    
    // 彩度（画像の鮮やかさ）フィルターに利用する値.
    // -1 〜 1 までの値を、画面のスライダーで指定する.
    var saturationFilterValue: Float = 0.0
    
    // フィルター加工前の画像を表示する UIImageView.
    @IBOutlet weak var originalImageView: UIImageView!
    
    // フィルター加工後の画像を表示する UIImageView.
    @IBOutlet weak var filteredImageView: UIImageView!
    
    // 画面が読み込まれた時に呼び出される.
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // ページタイトルを指定する.
        self.title = "フィルター画面"
        
        // 画面表示時には、フィルター加工前/後のどちらにも同じ画像を表示する.
        self.originalImageView.image = self.image
        self.filteredImageView.image = self.image
        
        // ナビゲーションバーの右側に「保存する」ボタンを設置する.
        // そのボタンがタップされたら「saveImage()」が呼び出される.
        let rightButton = UIBarButtonItem(title: "保存する", style: .plain, target: self, action: #selector(FilterViewController.saveImage))
        self.navigationItem.rightBarButtonItem = rightButton
    }
    
    // 「暖かみを追加」ボタンがタップされた時.
    @IBAction func onTapWarm() {
        // 暖かみフィルターの有効化を反転させる（true→false または false→true）
        self.warmFilterEnabled = !self.warmFilterEnabled
        // フィルターを適用しする.
        self.filter()
    }
    
    // 彩度調整スライダーで値が変わった時.
    @IBAction func onChangeSlider(_ sender: UISlider) {
        // 変更後の値を、取得して設定する.
        self.saturationFilterValue = sender.value
        // フィルターを適用する.
        self.filter()
    }
    
    // ナビゲーションバー右側の「保存する」ボタンがタップされた時.
    @objc func saveImage() {
        
        // フィルター加工後の画像を取得する.
        guard let filteredImage = self.filteredImageView.image else {
            return
        }
        
        // 写真に、フィルター加工後の画像を保存する.
        UIImageWriteToSavedPhotosAlbum(filteredImage, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
    }
    
    // 写真への画像保存が完了した時に呼び出される.
    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {
        if let error = error {
            // エラーがある場合には、エラーを表示する.
            self.showAlert(message: "保存に失敗しました。 error=\(error.localizedDescription)")
        } else {
            // 成功した場合には、その旨を表示する.
            self.showAlert(message: "保存しました。")
        }
    }
    
    // 画像にフィルターを適用する.
    private func filter() {
        
        // 暖かみフィルターを適用する.
        guard let filteredImage1 = self.warmFilter(image: self.image) else {
            return
        }
        
        // 彩度フィルターを適用する.
        guard let filteredImage2 = self.saturationFilter(image: filteredImage1) else {
            return
        }
        
        // UIImageView に表示する.
        self.filteredImageView.image = filteredImage2
    }
    
    // 暖かみフィルターを適用する.
    private func warmFilter(image: UIImage) -> UIImage? {
        
        // 暖かみフィルターが無効化されている場合には、画像をそのまま返却する.
        if !self.warmFilterEnabled {
            return image
        }
        
        // 今後の処理のために、UIImageをCIImageに変換する.
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        
        // 暖かみフィルターを作成する.
        guard let filter = CIFilter(name: "CIPhotoEffectTransfer") else {
            return nil
        }
        
        // 暖かみフィルターを適用する.
        filter.setDefaults()
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        // 後続処理の為、加工後の画像（CIImage）から、CGImageを取得する.
        guard let outputCIImage = filter.outputImage,
            let cgImage = CIContext(options: nil).createCGImage(outputCIImage, from: outputCIImage.extent) else {
                return nil
        }
        // CGImage から UIImage に変換して、返却する.
        return UIImage(cgImage: cgImage, scale: 1, orientation: image.imageOrientation)
    }
    
    // 彩度フィルターを適用します.
    private func saturationFilter(image: UIImage) -> UIImage?  {
        
        // 今後の処理のために、UIImageをCIImageに変換する.
        guard let ciImage = CIImage(image: image) else {
            return nil
        }
        
        // 彩度フィルターを作成する.
        guard let filter = CIFilter(name: "CIVibrance") else {
            return nil
        }
        
        // 暖かみフィルターに、彩度を指定する.
        filter.setValue(saturationFilterValue, forKey: "inputAmount")
        
        // 作成したフィルタを画像に適用する.
        filter.setValue(ciImage, forKey: kCIInputImageKey)
        
        // 後続処理の為、加工後の画像（CIImage）から、CGImageを取得する.
        guard let outputCIImage = filter.outputImage,
            let cgImage = CIContext(options: nil).createCGImage(outputCIImage, from: outputCIImage.extent) else {
                return nil
        }
        
        // CGImage から UIImage に変換して、返却する.
        return UIImage(cgImage: cgImage, scale: 1, orientation: image.imageOrientation)
    }
    
}
