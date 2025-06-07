import React from 'react';
import { useNavigate } from 'react-router-dom';
import styles from './Reportes.module.css';

export default function Reportes() {
  const navigate = useNavigate();

  const irAReporte = (tipo) => {
    navigate(`/resultados?tipo=${tipo}`);
  };

  const reportes = [
    { tipo: 'servicios_populares', icono: '🛠️', titulo: 'Servicios Más Solicitados' },
    { tipo: 'vehiculos_reparacion', icono: '🚗', titulo: 'Vehículos en Reparación' },
    { tipo: 'facturacion_mensual', icono: '📈', titulo: 'Facturación Mensual' },
    { tipo: 'horas_empleado', icono: '👷‍♂️', titulo: 'Horas por Empleado' },
    { tipo: 'repuestos_usados', icono: '🔧', titulo: 'Repuestos Más Usados' },
    { tipo: 'citas_pendientes', icono: '📅', titulo: 'Citas Pendientes' }
  ];  

  return (
    <div className={styles.autosContainer}>
      <h1 className={styles.autosTitle}>📊 Dashboard del Taller</h1>
      <section className={styles.gridReportes}>
        {reportes.map((reporte) => (
          <div
            key={reporte.tipo}
            className={styles.reporteCard}
            onClick={() => irAReporte(reporte.tipo)}
          >
            <div className={styles.icon}>{reporte.icono}</div>
            <h3>{reporte.titulo}</h3>
          </div>
        ))}
      </section>
    </div>
  );
}
