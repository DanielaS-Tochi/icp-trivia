import React, { useState, useEffect } from 'react';
import { icp_trivia_backend } from 'declarations/icp-trivia-backend';
import './index.scss';

function App() {
  const [pregunta, setPregunta] = useState(null);
  const [indice, setIndice] = useState(null);
  const [resultado, setResultado] = useState('');
  const [ranking, setRanking] = useState([]);
  const [nombreJugador, setNombreJugador] = useState("Ana"); // Ahora es dinámico

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

  async function responderPregunta(respuesta) {
    if (indice === null || !nombreJugador) return;
    const exito = await icp_trivia_backend.responderPregunta(nombreJugador, indice, respuesta);
    setResultado(exito ? '¡Correcto!' : 'Incorrecto');
    actualizarRanking();
  }

  async function actualizarRanking() {
    const rankingData = await icp_trivia_backend.verRanking();
    setRanking(rankingData);
  }

  return (
    <div className="app">
      <h1>ICP Trivia</h1>
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
              <button key={i} onClick={() => responderPregunta(i)} className="opcion-btn">
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
      <h2>Ranking</h2>
      <ul className="ranking">
        {ranking.map((jugador, i) => (
          <li key={i}>
            {jugador.nombre} - {jugador.puntos} puntos ({jugador.avatar})
          </li>
        ))}
      </ul>
    </div>
  );
}

export default App;