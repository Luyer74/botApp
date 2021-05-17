//
//  tweet.swift
//  
//
//  Created by Luis Arambula on 5/16/21.
//

import UIKit

class tweet: NSObject {
    var tweet_text : String
    var fecha_creado : String
    //var lugar : String
    //var nombre : String
    //var img_url : String
    
    init(tweet_text : String, fecha_creado : String) {
        self.tweet_text = tweet_text
        self.fecha_creado = fecha_creado
        //self.lugar = lugar
        //self.nombre = nombre
        //self.img_url = img_url
    }
}
