//
//  GameScene.swift
//  JETWOMAN
//
//  Created by richardleandro on 08/04/19.
//  Copyright © 2019 richardleandro. All rights reserved.
//

import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate {
    let chacacters = ["A","B","C","D","E","1","2","3","4"]
    let keyCodes = [0,11,8,2,14,18,19,20,21]
    let jetWomanCategory : UInt32 = 2
    let spikesCategory : UInt32 = 1
    
    private var label : SKLabelNode?
    private var jetWoman : SKSpriteNode?
    private var startButton : SKSpriteNode?
    private var scoreLabel : SKLabelNode?
    private var highscorelabel : SKLabelNode?
    
    var currentCharacter : String?
    var currentKeyCode : Int?
    var score = 0
    
    override func didMove(to view: SKView) {
        
        self.physicsWorld.contactDelegate = self
        
        // Get label node from scene and store it for use later
        self.label = self.childNode(withName: "//helloLabel") as? SKLabelNode
        if let label = self.label {
            label.alpha = 0.0
            
        }
        
        self.jetWoman = self.childNode(withName: "jetwoman") as?
        SKSpriteNode
        self.startButton = self.childNode(withName: "startbutton") as?
        SKSpriteNode
        self.scoreLabel = self.childNode(withName: "scoreLabel") as?
        SKLabelNode
        self.highscorelabel = self.childNode(withName: "highscorelabel") as?
        SKLabelNode
        
        let highscore = UserDefaults.standard.integer(forKey: "highscore")
        highscorelabel?.text = "High:\(highscore)"
        scoreLabel?.text = "Score:\(score)"

    }
    
    func updateHighScore(){
        let highscore = UserDefaults.standard.integer(forKey: "highscore")
        highscorelabel?.text = "High:\(highscore)"
    }
    
    
    func chooseNextKey(){
        let count = UInt32(chacacters.count)
        let randomIndex = Int(arc4random_uniform(count))
        currentCharacter = chacacters[randomIndex]
        currentKeyCode = keyCodes[randomIndex]
        if let label = self.label {
            label.text = currentCharacter
            label.alpha = 1.0
        }
    }
    
    
    override func mouseDown(with event: NSEvent) {
        let point = event.location(in: self)
        let nodeAtpoint = nodes(at: point)
        for node in nodeAtpoint{
            if node.name == "startButton"{
                if let jetWoman = self.jetWoman{
                    jetWoman.position = CGPoint(x: 0, y: 100)
                    jetWoman.physicsBody?.pinned = false
                    node.removeFromParent()
                    score = 0
                    scoreLabel?.text = "Score:\(score)"
                    chooseNextKey()
                }
            }
        }
        
    }
    
    override func keyDown(with event: NSEvent) {
        if let theKeyCode = currentKeyCode{
            switch event.keyCode {
            case UInt16(theKeyCode):
                if let jetWoman = self.jetWoman{
                    jetWoman.physicsBody?.applyImpulse(CGVector(dx:0,dy:(200 - score*5)))
                    score += 1
                    scoreLabel?.text = "Score:\(score)"
                    chooseNextKey()
                }
            default:
                print("keyDown: \(event.characters!) keyCode: \(event.keyCode)")
            }
        }
    }
    
    
    func didBegin(_ contact: SKPhysicsContact) {
        let bodyA = contact.bodyA
        let bodyB = contact.bodyB
        
        if bodyA.categoryBitMask == spikesCategory || bodyB.categoryBitMask == jetWomanCategory {
            if let startButton = self.startButton{
                if startButton.parent != self{
                    addChild(startButton)
                    currentCharacter = nil
                    currentKeyCode = nil
                    if let label = self.label {
                        label.alpha = 0.0
                    }
                    //check if high score
                    let highscore = UserDefaults.standard.integer(forKey: "highscore")
                    if score > highscore{
                        UserDefaults.standard.set(score, forKey: "highscore")
                        UserDefaults.standard.synchronize()
                        highscorelabel?.text = "High:\(score)"
                    }
                }
                
            }
        }
        
        
    }
    
    
    override func update(_ currentTime: TimeInterval) {
        // Called before each frame is rendered
    }
}
