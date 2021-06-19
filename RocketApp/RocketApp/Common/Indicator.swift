//
//  IndicatorView.swift
//  RocketApp
//
//  Created by iOS Developer on 19/06/21.
//

import UIKit
import EZProgressHUD

class Indicator {

    static let shared = Indicator()
    
    var hud: EZProgress!
    
    init() {
        let options = EZProgressOptions { (option) in
            option.radius = 80
            option.secondLayerStrokeColor = UIColor.green
            option.strokeWidth = 10
            option.thirdLayerStrokeColor = UIColor.green.withAlphaComponent(0.6)
            option.firstLayerStrokeColor = UIColor.blue.withAlphaComponent(0.6)
            option.transViewBackgroundColor = UIColor.black.withAlphaComponent(0.3)
            option.title = "Loading..."
            option.animationOption = EZAnimationOptions.xyRotation
        }
        self.hud = EZProgressHUD.setProgress(with: options)
    }
    
    func show() {
        hud.show()
    }
    
    func hide() {
        hud.dismiss(completion: nil)
    }
    
}
