//
//  GoalsListView.swift
//  Goals
//
//  Created by Manuel M T Chakravarty on 05/03/2024.
//

import SwiftUI


struct GoalsListView: View {
  var model: GoalsModel

  var body: some View {

    NavigationStack {

      List {

        ForEach(model.goals) { goalProgress in

          NavigationLink(value: goalProgress.goal) {
            HStack {
              Text(goalProgress.goal.title)
              Spacer()
              let actvityStatus = if goalProgress.progress == nil { "inactive" } else { "active" }
              Text(actvityStatus)
                .foregroundStyle(.secondary)
            }
          }
        }
        .onDelete { indexSet in
          model.goals.remove(atOffsets: indexSet)
        }
        .onMove { indices, newOffset in
          model.goals.move(fromOffsets: indices, toOffset: newOffset)
        }

        Button("Add new goal") {
          model.goals.append(GoalProgress())
        }
      }
      .navigationTitle("Goals")
      .toolbar{ EditButton() }
      .navigationDestination(for: Goal.self) { goal in

        GoalDetailView(model: model, goal: goal, isActive: model.progress(of: goal) != nil)
      }

    }
  }
}


#Preview {
  GoalsListView(model: GoalsModel.mock)
}
