//
//  GoalSummaryView.swift
//  Goals
//
//  Created by Manuel M T Chakravarty on 04/03/2024.
//

import SwiftUI


private let percentageFormatter: NumberFormatter = {
  let formatter = NumberFormatter()
  formatter.multiplier  = NSNumber(value: 100)
  formatter.numberStyle = .percent
  return formatter
  }()


struct GoalSummaryView: View {
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
  GoalSummaryView(goalProgress: mockGoals[0])
}

#Preview {
  GoalSummaryView(goalProgress: mockGoals[1])
}
