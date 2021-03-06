//
//  ControlCenter.swift
//  Pirate Fleet
//
//  Created by Jarrod Parkes on 9/2/15.
//  Copyright © 2015 Udacity. All rights reserved.
//

struct GridLocation {
    let x: Int
    let y: Int
}

struct Ship {
    let length: Int
    let location: GridLocation
    let isVertical: Bool
    let isWooden: Bool
    

// TODO: Add the computed property, cells.
    var cells: [GridLocation] {
        get {
            // Hint: These two constants will come in handy
            let start = self.location
            let end: GridLocation = ShipEndLocation(self)
            // Hint: The cells getter should return an array of GridLocations.
            var occupiedCells = [GridLocation]()
            var incrValue: GridLocation
            
            //check vertical orientation, step x or y depending on vertical orientation
            if self.isVertical == true {
                for y in start.y...end.y {
                    incrValue = GridLocation(x: start.x,y: y)
                    occupiedCells.append(incrValue)
                }
            } else {
                for x in start.x...end.x {
                    incrValue = GridLocation(x: x,y: start.y)
                    occupiedCells.append(incrValue)
                }
            }
            return occupiedCells
        }
    }
    
    var hitTracker: HitTracker
// TODO: Add a getter for sunk. Calculate the value returned using hitTracker.cellsHit.
    var sunk: Bool {
        get {
            var sunkStatus: Bool = false
            var hitCells = [GridLocation]()
            for (key, value) in hitTracker.cellsHit {
                if value == true {
                    hitCells.append(key)
                }
            }
            if hitCells.count == self.length{
                sunkStatus = true
            }
            return sunkStatus
        }
    }

// TODO: Add custom initializers
    init(length: Int, location: GridLocation, isVertical: Bool) {
        self.length = length
        self.location = location
        self.hitTracker = HitTracker()
        self.isVertical = true
        self.isWooden = true
    }
    
    init(length: Int, isVertical: Bool, isWooden: Bool, location: GridLocation) {
        self.length = length
        self.location = location
        self.hitTracker = HitTracker()
        self.isVertical = isVertical
        self.isWooden = isWooden
    }
}

// TODO: Change Cell protocol to PenaltyCell and add the desired properties
protocol PenaltyCell {
    var location: GridLocation {get}
    var guaranteesHit: Bool {get}
    var penaltyText: String {get}
}

// TODO: Adopt and implement the PenaltyCell protocol
struct Mine: PenaltyCell {
    let location: GridLocation
    let guaranteesHit: Bool
    let penaltyText: String
    
    init(location: GridLocation, penaltyText: String) {
        self.location = location
        self.penaltyText = penaltyText
        self.guaranteesHit = false
    }
    
    init(location: GridLocation, penaltyText: String, guaranteesHit: Bool) {
        self.location = location
        self.penaltyText = penaltyText
        self.guaranteesHit = guaranteesHit
    }
}

// TODO: Adopt and implement the PenaltyCell protocol
struct SeaMonster: PenaltyCell {
    let location: GridLocation
    let guaranteesHit = true
    let penaltyText = "RAWR a Sea Monster!"
}

class ControlCenter {
    
    func placeItemsOnGrid(_ human: Human) {
        
//        let smallShip = Ship(length: 2, location: GridLocation(x: 3, y: 4), isVertical: true, isWooden: false, hitTracker: HitTracker())
       
        let smallShip = Ship.init(length: 2, isVertical: true, isWooden: false, location: GridLocation(x: 3, y:4))
        human.addShipToGrid(smallShip)
        print("smallShip!")
//        
////        let mediumShip1 = Ship(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false, isWooden: false, hitTracker: HitTracker())
        let mediumShip1 = Ship.init(length: 3, location: GridLocation(x: 0, y: 0), isVertical: false)
        human.addShipToGrid(mediumShip1)
//        
////        let mediumShip2 = Ship(length: 3, location: GridLocation(x: 3, y: 1), isVertical: false, isWooden: false, hitTracker: HitTracker())
        let mediumShip2 = Ship.init(length: 3, isVertical: false, isWooden: true, location: GridLocation(x: 3, y: 1))
        human.addShipToGrid(mediumShip2)
//        
////        let largeShip = Ship(length: 4, location: GridLocation(x: 6, y: 3), isVertical: true, isWooden: false, hitTracker: HitTracker())
        let largeShip = Ship.init(length: 4, isVertical: true, isWooden: true, location: GridLocation(x: 6, y: 3))
        human.addShipToGrid(largeShip)
//        
////        let xLargeShip = Ship(length: 5, location: GridLocation(x: 7, y: 2), isVertical: true, isWooden: false, hitTracker: HitTracker())
        let xLargeShip = Ship.init(length: 5, isVertical: true, isWooden: true, location: GridLocation(x: 7, y: 2))
        human.addShipToGrid(xLargeShip)
        
        let mine1 = Mine.init(location: GridLocation(x: 6, y: 0), penaltyText: "Boom a mine!")
        human.addMineToGrid(mine1)
        
        let mine2 = Mine.init(location: GridLocation(x: 3, y: 3), penaltyText: "Boom a mine!", guaranteesHit: true)
        human.addMineToGrid(mine2)
        
        let seamonster1 = SeaMonster(location: GridLocation(x: 5, y: 6))
        human.addSeamonsterToGrid(seamonster1)
        
        let seamonster2 = SeaMonster(location: GridLocation(x: 2, y: 2))
        human.addSeamonsterToGrid(seamonster2)
    }
    
    func calculateFinalScore(_ gameStats: GameStats) -> Int {
        
        var finalScore: Int
        
        let sinkBonus = (5 - gameStats.enemyShipsRemaining) * gameStats.sinkBonus
        let shipBonus = (5 - gameStats.humanShipsSunk) * gameStats.shipBonus
        let guessPenalty = (gameStats.numberOfHitsOnEnemy + gameStats.numberOfMissesByHuman) * gameStats.guessPenalty
        
        finalScore = sinkBonus + shipBonus - guessPenalty
        
        return finalScore
    }
}
