//
//  APICaller.swift
//  Spotify
//
//  Created by Caner Karabulut on 26.04.2024.
//

import Foundation

final class APICaller {
    static let shared = APICaller()
    
    private init() {}
    
    struct Constants {
        static let baseURL = "https://api.spotify.com/v1"
    }
    
    enum APIError: Error {
        case failedToGetData
    }
    //MARK: - Profile
    ///Get Current User
    public func getCurrentUserProfile(completion: @escaping(Result<UserProfile, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseURL + "/me"), type: .GET) { baseRequest in
            let task = URLSession.shared.dataTask(with: baseRequest) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(UserProfile.self, from: data)
                    completion(.success(result))
                }
                catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //MARK: - Browse
    
    ///Get New Releases
    public func getNewReleases(completion: @escaping ((Result<NewReleasesResponse, Error>)) -> Void) {
        createRequest(with: URL(string: Constants.baseURL + "/browse/new-releases?limit=40"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(NewReleasesResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    ///Get Featured Playlists
    public func getFeaturedPlaylists(completion: @escaping(Result<FeaturedPlaylistsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseURL + "/browse/featured-playlists?limit=20"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(FeaturedPlaylistsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    ///Get Recommendations
    public func getRecommendations(genres: Set<String>, completion: @escaping(Result<RecommendationsResponse, Error>)->Void) {
        let seeds = genres.joined(separator: ",")
        createRequest(with: URL(string: Constants.baseURL + "/recommendations?limit=50&seed_genres=\(seeds)"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendationsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    ///Get Recommended Genres
    public func getRecommendedGenres(completion: @escaping(Result<RecommendedGenresResponse, Error>)->Void) {
        createRequest(with: URL(string: Constants.baseURL + "/recommendations/available-genre-seeds"), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(RecommendedGenresResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //MARK: - Albums
    public func getAlbumDetails(for album: Album, completion: @escaping (Result<AlbumDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseURL + "/albums/" + album.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(AlbumDetailsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //MARK: - Playlists
    public func getPlaylistDetails(for playlist: Playlist, completion: @escaping (Result<PlaylistDetailsResponse, Error>) -> Void) {
        createRequest(with: URL(string: Constants.baseURL + "/playlists/" + playlist.id), type: .GET) { request in
            let task = URLSession.shared.dataTask(with: request) { data, _, error in
                guard let data = data, error == nil else {
                    completion(.failure(APIError.failedToGetData))
                    return
                }
                do {
                    let result = try JSONDecoder().decode(PlaylistDetailsResponse.self, from: data)
                    completion(.success(result))
                } catch {
                    completion(.failure(error))
                }
            }
            task.resume()
        }
    }
    //MARK: - Request
    enum HTTPMethod: String {
        case GET
        case POST
    }
    
    private func createRequest(with url: URL?,type: HTTPMethod, completion: @escaping(URLRequest) -> Void) {
        AuthManager.shared.withValidToken { token in
            guard let apiURL = url else { return }
            var request = URLRequest(url: apiURL)
            request.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
            request.httpMethod = type.rawValue
            request.timeoutInterval = 30
            completion(request)
        }
    }
}
