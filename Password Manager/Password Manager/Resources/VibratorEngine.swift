//
//  VibratorEngine.swift
//  vibro
//
//  Created by Alex Gurbo on 9/12/20.
//  Copyright © 2020 Alex Gurbo. All rights reserved.
//

import UIKit
import CoreHaptics

class VibratorEngine: NSObject{
    static let shared = VibratorEngine()
    override init() {
        super.init()
    }
    
    func actionTaptic() {
        let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.light)
        generator.impactOccurred()
    }
    
    func sliderTaptic() {
        let generator = UIImpactFeedbackGenerator(style: UIImpactFeedbackGenerator.FeedbackStyle.soft)
        generator.impactOccurred()
    }
}
