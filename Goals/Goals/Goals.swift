//
//  Goals.swift
//  Goals
//
//  Created by Manuel M T Chakravarty on 04/03/2024.
//

import SwiftUI


// MARK: -
// MARK: Model data structures

/// Intervals at which activities are to be repeated.
///
enum GoalInterval: String, CaseIterable {
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

extension GoalInterval: Identifiable {
  var id: String { self.rawValue }
}

/// Specification of a single goal
///
struct Goal: Identifiable, Equatable, Hashable {
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
  
  /// Create a default new goal.
  ///
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

  init(goal: Goal, progress: Int? = nil) {
    self.goal      = goal
    self.progress = progress
  }

  /// Create a default new goal without progress.
  ///
  init() { self = GoalProgress(goal: Goal(), progress: nil) }
}

extension GoalProgress: Identifiable {

  /// Inherits identify from the enclosed goal.
  ///
  var id: UUID { goal.id }
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

  init(goals: [GoalProgress] = []) {
    self.goals = goals
  }
  
  /// Remove the given goal.
  ///
  /// - Parameter goal: The goal that is to be removed.
  ///
  func remove(goal: Goal) {
    goals.removeAll{ $0.goal.id == goal.id }
  }
  
  /// Update a goal's detail information.
  ///
  /// - Parameters:
  ///   - goal: The new goal details.
  ///   - transferProgress: Whether to transfer the current progress to the new goal.
  ///
  /// If the goal details remain unchanged, we always transfer current progress.
  ///
  func update(goal: Goal, transferProgress: Bool) {

    if let idx = (goals.firstIndex{ $0.goal.id == goal.id }),
       goals[idx].goal != goal
    {
      let newProgress: Int? = if transferProgress { goals[idx].progress } else { nil }
      goals[idx] = GoalProgress(goal: goal, progress: newProgress)
    }
  }
  
  /// Determine the progress of the given goal.
  ///
  /// - Parameter goal: The goal whose progress we want to determine.
  /// - Returns: The progress of the goal or `nil` if the goal is inactive or does not exist.
  /// 
  func progress(of goal: Goal) -> Int? { goals.first{ $0.goal.id == goal.id }?.progress }

  /// Advance the progress for the given goal.
  ///
  /// - Parameter goal: The goal whose progress we want to advance.
  ///
  func recordProgress(for goal: Goal) {

    if let idx             = (goals.firstIndex{ $0.goal.id == goal.id }),
       let currectProgress = goals[idx].progress
    {
      goals[idx].progress = currectProgress + 1
    }
  }
  
  /// Set a goal's activity status.
  ///
  /// - Parameters:
  ///   - goal: The goal whose activity status is to be set.
  ///   - activity: The goal is set to active (with no progress) if `activity == true`; otherwise, it is set to being
  ///       inactive.
  ///       
  func set(goal: Goal, activity: Bool) {

    if let idx = (goals.firstIndex{ $0.goal.id == goal.id }) {
      let progress: Int? = if activity { 0 } else { nil }
      goals[idx].progress = progress
    }
  }
}


// MARK: -
// MARK: Mock data

let mockGoals: [GoalProgress] = [ GoalProgress(goal:  Goal(colour: .blue, title: "Yoga", interval: .monthly, frequency: 5),
                                               progress: 3)
                                , GoalProgress(goal:  Goal(colour: .orange, title: "Walks", interval: .weekly, frequency: 3),
                                               progress: 0)
                                , GoalProgress(goal:  Goal(colour: .purple, title: "Stretching", interval: .daily, frequency: 3),
                                               progress: 1)
                                , GoalProgress(goal:  Goal(colour: .cyan, title: "Meditation", interval: .weekly, frequency: 2),
                                               progress: 1)
                                ]

extension GoalsModel {

  static var mock = GoalsModel(goals: mockGoals)
}
