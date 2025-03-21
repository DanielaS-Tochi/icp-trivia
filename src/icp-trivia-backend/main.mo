import Array "mo:base/Array";
import Random "mo:base/Random";
import Order "mo:base/Order";

actor IcpTrivia {
  type Jugador = {
    nombre: Text;
    puntos: Nat;
  };

  type Pregunta = {
    texto: Text;
    opciones: [Text];
    respuestaCorrecta: Nat;
  };

  stable var jugadores: [Jugador] = [];
  stable var preguntas: [Pregunta] = [
    {
      texto = "¿Qué es ICP?";
      opciones = ["Internet Computer", "International Crypto Protocol", "Integrated Chain Process", "Internet Control Panel"];
      respuestaCorrecta = 0;
    },
    {
      texto = "¿Quién creó Motoko?";
      opciones = ["Microsoft", "DFINITY", "Google", "Ethereum Foundation"];
      respuestaCorrecta = 1;
    },
    {
      texto = "¿Qué tipo de blockchain es ICP?";
      opciones = ["Centralizada", "Descentralizada", "Privada", "Híbrida"];
      respuestaCorrecta = 1;
    },
    {
      texto = "¿Para qué se usa Web3?";
      opciones = ["Juegos en línea", "Internet descentralizado", "Redes sociales tradicionales", "Procesamiento de datos"];
      respuestaCorrecta = 1;
    },
    {
      texto = "¿Qué es un canister en ICP?";
      opciones = ["Un contrato inteligente", "Una base de datos", "Un servidor central", "Un token"];
      respuestaCorrecta = 0;
    },
    {
      texto = "¿Qué protocolo usa ICP para consenso?";
      opciones = ["Proof of Work", "Proof of Stake", "Threshold Relay", "Delegated Proof of Stake"];
      respuestaCorrecta = 2;
    },
    {
      texto = "¿Qué permite Motoko con los actores (actors)?";
      opciones = ["Crear bases de datos", "Definir contratos inteligentes", "Ejecutar juegos 3D", "Minar criptomonedas"];
      respuestaCorrecta = 1;
    },
    {
      texto = "¿Qué es el NNS en ICP?";
      opciones = ["Network Nervous System", "New Node Service", "Nano Network Storage", "National Node System"];
      respuestaCorrecta = 0;
    },
    {
      texto = "¿Qué tipo de lenguaje es Motoko?";
      opciones = ["Orientado a objetos", "Funcional", "Basado en scripts", "Orientado a objetos y funcional"];
      respuestaCorrecta = 3;
    },
    {
      texto = "¿Qué hace el comando 'dfx deploy'?";
      opciones = ["Inicia un nodo", "Compila y sube el canister", "Borra el proyecto", "Genera una clave privada"];
      respuestaCorrecta = 1;
    },
    {
      texto = "¿Qué son los cycles en ICP?";
      opciones = ["Unidades de tiempo", "Tokens de gobernanza", "Combustible para ejecutar canisters", "Puntos de recompensa"];
      respuestaCorrecta = 2;
    },
    {
      texto = "¿Qué significa 'stable' en Motoko?";
      opciones = ["Variable temporal", "Estado persistente", "Código optimizado", "Función estática"];
      respuestaCorrecta = 1;
    },
    {
      texto = "¿Qué permite el modelo de 'reverse gas' de ICP?";
      opciones = ["Usuarios pagan gas", "Desarrolladores pagan gas", "No hay gas", "Gas se paga en BTC"];
      respuestaCorrecta = 1;
    },
    {
      texto = "¿Qué es una identidad en dfx?";
      opciones = ["Un nombre de usuario", "Una clave criptográfica", "Un avatar", "Una dirección IP"];
      respuestaCorrecta = 1;
    },
    {
      texto = "¿Qué hace el Internet Computer con HTTP?";
      opciones = ["Lo reemplaza", "Lo usa para dApps", "Lo bloquea", "Lo convierte a HTTPS"];
      respuestaCorrecta = 1;
    }
  ];
  
  public func registrarJugador(nombre: Text) : async Bool {
    
    let existe = Array.find(jugadores, func (j: Jugador) : Bool { j.nombre == nombre }) != null;
    if (existe) {
      return true; 
    };
    let nuevoJugador = { nombre = nombre; puntos = 0 };
    jugadores := Array.append(jugadores, [nuevoJugador]);
    return true;
  };

  public shared func obtenerPregunta() : async (Nat, Pregunta) {
    let seed = await Random.blob();
    let random = Random.Finite(seed);
    let tamano = Array.size(preguntas); // 15 preguntas
    let indiceAleatorio = switch (random.range(32)) {
      case (null) 0;
      case (?n) n % tamano; 
    };
    (indiceAleatorio, preguntas[indiceAleatorio])
  };

  public func responderPregunta(nombre: Text, indicePregunta: Nat, respuesta: Nat) : async Bool {
    if (indicePregunta >= Array.size(preguntas)) {
      return false;
    };
    let pregunta = preguntas[indicePregunta];
    if (respuesta == pregunta.respuestaCorrecta) {
      var encontrado = false;
      let nuevosJugadores = Array.map(jugadores, func (j: Jugador) : Jugador {
        if (j.nombre == nombre) {
          encontrado := true;
          return { nombre = j.nombre; puntos = j.puntos + 1 };
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
    switch (Array.find(jugadores, func (j: Jugador) : Bool { j.nombre == nombre })) {
      case null { null };
      case (?jugador) { ?jugador.puntos };
    };
  };

  public query func verRanking() : async [Jugador] {
    let ordenados = Array.sort(jugadores, func (a: Jugador, b: Jugador) : Order.Order {
      if (a.puntos > b.puntos) { #less } else if (a.puntos < b.puntos) { #greater } else { #equal }
    });
    
    if (Array.size(ordenados) > 10) {
      Array.subArray(ordenados, 0, 10)
    } else {
      ordenados
    }
  };
};