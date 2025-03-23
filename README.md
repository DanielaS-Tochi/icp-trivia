# icp-trivia

¡Bienvenidos a *ICP Trivia*! Este es un juego de trivia descentralizado sobre Internet Computer (ICP), construido con Motoko para el backend y React para el frontend. El proyecto permite registrar jugadores, responder preguntas sobre ICP y Motoko, y ver un ranking de los top 10 puntajes, todo con un diseño inspirado en la paleta de colores de ICP.

# Requisitos previos

Para probar este proyecto, necesitás instalar:

**DFX SDK**: El kit de desarrollo de Internet Computer.

bash
sh -ci "$(curl -fsSL https://internetcomputer.org/install.sh)"

Verificá con dfx --version.

Node.js y npm: Para el frontend React (Node 18 o superior).

Descargalo desde https://nodejs.org/en

Verificá con node --version y npm --version.

## Instalación
Cloná el repositorio y prepará el proyecto con estos pasos:

Cloná el repo:

bash
git clone https://github.com/DanielaS-Tochi/icp-trivia.git

cd icp-trivia

Instalá las dependencias del frontend:

bash
cd src/icp-trivia-frontend
npm install
cd ../..

Iniciá el entorno local de ICP:

bash
dfx start --background

Deployeá los canisters:

bash
dfx deploy

Uso
Una vez deployado, accedé a la aplicación:

## Frontend:
Obtené el ID del canister frontend:

bash
dfx canister id icp-trivia-frontend

Abrí: http://localhost:4943/?canisterId=<frontend-id>.

Candid UI: Interfaz gráfica para probar el backend.

Obtené el ID del canister backend:

bash
dfx canister id icp-trivia-backend

Abrí: http://localhost:4943/?canisterId=<backend-id>.

## Cómo funciona

Backend (Motoko): src/icp-trivia-backend/main.mo
Almacena preguntas y jugadores en variables stable.

Funciones:

registrarJugador: Registra jugadores, evitando duplicados.
obtenerPregunta: Devuelve una pregunta aleatoria.
responderPregunta: Suma puntos si la respuesta es correcta.
verRanking: Muestra los top 10 jugadores.

Frontend (React): src/icp-trivia-frontend/src/App.jsx

Interfaz interactiva que:
Permite ingresar un nombre.
Muestra preguntas y opciones.
Actualiza el ranking en tiempo real.
Estilizado con index.scss usando la paleta de ICP ( #0E1C4A (azul oscuro), #00A4FF (azul claro), #E5E7EB (gris suave), #FFFFFF (blanco).

## Desarrollo
Si querés modificar el proyecto:

### Backend: 
Editá main.mo y redeployeá con dfx deploy.

### Frontend:
Editá App.jsx o index.scss.

Para desarrollo en vivo:

bash
cd src/icp-trivia-frontend
npm start
Abre http://localhost:8080 con proxy al backend en 4943.

Generá nuevas declaraciones si cambias el backend:

bash
npm run generate

## Deploy en la red principal (opcional)
Para subirlo a la blockchain de ICP:

Configurá una identidad con ciclos (consultá NNS).

Deployeá:
bash
dfx deploy --network ic

## Notas
Si usás un entorno sin DFX (ej. hosting externo), ajustá DFX_NETWORK a ic en las declaraciones del frontend para evitar fetch del root key en producción.

Proyecto creado por Daniela Silvana Tochi como mi primera aventura en Motoko e ICP.

## Recursos
Para saber más sobre cómo trabajar con ICP, consultá la documentación disponible online:

- [Quick Start](https://internetcomputer.org/docs/current/developer-docs/setup/deploy-locally)
- [SDK Developer Tools](https://internetcomputer.org/docs/current/developer-docs/setup/install)
- [Motoko Programming Language Guide](https://internetcomputer.org/docs/current/motoko/main/motoko)
- [Motoko Language Quick Reference](https://internetcomputer.org/docs/current/motoko/main/language-manual)

# Agradecimientos

Este proyecto fue posible gracias al Bootcamp de ICP México y su equipo que siempre estuveron dispuestos para compartir sus conocimientos y ayudarnos a despejar dudas. También me apoyé en **Grok**, una IA desarrollada por xAI, que me asistió en la resolución de errores, optimización del código y diseño del flujo del juego. ¡Gracias ICP México y Grok, por acompañarmd en mi primera aventura con Motoko e ICP!

## Licencia
MIT License - Ver LICENSE.