//: [Previous](@previous)

import Foundation

class Album {
    var name: String
    
    var salesPerformance: String {
        return "The album  \"\(name)\" sold lots"
    }
    
    init(name: String) {
        self.name = name
    }
}


class StudioAlbum: Album {
    var studio: String
    
    override var salesPerformance: String {
        return "The studio album \"\(name)\" sold lots"
    }
    
    init(name: String, studio: String) {
        self.studio = studio
        super.init(name: name)
    }
}


class LiveAlbum: Album {
    var location: String
    
    override var salesPerformance: String {
        return "The live album \"\(name)\" sold lots"
    }
    
    init(name: String, location: String) {
        self.location = location
        super.init(name: name)
    }
}

let taylorSwift = StudioAlbum(name: "Taylor Swift", studio: "The Castles Studio")
let fearless = StudioAlbum(name: "Fearless", studio: "Aimeeland Studio")
let iTunesLive = LiveAlbum(name: "iTunes Live from SoHo", location: "NYC")


func optionalDowncasting() {
    let allAlbums: [Album] = [taylorSwift, fearless, iTunesLive]
    
    print(allAlbums)
    
    for album in allAlbums {
        print(album.salesPerformance)
        
        if let studioAlbum = album as? StudioAlbum {
            print(studioAlbum.studio)
        } else if let liveAlbum = album as? LiveAlbum {
            print(liveAlbum.location)
        }
    }
    
    for album in allAlbums as? [LiveAlbum] ?? [LiveAlbum]() {
        print(album.location)
    }
}

func forcedDowncasting() {
    let allAlbums: [Album] = [taylorSwift, fearless]
    
    for album in allAlbums {
        let studioAlbum = album as! StudioAlbum
        print(studioAlbum.studio)
    }
    
    for album in allAlbums as! [StudioAlbum] {
        print(album.studio)
    }
}


optionalDowncasting()
forcedDowncasting()
//: [Next](@next)
