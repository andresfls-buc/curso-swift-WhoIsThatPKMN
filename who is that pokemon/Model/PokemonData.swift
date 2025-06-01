//
//  PokemonData.swift
//  who is that pokemon
//
//  Created by Andres Landazabal on 2025/05/31.
//



import Foundation

// MARK: - PokemonData
struct PokemonData: Codable {
    
    let results: [Result]?
}

// MARK: - Result
struct Result: Codable {
    let name: String?
    let url: String?
}

