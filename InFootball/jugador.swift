//
//  jugador.swift
//  InFootball
//
//  Created by Mac5 on 27/01/21.
//

import Foundation
class Jugador{
    func constructor (nombreJugador:String, posicion:String, provider:String ) {
        this.nombreJugador = nombreJugador;
        this.posicion = posicion;
        this.provider = provider;
    }
    func toString() {
        return this.nombreJugador + ", " + this.posicion + ", " + this.provider;
    }
}
// Firestore data converter
var cityConverter = {
    toFirestore: function(jugador) {
        return {
            nombreJugador: jugador.nombreJugador,
            posicion: jugador.posicion,
            provider: jugador.provider
            };
    },
    fromFirestore: function(snapshot, options){
        const data = snapshot.data(options);
        return new Jugador(data.nombreJugador, data.posicion, data.provider);
    }
};
