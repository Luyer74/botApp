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
    var imagen_link : String?
    
    init(tweet_text : String, fecha_creado : String, imagen_link : String?) {
        self.tweet_text = tweet_text
        self.fecha_creado = fecha_creado
        self.imagen_link = imagen_link
    }
}
