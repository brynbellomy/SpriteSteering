//
//  SteeringComponent.swift
//  GameObjects
//
//  Created by bryn austin bellomy on 6.14.14.
//  Copyright (c) 2014 bryn austin bellomy. All rights reserved.
//

import Foundation
import Funky
import UpdateTimer
import Signals
import BrynSwift
import SwiftDataStructures


@objc public protocol ILocatable : class
{
    var position : CGPoint { get }
    var velocity : CGVector { get }
}


@objc public protocol ISteerable : class, ILocatable
{
    var position : CGPoint { get }
    var velocity : CGVector { get }
    var maxVelocity : CGFloat  { get }
    var mass : CGFloat { get }
}


public protocol ISteeringBehavior
{
     mutating func getSteeringVectorForSnapshot(snapshot:SteeringComponent.Snapshot) -> CGVector
}


/**
 * MARK: - struct SteeringComponent -
 */

public struct SteeringComponent
{
    public struct Signals {
        public let velocityVector = Signal<CGVector>()
        public let steeringVector = Signal<CGVector>()
        public let steeringForceVector = Signal<CGVector>()
    }


    //
    // MARK: - Associated types
    //

    /** Encapsulates the relevant state of the ISteerable host at a given moment in time.  Snapshots are passed to steering behaviors which use them to calculate the current steering vector. */
    public struct Snapshot
    {
        public let position: CGPoint
        public let velocity: CGVector
        public let maxVelocity: CGFloat
        public let mass: CGFloat

        public static let Zero = Snapshot(position: CGPointZero, velocity: CGVectorZero, maxVelocity: 0, mass: 0)
    }


    //
    // MARK: - Properties
    //

    // MARK: + Public

    public var maxSteeringForce: CGFloat  = 300
    public let signals = Signals()

    // MARK: + Private

    private var steeringBehaviors = OrderedDictionary<String, ISteeringBehavior>() // [String: ISteeringBehavior]()
    private var steeringVector = CGVectorZero
    private var currentSnapshot = Snapshot.Zero
    private var updateTimer = UpdateTimer()



    //
    // MARK: - Lifecycle
    //

    public init() {}


    //
    // MARK: - Scene loop
    //

    public mutating func update(currentTime:NSTimeInterval, position:CGPoint, velocity:CGVector, maxVelocity:CGFloat, mass:CGFloat)
    {
        updateTimer.update(currentTime)
        currentSnapshot = Snapshot(position:position, velocity:velocity, maxVelocity:maxVelocity, mass:mass)
        steeringVector  = calculateSteeringVector(currentSnapshot)
//        signals.steeringVector.fire(steeringVector)
    }

    public mutating func currentSteeringImpulseVector() -> CGVector {
        return steeringVector
    }

    public mutating func currentStaticBodySteering() -> (steering:CGVector, velocity:CGVector, position:CGPoint)
    {
        let newVelocity = calculateVelocityVector(currentSnapshot, steeringVector:steeringVector)
        let newPosition = currentSnapshot.position + currentSnapshot.velocity * CGFloat(updateTimer.timeSinceLastUpdate)
        return (steering:steeringVector, velocity:newVelocity, position:newPosition)
    }

    //
    // MARK: - Public API
    //

    private mutating func calculateVelocityVector(currentSnapshot:Snapshot, steeringVector:CGVector) -> CGVector
    {
        // @@TODO: test whether mass is affecting steering correctly
        let steeringForce = steeringVector.limited(maxSteeringForce)
                                          .scaled(1 / currentSnapshot.mass) |> mapNaNComponentsToZeros

        let velocity = (currentSnapshot.velocity + steeringForce)
                                          .limited(currentSnapshot.maxVelocity) |> mapNaNComponentsToZeros

//        signals.steeringForceVector.fire(steeringForce)
//        signals.velocityVector.fire(velocity)

        return velocity
    }

    private mutating func calculateSteeringVector(currentSnapshot:Snapshot) -> CGVector
    {
        return steeringBehaviors.values
                |> mapr { (var behavior) in behavior.getSteeringVectorForSnapshot(currentSnapshot) }
                |> reducer(CGVectorZero) { $0 + $1 }
                |> mapNaNComponentsToZeros
    }



    public mutating func addSteering(steering:ISteeringBehavior, withKey key:String)
    {
        if let oldBehaviorForKey = steeringBehaviors[key] {
            removeSteeringForKey(key)
        }
        steeringBehaviors[key] = steering
    }


    public mutating func removeSteeringForKey(key:String) -> ISteeringBehavior? {
        let removed = steeringBehaviors.removeForKey(key)
        return removed.value
    }


    public func has(key:String) -> Bool {
        return steeringBehaviors[key] != nil
    }


    public func steeringForKey(key:String) -> ISteeringBehavior?
    {
        if let steering = steeringBehaviors[key] {
            return steering
        }
        else {
            // lllog(.Warning, "could not find steering for key '\(key)'")
            return nil
        }
    }



}













