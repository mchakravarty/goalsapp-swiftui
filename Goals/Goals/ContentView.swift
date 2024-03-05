//
//  ContentView.swift
//  Goals
//
//  Created by Manuel M T Chakravarty on 04/03/2024.
//

import SwiftUI


struct ContentView: View {
  let model: GoalsModel

  var body: some View {
    TabView {

      ProgressView(model: model)
      .tabItem({ TabLabel(imageName: "timer.circle.fill", label: "Progress") })

      VStack {
        Text("Goals Tab")
      }
      .tabItem({ TabLabel(imageName: "list.bullet.circle.fill", label: "Goals") })

    }
  }
}

struct TabLabel: View {
  let imageName: String
  let label:     String

  var body: some View {
    HStack {
      Image(systemName: imageName)
      Text(label)
    }
  }
}


// MARK: -
// MARK: Previews

#Preview {
  ContentView(model: GoalsModel.mock)
}
