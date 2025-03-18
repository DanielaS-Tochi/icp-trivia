import Array "mo:base/Array";

actor IcpTrivia {
  type Jugador = {
    nombre: Text;
    avatar: Text;
    puntos: Nat;
  };

  type Pregunta = {
    texto: Text;
    opciones: [Text];
    respuestaCorrecta: Nat;
  };

  let avatares: [Text] = ["😎", "🚀", "🐱"];

  stable var jugadores: [Jugador] = [];
  stable var preguntas: [Pregunta] = [
    {
      texto = "¿Qué es ICP?";
      opciones = ["Internet Computer", "Protocolo Crypto", "Panel de Control"];
      respuestaCorrecta = 0;
    },
    {
      texto = "¿Quién creó Motoko?";
      opciones = ["Microsoft", "DFINITY", "Google"];
      respuestaCorrecta = 1;
    }
  ];

  public query func obtenerAvatares() : async [Text] {
    avatares
  };

  public func registrarJugador(nombre: Text, indiceAvatar: Nat) : async Bool {
    if (indiceAvatar >= 3) {
      return false;
    };
    let nuevoJugador = { nombre = nombre; avatar = avatares[indiceAvatar]; puntos = 0 };
    jugadores := Array.append(jugadores, [nuevoJugador]);
    return true;
  };

  public query func obtenerPregunta() : async (Nat, Pregunta) {
    (0, preguntas[0])
  };

  public func responderPregunta(nombre: Text, indicePregunta: Nat, respuesta: Nat) : async Bool {
    if (indicePregunta >= 2) {
      return false;
    };
    let pregunta = preguntas[indicePregunta];
    if (respuesta == pregunta.respuestaCorrecta) {
      var encontrado = false;
      let nuevosJugadores = Array.map(jugadores, func (j: Jugador) : Jugador {
        if (j.nombre == nombre) {
          encontrado := true;
          return { nombre = j.nombre; avatar = j.avatar; puntos = j.puntos + 1 };
        } else {
          return j;
        };
      });
      if (encontrado) {
        jugadores := nuevosJugadores;
        return true;
      } else {
        return false;
      };
    } else {
      return false;
    };
  };

  public query func obtenerPuntos(nombre: Text) : async ?Nat {
    for (jugador in jugadores.vals()) {
      if (jugador.nombre == nombre) {
        return ?jugador.puntos;
      };
    };
    return null;
  };
};