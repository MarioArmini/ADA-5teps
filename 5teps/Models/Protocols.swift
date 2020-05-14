//
//  Protocols.swift
//  5teps
//
//  Created by Fabio Palladino on 14/05/2020.
//  Copyright © 2020 Mario Armini. All rights reserved.
//

import Foundation
import UIKit

protocol OnCloseChildView {
    func onOpenChallengeView(topic: Topic) -> Void
}

extension OnCloseChildView {
    func onOpenChallengeView(topic: Topic) {}
}
