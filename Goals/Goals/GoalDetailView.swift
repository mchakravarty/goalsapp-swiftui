//
//  GoalDetailView.swift
//  Goals
//
//  Created by Manuel M T Chakravarty on 06/03/2024.
//

import SwiftUI


struct GoalDetailView: View {
  let model: GoalsModel

  @State var goal:     Goal
  @State var isActive: Bool

  @State var keepProgress:     Bool = false
  @State var deletingProgress: Bool = false

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
              isActive = model.progress(of: goal) != nil
            }
        }

        Toggle("Active", isOn: $isActive)
          .onChange(of: isActive) {
            if let currentProgress = model.progress(of: goal),
               currentProgress > 0,
               !isActive
            {
              deletingProgress = true
            } else {
              model.set(goal: goal, activity: isActive)
            }
          }
      }
    }
    .alert("Discard progress?", isPresented: $deletingProgress) {

      Button("Discard \(goal.title) progress", role: .destructive) {
        model.set(goal: goal, activity: false)
      }
      Button("Cancel", role: .cancel) {
        isActive = true
      }

    } message: {
      Text("Deactivating a goal discards its current progress.")
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
  GoalDetailView(model: GoalsModel.mock, goal: mockGoals[0].goal, isActive: true)
}

#Preview {
  GoalFrequencySelectionView(goal: .constant(mockGoals[0].goal), keepProgress: .constant(false))
}
