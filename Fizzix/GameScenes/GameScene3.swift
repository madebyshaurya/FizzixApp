//
//  GameScene3.swift
//  Fizzix
//
//  Created by Shaurya on 2024-06-01.
//

import Foundation
import SpriteKit
import GameplayKit


class GameScene3: SKScene {
    
    private var law3View: Law3?
    let cradleFrame: CGRect;
    
    init(size: CGSize ,law3View: Law3?, cradleFrame: CGRect) {
        self.law3View = law3View
        self.cradleFrame = cradleFrame
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var newtonsCradle: NewtonsCradle?
    
    override func didMove(to view: SKView) {
        newtonsCradle = NewtonsCradle(colors: [
            UIColor(red: 0.8779790997505188, green: 0.3812967836856842, blue: 0.5770481824874878, alpha: 1),
            UIColor(red: 0.2202886641025543, green: 0.7022308707237244, blue: 0.9593387842178345, alpha: 1),
            UIColor(red: 0.9166661500930786, green: 0.4121252298355103, blue: 0.2839399874210358, alpha: 1),
            UIColor(red: 0.521954357624054, green: 0.7994346618652344, blue: 0.3460423350334167, alpha: 1)
        ], law3View: law3View, cradleFrame: cradleFrame)
        
        newtonsCradle?.ballSize = CGSize(width: 60, height: 60)
        newtonsCradle?.ballPadding = 2.0
        newtonsCradle?.itemBehavior.elasticity = 1.0
        newtonsCradle?.itemBehavior.resistance = 0.2
        newtonsCradle?.useSquaresInsteadOfBalls = false
        newtonsCradle?.itemBehavior.allowsRotation = false
        newtonsCradle?.gravityBehavior.angle = CGFloat.pi / 2
        newtonsCradle?.gravityBehavior.magnitude = 1.0
        
        for attachmentBehavior in newtonsCradle!.attachmentBehaviors {
            attachmentBehavior.length = 100
        }
        
        newtonsCradle?.center = CGPoint(x: size.width / 2, y: size.height / 2)
        
        if let newtonsCradle = newtonsCradle {
            view.addSubview(newtonsCradle)
        }
    }
}
