//
//  GameScene1.swift
//  Fizzix
//
//  Created by Shaurya on 2024-06-01.
//

import Foundation
import SpriteKit
import GameplayKit

class GameScene1: SKScene, SKPhysicsContactDelegate {
    
    private var law1View: Law1?
    
    init(size: CGSize ,law1View: Law1?) {
        self.law1View = law1View
        super.init(size: size)
    }
    
    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private var car = SKSpriteNode(texture: SKTexture(imageNamed: "car"))
    private var box = SKSpriteNode(texture: SKTexture(imageNamed: "crate"), size: CGSize(width: 70, height: 70))
    private var terrain = SKShapeNode(rectOf: CGSize(width: 500, height: 10))
    private var carIsMovable = true
    
    override func didMove(to view: SKView) {
        physicsWorld.contactDelegate = self
        backgroundColor = .white
        
        box.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 70, height: 70))
        box.physicsBody?.affectedByGravity = true
        box.physicsBody?.collisionBitMask = .max
        box.name = "crate"
        box.physicsBody?.isDynamic = true
        box.physicsBody?.friction = 0.5
        box.position = .init(x: 200, y: 450)
        addChild(box)
        
        car.xScale = -1;
        car.physicsBody = SKPhysicsBody(texture: SKTexture(imageNamed: "car"), size: car.texture!.size())
        car.name = "car"
        car.physicsBody?.affectedByGravity = true
        car.physicsBody?.collisionBitMask = .max
        car.physicsBody?.contactTestBitMask = car.physicsBody?.collisionBitMask ?? 0
        car.physicsBody?.isDynamic = true
        car.constraints = [SKConstraint.zRotation(SKRange(upperLimit: 1))]
        car.position = .init(x: 70, y: 450)
        addChild(car)
        
        terrain.strokeColor = .brown
        terrain.fillColor = .brown
        terrain.name = "terrain"
        terrain.physicsBody = SKPhysicsBody(rectangleOf: CGSize(width: 500, height: 10))
        terrain.physicsBody?.affectedByGravity = false
        terrain.physicsBody?.isDynamic = false
        terrain.position = .init(x: 200, y: 150)
        addChild(terrain)
        
        
    }
    
    func didBegin(_ contact: SKPhysicsContact) {
        
        if contact.bodyA.node?.name == "crate" && contact.bodyB.node?.name == "car" {
            if let law1 = law1View {
                if law1.instructionNum == 3 {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
                        law1.instructionNum = 3
                        law1.instructionNum += 1
                        law1.counter += 1
                        law1.navigationButtonsVisible = false
                        law1.checkForCompletion = false
                        law1.biggerCard = true
                    }
                }
            }
            
        }
    }
    
    override func update(_ currentTime: TimeInterval) {
        
        if (!intersects(car)) {
            car.position = CGPoint(x: 100, y: 300)
        }
        
        if (!intersects(box)) {
            box.position = CGPoint(x: 200, y: 300)
        }
        
        if box.position.x >= 400 {
            
        }
    }
    
    
    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        for touch in touches {
            let location = touch.location(in: self)
            
            if carIsMovable == true {
                car.position.x = location.x
            }
        }
    }
    
    
    
}
