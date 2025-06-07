import { BrowserRouter as Router, Routes, Route } from 'react-router-dom';

import Reportes from './pages/reportes';

export default function App() {
  return (
    <Router>
      <Routes>
        <Route path="/" element={<Reportes />} />
      </Routes>
    </Router>
  );
}
