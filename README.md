# 🎰 Ruleta Estratégica - Bash Scripting

Sistema avanzado de simulación de estrategias de apuestas desarrollado en Bash para el análisis de comportamiento en juegos de azar.

## 🚀 Características

* **Interfaz Visual**: Uso de códigos de colores ANSI para una experiencia profesional y legible en terminal.
* **Estrategias Implementadas**:
    * **Martingala**: Progresión clásica basada en doblar la apuesta tras cada pérdida para recuperar capital.
    * **Inverse Labrouchere**: Gestión de secuencias dinámica basada en la suma de extremos, con checkpoints automáticos para asegurar beneficios.
* **Gestión de Sesión**: Estadísticas en tiempo real, incluyendo pico de dinero alcanzado, contador de jugadas y registro detallado de malas rachas.
* **Seguridad y Robustez**: Manejo de interrupciones (`Ctrl+C`) para una salida limpia y control de errores en los parámetros de entrada.

## 🛠️ Instalación y Uso

1. Clona el repositorio:
   ```bash
   git clone [https://github.com/alloma2002/Ruleta-Estrategica.git](https://github.com/alloma2002/Ruleta-Estrategica.git)

2. Dale permisos de ejecución:
   ```bash
   chmod +x ruleta.sh

3. Ejecuta el script:
   ```bash
   ./ruleta.sh -m <cantidad_dinero> -t martingala


Ejemplos de uso:

Estrategia Martingala:
./ruleta.sh -m 150 -t martingala

Estrategia Inverse Labrouchere:
./ruleta.sh -m 150 -t inverseLabrouchere
