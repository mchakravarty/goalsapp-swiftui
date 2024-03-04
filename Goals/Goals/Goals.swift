//
//  Goals.swift
//  Goals
//
//  Created by Manuel M T Chakravarty on 04/03/2024.
//

import SwiftUI


// MARK: -
// MARK: Model data structures

/// The set of colours that can be used to render goals.
///
let goalColours: [Color] = [.blue, .cyan, .green, .yellow, .orange, .red, .purple]

/// Intervals at which activities are to be repeated.
///
enum GoalInterval: String {
  case daily   = "daily"
  case weekly  = "weekly"
  case monthly = "monthly"

  /// Printed frequency for the current time interval, assumming the argument is greater than zero.
  ///
  func frequency(number: Int) -> String {
    var result: String

    switch number {
    case 1:  result = "once"
    case 2:  result = "twice"
    default: result = "\(number) times"
    }
    switch self {
    case .daily:   result += " per day"
    case .weekly:  result += " per week"
    case .monthly: result += " per month"
    }
    return result
  }
}

/// Specification of a single goal
///
struct Goal: Identifiable, Equatable {
  let id: UUID                    // required by `Identifiable`

  var colour:     Color
  var title:      String
  var interval:   GoalInterval
  var frequency:  Int             // how often the goal ought to be achieved during the interval

  init(colour: Color, title: String, interval: GoalInterval, frequency: Int) {
    self.id        = UUID()
    self.colour    = colour
    self.title     = title
    self.interval  = interval
    self.frequency = frequency
  }

  init() { self = Goal(colour: .green, title: "New Goal", interval: .daily, frequency: 1) }

  var frequencyPerInterval: String {
    return "\(interval.frequency(number: frequency))"
  }

  /// Percentage towards achieving the goal in the current interval given a specific count of how often the activity
  /// has been performed in the current interval.
  ///
  func percentage(count: Int) -> Float { return Float(count) / Float(frequency) }
}

struct GoalProgress {
  
  /// The goal whose progress we track here.
  ///
  let goal: Goal

  /// Progress towards a goal.
  ///
  /// If `nil`, the goal is not active. Otherwise, it specifies the number of times that the corresponding activity has
  /// been undertaken.
  ///
  var progress: Int?
}


// MARK: -
// MARK: App model

@Observable
final class GoalsModel {
  
  /// These are all the goals and the progress towards these goals maintained by the app.
  ///
  /// NB: The order of the elements in the array determines the order in which they are displayed.
  ///
  var goals: [GoalProgress] = []
}


// MARK: -
// MARK: Mock data

let mockGoals: [GoalProgress] = [ GoalProgress(goal:  Goal(colour: .blue, title: "Yoga", interval: .monthly, frequency: 5),
                                               progress: 3)
                                , GoalProgress(goal:  Goal(colour: .orange, title: "Walks", interval: .weekly, frequency: 3),
                                               progress: 0)
                                , GoalProgress(goal:  Goal(colour: .purple, title: "Stretching", interval: .daily, frequency: 3),
                                               progress: 1)
                                ]
