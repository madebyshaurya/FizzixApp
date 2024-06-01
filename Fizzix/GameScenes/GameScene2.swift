//
//  GameScene2.swift
//  Fizzix
//
//  Created by Shaurya on 2024-06-01.
//

import Foundation
import SpriteKit
import GameplayKit


class GameScene2: SKScene {
    var elapsedTime = 0
    var speedTimer: Timer?
    let pixelsPerMeter: CGFloat = 100
    let inputWidth: Int = 200
    let inputHeight: Int = 40
    
    private var law2View: Law2?
    
    init(size: CGSize ,law2View: Law2?) {
        self.law2View = law2View
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    var durationLabel = SKLabelNode(fontNamed: "KleeOne-Regular")
    var errorTextLabel = SKLabelNode(fontNamed: "KleeOne-Regular")
    var forceInputField: UITextField!
    var massInputField: UITextField!
    var moveButton: UIButton!
    var durationStepper: UIStepper!
    var terrain = SKShapeNode(rectOf: CGSize(width: 500, height: 10))
    var box = SKSpriteNode(texture: SKTexture(imageNamed: "crate"), size: CGSize(width: 70, height: 70))
    
    override func didMove(to view: SKView) {
        backgroundColor = .white
        
        errorTextLabel.text = ""
        errorTextLabel.fontSize = 20
        errorTextLabel.fontColor = SKColor.red
        errorTextLabel.position = CGPoint(x: frame.midX, y: frame.midY - 50)
        addChild(errorTextLabel)
        
        box.name = "crate"
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 70, height: 70))
        box.physicsBody?.affectedByGravity = true
        box.physicsBody?.collisionBitMask = .max
        box.name = "crate"
        box.physicsBody?.isDynamic = true
        box.physicsBody?.friction = 0.5
        box.position = .init(x: 75, y: 350)
        addChild(box)
        
        terrain.strokeColor = .brown
        terrain.fillColor = .brown
        terrain.name = "terrain"
        terrain.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 500, height: 10))
        terrain.physicsBody?.affectedByGravity = false
        terrain.physicsBody?.isDynamic = false
        terrain.position = .init(x: 250, y: 210)
        addChild(terrain)
        
        durationStepper = UIStepper(frame: CGRect(x: 230, y: 30, width: 100, height: 50))
        durationStepper.layer.cornerRadius = 10
        durationStepper.backgroundColor = .white
        durationStepper.maximumValue = 5
        durationStepper.minimumValue = 1
        durationStepper.value = 3.0
        view.addSubview(durationStepper)
        
        durationLabel.text = "Duration: \(durationStepper.value)"
        durationLabel.fontSize = 20
        durationLabel.fontColor = .black
        durationLabel.position = CGPoint(x: 400, y: 345)
        addChild(durationLabel)
        
        forceInputField = UITextField(frame: CGRect(x: 20, y: 300, width: inputWidth, height: inputHeight))
        forceInputField.textAlignment = .center
        forceInputField.placeholder = "Enter Force (Newtons)"
        forceInputField.keyboardType = .numberPad
        forceInputField.backgroundColor = .gray
        forceInputField.textColor = .black
        forceInputField.layer.cornerRadius = 5
        forceInputField.layer.borderColor = .init(red: 0, green: 255, blue: 0, alpha: 1)
        forceInputField.layer.borderWidth = 2
        
        view.addSubview(forceInputField)
        
        massInputField = UITextField(frame: CGRect(x: 280, y: 300, width: inputWidth, height: inputHeight))
        massInputField.textAlignment = .center
        massInputField.placeholder = "Enter Mass (kg)"
        massInputField.keyboardType = .numberPad
        massInputField.backgroundColor = .gray
        massInputField.textColor = .black
        massInputField.layer.cornerRadius = 5
        massInputField.layer.borderColor = .init(red: 0, green: 0, blue: 150, alpha: 1)
        massInputField.layer.borderWidth = 2
        view.addSubview(massInputField)
        
        moveButton = UIButton(type: .system)
        moveButton.backgroundColor = .blue
        moveButton.tintColor = .white
        moveButton.layer.cornerRadius = 5
        moveButton.frame = CGRect(x: frame.midX-75, y: 350, width: 150, height: 30)
        moveButton.setTitle("Move Crate!", for: .normal)
        moveButton.addTarget(self, action: #selector(moveCrate), for: .touchDown)
        view.addSubview(moveButton)
    }
    
    override func update(_ currentTime: TimeInterval) {
        if (!intersects(box)) {
            box.position = .init(x: 75, y: 250)
        }
        durationLabel.text = "Duration: \(durationStepper.value)s"
    }
    
    @objc func moveCrate() {
        elapsedTime = 0
        speedTimer = Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(updateElapsedTime), userInfo: nil, repeats: true)
        
        Timer.scheduledTimer(timeInterval: durationStepper.value, target: self, selector: #selector(endSpeedChange), userInfo: nil, repeats: false)
        view?.endEditing(true)
    }
    
    @objc func updateElapsedTime() {
        elapsedTime += 1
        changeSpeed(elapsedTime: elapsedTime)
    }
    
    @objc func changeSpeed(elapsedTime: Int) {
        guard let forceString = forceInputField.text,
              let massString = massInputField.text,
              let force = Double(forceString),
              let mass = Double(massString) else {
            return
        }
        
        if !(mass > 20) && !(mass < 1) {
            if (!(force > 100) && !(force < 1)) {
                errorTextLabel.text = ""
                let acceleration = force / mass
                
                print("Elapsed Time = \(elapsedTime) and acceleration is \(acceleration) and combined is \(CGFloat(Double(elapsedTime) * acceleration))")
                
                let moveAction = SKAction.moveBy(x: CGFloat((Double(elapsedTime) * acceleration) * pixelsPerMeter), y: 0, duration: 5)
                box.run(moveAction)
                
                if let law2 = law2View {
                    if law2.instructionNum == 4 {
                        law2.checkForCompletion = false
                        law2.instructionNum += 1
                        law2.counter += 1
                        law2.navigationButtonsVisible = false
                    }
                }
            } else {
                errorTextLabel.text = "Force input should be between 1N and 100N"
                forceInputField.text = ""
            }
        } else {
            errorTextLabel.text = "Mass should be between 1kg and 20kg"
            massInputField.text = ""
        }
    }
    
    @objc func endSpeedChange() {
        // Invalidate the speed timer
        speedTimer?.invalidate()
        speedTimer = nil
    }

    
}
