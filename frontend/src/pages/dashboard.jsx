import { useNavigate } from 'react-router-dom';
import styles from './dashboard.module.css';

export default function Reportes() {
  const navigate = useNavigate();

  const irA = (ruta) => {
    navigate(ruta);
  };

  const reportes = [
    { ruta: '/resultados?tipo=vehiculos_reparacion', titulo: '🚗 Vehículos en Reparación' },
    { ruta: '/resultados?tipo=servicios_populares', titulo: '🛠️ Servicios Más Solicitados' },
    { ruta: '/resultados?tipo=facturacion_mensual', titulo: '📊 Facturación Mensual' }
  ];

  const gestion = [
    { ruta: '/clientes', titulo: '👤 Gestión de Clientes' },
    { ruta: '/vehiculos', titulo: '🚘 Gestión de Vehículos' }
  ];

  return (
    <div className={styles.autosContainer}>
      <h1 className={styles.autosTitle}>📋 Panel del Taller</h1>

      <section className={styles.gridReportes}>
        {reportes.map((item) => (
          <div
            key={item.titulo}
            className={styles.reporteCard}
            onClick={() => irA(item.ruta)}
          >
            <h3>{item.titulo}</h3>
          </div>
        ))}
      </section>

      <h2 className={styles.autosTitle}>🗂️ Gestión de Datos</h2>

      <section className={styles.gridReportes}>
        {gestion.map((item) => (
          <div
            key={item.titulo}
            className={styles.reporteCard}
            onClick={() => irA(item.ruta)}
          >
            <h3>{item.titulo}</h3>
          </div>
        ))}
      </section>
    </div>
  );
}
