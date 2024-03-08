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
            Text(goalProgress.goal.title)
          }
        }

        Button("Add new goal") {
          model.goals.append(GoalProgress())
        }
      }
      .navigationTitle("Goals")
      .navigationDestination(for: Goal.self) { goal in

        GoalDetailView(model: model, goal: goal)
      }

    }
  }
}


#Preview {
  GoalsListView(model: GoalsModel.mock)
}
