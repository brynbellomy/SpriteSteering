//
//  SteeringHelpers.swift
//  SpriteSteering
//
//  Created by bryn austin bellomy on 2015 Jan 1.
//  Copyright (c) 2015 bryn austin bellomy. All rights reserved.
//

import Foundation
import Funky
import BrynSwift
import UpdateTimer
import SwiftLogger

public struct SteeringHelpers
{

    public static func createConstantVector(snapshot:SteeringComponent.Snapshot, vector:CGVector) -> CGVector
    {
        if snapshot.velocity.magnitude < snapshot.maxVelocity {
            let desired = mapNaNComponentsToZeros(vector.normalized) * snapshot.maxVelocity
            let force   = desired - snapshot.velocity
            return force
        }
        return CGVectorZero
    }

    public static func createStaticVector(snapshot:SteeringComponent.Snapshot, point:CGPoint, slowingRadius:CGFloat, stopRadius:CGFloat, towards:Bool) -> CGVector
    {
        let difference = towards ? point - snapshot.position : snapshot.position - point
        var desired  = CGVector(dx:difference.x, dy:difference.y)
        let distance = CGFloat(desired.magnitude)

        if (towards && distance <= stopRadius) || (!towards && distance >= stopRadius) {
            desired = CGVectorZero
        }
        else if (towards && distance <= slowingRadius) || (!towards && distance >= slowingRadius) {
            desired = desired.normalized * snapshot.maxVelocity * (distance / slowingRadius)
        }
        else {
            desired = desired.normalized * snapshot.maxVelocity
        }

        let force = mapNaNComponentsToZeros(desired - snapshot.velocity)
        return force
    }

    public static func createDynamicVector(snapshot:SteeringComponent.Snapshot, target:ILocatable, offset:CGVector, stopRadius:CGFloat, towards:Bool) -> CGVector
    {
        let difference = (target.position + offset) - snapshot.position
        let distance = CGVector(dx:difference.x, dy:difference.y)

        if towards && distance.magnitude < stopRadius
            || !towards && distance.magnitude > stopRadius {
            return CGVectorZero
        }

        var updatesNeeded  = distance.length / snapshot.maxVelocity
        var targetVelocity = target.velocity * updatesNeeded

        let targetFuturePosition = (target.position + targetVelocity) + offset
        if towards {
            return createStaticVector(snapshot, point:targetFuturePosition, slowingRadius:0, stopRadius:stopRadius, towards:true)
        }
        else {
            return createStaticVector(snapshot, point:targetFuturePosition, slowingRadius:0, stopRadius:stopRadius, towards:false)
        }
    }


    public static func createWanderVector
        (snapshot:SteeringComponent.Snapshot, circleDistance:CGFloat, circleRadius:CGFloat, angleChange:CGFloat, wanderAngle:CGFloat)
        -> (vector:CGVector, newWanderAngle:CGFloat)
    {
        //
        // Calculate the circle center
        let circleCenter = snapshot.velocity.normalized.scaled(circleDistance)

        //
        // Calculate the displacement force
        let displacement = CGVector(dx:0, dy:-1).scaled(circleRadius)

        //
        // Randomly change the vector direction
        // by making it change its current angle
        let randomDisplacement = CGVector(magnitude:displacement.magnitude, angleInRadians:wanderAngle) //setAngle(displacement, angle:wanderAngle)

        //
        // Change wanderAngle just a bit, so it
        // won't have the same value in the
        // next game frame.
        let rand = CGFloat(random(min:0, max:1))
        let angleDelta = rand * angleChange - angleChange * 0.5
        let newWanderAngle = wanderAngle + angleDelta

        //
        // Finally calculate and return the wander force
        let wanderForce = mapNaNComponentsToZeros(circleCenter + randomDisplacement)

        return (vector:wanderForce, newWanderAngle:newWanderAngle)
    }

}




