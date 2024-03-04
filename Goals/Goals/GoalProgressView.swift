//
//  GoalSummaryView.swift
//  Goals
//
//  Created by Manuel M T Chakravarty on 04/03/2024.
//

import SwiftUI


/// A number format to render percentages.
///
private let percentageFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.multiplier  = NSNumber(value: 100)
  formatter.numberStyle = .percent
  return formatter
  }()

/// A view that renders the progress towards a single goal.
///
struct GoalProgressView: View {
  let goalProgress: GoalProgress

  var body: some View {

    let percentage       = goalProgress.goal.percentage(count: goalProgress.progress ?? 0),
        percentageString = percentageFormatter.string(from: NSNumber(value: percentage))

    VStack {
      Text("\(percentageString ?? "0")")
        .font(.title)
      Text(goalProgress.goal.title)
    }
  }
}

#Preview {
  GoalProgressView(goalProgress: mockGoals[0])
}

#Preview {
  GoalProgressView(goalProgress: mockGoals[1])
}
