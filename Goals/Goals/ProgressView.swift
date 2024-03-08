//
//  ProgressTabView.swift
//  Goals
//
//  Created by Manuel M T Chakravarty on 04/03/2024.
//

import SwiftUI


struct ProgressView: View {
  let model: GoalsModel

  var body: some View {
    VStack {

      ScrollView {
        LazyVGrid(columns: [GridItem(.adaptive(minimum: 100))], spacing: 30) {
          ForEach(model.goals.filter{ $0.progress != nil }) { goalProgress in

            GoalProgressView(goalProgress: goalProgress) {
              model.recordProgress(for: goalProgress.goal)
            }
          }
        }
      }

      Spacer()

      Text("Tap any goal to record progress")
        .font(.footnote)
    }
    .padding([.top, .bottom], 20)
  }
}

#Preview {
    ProgressView(model: GoalsModel.mock)
}
