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

/// Percentage rendered as text.
///
struct PercentageTextView: View {
  let percentage: Float
  let colour:     Color

  var body: some View {

    let percentageString = percentageFormatter.string(from: NSNumber(value: percentage))

    Text("\(percentageString ?? "0")")
      .font(.largeTitle)
      .foregroundStyle(colour)
  }
}

/// Percentage with circular chart.
///
struct PercentageView: View {
  let percentage: Float
  let colour:     Color

  @State var chartPercentage: Float = 0

  var body: some View {

    let percentageString = percentageFormatter.string(from: NSNumber(value: percentage))

    ZStack {

      Circle()
        .foregroundColor(colour.opacity(0.2))
        .frame(width: 80, height: 80)

      Circle()
        .trim(from: 0, to: CGFloat(chartPercentage))
        .stroke(.angularGradient(colour.gradient,
                                 startAngle: .degrees(0),
                                 endAngle: .degrees(360 * Double(chartPercentage))),
                style: StrokeStyle(lineWidth: 10, lineCap: .round))
        .rotationEffect(.degrees(-90))
        .frame(width: 80, height: 80)
        .animation(.easeInOut, value: chartPercentage)

      Text("\(percentageString ?? "0")")
        .font(.headline)
        .foregroundStyle(colour)

    }
    .padding(10)
    .onAppear{ chartPercentage = percentage }
    .onChange(of: percentage){ chartPercentage = percentage }
  }
}

/// A view that renders the progress towards a single goal.
///
struct GoalProgressView: View {
  let goalProgress:   GoalProgress
  let recordProgress: () -> Void

  var body: some View {

    let count = goalProgress.progress ?? 0
    VStack {

      Button(action: recordProgress) {
        PercentageView(percentage: goalProgress.goal.percentage(count: count),
                       colour: goalProgress.goal.colour)
      }

      Text(goalProgress.goal.title)
        .font(.headline)
    }
  }
}

#Preview {
  GoalProgressView(goalProgress: mockGoals[0], recordProgress: { })
}

#Preview {
  GoalProgressView(goalProgress: mockGoals[1], recordProgress: { })
}
