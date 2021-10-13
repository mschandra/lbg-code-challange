# last-fm

Pattern followed : MVVM

Data storage used : Coredata

ViewControllers : AlbumsSearchViewController.swift and AlbumInfoViewController.swift

Views : AlbumGridCell.swift, TrackCell.swift and AlbumGridCell.xib

ViewModels : AlbumsSearchViewModel.swift and AlbumInfoViewModel.swift

Parser used : JSONDecoder [ JsonAlbum, JsonArtist, JsonTrack, JsonWiki, AlbumsResponse, AlbumResponse] [Refer: JSONModels.swift]

Service layer : AlbumService.swift

Webservice handler : WebserviceClient.swift

Coredata handler : DataStore.swift

Swift Extension : Extensions.swift

Enums : Enums.swift

Helper classes : Helpers.swift

Constants file : Constants.swift [API key is hardcoded here]

Note:

1. Due to time constraints coredata involved modules are not unit tested.
2. Due to time constraints and avoid usage of 3rd party component hardcoded API key is not obfusicated
3. Unit testing is done to demonstrate that the code is unit testable, hence code coverage is not full.
4. Usage of rxswift in one of the view-controller is just for a demonstration purpose. 
