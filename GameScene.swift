import SpriteKit
import GameplayKit

class GameScene: SKScene, SKPhysicsContactDelegate
{
  var redBall = SKSpriteNode()
  var redEmitter = SKEmitterNode()
  var blueBall = SKSpriteNode()
  var blueEmitter = SKSpriteNode()
  var rotatePoint = SKNode()
  
  var rectangle = SKSpriteNode()
  var rectangleEmitter = SKEmitterNode()
  var square = SKSpriteNode()
  var squareEmitter = SKEmitterNode()
  
  var scoreToDeaths: [Int, Int] = [0, 0]
  var scoreLabel: SKLabelNode()
  var deathsLabel: SKLabelNode()
  
  var referencePath = SKShapeNode()
  var leftPosition: CGPoint = CGPoint(x: -250, y: frame.maxY)
  var rightPosition: CGPoint = CGPoint(x: 250, y: frame.maxY)
  
  var isTouching: Bool = false
  var direction: String = ""
  
  override func didMove(to view: SKView)
  {
    redBall = rotateNode.childNode(withName: "redBall") as! SKSpriteNode
    redBall.physicsBody?.categoryBitMask = 1
    redBall.physicsBody?.collisionBitMask = 2
    redBall.usesPreciseCollisionDetection = true
    redBall.position = CGPoint(x: -50, y: 0)
    redEmittor = redBall.childNode(fileNamed: "redEmitter.sks"!)!
    redEmitter.targetNode = self
    blueBall = rotateNode.childNode(withName: "blueBall") as! SKSpriteNode
    blueBall.physicsBody?.categoryBitMask = 1
    blueBall.physicsBody?.collisionBitMask = 2
    blueBall.usesPreciseCollisionDetection = true
    blueBall.position = CGPoint(x: 50, y: 0)
    blueEmitter = blueBall.childNode(fileNamed: "blueEmitter.sks"!)!
    blueEmittor.targetNode = self
    rotatePoint = self.childNode(withName: "rotatePoint")!
    rotatePoint.position = CGPoint(x: frame.midX, y: frame.midY)
    
    rectangle = self.childNode(withName: "rectangle") as! SKSpriteNode
    rectangle.physicsBody?.categoryBitMask = 2
    rectangle.physicsBody?.collisionBitMask = 1
    rectangle.isHidden = true
    rectangleEmitter = rectangle.childNode(fileNamed: "rectangleEmitter.sks"!)!
    rectangleEmitter.targetNode = self
    square = self.childNode(withName: "square") as! SKSpriteNode
    square.physicsBody?.categoryBitMask = 2
    square.physicsBody?.collisionBitMask = 1
    square.isHidden = true
    squareEmitter = square.childNode(fileNamed: "squareEmitter.sks"!)!
    squareEmitter.targetNode = self
    
    scoreLabel = self.childNode(withName: "scoreLabel") as! SKLabelNode
    deathsLabel = self.childNode(withName: "deathsLabel") as! SKLabelNode
    
    drawLines()
    spawnBlocks()
  }
  
  override func touchesBegan(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    for touch in touches
    {
      let location = touch.location(in: self)
      
      if (location.x < frame.midX)
      {
        isTouching = true
        direction = "COUNTERCLOCKWISE"
      }
      else if (location.x > frame.midX)
      {
        isTouching = true
        direction = "CLOCKWISE"
      }
    }
  }
  
  override func touchesEnded(_ touches: Set<UITouch>, with event: UIEvent?)
  {
    isTouching = false
    direction = ""
  }
  
  override func didBegin(_ contact: SKPhysicsContact)
  {
    let gameScene = GameScene(size: self.size)
    gameScene.scaleMode = self.scaleMode
    let animation = SKTransition.fade(withDuration: 1.0)
  
    switch contact.bodyA.node?.name
    {
      case "redBall":
        redBall.isHidden = true
        
        switch contact.bodyB.node?.name
        {
          case rectangle:
            retangle.run(SKAction.repeatForever(SKAction.wait(forDuration: 10.0)))
            self.view?.presentScene(gameScene, transition: animation)
          case square:
            square.run(SKAction.repeatForever(SKAction.wait(forDuration: 10.0)))
            self.view?.presentScene(gameScene, transition: animation)
        }
      case "blueBall":
        blueBall.isHidden = true
      
        switch contact.bodyB.node?.name
        {
          case rectangle:
            retangle.run(SKAction.repeatForever(SKAction.wait(forDuration: 10.0)))
            self.view?.presentScene(gameScene, transition: animation)
          case square:
            square.run(SKAction.repeatForever(SKAction.wait(forDuration: 10.0)))
            self.view?.presentScene(gameScene, transition: animation)
        }
      }
    }
  }
  
  override func update(_ currentTime: TimeInterval)
  {
    scoreLabel.text = "\(scoreToDeaths[0])"
    deathsLabel.text = "\(scoreToDeaths[1])"
  
    if (isTouching)
    {
      rotateNode(node: rotatePoint, direction: direction)
    }
  }
  
  func rotateNode(node: SKNode, direction: String)
  {
    switch direction
    {
      case "COUNTERCLOCKWISE":
        node.rotate(byAngle: -1.0, duration: 0.25)
      case "CLOCKWISE":
        node.rotate(byAngle: 1.0, duration: 0.25)
      default:
        break
    }
  }
  
  func drawLines()
  {
    let leftLane = UIBezierPath()
    leftLane.move(to: CGPoint(x: -250, y: frame.maxY))
    leftLane.addLine(to: CGPoint(x: -250, y: frame.minY))
    
    let rightLane = UIBezierPath()
    rightLane.move(to: CGPoint(x: 250, y: frame.maxY))
    rightLane.addLine(to: CGPoint(x: 250, y: frame.minY))
  
    let referenceBezierPath = UIBezierPath(arcCenter: CGPoint(x: 0.0, y: 0.0), 
                                           radius: 50.0, 
                                           startAngle: 0.0, 
                                           endAngle: (Double.pi) * 2, 
                                           clockwise: true))
    referencePath.path = referenceBezierPath.cgPath
    referencePath.lineWidth = 2.5
    referencePath.strokeColor = UIColor.white
    
    self.addChild(referencePath)
  }
  
  func spawnBlocks()
  {
    let blocks: [SKSpriteNode] = [rectangle, square]
    let positions: [CGPoint] = [leftPosition, rightPosition]
    let randomBlock = Int(arc4random_uniform(UInt32(blocks.count)))
    let randomPosition = Int(arc4random_uniform(UInt32(positions.count)))
    
    if (rectangle.isHidden && square.isHidden)
    {
      let chosenBlock = blocks[randomBlock]
      let chosenPosition = positions[randomPosition]
      
      chosenBlock.position = chosenPosition
      
      switch chosenBlock.position
      {
        case leftPosition:
          chosenBlock.run(SKAction.follow(path: leftLane.cgPath, duration: 5.0))
          chosenBlock.run({
          chosenBlock.isHidden = true
          scoreToDeaths[0] += 1})
        case rightPosition:
          chosenBlock.run(SKAction.follow(path: rightLane.cgPath, duration: 5.0))
          chosenBlock.run({
          chosenBlock.isHidden = true
          scoreToDeaths[0] += 1})
        default:
          break
      }
    }
  }
