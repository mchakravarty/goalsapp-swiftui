//
//  GoalDetailView.swift
//  Goals
//
//  Created by Manuel M T Chakravarty on 06/03/2024.
//

import SwiftUI


struct GoalDetailView: View {
  let model: GoalsModel

  @State var goal: Goal

  @State var keepProgress: Bool = false

  var body: some View {

    Form {
      Section(goal.title + " details") {

        TextField("Name", text: $goal.title)
          .onSubmit {
            model.update(goal: goal, transferProgress: true)
          }

        ColorPicker("Colour", selection: $goal.colour, supportsOpacity: false)
          .onChange(of: goal.colour) {
            model.update(goal: goal, transferProgress: true)
          }

        NavigationLink(goal.frequencyPerInterval) {
          GoalFrequencySelectionView(goal: $goal, keepProgress: $keepProgress)
            .onDisappear {
              model.update(goal: goal, transferProgress: keepProgress)
            }
        }

      }
    }
  }
}

struct GoalFrequencySelectionView: View {
  @Binding var goal:         Goal
  @Binding var keepProgress: Bool

  var body: some View {

    Form {

      Section {

        Picker("Interval", selection: $goal.interval) {
          ForEach(GoalInterval.allCases) { interval in
            Text(interval.rawValue)
              .tag(interval)
          }
        }

        Stepper(value: $goal.frequency, in: 1...9, step: 1) {
          HStack {
            Text("\(goal.frequency.description)")
            Text("times")
          }
        }
      }

      Toggle("Keep progress on change", isOn: $keepProgress)
    }
  }
}

#Preview {
  GoalDetailView(model: GoalsModel.mock, goal: mockGoals[0].goal)
}

#Preview {
  GoalFrequencySelectionView(goal: .constant(mockGoals[0].goal), keepProgress: .constant(false))
}
