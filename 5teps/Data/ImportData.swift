//
//  ImportData.swift
//  5teps
//
//  Created by Fabio Palladino on 09/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import Foundation

public class ImportData {
    public init() {
        
    }
    static func importJson() -> [JsonTopic] {
        var json = [JsonTopic]()
        
        let nameJson =  NSLocalizedString("JSON_FILE_CHALLENGE", comment: "")
        if let pathFile = Bundle.main.path(forResource: nameJson, ofType: "json") {
            do {
                let jsonData = try Data(contentsOf: URL(fileURLWithPath: pathFile), options: .mappedIfSafe)
               
                let decoder = JSONDecoder()
                json = try decoder.decode([JsonTopic].self, from: jsonData)
                
            } catch {
                print("Error importJson: \(error.localizedDescription)")
            }
        } else {
            print("file non found")
        }
        return json
    }
    static func saveTopic(topics: [JsonTopic]) {
        for t in topics {
            var topic = Topic.findByName(name: t.name)
            if topic == nil {
                
                topic = Topic(context: SharedInfo.context)
                topic?.id = UUID()
                topic?.user = User.userData
                topic?.name = t.name
                topic?.active = true
                topic?.timestamp = Date()
                topic?.icon = t.icon
                topic?.color = t.color
                topic?.save()
                print("New Topic created \(String(describing: topic?.name))")
            }
            for c in t.challenge {
                if topic?.findChallengeByName(name: c.name) == nil {
                    let challenge = Challenge(context: SharedInfo.context)
                    challenge.id = UUID()
                    challenge.timestamp = Date()
                    challenge.name = c.name
                    challenge.currentStep = 0
                    challenge.dateLast = Date()
                    challenge.numberSteps = Int64(c.steps.count)
                    challenge.state = ChallengeState.Create.rawValue
                    challenge.topic = topic
                    
                    var nstep = 0
                    for s in c.steps {
                        nstep = nstep + 1
                        let step = StepChallenge(context: SharedInfo.context)
                        step.id = UUID()
                        step.timestamp = Date()
                        step.days = Int16(s.days)
                        step.name = s.name
                        step.step = Int64(nstep)
                        step.state =  StepChallengeState.Create.rawValue
                        
                        challenge.addToSteps(step)
                    }
                    challenge.save()
                    print("New Challenge created \(String(describing: challenge.name))")
                    challenge.debugPrint()
                }
            }
        }
    }
}

struct JsonTopic: Codable {
    var name: String
    var icon: String
    var color: String
    var challenge: [JsonChallenge]
    
}
struct JsonChallenge: Codable {
    var name: String
    var steps: [JsonStep]
}

struct JsonStep: Codable {
    var name: String
    var days: Int
}
public class StepBase {
    public var name: String
    public var days: Int
    public var step: Int
    public var state: StepChallengeState
    public init() {
        self.name = ""
        self.days = 0
        self.step = 0
        self.state = StepChallengeState.Create
    }
    public init(step: StepChallenge) {
        self.name = step.name ?? ""
        self.days = Int(step.days)
        self.step = Int(step.step)
        self.state = StepChallengeState(rawValue: Int64(step.state))!
    }
}
