import UIKit

struct Person: Decodable {
    let name: String
    var films: [URL]
    var vehicles: [URL]
}

struct Film: Decodable {
    let title: String
    let opening_crawl: String
    let release_date: String
    
}


class SwapiService {
    
    private static let baseURL = URL(string: "https://swapi.co/api/")
    private static let personPathComponents = "people"
    
    static func fetchPerson(id: Int, completion: @escaping (Person?) -> Void) {
        // 1 - Prepare URL
        guard let baseURL = baseURL else { return completion(nil) }
        let personURL = baseURL.appendingPathComponent(personPathComponents)
        let finalURL = personURL.appendingPathComponent("\(id)")
        
        print(finalURL)
        
        URLSession.shared.dataTask(with: finalURL) { (data, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
            
            //print(String(data: data, encoding: .utf8))
            
            do {
                let decoder = JSONDecoder()
                let person = try decoder.decode(Person.self, from: data)
                completion(person)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            
        }.resume()
        
        // 2 - Contact server
        
        // 3 - Handle errors
        
        // 4 - Check for data
        
        // 5 - Decode Person from JSON
        
    }
    
    static func fetchFilm(url: URL, completion: @escaping (Film?) -> Void) {
        // 1 - Contact server
        print(url)
        URLSession.shared.dataTask(with: url) { (data, _, error) in
            if let error = error {
                print(error, error.localizedDescription)
                return completion(nil)
            }
            
            guard let data = data else { return completion(nil) }
            do {
                let decoder = JSONDecoder()
                let film = try decoder.decode(Film.self, from: data)
                return completion(film)
            } catch {
                print(error, error.localizedDescription)
                return completion(nil)
            }
        }.resume()
        // 2 - Handle errors
        
        // 3 - Check for data
        
        // 4 - Decode Film from JSON
    }
    
}

func fetchFilm(url: URL) {
    SwapiService.fetchFilm(url: url) { film in
        if let film = film {
            print(film.title)
        }
    }
}

SwapiService.fetchPerson(id: 2) { person in
    if let person = person {
        print(person)
        for film in person.films {
            fetchFilm(url: film)
            
            
        }
    }
}



