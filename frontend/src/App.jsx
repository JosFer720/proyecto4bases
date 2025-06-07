import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

import Dashboard from './pages/dashboard';
// import Resultados from './pages/Resultados';
// import Clientes from './pages/Clientes';
// import Vehiculos from './pages/Vehiculos';

export default function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Dashboard />} />
        {/* <Route path="/resultados" element={<Resultados />} />
        <Route path="/clientes" element={<Clientes />} />
        <Route path="/vehiculos" element={<Vehiculos />} /> */}
      </Routes>
    </Router>
  );
}
