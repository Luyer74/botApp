//
//  tweet.swift
//  botDesaparecidx
//
//  Created by Luis Arambula on 5/17/21.
//

import UIKit

class tweet: NSObject {
    var tweet_text : String
    var fecha_creado : String
    
    init(tweet_text : String, fecha_creado : String) {
        self.tweet_text = tweet_text
        self.fecha_creado = fecha_creado
    }
}
