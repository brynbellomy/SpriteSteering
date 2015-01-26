////
////  SteeringComponent+Debug.swift
////  GameObjects
////
////  Created by bryn austin bellomy on 2014 Oct 6.
////  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
////
//
//import Foundation
//import SpriteKit
//
//import SwiftLogger
//import MoarNodes
//import Funky
//import NodeBehaviors
//import GameObjects
//
//
//public class DebugSteeringBehavior<N : SKNode where N : ISteerable> : NodeBehavior<N>, IBehavior
//{
//    public typealias SteerableNode = N
//
//    public var debugNode = SKNode()
//    public var scene : Scene? { return getScene() }
//
//    let steeringKey : String
//    let steering : SteeringComponent.Steering?
//
//    public init(targetNode:SteerableNode, steeringKey k:String)
//    {
//        steeringKey = k
//        super.init(targetNode:targetNode)
//    }
//
//    override public func didMoveToController() {
//        scene?.signals.update.listen(self, update)
//    }
//
//    override public func willMoveFromController() {
//        debugNode.removeFromParentAndNotify()
//        scene?.signals.update.removeListener(self)
//    }
//
//    public func update(currentTime:NSTimeInterval) { }
//}
//
//
//
//public class DebugSteeringVectorBehavior<N : SKNode where N : ISteerable> : NodeBehavior<N>, IBehavior
//{
//    public typealias SteerableNode = N
//
//    public var debugNode = SKNode()
//    var lineNode = LineShapeNode() as LineShapeNode
//
//    public override init(targetNode:SteerableNode)
//    {
//        super.init(targetNode:targetNode)
//
//        debugNode.addChildAndNotify(lineNode)
//
//        lineNode.strokeColor = SKColor.orangeColor()
//        lineNode.lineWidth = 3
//        lineNode.startPoint = CGPointZero
//        lineNode.zPosition = 9999
//    }
//
//    override public func didMoveToController() {
////        targetNode?.steeringComponent.signals.steeringVector.listen(self) { [weak self] (steeringVector:CGVector) -> () in
////            let endVector : CGVector = steeringVector.normalized * 100
////            self?.lineNode.endPoint = CGPointZero + endVector
////        }
//    }
//
//    override public func willMoveFromController()
//    {
//        debugNode.removeFromParent()
////        steerable?.steeringComponent.signal_steeringVector.removeListener(self)
//    }
//}
//
//
//
//public class DebugStaticSteeringBehavior<N : SKNode where N : ISteerable> : DebugSteeringBehavior<N>
//{
//    let radiusNode              = CircleShapeNode()
//    let destinationPointNode    = CircleShapeNode()
//    let lineNode                = LineShapeNode()
//
//    var destinationPoint : CGPoint?
//    var slowingRadius : CGFloat = 0
//
//    override public init(targetNode:N, steeringKey:String)
//    {
//        super.init(targetNode:targetNode, steeringKey:steeringKey)
//
//        var radius : CGFloat?
//        if let steering = self.steering?
//        {
//            switch steering
//            {
//                case let .Seek(point, slowingRadius):
//                    radius = slowingRadius
//                    destinationPoint = point
//                    break
//
//                case let .Flee(point):
//                    radius = 0
//                    destinationPoint = point
//                    break
//
//                default: break
//            }
//        }
//
//        lineNode.strokeColor             = SKColor.yellowColor()
//        radiusNode.strokeColor           = SKColor.blueColor()
//        destinationPointNode.strokeColor = SKColor.redColor()
//
//        radiusNode.radius = radius
//        destinationPointNode.radius = 10
//
//        lineNode.lineWidth = 3
//        lineNode.startPoint = CGPointZero
//
//        debugNode.addChildAndNotify(radiusNode)
//        debugNode.addChildAndNotify(destinationPointNode)
//        debugNode.addChildAndNotify(lineNode)
//    }
//
//
//    override public func update(currentTime:NSTimeInterval)
//    {
//        radiusNode.radius = slowingRadius
//
//        if destinationPoint != nil && targetNode != nil
//        {
//            let relativePoint = destinationPoint! - targetNode!.position
//            destinationPointNode.position = relativePoint
//            lineNode.endPoint = relativePoint
//        }
//    }
//}
//
//
//public class DebugDynamicSteeringBehavior<N : SKNode where N : ISteerable> : DebugSteeringBehavior<N>
//{
//    var offsetNode       = CircleShapeNode()
//    var targetCircleNode = CircleShapeNode()
//    var lineNode         = LineShapeNode()
//
//    var target : ILocatable?
//    var offset : CGVector?
//    var enoughRadius : CGFloat?
//
//    override public init(targetNode:N, steeringKey:String)
//    {
//        super.init(targetNode:targetNode, steeringKey:steeringKey)
//
//        targetCircleNode.radius = 10
//        targetCircleNode.strokeColor = SKColor.redColor()
//
//        offsetNode.strokeColor = SKColor.blueColor()
//
//        lineNode.lineWidth = 3
//        lineNode.startPoint = CGPointZero
//        lineNode.strokeColor = SKColor.yellowColor()
//
//        if let steering = self.steering?
//        {
//            switch steering
//            {
//                case let .Pursue(target, offset, enoughRadius):
//                    self.target = target
//                    self.offset = offset
//                    self.enoughRadius = enoughRadius
//                    break
//
//                case let .Evade(target, enoughRadius):
//                    self.target = target
//                    self.offset = CGVectorZero
//                    self.enoughRadius = enoughRadius
//                    break
//
//                default: break
//            }
//        }
//        else { lllog(.Error, "steering is nil.") }
//
//        debugNode.addChildAndNotify(targetNode)
//        debugNode.addChildAndNotify(offsetNode)
//        debugNode.addChildAndNotify(lineNode)
//    }
//
//
//    override public func update(currentTime:NSTimeInterval)
//    {
//        if offset != nil {
//            offsetNode.radius = CGFloat(offset!.magnitude)
//        }
//
//        if target != nil && targetNode != nil
//        {
//            let position = target!.position - targetNode!.position
//            targetCircleNode.position = position
//            offsetNode.position = position
//            
//            let relativePoint = target!.position - targetNode!.position
//            lineNode.endPoint = relativePoint
//        }
//        else {
//            if target == nil     { lllog(.Warning, "target is nil.")     }
//            if targetNode == nil { lllog(.Warning, "targetNode is nil.") }
//        }
//    }
//}
//    
//    
//
//
//
//
