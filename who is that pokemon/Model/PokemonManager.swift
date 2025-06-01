//
//  PokemonManager.swift
//  who is that pokemon
//
//  Created by Andres Landazabal on 2025/05/31.
//

import Foundation

protocol PokemonManagerDelegate {
    func didUpdatePokemon(pokemon: [PokemonModel])
    func didFailWithError(error: Error)
}


struct PokemonManager {
    let pokemonURL: String = "https://pokeapi.co/api/v2/pokemon?limit=898&offset=0"
    var delegate: PokemonManagerDelegate?
    
    func fetchPokemon(){
        performRequest(with: pokemonURL)
    }
    
    private func performRequest(with urlString: String){
        
        //1. Create/get URL
        if let url = URL(string: urlString) {
            //2. Create the URLSession
            let session = URLSession(configuration: .default)
            //3. Give the session a task
            let task = session.dataTask(with: url) { (data, response, error) in
                if error != nil {
                    self.delegate?.didFailWithError(error: error!)
                    
                    
                }
                if let safeData = data {
                    if let pokemon = self.parseJSON(pokemonData: safeData){
                        self.delegate?.didUpdatePokemon(pokemon: pokemon)
                    }
                }
                
            }
            // 4. Start the task
            task.resume()
        }
        
        
        
        
    }
    
    private func parseJSON(pokemonData: Data) -> [PokemonModel]? {
        let decoder = JSONDecoder()
        do {
            let decodedData = try decoder.decode(PokemonData.self, from: pokemonData)
            let pokemon = decodedData.results?.map {
                PokemonModel(name: $0.name ?? "", imageUrl: $0.url ?? "")
            }
            return pokemon
        } catch {
            print("Error decoding JSON: \(error)")
            return nil
        }
    }
}

