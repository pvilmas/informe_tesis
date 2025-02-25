#import "final.typ": conf, guia, pronombre, resumen, dedicatoria, agradecimientos, start-doc, capitulo, end-doc, apendice
#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge
#import "@preview/cades:0.3.0": qr-code
#let mostrar_guias = false
#show: conf.with(
    titulo: "PARALELIZACIÓN DE PROCESOS DE MODELAMIENTO DE TRÁFICO URBANO POR MEDIO DE LA CONTENERIZACIÓN DEL SOFTWARE SIMULATION OF URBAN MOBILITY (SUMO) PARA SUPERCOMPUTADORES",
    autor: (nombre: "Pablo Villar Mascaró", pronombre: pronombre.elle),
    profesores: ((nombre: "JAVIER BUSTOS JIMÉNEZ", pronombre: pronombre.el),),
    coguias: ((nombre: "PATRICIO REYES", pronombre: pronombre.el),),
    anno: "2025",
    tesis: true,
    grado-titulo: "COMPUTACIÓN",
    espaciado_titulo: 2fr,
)

#resumen(
    titulo: "Paralelización de procesos de modelamiento de tráfico urbano por medio de la contenerización del software Simulation of Urban MObility (SUMO) para Supercomputadores",
    autor: (nombre: "Pablo Villar Mascaró", pronombre: pronombre.elle),
    tesis: true,
    grado-titulo: "COMPUTACIÓN",
    anno: "2025",
    profesores: ((nombre: "JAVIER BUSTOS JIMÉNEZ", pronombre: pronombre.el),),
)[
    El presente trabajo de tesis aborda la problemática del escalamiento de simulaciones de tráfico vehicular urbano para su uso en el modelamiento de flujos de tráfico a nivel microscópico a través de grandes áreas metropolitanas. Se encuentra orientado a su implementación en ambientes de supercomputación, insertándose en un proyecto conjunto entre NIC Chile Research Labs y el _Barcelona Supercomputing Center_ (BSC) para el desarrollo de gemelos digitales para las ciudades de Barcelona y Kobe (Japón).

    Dado el escalamiento de comportamiento exponencial de las simulaciones que se estudian dentro del trabajo preliminar de esta investigación, se propone una solución basada en la paralelización de estos procesos, buscando aumentar el _speedup_ de la ejecución de las simulaciones, con el objetivo de analizar y comparar el crecimiento entre ambos modelos en cuanto al tiempo de ejecución.
    
    Por medio del uso del _software_ SUMO (_Simulation of Urban MObility_), el uso del algoritmo de partición de grafos _SPartSim_ para la división de mapas y la implementación de una arquitectura de paralelización orientada a dispositivos de memoria compartida a través de _OpenMP_, se logra desarrollar una versión paralela de simulaciones generadas para las ciudades de Barcelona y Viladecans.

    Para medir la escalabilidad de la solución implementada, se realiza un test de carga inicial para la versión secuencial de las simulaciones, midiendo sus tiempos de ejecución y el uso de CPU en cada caso, mientras que para la versión paralelizada se realiza un procedimiento similar. 

    A partir de estos experimentos, se obtiene que a medida que se aumenta el número de nodos de ejecución, se logra un escalamiento de comportamiento más lineal respecto al comportamiento de la versión secuencial, además de cotas más bajas para el tiempo máximo que ocupan las simulaciones en su ejecución. 
]