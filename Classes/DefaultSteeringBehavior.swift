//
//  DefaultSteeringBehavior.swift
//  SpriteSteering
//
//  Created by bryn austin bellomy on 2014 Nov 30.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import Funky
import let BrynSwift.CGVectorZero


public struct ConstantSteering : ISteeringBehavior
{
    /** The direction in which to move. */
    public let vector: CGVector

    public init(vector v:CGVector) {
        vector = v
    }

    public func getSteeringVectorForSnapshot(snapshot:SteeringComponent.Snapshot) -> CGVector {
        return SteeringHelpers.createConstantVector(snapshot, vector:vector)
    }
}


public struct SeekSteering : ISteeringBehavior
{
    /** The point to move towards. */
    public let point: CGPoint

    /* The radius from `point` at which movement begins to slow. */
    public let slowingRadius: CGFloat

    /* The radius from `point` at which movement stops. */
    public let stopRadius: CGFloat

    public init(point p:CGPoint, slowingRadius slow:CGFloat, stopRadius stop: CGFloat) {
        point = p
        slowingRadius = slow
        stopRadius = stop
    }

    public func getSteeringVectorForSnapshot(snapshot:SteeringComponent.Snapshot) -> CGVector {
        return SteeringHelpers.createStaticVector(snapshot, point:point, slowingRadius:slowingRadius, stopRadius:stopRadius, towards:true)
    }
}


public struct FleeSteering : ISteeringBehavior
{
    /** The point to move away from. */
    public let point: CGPoint

    /** The radius from `point` at which movement begins to slow. */
    public let slowingRadius: CGFloat

    /** The radius from `point` at which movement stops. */
    public let stopRadius: CGFloat

    public init(point p:CGPoint, slowingRadius slow:CGFloat, stopRadius stop: CGFloat) {
        point = p
        slowingRadius = slow
        stopRadius = stop
    }

    public func getSteeringVectorForSnapshot(snapshot:SteeringComponent.Snapshot) -> CGVector {
        return SteeringHelpers.createStaticVector(snapshot, point:point, slowingRadius:slowingRadius, stopRadius:stopRadius, towards:false)
    }
}



public struct PursueSteering : ISteeringBehavior
{
    /** The object to pursue. */
    public let target: ILocatable

    /** The offset from `target`'s current position towards which to move. */
    public let offset: CGVector

    /** The radius from `point` at which pursuit stops. */
    public let stopRadius: CGFloat

    public init(target t: ILocatable, offset o: CGVector, stopRadius stop:CGFloat) {
        target = t
        offset = o
        stopRadius = stop
    }

    public func getSteeringVectorForSnapshot(snapshot:SteeringComponent.Snapshot) -> CGVector {
        return SteeringHelpers.createDynamicVector(snapshot, target: target, offset: offset, stopRadius: stopRadius, towards: true)
    }
}



public struct EvadeSteering : ISteeringBehavior
{
    /** The object to move away from. */
    let target: ILocatable

    /** The radius from `point` at which evasion stops.  ("Whew!  Got away!") */
    let stopRadius: CGFloat

    public init(target t: ILocatable, stopRadius stop:CGFloat) {
        target = t
        stopRadius = stop
    }

    public func getSteeringVectorForSnapshot(snapshot:SteeringComponent.Snapshot) -> CGVector {
        return SteeringHelpers.createDynamicVector(snapshot, target: target, offset: CGVectorZero, stopRadius: stopRadius, towards: false)
    }
}



public struct WanderSteering : ISteeringBehavior
{
    let circleDistance: CGFloat
    let circleRadius: CGFloat
    let angleChange: CGFloat
    var wanderAngle: CGFloat

    public init(circleDistance d:CGFloat = 10, circleRadius r:CGFloat = 20, angleChange a:CGFloat = 20)
    {
        circleDistance = d
        circleRadius = r
        angleChange = a
        wanderAngle = 0
    }

    public mutating func getSteeringVectorForSnapshot(snapshot:SteeringComponent.Snapshot) -> CGVector
    {
        let (vector, newWanderAngle) = SteeringHelpers.createWanderVector(snapshot, circleDistance: circleDistance, circleRadius: circleRadius, angleChange: angleChange, wanderAngle: wanderAngle)
        wanderAngle = newWanderAngle
        return vector
    }

}



extension SeekSteering : Printable {
    public var description : String { return "Seek(point: \(point), slowingRadius: \(slowingRadius))" }
}

extension FleeSteering : Printable {
    public var description : String { return "Flee(point: \(point))" }
}

extension PursueSteering : Printable {
    public var description : String { return "Pursue(target: \(target), offset: \(offset), stopRadius: \(stopRadius))" }
}

extension EvadeSteering : Printable {
    public var description : String { return "Evade(target: \(target), stopRadius: \(stopRadius))" }
}

extension WanderSteering : Printable {
    public var description : String { return "Wander(circleDistance:\(circleDistance), circleRadius:\(circleRadius), angleChange:\(angleChange), wanderAngle:\(wanderAngle))" }
}




