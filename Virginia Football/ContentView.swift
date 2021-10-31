//
//  ContentView.swift
//  Virginia Football
//
//  Created by Samuel Cummings on 10/19/21.
//

import SwiftUI

struct StatsView: View {
    let stats = Network(url: "https://api.sportsdata.io/v3/cfb/stats/json/PlayerSeasonStatsByTeam/2021/vir?season=2021&team=vir")
    @State var playerDictionary = [Substring:Dictionary<Substring, Substring>]()

    var body: some View {
        VStack {
        }.onAppear {
            let url = URL(string: "https://api.sportsdata.io/v3/cfb/stats/json/PlayerSeasonStatsByTeam/2021/vir?season=2021&team=vir")!
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.setValue("e76b29b3cc1e46a7b28c3346389bead4", forHTTPHeaderField: "Ocp-Apim-Subscription-Key")
            let task = URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    print("There was an error: \(error)")
                    return
                }
                if let response = response as? HTTPURLResponse {
                    print("Response Status Code: \(response.statusCode)")
                }
                if let data = data, let dataString = String(data: data, encoding: .utf8) {
                    var d = dataString
                    d.remove(at: dataString.startIndex)
                    d.removeLast()
                    let dList = d.split(separator: "}")
                    for i in dList {
                        var item = i.replacingOccurrences(of: ",{", with: "")
                        
                        if (item.contains("{")) {
                            item = i.replacingOccurrences(of: "{", with: "")
                        }
                        var statsForIndividualPlayer = [Substring:Substring]()
                        for r in item.split(separator: ",") {
                            var stat = r.split(separator: ":")
                            
                            stat[0].removeFirst()
                            stat[0].removeLast()
                            
                            let key = stat[0]
                            let value = stat[1]
                            
                            statsForIndividualPlayer.updateValue(value, forKey: key)
                        }
                        playerDictionary[statsForIndividualPlayer["Name"]!] = statsForIndividualPlayer
                    }
                    var headerString : String = "|"
                    var headers : Array<Any> = Array()
                    
                    for s in playerDictionary["\"Nick Grant\""]!.keys {
                        headerString += s + "|"
                    }
                    
                    let offensiveHeaders : Array<Substring> = ["Name", "ReceivingTouchdowns", "Receptions", "ReceivingYards", "PassingYardsPerCompletion", "PassingYardsPerAttempt", "RushingTouchdowns","RushingYards", "ReceivingLong", "RushingLong", "RushingYardsPerAttempt", "RushingAttempts", "PassingTouchdowns", "ReceivingYardsPerReception"]
                    
                    var offensiveHeaderString : String = "|"
                    for oh in offensiveHeaders {
                        offensiveHeaderString += oh + "|"
                    }
                    var totalStatsPart: String = ""
                    for k in playerDictionary.keys {
                        var playerStatsLine: Substring = ""

                        if (playerDictionary[k]!["Position"] == "\"WR\"" ||
                                playerDictionary[k]!["Position"] == "\"TE\"" ||
                                playerDictionary[k]!["Position"] == "\"RB\"" ||
                                playerDictionary[k]!["Position"] == "\"DB\"") {
                            
                            for var i in offensiveHeaders {
                                playerStatsLine += (playerDictionary[k]?[i])! + "|" + String.init(repeating: " ", count: 8)
                            }
                            totalStatsPart += playerStatsLine + "\n"
                        }
                    }
//                    for p in playerDictionary.keys {
//                        //print("stats for player \(p): ", playerDictionary[p]?.keys)
//                    }
                    //print(playerDictionary.keys)
                    print(offensiveHeaderString)
                    print(totalStatsPart)
                    
                    DispatchQueue.main.async {
                        self.playerDictionary = playerDictionary
                    }
                }
            }
            task.resume()
        }
    }
}



struct MenuView: View {
    let network = Network(url: "https://api.sportsdata.io/v3/cfb/scores/json/Players/VIR")
    
    var body: some View {
        NavigationView {
            let screenSize: CGRect = UIScreen.main.bounds
            let blue: Color = Color.init(UIColor(red: 131/255, green: 163/255, blue: 190/255, alpha: 1));
            let orange: Color = Color.init(UIColor(red: 255/255, green: 209/255, blue: 173/255, alpha: 1))
            let columns: [GridItem] = [GridItem(.fixed(100), spacing: 16)]
        
            VStack(alignment: .center) {
                    LinearGradient(gradient: Gradient(colors: [blue, orange]),
                               startPoint: .topLeading,
                               endPoint:.bottomTrailing)
                    .ignoresSafeArea()
                    .overlay(
                        VStack(alignment: .center, spacing: 50) {
                            HStack(alignment: .center) {
                                Color.init(UIColor(red: 0, green: 25/255, blue: 60/255, alpha: 1))
                                .overlay(
                                Text("Virginia Football")
                                    .multilineTextAlignment(.center)
                                    .font(.title)
                                    .foregroundColor(.white)
                                    .offset(y: 15)
                                )
                                .edgesIgnoringSafeArea(.all)
                                .frame(width: 500.0, height: 10.0)
                            }

                            Text("Live Score / Last Game")
                                .background(.orange)

                            Text("News")
                                .background(.orange)
                            
                        
                            NavigationLink(destination: StatsView()) {
                               Text("Stats")
                                    .foregroundColor(.black)
                                    .background(.orange)
                            }
                        
                            Text("Message Board")
                                .background(.orange)
                            
                            Spacer()
                    }
                )
            }
        }
    }
}



struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        MenuView()
            .preferredColorScheme(.light)
            .environmentObject(Network(url: "https://api.sportsdata.io/v3/cfb/scores/json/Players/VIR"))
    }
}

