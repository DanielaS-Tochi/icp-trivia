import React, { useState, useEffect } from 'react';
import { icp_trivia_backend } from '../../declarations/icp-trivia-backend';
import './index.scss';

function App() {
  const [pregunta, setPregunta] = useState(null);
  const [indice, setIndice] = useState(null);
  const [resultado, setResultado] = useState('');
  const [ranking, setRanking] = useState([]);
  const nombreJugador = "Ana"; // Podemos hacer esto dinámico después

  // Obtener una pregunta al cargar la página
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
    if (indice === null) return;
    const exito = await icp_trivia_backend.responderPregunta(nombreJugador, indice, respuesta);
    setResultado(exito ? '¡Correcto!' : 'Incorrecto');
    actualizarRanking();
  }

  async function actualizarRanking() {
    const rankingData = await icp_trivia_backend.verRanking();
    setRanking(rankingData);
  }

  return (
    <div className="App">
      <h1>ICP Trivia</h1>
      {pregunta ? (
        <>
          <p>{pregunta.texto}</p>
          <div className="opciones">
            {pregunta.opciones.map((opcion, i) => (
              <button key={i} onClick={() => responderPregunta(i)}>
                {opcion}
              </button>
            ))}
          </div>
          <p>{resultado}</p>
          <button onClick={obtenerPregunta}>Nueva Pregunta</button>
        </>
      ) : (
        <p>Cargando pregunta...</p>
      )}
      <h2>Ranking</h2>
      <ul>
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