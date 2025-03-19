import React, { useState, useEffect } from 'react';
import { icp_trivia_backend } from 'declarations/icp-trivia-backend';
import './index.scss';

function App() {
  const [pregunta, setPregunta] = useState(null);
  const [indice, setIndice] = useState(null);
  const [resultado, setResultado] = useState('');
  const [ranking, setRanking] = useState([]);
  const [nombreJugador, setNombreJugador] = useState("");

  useEffect(() => {
    obtenerPregunta();
    actualizarRanking();
  }, []);

  async function obtenerPregunta() {
    const [indicePregunta, datosPregunta] = await icp_trivia_backend.obtenerPregunta();
    setIndice(indicePregunta);
    setPregunta(datosPregunta);
    setResultado('');
  }

  async function registrarYResponder(respuesta) {
    if (indice === null || !nombreJugador) {
      setResultado("Por favor, ingresá un nombre.");
      return;
    }

    // Verificar si el nombre ya existe
    const puntosOpt = await icp_trivia_backend.obtenerPuntos(nombreJugador);
    const puntos = puntosOpt.length > 0 ? puntosOpt[0] : null;
    if (puntos !== null) {
      // Nombre ya existe, seguir jugando
    } else {
      // Registrar nuevo jugador
      const registrado = await icp_trivia_backend.registrarJugador(nombreJugador);
      if (!registrado) {
        setResultado("Error al registrar el jugador.");
        return;
      }
      await actualizarRanking();
    }

    const exito = await icp_trivia_backend.responderPregunta(nombreJugador, indice, respuesta);
    setResultado(exito ? '¡Correcto!' : 'Incorrecto');
    await actualizarRanking();
  }

  async function actualizarRanking() {
    const rankingData = await icp_trivia_backend.verRanking();
    // Ordenar por puntos (descendente) y tomar top 10
    const sortedRanking = rankingData
      .sort((a, b) => Number(b.puntos) - Number(a.puntos))
      .slice(0, 10);
    setRanking(sortedRanking);
  }

  return (
    <div className="app">
      <h1 className="titulo">ICP Trivia</h1>
      <div>
        <input
          type="text"
          value={nombreJugador}
          onChange={(e) => setNombreJugador(e.target.value)}
          placeholder="Tu nombre"
          className="nombre-input"
        />
      </div>
      {pregunta ? (
        <div className="pregunta-container">
          <p className="pregunta-texto">{pregunta.texto}</p>
          <div className="opciones">
            {pregunta.opciones.map((opcion, i) => (
              <button key={i} onClick={() => registrarYResponder(i)} className="opcion-btn">
                {opcion}
              </button>
            ))}
          </div>
          <p className="resultado">{resultado}</p>
          <button onClick={obtenerPregunta} className="nueva-pregunta-btn">Nueva Pregunta</button>
        </div>
      ) : (
        <p>Cargando pregunta...</p>
      )}
      <h2>Ranking Top 10</h2>
      <ul className="ranking">
        {ranking.map((jugador, i) => (
          <li key={i} className="jugador-nombre">
            {jugador.nombre} - {Number(jugador.puntos)} puntos
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;