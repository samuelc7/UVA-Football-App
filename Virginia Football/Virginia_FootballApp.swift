//
//  Virginia_FootballApp.swift
//  Virginia Football
//
//  Created by Samuel Cummings on 10/19/21.
//

import SwiftUI

@main
struct Virginia_FootballApp: App {
    var liveUpdateNetwork = Network(url: "https://api.sportsdata.io/v3/cfb/scores/json/Players/VIR")
    var stats = Network(url: "https://api.sportsdata.io/v3/cfb/stats/json/PlayerSeasonStatsByTeam/2021/vir?season=2021&team=vir")
    
    var body: some Scene {
        WindowGroup {
            MenuView()
                .environmentObject(liveUpdateNetwork)
                .environmentObject(stats)
        }
    }
}

struct Virginia_FootballApp_Previews: PreviewProvider {
    var menuScreen: Bool = false
    static var previews: some View {
        MenuView()
    }
}
