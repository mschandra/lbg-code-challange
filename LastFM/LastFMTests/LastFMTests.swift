//
//  LastFMTests.swift
//  LastFMTests
//
//  Created by CHANDRA SEKARAN M on 10/10/2021.
//  Copyright © 2021 CHANDRA SEKARAN M. All rights reserved.
//

import XCTest
@testable import LastFM

class LastFMTests: XCTestCase {
    static  let inputData = "{\"album\":{\"name\":\"Believe\",\"artist\":\"Cher\",\"mbid\":\"63b3a8ca-26f2-4e2b-b867-647a6ec2bebd\",\"url\":\"https://www.last.fm/music/Cher/Believe\",\"image\":[{\"#text\":\"https://lastfm.freetls.fastly.net/i/u/34s/b0c2311a9af7f0edbc8b99450944ca1b.png\",\"size\":\"small\"},{\"#text\":\"https://lastfm.freetls.fastly.net/i/u/64s/b0c2311a9af7f0edbc8b99450944ca1b.png\",\"size\":\"medium\"},{\"#text\":\"https://lastfm.freetls.fastly.net/i/u/174s/b0c2311a9af7f0edbc8b99450944ca1b.png\",\"size\":\"large\"},{\"#text\":\"https://lastfm.freetls.fastly.net/i/u/300x300/b0c2311a9af7f0edbc8b99450944ca1b.png\",\"size\":\"extralarge\"},{\"#text\":\"https://lastfm.freetls.fastly.net/i/u/300x300/b0c2311a9af7f0edbc8b99450944ca1b.png\",\"size\":\"mega\"},{\"#text\":\"https://lastfm.freetls.fastly.net/i/u/300x300/b0c2311a9af7f0edbc8b99450944ca1b.png\",\"size\":\"\"}],\"listeners\":\"407115\",\"playcount\":\"2660105\",\"tracks\":{\"track\":[{\"name\":\"Believe\",\"url\":\"https://www.last.fm/music/Cher/_/Believe\",\"duration\":\"241\",\"@attr\":{\"rank\":\"1\"},\"streamable\":{\"#text\":\"0\",\"fulltrack\":\"0\"},\"artist\":{\"name\":\"Cher\",\"mbid\":\"bfcc6d75-a6a5-4bc6-8282-47aec8531818\",\"url\":\"https://www.last.fm/music/Cher\"}},{\"name\":\"The Power\",\"url\":\"https://www.last.fm/music/Cher/_/The+Power\",\"duration\":\"236\",\"@attr\":{\"rank\":\"2\"},\"streamable\":{\"#text\":\"0\",\"fulltrack\":\"0\"},\"artist\":{\"name\":\"Cher\",\"mbid\":\"bfcc6d75-a6a5-4bc6-8282-47aec8531818\",\"url\":\"https://www.last.fm/music/Cher\"}},{\"name\":\"Runaway\",\"url\":\"https://www.last.fm/music/Cher/_/Runaway\",\"duration\":\"286\",\"@attr\":{\"rank\":\"3\"},\"streamable\":{\"#text\":\"0\",\"fulltrack\":\"0\"},\"artist\":{\"name\":\"Cher\",\"mbid\":\"bfcc6d75-a6a5-4bc6-8282-47aec8531818\",\"url\":\"https://www.last.fm/music/Cher\"}},{\"name\":\"All or Nothing\",\"url\":\"https://www.last.fm/music/Cher/_/All+or+Nothing\",\"duration\":\"237\",\"@attr\":{\"rank\":\"4\"},\"streamable\":{\"#text\":\"0\",\"fulltrack\":\"0\"},\"artist\":{\"name\":\"Cher\",\"mbid\":\"bfcc6d75-a6a5-4bc6-8282-47aec8531818\",\"url\":\"https://www.last.fm/music/Cher\"}},{\"name\":\"Strong Enough\",\"url\":\"https://www.last.fm/music/Cher/_/Strong+Enough\",\"duration\":\"223\",\"@attr\":{\"rank\":\"5\"},\"streamable\":{\"#text\":\"0\",\"fulltrack\":\"0\"},\"artist\":{\"name\":\"Cher\",\"mbid\":\"bfcc6d75-a6a5-4bc6-8282-47aec8531818\",\"url\":\"https://www.last.fm/music/Cher\"}},{\"name\":\"Dov'e L'amore\",\"url\":\"https://www.last.fm/music/Cher/_/Dov%27e+L%27amore\",\"duration\":\"258\",\"@attr\":{\"rank\":\"6\"},\"streamable\":{\"#text\":\"0\",\"fulltrack\":\"0\"},\"artist\":{\"name\":\"Cher\",\"mbid\":\"bfcc6d75-a6a5-4bc6-8282-47aec8531818\",\"url\":\"https://www.last.fm/music/Cher\"}},{\"name\":\"Takin' Back My Heart\",\"url\":\"https://www.last.fm/music/Cher/_/Takin%27+Back+My+Heart\",\"duration\":\"272\",\"@attr\":{\"rank\":\"7\"},\"streamable\":{\"#text\":\"0\",\"fulltrack\":\"0\"},\"artist\":{\"name\":\"Cher\",\"mbid\":\"bfcc6d75-a6a5-4bc6-8282-47aec8531818\",\"url\":\"https://www.last.fm/music/Cher\"}},{\"name\":\"Taxi Taxi\",\"url\":\"https://www.last.fm/music/Cher/_/Taxi+Taxi\",\"duration\":\"304\",\"@attr\":{\"rank\":\"8\"},\"streamable\":{\"#text\":\"0\",\"fulltrack\":\"0\"},\"artist\":{\"name\":\"Cher\",\"mbid\":\"bfcc6d75-a6a5-4bc6-8282-47aec8531818\",\"url\":\"https://www.last.fm/music/Cher\"}},{\"name\":\"Love Is the Groove\",\"url\":\"https://www.last.fm/music/Cher/_/Love+Is+the+Groove\",\"duration\":\"271\",\"@attr\":{\"rank\":\"9\"},\"streamable\":{\"#text\":\"0\",\"fulltrack\":\"0\"},\"artist\":{\"name\":\"Cher\",\"mbid\":\"bfcc6d75-a6a5-4bc6-8282-47aec8531818\",\"url\":\"https://www.last.fm/music/Cher\"}},{\"name\":\"We All Sleep Alone\",\"url\":\"https://www.last.fm/music/Cher/_/We+All+Sleep+Alone\",\"duration\":\"233\",\"@attr\":{\"rank\":\"10\"},\"streamable\":{\"#text\":\"0\",\"fulltrack\":\"0\"},\"artist\":{\"name\":\"Cher\",\"mbid\":\"bfcc6d75-a6a5-4bc6-8282-47aec8531818\",\"url\":\"https://www.last.fm/music/Cher\"}}]},\"tags\":{\"tag\":[{\"name\":\"pop\",\"url\":\"https://www.last.fm/tag/pop\"},{\"name\":\"90s\",\"url\":\"https://www.last.fm/tag/90s\"},{\"name\":\"dance\",\"url\":\"https://www.last.fm/tag/dance\"},{\"name\":\"cher\",\"url\":\"https://www.last.fm/tag/cher\"},{\"name\":\"albums I own\",\"url\":\"https://www.last.fm/tag/albums+I+own\"}]},\"wiki\":{\"published\":\"27 Jul 2008, 15:55\",\"summary\":\"Believe is the twenty-third studio album by American singer-actress Cher, released on November 10, 1998 by Warner Bros. Records. The RIAA certified it Quadruple Platinum on December 23, 1999, recognizing four million shipments in the United States; Worldwide, the album has sold more than 20 million copies, making it the biggest-selling album of her career. In 1999 the album received three Grammy Awards nominations including  Read more on Last.fm. User-contributed text is available under the Creative Commons By-SA License; additional terms may apply.\"}}}".data(using: .utf8)
    override func setUp() {
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }

    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
    }

    func testDateParsingAndFormat(){
    
        if let hasData = Self.inputData , let model = try? JSONDecoder().decode(AlbumResponse.self, from: hasData), let album = model.album, let mbid = album.mbid?.uuidString  {
            XCTAssert(mbid == "63b3a8ca-26f2-4e2b-b867-647a6ec2bebd".uppercased(), "Parsing error")
        }else {
           XCTFail()
        }
    }
        
    func testViewModelFlow() {
        let vm = AlbumInfoViewModel(name: "Believe", artist: "Cher")
        var hasError = false
        vm.setWebClient(client: MockWebserviceClient())
        let expectation = self.expectation(description: "MVVM.call")
        vm.getAlbumInfo(completionHandler:  { (success, error) in
            hasError = (error != nil)
            expectation.fulfill()
        })
        waitForExpectations(timeout: 5, handler: nil)
        if !hasError {
            XCTAssert(vm.albumInfo != nil, "Server communication went wrong, please check connection and api-key")
        }else{
               XCTFail()
        }
    }
   
}
class MockWebserviceClient : NetworkClient {
    func callServer(requestContext: RequestContext?, completion: @escaping SuccessDataBlock) {
        completion(.success(LastFMTests.inputData!))
    }
    
    func cancelServerCall() { }
    
}


