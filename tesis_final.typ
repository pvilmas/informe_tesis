#import "final.typ": conf, guia, pronombre, resumen, dedicatoria, agradecimientos, start-doc, capitulo, end-doc, apendice
#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge
#import "@preview/cades:0.3.0": qr-code
#let mostrar_guias = false
#show: conf.with(
    titulo: "PARALELIZACIÓN DE PROCESOS DE MODELAMIENTO DE TRÁFICO URBANO POR MEDIO DE LA CONTENERIZACIÓN DEL SOFTWARE SIMULATION OF URBAN MOBILITY (SUMO) PARA SUPERCOMPUTADORES",
    autor: (nombre: "Pablo Villar Mascaró", pronombre: pronombre.elle),
    profesores: ((nombre: "JAVIER BUSTOS JIMÉNEZ", pronombre: pronombre.el),),
    coguias: ((nombre: "PATRICIO REYES", pronombre: pronombre.el),),
    comision: ("NOMBRE COMPLETO UNO", "NOMBRE COMPLETO DOS", "NOMBRE COMPLETO TRES"),
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

#dedicatoria[
    Para todos los amores paralelos de mi vida
    #figure(image("dedicatoria.png"))
    por todo su cariño y soporte a través de estos años inciertos y hostiles.
    
]

#agradecimientos[
    #figure(
        qr-code("https://github.com/pvilmas/agradecimientos_tesis")
    )
]

#show: start-doc

#capitulo(title: "Introducción")[
  El modelamiento de tráfico vehicular urbano por medio del uso de _software_ de simulación resulta ser de gran relevancia al momento de proveer información necesaria para diseños y decisiones en torno a la movilidad de distintos agentes dentro de un área determinada. En particular, se puede considerar crucial para el desarrollo de _Gemelos Digitales_ de ciudades y áreas metropolitanas. Un _Gemelo Digital_ consiste en "una representación de un producto activo o un sistema de productos-servicios único que incluye una selección de características, propiedades, condiciones y comportamientos por medio de modelos, información y datos a través de una o múltiples fases de su ciclo de vida" @Stark2019. Es decir, un _Gemelo Digital_ consiste en una representación en tiempo real de una entidad física en un ambiente digital @IETF_DT. En este contexto, el presente trabajo se desarrolla bajo la colaboración entre NIC Research Labs y el equipo de Data Analytics and Visualization Group del Barcelona Supercomputing Center (BSC) para la creación de una plataforma generadora de _Gemelos Digitales_ para las ciudades de Kobe (Japón) y Barcelona (España), los cuales tienen por objetivo contribuir a la toma de decisiones para la implementación de políticas de urbanismo en las ciudades, con el fin de mejorar la calidad de vida mediante la ejecución de cambios estructurales en éstas.

  En dicho sentido, el uso de estas herramientas de simulación cobra especial importancia al momento de querer obtener cierto nivel de precisión en el modelamiento de diferentes escenarios, tales como puntos de congestión y flujo de tráfico en horas críticas para la movilidad de las personas. Sin embargo, el obtener simulaciones detalladas a grandes escalas implica un alto costo en cuanto a recursos computacionales, por lo que durante los últimos años se ha buscado desarrollar métodos de distribución y paralelización de estos procesos, con el objetivo de optimizar los recursos disponibles para simular, por ejemplo, áreas metropolitanas grandes y concurridas.

  El problema propuesto aborda el estudio de la escalabilidad de estas simulaciones, con el objetivo de proponer una solución que mejore su _performance_ y el uso de recursos computacionales, en especial para escenarios que contemplen una alta carga de tráfico vehicular urbano, y de esta maner implementar un sistema de simulaciones para dispositivos de memoria compartida, como lo son los supercomputadores, facilitando su uso para el desarrollo de modelos tales como _Gemelos Digitales_. Es así que, en el estado inicial de este trabajo, se realiza un estudio de la escalabilidad de simulaciones sin paralelizar, el cual muestra que los tiempos de ejecución de estas simulaciones crecen de una manera exponencial. Adicionalmente, se muestra que el uso de CPU en cada simulación se mantiene constante en un 100%; es decir, cada una de las simulaciones ejecutadas utiliza la totalidad de los recursos asignados, lo cual, en adición al crecimiento de los tiempos de simulación, resulta inconveniente para la implementación de modelos a gran escala y con alta demanda de tráfico.

  Dada esta problemática, la presente tesis aborda la implementación de una arquitectura de paralelización y la determinación de los parámetros necesarios para implementar sincronización en simulaciones de tráfico vehicular urbano con orientación a su uso en supercomputadores, con el objetivo de estudiar la escalabilidad de simulaciones microscópicas (es decir, de alta granularidad), las cuales son realizadas mediante el _software_ SUMO, para áreas urbanas extensas y con alta carga de tráfico vehicular. Para esto, se propone el uso de herramientas orientadas a High-Performance Computing, tales como _Singularity Containers_ y _Message Passing Interface_ (MPI), lo cual permite tanto la contenerización de procesos y aplicaciones complejas para su uso en supercomputadores, como la comunicación y sincronización de dichos procesos. En este caso, este trabajo se encuentra orientado a su implementación en el supercomputador _MareNostrum_, ubicado en el Centro Nacional de Supercomputación de Barcelona. 


  El proyecto se dividió en tres etapas, a ser: la partición y contenerización de las simulaciones, la paralelización de las mismas, y la determinación de los parámetros necesarios para la comunicación entre los procesos de simulación para su sincronización. En las tres etapas se hizo uso de _Singularity Containers_, mientras que en la segunda y tercera se sumó el uso de _OpenMP_.

  El presente informe se divide en siete capítulos, a ser: 
  - *Problema*: donde se plantea el problema de investigación y se presentan los resultados de la primera prueba de escalabilidad de SUMO.
  - *Preguntas de investigación, hipótesis y objetivos*: donde se postulan las preguntas de investigación, de las cuales se desprenden la hipótesis y los objetivos de este trabajo.
  - *Solución propuesta*: donde se detalla la creación de la solución propuesta, su desarrollo, avances y los impedimentos presentados en el camino.
  - *Marco teórico*: donde se profundizan y estudian materias relacionadas a la solución propuesta, tales como distintos simuladores de tráfico existentes y trabajos orientados al desarrollo de simulaciones en ambientes de _High-Performance Computing_.
  - *Resultados*: donde se presentan los resultados obtenidos de la medición de los tiempos de simulación para la solución propuesta, su _speedup_ y su eficiencia.
  - *Discusión*: donde se analizan los resultados obtenidos, considerando detalles importantes del proceso de paralelización.
  - *Conclusiones*: donde se concluye el trabajo y se da cuenta de los posibles trabajos futuros a desarrollar a partir de éste.
]

#capitulo(title: "Problema")[
  == Pruebas de escalabilidad en SUMO <pruebas>
  En un estudio inicial en desarrollo de este trabajo de tesis, se implementó y ejecutó un conjunto de distintas pruebas de escalabilidad para observar el crecimiento de los tiempos de ejecución de SUMO en un computador personal. En particular, dos pruebas de escalabilidad fueron realizadas considerando dos aspectos importantes de los requerimientos para la creación de simulaciones de tráfico urbano: en primer lugar, se considera el tamaño de la red de caminos en número de aristas del grafo que representa el mapa, mientras que para el segundo se toma en consideración el número de agentes o vehículos por simulación.

  Ambos experimentos se encuentran implementados en el lenguaje de programación `C++` y fueron testeados en un computador personal con Intel#sym.trademark.registered Core#sym.trademark i7-106G7 CPU \@1,30GHz. Para cada test se asignó únicamente una CPU, con el objetivo de mantener la simplicidad de los resultados. Adicionalmente, sólo fue considerado un tipo de agente para las simulaciones (automóviles) y cada simulación representa 1 hora de tráfico continuo en la ciudad de Barcelona, España, cuya área es de aproximadamente 101,9 km².

  === Prueba de escalabilidad basada en el tamaño de la red para computadores personales

  Para este experimento, se implementó una forma automatizada para obtener los datos necesarios desde OpenStreetMap (OSM). Esta automatización toma una localización descrita en coordenadas, y consulta los datos requeridos a través de 30 iteraciones, donde el tamaño de la red es más grande con cada iteración. 

  Luego, se crearon las simulaciones correspondientes mediante el _software_ SUMO. Los archivos que describen los viajes, es decir, los puntos de partida y llegada de cada vehículo, fueron creados con _randomTrips.py_ @Lopez por simplicidad , haciendo uso de una semilla de aleatoriedad definida; en tanto, los archivos correspondientes a la descripción de las rutas fueron creados mediante el uso de la herramienta _duarouter_ de SUMO @Duarouter. Finalmente, se midió el tiempo de ejecución de cada simulación versus el número de aristas del grafo correspondiente. El _pipeline_ para la generación de estas simulaciones se muestra en la siguiente figura:

  #figure(
      diagram(
          spacing: (10mm, 5mm),
          node-stroke: 1pt,
          edge-stroke: 1pt,
          node((-3,-3), "get_maps.py", stroke: none),
          node((-3,-2), ".osm", name:<1>),
          node((-3,-1), ".osm", name:<2>),
          node((-3,0), ".osm", name:<3>),
          node((-3,2), ".osm", name: <4>),
          edge(<3>,<4>, ".."),
          node(
              enclose: (<1>,<2>,<3>,<4>),
              name: <osm>,
              corner-radius: 3pt,
          ),
          node((0,-3), "randomTrips.py", stroke: none),
          node((0,-2), ".trips.xml", name:<5>),
          node((0,-1), ".trips.xml", name:<6>),
          node((0,0), ".trips.xml", name:<7>),
          node((0,2), ".trips.xml", name: <8>),
          edge(<7>,<8>, ".."),
          node(
              enclose: (<5>,<6>,<7>,<8>),
              name: <trips>,
              corner-radius: 3pt,
          ),
          node((3,-3), "duarouter", stroke: none),
          node((3,-2), ".rou.xml", name:<9>),
          node((3,-1), ".rou.xml", name:<10>),
          node((3,0), ".rou.xml", name:<11>),
          node((3,2), ".rou.xml", name: <12>),
          edge(<11>,<12>, ".."),
          node(
              enclose: (<9>,<10>,<11>,<12>),
              name: <rou>,
              corner-radius: 3pt,
          ),
          edge(<osm>,<trips>, "-|>", label: "netconvert 
(.net.xml)"),
          edge(<trips>, <rou>, "-|>"),
      ),
      caption: [_Pipeline_ para simulaciones basadas en el tamaño de la red.]
  )

  === Prueba de escalabilidad basada en el número de agentes por simulación para computadores personales

  Por otro lado, en orden de testear la escalabilidad de las simulaciones respecto al número de agentes, se determinó una red de caminos de tamaño fijo sobre la ciudad de Barcelona y se crearon las simulaciones correspondientes con _randomTrips.py_ y _duarouter_. El _pipeline_ para este experimento se muestra en la @pipeline.

  #figure(
      diagram(
          spacing: (10mm, 5mm),
          node-stroke: 1pt,
          edge-stroke: 1pt,
          node((-3,0), "osm.net.xml", name:<1>, corner-radius: 3pt),
          node((0,-3), "randomTrips.py", stroke: none),
          node((0,-2), "-p 1.0", name:<5>),
          node((0,-1), "-p 0.975", name:<6>),
          node((0,0), "-p 0.95", name:<7>),
          node((0,2), "-p 0.025", name: <8>),
          edge(<7>,<8>, ".."),
          node(
              enclose: (<5>,<6>,<7>,<8>),
              name: <trips>,
              corner-radius: 3pt,
          ),
          node((3,-3), "duarouter", stroke: none),
          node((3,-2), ".rou.xml", name:<9>),
          node((3,-1), ".rou.xml", name:<10>),
          node((3,0), ".rou.xml", name:<11>),
          node((3,2), ".rou.xml", name: <12>),
          edge(<11>,<12>, ".."),
          node(
              enclose: (<9>,<10>,<11>,<12>),
              name: <rou>,
              corner-radius: 3pt,
          ),
          edge(<1>,<trips>, "-|>",),
          edge(<trips>, <rou>, "-|>"),
      ),
      caption: [_Pipeline_ para simulaciones basadas en la carga de tráfico vehicular.]
  )<pipeline>

  Para poder incrementar de manera uniforme la cantidad de vehículos presentes en la simulación, se configuró la tasa de inserciones de agentes de _randomTrips.py_ @Randomtrips para tomar valores decrecientes en el intervalo [0.025, 1.0], mientras que la configuración de _duarouter_ no fue alterada.

  En total, 40 simulaciones con diferentes tasas de inserción fueron realizadas, midiendo el tiempo de ejecución de cada una. El tiempo total destinado a ejecutar todas estas simulaciones fue de aproximadamente 48 horas cronológicas.

  === Resultados

  Los resultados obtenidos para ambas pruebas se muestran en los gráficos expuestos a continuación. A la izquierda, se muestran los tiempos de simulación en función del número de aristas de la red, mientras que a la derecha, se muestra el uso de CPU por cada simulación ejecutada:

  *Resultados para simulaciones basadas en el tamaño de la red*

  #figure(
      grid(
          columns: 2,
          gutter: 1mm,
          image("imagenes/s_time_edges.png", width: 90%),
          image("imagenes/cpu_edges.png", width: 90%),
      ),
      caption: [Resultados para la prueba de escalabilidad basada en el tamaño de la red de caminos.]
  )

  Como es posible observar, en este caso existe un crecimiento lineal de los tiempos de simulación en relación al crecimiento de la red de caminos, lo cual nos muestra que dicho crecimiento no es realmente un problema al momento de ejecutar simulaciones sobre áreas extensas. Aún así, cabe destacar que el uso de CPU se mantiene constante en un valor máximo, lo cual muestra que los procesos de SUMO consumen la totalidad de los recursos que se le asignan.

  *Resultados para simulaciones basadas en la carga de tráfico vehicular*

  #figure(
      grid(
          columns: 2,
          gutter: 1mm,
          image("imagenes/s_time_freq.png", width: 90%),
          image("imagenes/cpu_freq.png", width: 90%),
      ),
      caption: [Resultados para la prueba de escalabilidad basada en la carga de tráfico vehicular.]
  )

  En este caso, se puede observar un crecimiento exponencial de los tiempos de ejecución de cada simulación en relación a la frecuencia de inserción de vehículos en ésta. Es relevante mencionar que, a pesar de aumentar los tiempos de manera exponencial, las simulaciones no realizaron uso de la memoria _swap_ del computador, lo que deja en evidencia que el problema principal para la ejecución de las simulaciones en términos de procesamiento refiere a la carga de vehículos o agentes dentro de la simulación más que el tamaño de la red, y sugiere la necesidad de paralelización de estos procesos. Por otro lado, se obtiene que el uso de CPU también se mantiene constante en un valor máximo para la mayoría de los casos.

  Como es posible observar a partir de lo ya expuesto, existen principalmente dos dificultades al momento de buscar mejorar la _performance_ de las simulaciones de tráfico urbano. La primera de ellas, y la más importante, refiere a la cantidad y variedad de agentes presentes en cada simulación. Dado que de la ejecución secuencial se tiene que los tiempos de ejecución aumentan de forma exponencial, al momento de querer simular redes de caminos con alta congestión de tránsito, el tiempo de ejecución de la simulación se alejará cada vez más de lo que se desea como una simulación en tiempo real. Este resultado se extiende también a la presencia de diversidad en los agentes de tráfico urbano, a saber: vehículos privados, transporte público, bicicletas, peatones, etc. Si bien el primer estudio de escalabilidad fue realizado con un solo tipo de vehículo, es posible extrapolar que el crecimiento de los tiempos de ejecución ante una mayor variedad de agentes se verá afectado en tanto crecerán también de una forma exponencial.

  La segunda dificultad a considerar tiene que ver con la paralelización misma y la sincronización de los procesos paralelos, dado que existe la posibilidad de generar cuellos de botella en las comunicaciones entre nodos y de esta forma perjudicar la _performance_ de las simulaciones.

  El problema que se plantea a partir de esto radica en la necesidad de paralelizar simulaciones que no sólo representen grandes áreas metropolitanas, sino que también presenten una alta carga de tráfico de agentes (ya sea vehicular o peatonal), manteniendo la granularidad y precisión de dichas simulaciones en un ambiente de supercomputación y otorgando un _speedup_ de éstas de manera significativa, reduciendo también los posibles cuellos de botella en la comunicación de los procesos paralelizados.
    
]

#capitulo(title: "Preguntas de investigación, hipótesis y objetivos")[
    == Preguntas de investigación
    - ¿Cómo se diferencian en cuanto a _performance_ la versión secuencial de simulaciones en SUMO respecto a una versión paralelizada en un ambiente de supercomputación?
    - ¿Es posible mejorar la _performance_ de simulaciones de tráfico urbano en orden de poder simular áreas metropolitanas completas a nivel microscópico?
    - ¿Cómo se comporta asintóticamente la influencia del área a simular en la _performance_ de las simulaciones de tráfico urbano con SUMO?
    - ¿Cómo se comporta asintóticamente la influencia de la carga vehicular a simular en la _performance_ de las simulaciones de tráfico urbano con SUMO?

    == Hipótesis
    Es posible otorgar escalabilidad a los procesos de simulación  de alta granularidad mediante la paralelización de los procesos del _software_ SUMO en un ambiente de supercomputación, incrementando el _speedup_ de éstos en al menos un 5% de los tiempos de simulación secuenciales, y optimizando así el uso de recursos para simulaciones que contemplen áreas metropolitanas de gran extensión y alta carga de tráfico vehicular, determinando para ello los parámetros necesarios para la propia comunicación y sincronización entre los procesos.

    == Objetivos <objetivos>
    === Objetivo General
    Avanzar en el estado del arte acerca de la paralelización de procesos de simulación de tráfico urbano en supercomputadores, comprobando el aumento en la escalabilidad de dichos procesos luego de su correspondiente paralelización.
    #pagebreak()
    === Objetivos específicos
    + Aplicar la contenerización de SUMO en _Singularity Containers_ para su ejecución en supercomputadores.
    + Diseñar e implementar un modelo de paralelización de los procesos contenerizados, determinando los parámetros necesarios para la efectiva comunicación y sincronización entre los procesos.
    + Medir la escalabilidad de la solución implementada en un ambiente de supercomputación y comparar con las mediciones previamente realizadas.
]

#capitulo(title: "Solución propuesta")[
    La paralelización de procesos es una herramienta ampliamente utilizada para la optimización de operaciones en computación. Mediante la división de tareas en tareas más pequeñas que se ejecutan de manera simultánea, es posible reducir los tiempos de ejecución.

    Durante los últimos años, han surgido distintas técnicas y herramientas que podrían facilitar las simulaciones de tráfico en paralelo aplicado a ambientes de High-Performance Computing, tales como supercomputadores. Algunas de estas son:

  + *Paralelización híbrida*: consiste en la combinación de múltiples técnicas de paralelización, incluyendo estándares de transmisión de mensajes para computación paralela tal como lo es MPI (_Message Passing Interface_) u _OpenMP_ para dispositivos de memoria compartida, con el objetivo de alcanzar una mejor _performance_ y escalabilidad. Esto permite una distribución más granular de tareas de simulación a través de múltiples nodos.
  + *Particionamiento de modelos*: refiere a la partición de modelos de simulación en submodelos que pueden ser ejecutados en paralelo, lo cual puede ayudar a reducir los costos de comunicación y mejorar la escalabilidad de las simulaciones.
  + *Simulaciones cloud-based*: implica la ejecución de modelos de simulación en Cloud Computing, lo que ofrece la oportunidad de tener simulaciones más flexibles y escalables. Sin embargo, la latencia de la red y las posibles amenazas en torno a la seguridad de los datos son desventajas que esta opción presenta.

  Un estudio que aborda el problema de la paralelización de SUMO refiere al estudio llevado a cabo por Arroyave et. al. @Arroyave2018, en donde se presenta un modelo de particiones de mapa simplificadas para la simulación en paralelo de tráfico en zonas urbanas. Este modelo consiste en la división de las redes de caminos en forma de cuadrículas, lo cual incrementa el nivel de error de la simulación de manera proporcional con el número de particiones realizadas al momento de simular, dado que las particiones no resultan ser precisas respecto a la topología de la red. Además de esto, dicho estudio señala que el método de paralelización presentado es más lento que su contraparte centralizada dado el proceso de sincronización implementado. Esto plantea la necesidad de abordar el problema desde una perspectiva que considere un esquema de partición de grafos más eficiente, que permita distribuir mejor la carga vehicular en los nodos de simulación.

  Por otro lado, el trabajo titulado "QarSUMO: A Parallel, Congestion-optimized Traffic Simulator" @Chen2020, presenta una versión paralelizada de SUMO considerando la complejidad de la distribución de las redes de caminos por medio de la implementación de un esquema de partición de grafos no-regulares, abreviado como METIS @Karypis1998. Si bien este estudio logra establecer un método de paralelización de alto nivel, incrementando la eficiencia de las simulaciones para situaciones de alta congestión de tráfico, su alcance en cuanto a áreas urbanas no alcanza una escalabilidad a nivel de simulaciones completas al no considerar su implementación en ambientes de _High-Performance Computing_. Sumado a esto, el _software_ disminuye el nivel de granularidad de las simulaciones por medio de la simplificación del modelamiento de un gran número de vehículos a una sola entidad. Esto plantea, a su vez, la posibilidad de obtener un mejor escalamiento y una mejor tasa de granularidad en las simulaciones teniendo una mayor capacidad de cómputo, como es el caso de los supercomputadores.
    
    En cuanto a la escalabilidad de las simulaciones en un contexto de paralelismo, si bien existen limitaciones respecto a cuánto se puede llegar a aumentar el _speedup_ de una tarea mediante la paralelización, tal como dicta la Ley de Amdahl, la cual señala que la reducción en los tiempos de ejecución de un programa se verá limitado por aquellas porciones de programa que no son posibles de paralelizar, la paralelización de procesos resulta ser útil al considerar la disponibilidad de múltiples unidades de cómputo y tareas con alta posibilidad de concurrencia.

    En particular, los procesos de simulación de tráfico vehicular urbano consumen una gran cantidad de recursos y tiempos de ejecución al correr de forma secuencial. Dado que la escalabilidad de dichas simulaciones depende de la carga de vehículos que ésta tenga, es posible pensar en una solución que distribuya esta carga a través de múltiples nodos que computen simultáneamente rutas divididas según zonas geográficas, de manera que cada nodo maneje una zona distinta, y se comunique con los nodos correspondientes mediante una entidad central que gestione la salida y entrada de vehículos a distintas particiones. Es importante, en este caso, considerar el _overhead_ que dichos procesos de comunicación implican, dado que plantean casos de exclusión mutua que serializan parte de las tareas y, por lo tanto, limitan su _speedup_.

    A raíz de lo ya expuesto, es posible extraer la posibilidad de implementar un modelo de paralelización orientado a su uso en dispositivos de alta disponibilidad, solucionando el problema de la escalabilidad, y haciendo uso de herramientas tales como algoritmos de partición de grafos no-regulares para distribuir apropiadamente la carga vehicular, de manera que se optimice el uso de recursos y no se arrastre un margen de error proporcional al número de particiones realizadas para las simulaciones a ejecutar, conservando un mayor porcentaje de precisión para éstas.

  == Diseño de la solución
    La solución propuesta al problema planteado contempla el desarrollo e implementación de un modelo de paralelización para simulaciones de tráfico vehicular urbano a partir de la contenerización de instancias del _software_ SUMO. Para esto, se trabajó con el lenguaje `C++` y las librerías _libtraci_ y _OpenMP_. 


  El diseño considera el levantamiento de distintos nodos de ejecución, al cual se les asigna el mapa a simular y las rutas correspondientes a su partición, y, mediante una instancia contenerizada de SUMO, también asignada al nodo, se ejecuta la simulación a través de estas particiones que corren en paralelo. Es importante destacar la necesidad de la contenerización de SUMO, dado que cada nodo necesita su propia instancia del _software_ para poder funcionar sin problemas de lectura/escritura en dispositivos de memoria compartida.

  El particionamiento de los mapas a utilizar para las simulaciones contempla el uso del algoritmo de particionamiento de grafos _SPartSim_ @SPartSim, mientras que el posterior corte de las rutas para cada partición se realiza a partir de la herramienta _cutRoutes.py_, provista por el _software_ SUMO.

  Para medir la eficiencia de la solución implementada, se propone el diseño e implementación de tests de carga que midan el tiempo de ejecución y uso de CPU para simulaciones paralelizadas con distintos _sets_ de particiones, con el objetivo de comparar estos resultados con los previamente obtenidos y mostrados en la @pruebas para simulaciones ejecutadas de manera secuencial. 

  Dado el contexto en el que este trabajo se inserta, los mapas utilizados para las pruebas de concepto y la posterior ejecución de los test de carga corresponden a las áreas de Barcelona y Viladecans, ambas ciudades de la región de Cataluña, España.

  == Herramientas utilizadas
  === _Singularity Containers_
  _Singularity_ es un proyecto _open-source_ que permite la creación de contenedores de forma portable y reproducible @Singularity. A diferencia de _Docker_, _Singularity_ fue creado para ejecutar aplicaciones complejas en _clusters_ HPC, cobrando popularidad de manera significativa para su uso en supercomputadores; sin embargo, es posbile construir contenedores de _Singularity_ a partir de contenedores de _Docker_.

  Adicionalmente, este _software_ soporta la generación de imágenes _custom_ a través de sus archivos de definición, permitiendo envolver todas las imágenes necesarias en un sólo archivo que provee facilidad de manejo, además de simplificar el despliegue de los contenedores @Younge2017. La interoperabilidad que ofrece _Singularity_ permite también su portabilidad a través de distintas arquitecturas HPC.

  === _OpenMP_
  _OpenMP_ es una API de modelo escalable que ofrece una interfaz flexible y sencilla de manejar para programación paralela @OpenMP. Provee soporte para los lenguajes `C`, `C++` y `Fortran`, y permite el desarrollo de aplicaciones portables, encontrándose orientado principalmente a la programación para multiprocesadores de memoria compartida.

  Esta API consiste en una especificación para un set de directivas de compilación, rutinas de librería y variables de ambiente que pueden ser usadas para especificar paralelismo de alto nivel. Actualmente, se encuentra en la versión 5.2.
  === SUMO y _libtraci_
  La librería _libtraci_ de SUMO es una herramienta que compatibiliza el uso de TraCI con códigos de `C++` @libtraci, de manera que no sólo se pueda ejecutar una simulación, sino que también pueda controlarse y monitorearse sin necesidad de una GUI. _Libtraci_ provee, además de las funcionalidades de TraCI, soporte para el uso de múltiples clientes, lo cual resulta conveniente al momento de pensar en la paralelización de las simulaciones. 

  == Partición de mapas de Barcelona y Viladecans

  Para realizar la división de los mapas originales de Barcelona y Viladecans se utilizó una implementación en `Java` ya existente del algoritmo de _SPartSim_ @SPartSim, el cual ejecuta una división por zonas geográficas eligiendo puntos distantes en el mapa dada una heurística inicial y va expandiendo las particiones con los nodos cercanos en cada iteración, para luego balancear la carga de las particiones moviendo aquellos nodos con más peso a particiones vecinas que tengan un menor peso. El objetivo de esto es entregar un mapa particionado de manera relativamente equitativa, de forma que los hilos de ejecución de cada sub-simulación no se vean sobrecargados.

  En orden de mantener la compatibilidad con los archivos de entrada de las simulaciones con SUMO, a dicha implementación se le agregó un módulo de compatibilidad con archivos `XML`, ya que el código original sólo trabajaba con archivos `GeoJSON`, los cuales además perdían información importante al momento de convertir desde archivos `XML`. A raíz de esto, se debió implementar una clase que conservase dicha información, para después restaurarla al momento de hacer la conversión desde los grafos generados por el _software_ hacia la clase de grafos compatibles con la estructura `XML` requerida por las simulaciones. La siguiente figura ilustra el proceso de conversión implementado para la compatibilidad del _software_ de particionamiento de rutas con archivos `XML`.
  // TO-DO: Figura
  #figure(
      diagram(
          spacing: (10mm, 5mm),
          node-stroke: 1pt,
          edge-stroke: 1pt,
          node((-7, 0), `XML File`, name: <1>, width: 20mm),
          node((-5, 0), `XMLGraph

- String version
- double limitTurnSpeed
- NetLocation location
- List<NetType> types
- List <NetEdge> edges
- List <NetJunction> junctions`, name: <2>, width: 65mm),
      node((-3, 0), `Graph
      
- Map<Integer, Vertex> vertices
- Map<Integer, Edge> edges`, name: <3>, width: 35mm),
      edge(<1>, <2>, "-|>", label: `read()`),
      edge(<2>,<3>, "-|>", label: `parse()`)
      ),
      caption: [Diagrama de conversión de archivos `XML` a estructuras de tipo `Graph`.]
  )
  
  Como es posible observar, la estructura `XMLGraph` conserva del mapa original atributos tales como la localización, los límites de velocidad y la versión del archivo, los cuales se mantienen al momento de realizar la conversión de las particiones desde la estructura `Graph` a `XMLGraph` para su posterior escritura en los distintos archivos `XML` correspondientes a cada partición.

  == Generación y partición de rutas vehiculares <5.3>

  Para la generación de las rutas vehiculares se consideraron, en primer lugar, dos enfoques distintos: por un lado, el generar dichas rutas a partir de datos reales de movilidad urbana, y por otro lado, generarlas de manera aleatoria o pseudo-aleatoria por medio de la herramienta _randomTrips.py_, provista por SUMO y utilizada para realizar las pruebas de escalabilidad de las simulaciones secuenciales.

  Respecto al primer enfoque, se obtuvieron los datos de movilidad de la población de Barcelona en formato de matrices de Origen-Destino obtenidas a partir de los datos recolectados de las redes móviles por parte del ayuntamiento de Barcelona. Sin embargo, dada la complejidad implicada por la conversión de dichas matrices a los archivos `XML` que describen las rutas correspondientes, en contraste con la simplicidad de generar las rutas de manera pseudo-aleatoria con una herramienta ya integrada en el _software_, y considerando los objetivos planteados, se decidió tomar el segundo enfoque.

  Para la partición de las rutas generadas se hizo uso de la herramienta _cutRoutes.py_ de SUMO, la cual corta las rutas acorde a la partición del mapa que se busca simular. No obstante, dicha herramienta presenta problemas en tanto termina descartando ciertas rutas particionadas y recalculando los tiempos de partida para cada una; si bien existe una extensión que soluciona este problema para la futura paralelización de los procesos de simulación @Acosta2016, no fue posible acceder a ella, por lo que sólo se consideraron aquellas rutas resultantes de _cutRoutes.py_ para la posterior reconstrucción.

    #pagebreak()
  == Contenerización de simulaciones secuenciales
  En una primera instancia de exploración del uso de _Singularity Containers_, se procedió a implementar la contenerización de simulaciones sin paralelizar. El resultado de esto fue la creación de un archivo de definición de _containers_ con extensión `.def`, el cual construye el entorno necesario para la ejecución de las simulaciones de manera aislada. A continuación, se muestra un ejemplo de estos archivos de definición para el levantamiento de los contenedores.

  ```
  Bootstrap: debootstrap
  OSVersion: jammy
  From: ubuntu:22.04
  MirrorURL: http://us.archive.ubuntu.com/ubuntu/

  %files
      partition.net.xml /home/
      viladecans.poly.xml /home/
      partition.rou.xml /home/
      sim.sumocfg /home/
      traci_simulation /home/

  %post
      chmod 755 /root
      apt update
      apt-get install -y software-properties-common build-essential python3
      add-apt-repository universe
      add-apt-repository multiverse
      apt-get update
      apt-get install -y sumo sumo-tools sumo-doc


  %environment
      export SUMO_HOME=/usr/share/sumo

  %runscript
      cd /home
      ./traci_simulation
  ```

  El _script_ de `C++` _traci_simulation_ tiene por objetivo ejecutar simulaciones aisladas de forma secuencial. Para esto, luego de configurar el entorno de la simulación, el código llama a una instancia de SUMO con el archivo de configuración previamente definido a partir de un _script_ en `Python`, el cual genera un archivo `XML` especificando, entre otras cosas, cuáles son los archivos a utilizar para las redes de caminos y las rutas de los vehículos.
  // TO-DO: Anexo -> Ejemplo de archivo de configuración
    #pagebreak()
  == Paralelización de las simulaciones particionadas

  La paralelización de las simulaciones particionadas consistió en la implementación de un código en `C++` con la ayuda de _OpenMP_ para las directivas de compilación. Este código implementa una arquitectura de _multi-threading_, en la cual cada hilo de ejecución posee una instancia de SUMO contenerizada que simula una partición dada del mapa original, con las rutas propiamente particionadas de acuerdo con el algoritmo de _cutRoutes.py_.

  En la siguiente figura, se muestra el funcionamiento general de la paralelización realizada con 5 _threads_. Primero se realiza un proceso de configuración de forma secuencial, en el que se generan los archivos de configuración _sim.sumocfg_ a partir de los cuales se ejecutan las simulaciones en forma paralela mediante una instancia de SUMO contenerizada con _Singularity_. De esta manera, una vez que se crean los archivos de configuración, se realiza un llamado con el comando `#pragma omp parallel`, configurando el número de threads a ejecutarse como el número de particiones hechas previamente con _SPartSim_.
  
  #figure(
      diagram(
          spacing: (9mm, 4mm),
          node-stroke: 1pt,
          edge-stroke: 1pt,
          node((-7,0), `Generate sim_i.sumocfg`, name: <1>, width: 31mm),
          edge((-9,0), "r,r", "-|>", label: `start`),
          node((-2,0), `SUMO instance`, name: <2>, width: 21mm),
          node((-2,1), `SUMO instance`, name: <3>, width: 21mm),
          node((-2,-1), `SUMO instance`, name: <4>, width: 21mm),
          node((-2,2), `SUMO instance`, name: <5>, width: 21mm),
          node((-2,-2), `SUMO instance`, name: <6>, width: 21mm),
          node((0,0), `partition_3.log`, name: <7>, width: 34mm),
          node((0,1), `partition_4.log`, name: <8>, width: 34mm),
          node((0,-1), `partition_2.log`, name: <9>, width: 34mm),
          node((0,2), `partition_5.log`, name: <10>, width: 34mm),
          node((0,-2), `partition_1.log`, name: <11>, width: 34mm),
          edge(<1>,<1>, "-|>", bend: 130deg, label: `for each partition`),
          node(
              enclose: (<2>, <3>, <4>, <5>, <6>),
              name: <parallel>,
              corner-radius: 3pt,
          ),
          edge(<1>,<parallel>, "-|>", label: `#pragma omp parallel`),
          edge(<2>, <7>, "-|>"),
          edge(<3>, <8>, "-|>"),
          edge(<4>, <9>, "-|>"),
          edge(<5>, <10>, "-|>"),
          edge(<6>, <11>, "-|>"),
          edge(<parallel>,<parallel>, "-|>", bend: 100deg, label: `run simulation`)
      ),
      
  )

  #pagebreak()
  == Sincronización de las simulaciones particionadas
  === Reensamblaje de rutas
  En cuanto a la reconstrucción de las rutas, se implementó un código en `Python` que toma tanto las rutas originales como las particionadas y, por cada ruta particionada, busca la ruta original y las agrupa en un diccionario indicando sus aristas, la partición a la que pertenece la ruta, y su índice de ocurrencia en la ruta original. De esta manera, fue posible realizar una reconstrucción parcial de los viajes generados por _randomTrips.py_.
  
  El resultado de esta reconstrucción se guarda finalmente en un archivo `.json`, con la estructura que se muestra a continuación: //Queda como trabajo futuro refinar la reconstrucción de rutas para que las simulaciones sean más precisas.

  // TO-DO: Diagrama del archivo de reconstrucción de rutas.


  ```
  {
      "routes": [
          {
              "original_route": str,
              "cut_routes": [
                  {
                      "partition": int,
                      "id": str,
                      "cut_route": str,
                      "next_partition": int,
                      "next_route": str
                  },
                  ...
              ]
          },
          ...
      ]
  }
  ```
  
  === Comunicación entre nodos
  Dado que la implementación sigue un enfoque para _shared-memory devices_, la comunicación entre los nodos de ejecución se realizó mediante la implementación de una cola global en la cual, a cada paso de la simulación, cada hilo escribe los vehículos salientes de su partición con la partición a la que corresponde insertarse después, mientras que al paso siguiente lee e inserta en la simulación aquellos vehículos cuya entrada corresponde a su partición. Para esto, se hace uso de exclusión mutua por medio de la implementación de secciones críticas para la escritura en la cola de tráfico, mientras que para la adición o remoción de vehículos en cada partición se hace uso de las herramientas provistas por _libtraci_.
  
  #pagebreak()
  === Impedimentos para la sincronización <impedimentos>
  Como se menciona en la @5.3, la herramienta de particionamiento de rutas _cutRoutes.py_ presenta limitaciones al momento de considerarla para la sincronización de simulaciones de tráfico urbano mediante SUMO, principalmente al momento de definir los tiempos de partida de los vehículos (_departure times_), redefiniendo aquellas rutas que cruzan más de una partición como rutas independientes con el mismo tiempo de partida; esto radica en problemas tales como que al ingreso de nuevas rutas, no se reconozca el vehículo a insertar dado que el mismo ya ha salido de la simulación.
  == Diseño e implementación de test de carga
  === Test versión secuencial
  Para poder realizar la comparación en cuanto al crecimiento de los tiempos de ejecución para las simulaciones secuenciales, se implementó un módulo de test en el lenguaje `C++`, el que contempla una primera fase de _setup_, donde se definen los períodos de generación de vehículos a partir de los cuales se generan los archivos de rutas necesarios para el mapa definido. En total, se definen veinte períodos para los cuales se definen también los archivos de configuración a utilizar para cada simulación.

  La segunda etapa contempla la ejecución de cada simulación de forma secuencial, midiendo y registrando el tiempo que toma cada una en finalizar. Para esto, cada simulación se ejecutó un total de cincuenta veces, para luego obtener el tiempo total como el promedio de los tiempos de cada iteración.
  === Test versión paralelizada
  Para probar el escalamiento de la solución implementada, se siguió un procedimiento similar a los tests secuenciales, resultando en la implementación de los siguientes módulos:

  - *_setup_*: este módulo genera los períodos, rutas, particiones y archivos de configuración necesarios para cada simulación, y organiza los archivos en sus directorios correspondientes.
  - *_start_test_*: por cada set de particiones realizadas, este módulo se encarga de entrar a cada directorio e iniciar el test de carga para cada período dado.
  - *_load_test_*: este módulo implementa el test de carga, el cual, a partir de los archivos de configuración y la imagen de _Singularity_ construida para las instancias de SUMO, ejecuta las simulaciones llamando al módulo encargado de paralelizar los procesos de simulación según el número de particiones realizadas. Tal como en el test para la versión secuencial, cada simulación se ejecuta un total de cincuenta veces, para luego promediar los tiempos de cada iteración.
]

#capitulo(title: "Marco teórico")[
  == Simuladores de tráfico urbano
  Dentro del campo de las simulaciones computacionales, se destacan las simulaciones de tráfico urbano en tanto son capaces de proveer información útil para la movilidad en distintos entornos y bajo diversas condiciones. Pablo López et. al. realizan una clasificación de los tipos de simuladores existentes según el nivel de granularidad que poseen @Lopez:
  + Macroscópicas, donde se modelan dinámicas a gran escala tales como la densidad total de tráfico en una ciudad.
  + Microscópicas, en las cuales se modela cada vehículo o agente como una entidad individual, con sus correspondientes interacciones.
  + Mesoscópicas, que contemplan características tanto de las simulaciones macroscópicas como microscópicas, y
  + Submicroscópicas, en las cuales no sólo se simula cada vehículo como un agente individual, sino que es posible simular dinámicas o funciones dentro de ellos.

  Respecto a la variedad de simuladores de tráfico microscópicos existentes, @Kotusevski2009 realiza una comparación entre los simuladores SUMO, Quadstone Paramic Modeler, Treiber's Microsimulation of Road Traffic, Aimsun, Trafficware SimTraffic y CORSIM TRAFVU, considerando entre sus criterios de comparación:

  - Apertura de código (_open source_)
  - Portabilidad de sistema operativo
  - Documentación
  - Escalabilidad
  - _Performance_
  
  En cuanto al criterio de apertura de código, solamente SUMO y Treiber's Microsimulation of Road Traffic resultaron ser _open source_. Esto resulta un criterio importante a considerar, dado que al poder ser modificado por otros programadores, el _software_ tiene el potencial de poder paralelizar modelos de simulación y y desarrollar paquetes orientados a la alta disponibilidad. Ambos simuladores también coinciden en la portabilidad que ofrecen para sistemas operativos Linux, mientras que el resto de _software_ ofrece únicamente funcionamiento para sistemas Windows.

  Respecto a la disponibilidad de documentación, la mayoría de los simuladores resultaron poseer documentación disponible al usuario, mientras que en términos de escalabilidad y performance, SUMO resulta ser el simulador con mayor capacidad de soportar grandes redes de caminos

  Adicionalmente, Ejército et. al. @Ejercito realiza una comparación entre los simuladores Matsim, SUMO, Aimsun y PTV Vissim utilizando los mismos criterios ya descritos. De estos trabajos es posible extraer la siguiente tabla comparativa entre todos los _software_ presentados:

  #figure(
      table(
          columns: 5,
          align: center,
          table.header(
              [Simulador],
              [Apertura de código],
              [Portabilidad de SO],
              [Documentación],
              [Escalabilidad],
          ),
          [SUMO],
          [#emoji.checkmark], [Linux, Windows, MacOS], [#emoji.checkmark], [Alta],
          [Treiber's Microsimulation],
          [#emoji.checkmark], [Linux, Windows, MacOS], [#emoji.checkmark], [Baja],
          [Trafficware SimTraffic],
          [], [Windows], [#emoji.checkmark], [Media],
          [CORSIM TRAFVU],
          [], [Windows], [#emoji.checkmark], [Baja],
          [Matsim],
          [#emoji.checkmark], [Linux, Windows], [#emoji.checkmark], [Media],
          [Aimsun],
          [], [Linux, Windows, MacOS], [], [Alta],
          [PVT Vissim],
          [], [Windows], [#emoji.checkmark], [Alta],
      ),
      caption: [Comparación entre simuladores de tráfico vehicular (adaptada de @Kotusevski2009 y @Ejercito)],
  )

  En cuanto a los aspectos de _performance_, se presenta la siguiente tabla que reúne la información obtenida de @Kotusevski2009 y @Ejercito:

  #figure(
      table(
          columns: 3,
          align: center,
          table.header(
              [Simulador],
              [Uso de CPU],
              [Uso de memoria],
          ),
          [SUMO],
          [30-40%], [12-16 MB para redes promedio],
          [Paramics Modeler],
          [50%], [40-140 MB],
          [Aimsun],
          [30-40% dependiendo del número de vehículos], [300-400 MB dependiendo de la red de tráfico],
          [SimTraffic],
          [50%], [~35 MB],
          [CORSIM TRAFVU],
          [50%], [28-31 MB dependiendo de la red de tráfico],
          [Vissim],
          [50-60%], [720 MB],
      ),
      caption: [Comparación entre _performance_ de simuladores de tráfico vehicular (adpatada de @Kotusevski2009 y @Ejercito)]
  )

  De ambas tablas presentadas, es posible concluir que SUMO parece ser una opción eficiente en cuanto a escalabilidad y performance, sumando a esto la capacidad de paralelización que implica su apertura de código y la amplia documentación que posee para el usuario. 

  Por otro lado, y en una comparación más detallada, Diallo et. al. @Diallo2021 realiza un _benchmarking_ entre los _software_ Matsim, SUMO, Aimsun Next, PTV Vissim y GAMA según los criterios de naturaleza del _software_, creación de redes de caminos y demanda de transporte, realismo en las simulaciones, documentación e interfaz de usuario (GUI), y especificaciones del modelador. Respecto a este último aspecto, se desprende la siguiente tabla comparativa:

  #figure(
      table(
          columns: 8,
          table.header(
              [Simulador],
              [Modelo micro/meso],
              [Escalamiento],
              [Salida de estadísticas],
              [Intermodalidad],
              [Calibración],
              [API],
              [Acceso a código fuente],
          ),
          [SUMO],
          [#emoji.checkmark], [#emoji.checkmark], [#emoji.checkmark], [#emoji.checkmark], [#emoji.checkmark], [#emoji.checkmark], [#emoji.checkmark],
          [Matsim],
          [#emoji.checkmark], [#emoji.checkmark], [#emoji.checkmark], [#emoji.checkmark], [#emoji.checkmark], [], [#emoji.checkmark],
          [Aimsun Next],
          [#emoji.checkmark], [#emoji.checkmark], [#emoji.checkmark], [#emoji.checkmark],[#emoji.checkmark], [], [],
          [PTV Vissim],
          [#emoji.checkmark], [#emoji.checkmark], [#emoji.checkmark], [#emoji.checkmark], [#emoji.checkmark], [], [],
          [GAMA],
          [#emoji.checkmark], [#emoji.checkmark], [#emoji.checkmark], [], [], [], [#emoji.checkmark]
      ),
      caption: [Comparación entre características de simuladores de tráfico vehicular (Adaptada de @Diallo2021)]
  )

  Dos aspectos que además destacan la diferencia entre los simuladores Matsim y SUMO radican en el modelamiento de redes multimodales y la simulación de interacciones microscópicas tales como los cruces de peatones, los cuales son atributos importantes a considerar al momento de querer recrear entornos fieles a la realidad. En este sentido, SUMO presenta ventaja sobre Matsim dado que las redes multimodales se encuentran mejor modeladas con este _software_, además de que SUMO sí presenta la capacidad de simular interacciones microscópicas en sus simulaciones.  

  == Simulation of Urban MObility (SUMO)

  _Simulation of Urban MObility_ (SUMO) es un _software_ consistente en una herramienta de simulación de tráfico continuo y microscópico diseñado para manejar grandes redes de caminos @SUMO y simulaciones multiagente, modelando cada vehículo de manera explícita, con rutas individuales a través de dicha red. Produce simulaciones deterministas por defecto, aunque posee opciones para introducir aleatoriedad en éstas. Este _software_ provee una plataforma para simular y visualizar variados escenarios de transporte, incluyendo transporte público y privado, además de peatones y ciclistas. SUMO se encuentra diseñado para simular las redes de caminos bajo diferentes condiciones de tráfico, tales como congestión, accidentes y cambios en la infraestructura de la red. También permite el modelamiento de diferentes estrategias de gestión de tráfico e impactos de nuevas tecnologías de transporte.

  Adicionalmente, este _software_ se caracteriza por ser altamente portable @Krajzewicz2003, además de poseer la capacidad de importar redes de caminos de diversas fuentes, tales como OpenStreetMap (OSM), OpenDRIVE, Matsim, Vissim y otros simuladores @Lopez. En cuanto a la generación de rutas, SUMO permite la obtención de éstas a través de datos reales (matrices de Origen-Destino), así como la generación aleatoria de rutas a través de su herramienta _randomTrips.py_. La siguiente figura muestra el funcionamiento básico del simulador, desde los parámetros de entrada que debe obtener hasta los posibles _outputs_ que dispone.
  #figure(
      diagram(
          spacing: (10mm, 5mm),
          node-stroke: 1pt,
          edge-stroke: 1pt,
          node((-1,-2), "Red de caminos", name:<1>, width: 30mm),
          node((-1,-1), "Rutas", name: <2>, width: 30mm),
          node((-1,0), "Tiempo de inicio", name: <3>, width: 30mm),
          node((-1,1), "Tiempo de fin", name: <4>, width: 30mm),
          node((-1,2), "Otros elementos", name: <5>, width: 30mm),
          edge((-1,-2), "r,d,d,r", "-|>"),
          edge((-1,-1), "r,d,r", "-|>"),
          edge((-1,0), "r", "-"),
          edge((-1,1), "r,u,r", "-|>"),
          edge((-1,2), "r,u,u,r", "-|>"),
          node((1,0), "Simulación (SUMO)", name: <6>),
          node((3,-1), "Estadísticas de uso de la red", name: <7>, width: 30mm),
          node((3,0), "Estados de la red", name: <8>, width: 30mm),
          node((3,1), "Salida de detectores", name: <9>, width: 30mm),
          edge((1,0),"r,u,r", "-|>"),
          edge((1,0),"r,r", "-|>"),
          edge((1,0),"r,d,r", "-|>"),
      ),
      caption: [Entradas y salidas del simulador SUMO (adaptado de @Krajzewicz2003)]
  )
  
  Las redes de caminos de SUMO consisten en grafos de nodos y aristas unidireccionales que representan calles y veredas. Cada arista posee una geometría descrita por un arreglo de segmentos y consisten en una o más vías corriendo en paralelo @Lopez. Además de estas redes, SUMO puede modelar otros elementos, tales como detectores en la red, elementos avanzados como luces de tráfico, infraestructura adicional como paradas de buses, y polígonos y puntos de interés (POI).

  #figure(
      image("imagenes/ejemplo-simulacion.png", width: 90%),
      caption: [Ejemplo de simulación con SUMO de la ciudad de Barcelona.]
  )

  Para la gestión y ejecución de las simulaciones, SUMO posee una interfaz de control de tráfico (TraCI), la cual permite obtener valores de los objetos simulados y manipular su comportamiento durante la ejecución de las simulaciones @TraCI.

  En la actualidad, SUMO también permite manejar simulaciones microscópicas de áreas extensas; diversos estudios han logrado simular ciudades tales como Luxemburgo @Codeca2015 y Bologna @Bieker2015. A pesar de que estos avances en las simulaciones densas y de alta granularidad presentan sus limitaciones en cuanto a la escala de lo que se puede simular, dichos trabajos muestran que el _software_ SUMO posee la capacidad de modelar entornos realistas con alta precisión.

  == Gemelos Digitales (_Digital Twins_) para ciudades 

  La revolución digital y el crecimiento global de la Internet han levantado el fenómeno de las ciudades manejadas por datos (DDC o _Data-Driven City_) y ciudades inteligentes (_Smart Cities_) @Ivanov2020, las cuales integran datos y tecnologías digitales para asegurar la sustentabilidad, el bienestar ciudadano y el desarrollo económico en el sector urbano.

  Por otro lado, el concepto de Gemelo Digital (_Digital Twin_) conlleva el desarrollo y soporte de modelos de objetos y procesos del mundo real. En @Glaessgen2012 se describe como "una simulación probabilística integrada multiescala de un objeto complejo que utiliza modelos físicos, matemáticos y simulativos para obtener la representación más precisa del objeto real correspondiente, basado en el análisis de datos desde diversas fuentes".

  En este contexto, un Gemelo Digital de una ciudad se vale de datos de ésta, recolectados desde distintas fuentes para modelar su estructura, dinámicas y procesos. Adicionalmente, este modelo requiere la capacidad de simular escenarios hipotéticos sobre el modelo físico, ofreciendo funcionalidades que soporten cambios de estado en la infraestructura urbana y siendo capaz de proveer soluciones mediante el análisis de los datos obtenidos de los procesos simulados.

  Como se define en @Ivanov2020, un Gemelo Digital de una ciudad es un sistema interconectado de Gemelos Digitales que representan ciertos aspectos del funcionamiento y desarrollo del entorno urbano. Por otro lado, @Shahat2021 menciona que el desarrollo de los Gemelos Digitales para ciudades ha sido relativamente rápido, y se espera que provea potencial para el mejoramiento de la gestión de las ciudades y la calidad de vida de sus ciudadanos.

  Parte importante de lo anterior es el poder comprender los patrones de movilidad de la gente, lo cual puede aportar a la planificación urbana y operaciones de transporte, tales como los sistemas de control de tráfico. Para esto, se hace necesario el correcto modelamiento del tráfico urbano para el desarrollo de una réplica precisa a nivel digital. 

  == Simulaciones de tráfico con SUMO para el desarrollo de gemelos digitales

  Dentro del uso de SUMO para el desarrollo de gemelos digitales, destaca el trabajo titulado _"Getting Real: the Challenge of Building and Validating a Large-Scale Digital Twin of Barcelona's Traffic with Empirical Data"_ de Javier Argota Sánchez-Vaquerizo @Argota2022, el cual busca implementar una microsimulación de tráfico basada en agentes a gran escala de la ciudad de Barcelona utilizando SUMO, para mostrar las posibilidades y desafíos de construir estos escenarios basados en grandes cantidades de datos de alta granularidad, concluyendo que si bien es posible obtener simulaciones de estos escenarios, se hace necesario obtener más y mejores métodos de recolección y análisis de datos, mientras que el desarrollo de modelos más precisos y realistas sigue siendo un desafío.

  Por otro lado, @Kuvsic2022 se enfoca en la aplicación de simulaciones microscópicas en SUMO con datos reales de alta granularidad para el Gemelo Digital de la autopista de Geneva. En este trabajo, los autores destacan el mecanismo de calibración dinámica del flujo vehicular y el re-enrutamiento dinámico por medio de TraCI, características necesarias para el modelamiento de un Gemelo Digital.

  Otro resultado relevante es el que presenta @Azevedo2024, trabajo que utiliza Gemelos Digitales para enfrentar los desafíos de performance que presenta la integración de diversas tecnologías y plataformas de datos en torno a la movilidad vehicular. Azevedo et. al. recurren al _software_ SUMO para evaluar la eficiencia y confiabilidad de la arquitectura de datos vehiculares, destacando como resultado relevante la observación de que hubo un aumento significativo del uso de CPU durante la simulación, alcanzando valores máximos, como se puede observar en la siguiente tabla:

  #figure(
      table(
          columns: 4,
          table.header(
              [*Tiempo de simulación*],
              [*Uso promedio de CPU*],
              [*Uso máximo de CPU*],
              [*Uso promedio de memoria*]
          ),
          [Antes],
          [2.3%], [2.6%], [1.7%],
          [Durante],
          [63.43%], [99.9%], [1.86%],
          [Después],
          [2.3%], [2.6%], [1.7%],
      )
  )

  A partir de esto, surge la necesidad de explorar vías de mejoramiento en la _performance_ de las simulaciones, de manera que se optimice el uso de recursos computacionales para el funcionamiento esperado del Gemelo Digital.

  == Simulaciones de tráfico vehicular urbano en High-Performance Computing

  Respecto al uso de simuladores de tráfico vehicular urbano en ambientes de High-Performance Computing, existe un precedente puesto por Klefstad et. al. @Klefstad2005 presentando ParamGrid, un framework sincronizado y escalable que distribuye una simulación a través de un _cluster_ de _performance_ ordinaria, compuesto por computadores personales de bajo costo. Este trabajo utiliza el simulador PARAMICS y se muestra que el _speedup_ de las simulaciones aumenta de forma lineal de acuerdo al número de computadores presentes en el _cluster_. Sin embargo, y dadas las limitaciones que presenta, se señala como trabajo futuro el mejoramiento del algoritmo de partición de las redes de caminos basado en la carga computacional anticipada, además de establecer como necesario el estudio sobre la distribución dinámica de carga vehicular y la implementación de enrutamientos globales más eficientes.

  Más adelante, Suzumura et. al. presentan una plataforma de simulaciones de tráfico multi-modal y altamente escalable @Suzumura2015. Si bien el estudio de _performance_ correspondiente demuestra que el simulador es 15.5 veces más rápido que el tiempo real con 12 _threads_ en paralelo, se propone como trabajo futuro una mejora dentro de la precisión de las simulaciones por medio de la calibración de los agentes y la introducción de la búsqueda del camino más corto en relación al tiempo de viaje para los algoritmos de enrutamiento. Fuera de ello, no se hace mención a la portabilidad del simulador para otros entornos de High-Performance Computing.

  Por otro lado, Umemoto et. al. realizan una serie de simulaciones implementadas en SUMO sobre la ciudad de Kobe para su ejecución en el supercomputador K @Umemoto2019. Los resultados arrojan que una demanda alta de simulaciones requiere un mayor tiempo para empezar a ejecutarse, mientras que los tiempos de simulación llegaron a ser incluso el doble de lo que toma la misma simulación en una CPU convencional.

  Finalmente, durante el año 2021 se presenta el trabajo de Franchi et. al., el cual implementa un pipeline para simulación de vehículos autónomos utilizando Webots y SUMO en paralelo en un _cluster_ HPC (Palmetto Cluster) @Franchi2021. Si bien los resultados muestran una mejora en la performance de las simulaciones multimodales, se destaca que es necesario tener en cuenta el _overhead_ que implica el levantamiento de las simulaciones y la escritura de resultados por cada simulación ejecutada en paralelo.
]

#capitulo(title: "Resultados")[
  A continuación, se muestran los resultados obtenidos para el test de carga de la versión paralelizada de las simulaciones implementadas en SUMO, considerando para ello las distintas frecuencias de inserción de vehículos definidas para cada _set_ de simulaciones y los tiempos de ejecución promedio para cada una. Para estas mediciones, se consideraron cinco conjuntos de particiones de diferentes tamaños: 4, 8, 16, 32 y 64 particiones. Para cada uno de estos conjuntos, se ejecutaron 1000 simulaciones, a saber, 50 simulaciones por cada frecuencia de inserción de vehículos definida.

  #figure(
      grid(
          columns: 2,
          gutter: 1mm,
          image("graficos/1_particion.png", width: 91%),
          image("graficos/4_particiones.png", width: 91%)
      ),
      caption: [Resultados para la prueba de escalabilidad basada en la carga de tráfico vehicular para la versión paralelizada de SUMO para 1 y 4 particiones.]
  ) <figura_11>

  #figure(
    grid(
        columns: 2,
        gutter: 1mm,
        image("graficos/8_particiones.png", width: 91%),
        image("graficos/16_particiones.png", width: 91%),
    ),
    caption: [Resultados para la prueba de escalabilidad basada en la carga de tráfico vehicular para la versión paralelizada de SUMO para 8 y 16 particiones.]
  ) <figura_12>

  #figure(
    grid(
        columns: 2,
        gutter: 1mm,
        image("graficos/32_particiones.png", width: 91%),
        image("graficos/64_particiones.png", width: 91%)
    ),
    caption: [Resultados para la prueba de escalabilidad basada en la carga de tráfico vehicular para la versión paralelizada de SUMO para 32 y 64 particiones.]
  ) <figura_13>

Como es posible observar, la cota superior para el crecimiento de los tiempos de simulación para cada conjunto de particiones disminuye significativamente en comparación a una versión secuencial de éstas (es decir, una simulación que considera una única partición). Un detalle importante a observar dentro de estos resultados radica en la cota superior para las ejecuciones de los _sets_ de 64 particiones, ya que se muestra ligeramente mayor respecto a la cota para los _sets_ de 32 particiones.

Para estudiar más a fondo la escalabilidad de la solución propuesta, resulta necesario realizar una comparación entre los crecimientos de los tiempos de simulación para cada conjunto de particiones, además de contrastarlos con la versión secuencial. El siguiente gráfico muestra dichas diferencias, mostrando el comportamiento de cada conjunto de particiones al momento de ejecutar cada simulación para cada frecuencia de inserción definida:

  #figure(
      image("graficos/comparativo.png", width: 90%),
      caption: [Comparación de escalabilidad de simulaciones con su versión secuencial.]
  )<figura_14>

De aquí es posible observar que, si bien para frecuencias pequeñas no resulta eficiente una paralelización con 32 y 64 particiones, a medida que se aumenta el número de particiones los tiempos de simulación exhiben un comportamiento mucho más lineal, mientras que para altas tasas de inserción de vehículos, en la mayoría de los casos los tiempos de simulación tienden a converger, lo cual deja interpretar que, en casos de simulaciones con alta congestión de tráfico vehicular, no resulta más eficiente la solución que posea mayor número de particiones.

Por otro lado, el _speedup_ para cada _set_ de simulaciones, es decir, la medida de aceleración de la solución, se calcula mediante la razón entre los tiempos originales de ejecución y los tiempos de ejecución de la solución propuesta. Mediante dicho cálculo, se obtuvieron los resultados que se muestran en las siguientes tablas, los cuales muestran que en gran parte de los casos, logró obtenerse un speedup superior al 5% esperado:

#let speedup_4 = csv("resultados_csv/speedup_4.csv")
#let speedup_8 = csv("resultados_csv/speedup_8.csv")
#stack(
    dir: ltr,
    1fr,
    figure(
        table(
        columns: 3,
        ..speedup_4.flatten()
        ),
        caption: [Speedup para 4 particiones]
    ),
    1fr,
    figure(
        table(
        columns: 3,
        ..speedup_8.flatten()
        ),
        caption: [Speedup para 8 particiones]
    ),
    1fr
)<speedup_1>

#let speedup_16 = csv("resultados_csv/speedup_16.csv")
#let speedup_32 = csv("resultados_csv/speedup_32.csv")
#let speedup_64 = csv("resultados_csv/speedup_64.csv")
#stack(
    dir: ltr,
    spacing: 1fr,
    figure(
        table(
        columns: 3,
        ..speedup_16.flatten()
        ),
        caption: [Speedup para 16 particiones]
    ),
    figure(
        table(
        columns: 3,
        ..speedup_32.flatten()
        ),
        caption: [Speedup para 32 particiones]
    )
)<speedup_2>

#figure(
    table(
        columns: 3,
        ..speedup_64.flatten()
    ),
    caption: [Speedup para 64 particiones]
)<speedup_3>

El siguiente gráfico muestra con mayor claridad la variación del _speedup_ para cada set de simulaciones. Aquí es posible observar que, a medida que aumentamos el número de particiones, la tendencia general del _speedup_ de las simulaciones para cada punto mejorará; sin embargo, para simulaciones con alta carga de tráfico vehicular, la _performance_ de la solución propuesta disminuirá, llegando a ser similar a la solución secuencial:

#figure(
    image("graficos/speedup.png", width: 70%),
    caption: [Comparación del _speedup_ para distintos conjuntos de particiones.]
) <speedup>

Por otro lado, es posible calcular la eficiencia de la paralelización mediante la razón entre el _speedup_ y el número de particiones realizadas. Esto nos da una idea de qué tan eficiente es la solución en relación a la versión secuencial (ejecutada mediante un solo nodo). Los resultados obtenidos de este cálculo se resumen en el siguiente gráfico, el cual muestra que la mayor eficiencia se obtiene con números bajos de particiones (menor a 32):

#figure(
    image("graficos/efficiency.png", width: 70%),
    caption: [Comparación de la eficiencia de paralelización para distintos conjuntos de particiones.]
)<eficiencia>

  En cuanto al uso de CPU para cada set de simulaciones, se obtiene el siguiente gráfico comparativo entre la escalabilidad de cada número de particiones realizadas:

  #figure(
      image("resultados_test_de_carga/cpu_usage_fixed.png", width: 70%),
      caption: [Comparación de escalabilidad de uso de CPU por simulaciones ejecutadas con diferentes números de particiones.]
  )
]

#capitulo(title: "Discusión", label: <discusion>)[
  Como es posible observar de la @figura_11, la @figura_12 y la @figura_13, existe una gran diferencia entre la escalabilidad de la versión secuencial de una simulación y las versiones paralelizadas, teniendo estas últimas una cota superior considerablemente inferior a la cota superior de tiempo de las simulaciones no paralelizadas, lo cual muestra que las versiones paralelas de las simulaciones son más eficientes en cuanto al tiempo de ejecución de éstas.

  Adicionalmente, es posible extraer de la @figura_14 que, a medida que se aumenta la cantidad de particiones, el escalamiento de las simulaciones aparenta ser cada vez más lineal, implicando también un mayor costo para las simulaciones con menor tasa de inserción de vehículos para simulaciones de grandes cantidades de particiones, pero un menor crecimiento en cuanto a los tiempos de ejecución de las simulaciones.

  Asímismo, el aumento en el _speedup_ mostrado en la @speedup nos muestra que, si bien es posible llegar a tener tiempos hasta 40 veces mejores que en una versión secuencial para escenarios con una inserción de autos moderada, para escenarios con altas tasas de tráfico la _performance_ tiende a descender. En cuanto a la eficiencia de la solución planteada, la @eficiencia nos muestra que para un número de particiones también moderada (es decir, menor a 32 particiones), se tiene una alta eficiencia sobre los tiempos de simulación para frecuencias de generación de vehículos que se encuentran alrededor y bajo la mediana, mientras que para escenarios con mayor congestión de tráfico la eficiencia de la solución propuesta tiende a ser más baja.

  Cabe considerar en estos resultados dos aspectos importantes: el balance de las cargas en las particiones y la pérdida de información al realizar el corte de rutas.

  Por un lado, el algoritmo aplicado para el particionamiento de los grafos correspondientes a la representación de los mapas conlleva un desbalance entre la cantidad de nodos presentes en las particiones que es importante considerar, ya que existen particiones que superan considerablemente a otras en este aspecto. Esto puede provocar que la escalabilidad de la solución se vea sujeta principalmente a la escalabilidad que ofrezcan los nodos con mayor carga, en vez de cada una de las particiones realizadas.

  Por otro lado, el proceso de recorte de rutas según las particiones realizadas a los mapas implica una pérdida de información necesaria a considerar, dado que implica una menor carga para los nodos de ejecución, al eliminar vehículos cuyas rutas no cumplen con los criterios definidos por el algoritmo de particionamiento de rutas provisto por _cutRoutes.py_. Un posible trabajo a futuro consiste en revisitar este algoritmo para poder manejar de otra manera el corte de las rutas con los tiempos de partida de los vehículos y, de esta manera, evitar dicha pérdida de información.

  En cuanto a los procesos de sincronización, se hace necesario implementar una manera de gestionar los tiempos de partida de los vehículos, de forma que no se produzca el fenómeno descrito en la @impedimentos y las rutas particionadas no queden como rutas independientes, sino que posean dependencia de unas con otras entre los nodos de ejecución. Dentro de la implementación también resulta necesario considerar el _overhead_ que implican los procesos de comunicación entre los nodos, lo cual podría afectar de manera considerable a la escalabilidad de la solución ya implementada.

  En cuanto al uso de CPU, es posible observar que hasta en las condiciones menos óptimas se llega a un uso de alrededor del 80%, lo cual sugiere una mejora en cuanto al uso de recursos computacionales respecto a la solución secuencial, que ocupa, en el general de los casos, el 100% de la CPU que se le asigna para el proceso de simulación. 

  Cabe considerar, además, que la ejecución de estos experimentos fue realizada en un computador Intel#sym.trademark.registered Core#sym.trademark i7-106G7 CPU \@2,30GHz, dado que por problemas que escapan al alcance de esta tesis, no fue posible llevarla a cabo en un ambiente de supercomputación. Sin embargo, es posible replicar estos experimentos en supercomputadores dada la contenerización de los procesos de SUMO en _Singularity_, lo cual mantiene al _software_ portable para estos entornos.
]

#capitulo(title: "Conclusiones")[
  Durante este trabajo, se desarrolló un sistema de paralelización de simulaciones de tráfico vehicular urbano a partir del uso del _software_ SUMO, orientado a su uso en supercomputadores por medio de la herramienta de paralelización _OpenMP_. Esto, con el objetivo de estudiar la escalabilidad de una solución al problema de los costos en CPU y tiempos de ejecución para estas simulaciones, de manera que puedan insertarse de manera eficiente a proyectos tales como el desarrollo de _Gemelos Digitales_ para ciudades.

  Dentro de la investigación, se plantearon preguntas en torno al mejoramiento en la _performance_ de las simulaciones; en particular, si es que es posible optimizarla y cómo influyen el área a simular y la carga vehicular en el rendimiento de las ejecuciones. A partir de los resultados obtenidos y lo discutido en el @discusion, es posible concluir que si bien es posible mejorar la _performance_ de las simulaciones de tráfico vehicular urbano mediante la paralelización de sus procesos, es necesario tener en cuenta el _overhead_ que implica la necesidad de procesos de sincronización entre los nodos de ejecución, dado que en el _pipeline_ para llegar a la paralelización ocurre pérdida de información que se debe manejar si se quiere mantener la precisión y la alta granularidad de las simulaciones.

  Adicionalmente, se concluye que únicamente con paralelización, el escalamiento de las simulaciones en cuanto a tiempos de ejecución se _lineariza_ a medida que se aumenta el número de particiones; es decir, que pasan de mostrar un comportamiento exponencial a uno más lineal. Mientras tanto, el uso de CPU pasa de ser constante en un 100% de la CPU asignada a las simulaciones a un máximo del 80% de ésta, manteniéndose variable en función del número de particiones realizadas y la frecuencia de inserción de vehículos en la simulación. Respecto al comportamiento de los tiempos de ejecución en función del tamaño del mapa, se tiene que estos crecen de forma lineal a medida que la red de caminos lo hace; por lo tanto, se concluye que este no resulta ser un factor determinante al momento de considerar las variables que afectan de manera significativa la escalabilidad tanto de las simulaciones secuenciales como las paralelizadas.

  Finalmente, se consideran diferentes vías de trabajo futuro para el mejoramiento de las simulaciones en cuanto a su precisión y la pérdida de información en el proceso de corte de rutas para su paralelización. 

  En primer lugar, se plantea la necesidad del desarrollo de un mecanismo que maneje de manera apropiada los tiempos de partida de los vehículos que se insertan o salen de cada nodo de ejecución, además de determinar el destino de aquellas rutas que por defecto descarta la herramienta _cutRoutes.py_, con el objetivo de obtener una mayor precisión y una menor pérdida de información al momento de particionar las simulaciones.

  Por otro lado, se presenta como un posible trabajo a futuro el estudio de la escalabilidad de simulaciones sincronizadas considerando el _overhead_ que implica la comunicación entre los nodos, además del estudio y comparación de estas soluciones en un ambiente de supercomputación.

  Otro aspecto importante a considerar es la elección del algoritmo de particionamiento de grafos a utilizar para preparar la paralelización de las simulaciones; si bien en el presente trabajo se hizo uso únicamente del algoritmo de _SPartSim_, es posible realizar comparaciones sobre la _performance_ de las simulaciones en función del algoritmo de particionamiento elegido.

  El trabajo aquí desarrollado deja la posibilidad de continuar expandiendo la línea del conocimiento sobre la paralelización de simulaciones que, en un futuro próximo, podrá aportar una gran utilidad para el desarrollo de modelos tales como los _Gemelos Digitales_ para ciudades, los cuales pretenden ser una herramienta de mejoramiento en la calidad de vida de millones de personas alrededor del mundo por medio de la implementación de dinámicas y políticas públicas de manera más informada, eficiente y segura, por medio del modelamiento computacional de los entornos y sus dinámicas.
]

#show: end-doc

#apendice(title: "Ejemplos de archivos")[
    == Archivo `XML` para la descripción de redes de caminos en SUMO
    ```xml
<?xml version="1.0" encoding="UTF-8"?>

<!-- generated on 2025-01-11 20:15:28 by Eclipse SUMO netgenerate Version v1_17_0+0507-8eb8f3bd1d0
<configuration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://sumo.dlr.de/xsd/netgenerateConfiguration.xsd">

    <grid_network>
        <grid value="true"/>
        <grid.number value="2"/>
    </grid_network>

</configuration>
-->

<net version="1.16" junctionCornerDetail="5" limitTurnSpeed="5.50" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://sumo.dlr.de/xsd/net_file.xsd">

<location netOffset="0.00,0.00" convBoundary="0.00,0.00,100.00,100.00" origBoundary="0.00,0.00,100.00,100.00" projParameter="!"/>

    <edge id=":A0_0" function="internal">
        <lane id=":A0_0_0" index="0" speed="6.08" length="7.74" shape="-1.60,3.20 -1.30,1.10 -0.40,-0.40 1.10,-1.30 3.20,-1.60"/>
    </edge>
    <edge id=":A0_1" function="internal">
        <lane id=":A0_1_0" index="0" speed="3.90" length="2.58" shape="3.20,1.60 2.50,1.70 2.00,2.00 1.70,2.50 1.60,3.20"/>
    </edge>
    <edge id=":A1_0" function="internal">
        <lane id=":A1_0_0" index="0" speed="6.08" length="7.74" shape="3.20,101.60 1.10,101.30 -0.40,100.40 -1.30,98.90 -1.60,96.80"/>
    </edge>
    <edge id=":A1_1" function="internal">
        <lane id=":A1_1_0" index="0" speed="3.90" length="2.58" shape="1.60,96.80 1.70,97.50 2.00,98.00 2.50,98.30 3.20,98.40"/>
    </edge>
    <edge id=":B0_0" function="internal">
        <lane id=":B0_0_0" index="0" speed="3.90" length="2.58" shape="98.40,3.20 98.30,2.50 98.00,2.00 97.50,1.70 96.80,1.60"/>
    </edge>
    <edge id=":B0_1" function="internal">
        <lane id=":B0_1_0" index="0" speed="6.08" length="7.74" shape="96.80,-1.60 98.90,-1.30 100.40,-0.40 101.30,1.10 101.60,3.20"/>
    </edge>
    <edge id=":B1_0" function="internal">
        <lane id=":B1_0_0" index="0" speed="6.08" length="7.74" shape="101.60,96.80 101.30,98.90 100.40,100.40 98.90,101.30 96.80,101.60"/>
    </edge>
    <edge id=":B1_1" function="internal">
        <lane id=":B1_1_0" index="0" speed="3.90" length="2.58" shape="96.80,98.40 97.50,98.30 98.00,98.00 98.30,97.50 98.40,96.80"/>
    </edge>

    <edge id="A0A1" from="A0" to="A1" priority="-1">
        <lane id="A0A1_0" index="0" speed="13.89" length="93.60" shape="1.60,3.20 1.60,96.80"/>
    </edge>
    <edge id="A0B0" from="A0" to="B0" priority="-1">
        <lane id="A0B0_0" index="0" speed="13.89" length="93.60" shape="3.20,-1.60 96.80,-1.60"/>
    </edge>
    <edge id="A1A0" from="A1" to="A0" priority="-1">
        <lane id="A1A0_0" index="0" speed="13.89" length="93.60" shape="-1.60,96.80 -1.60,3.20"/>
    </edge>
    <edge id="A1B1" from="A1" to="B1" priority="-1">
        <lane id="A1B1_0" index="0" speed="13.89" length="93.60" shape="3.20,98.40 96.80,98.40"/>
    </edge>
    <edge id="B0A0" from="B0" to="A0" priority="-1">
        <lane id="B0A0_0" index="0" speed="13.89" length="93.60" shape="96.80,1.60 3.20,1.60"/>
    </edge>
    <edge id="B0B1" from="B0" to="B1" priority="-1">
        <lane id="B0B1_0" index="0" speed="13.89" length="93.60" shape="101.60,3.20 101.60,96.80"/>
    </edge>
    <edge id="B1A1" from="B1" to="A1" priority="-1">
        <lane id="B1A1_0" index="0" speed="13.89" length="93.60" shape="96.80,101.60 3.20,101.60"/>
    </edge>
    <edge id="B1B0" from="B1" to="B0" priority="-1">
        <lane id="B1B0_0" index="0" speed="13.89" length="93.60" shape="98.40,96.80 98.40,3.20"/>
    </edge>

    <junction id="A0" type="priority" x="0.00" y="0.00" incLanes="A1A0_0 B0A0_0" intLanes=":A0_0_0 :A0_1_0" shape="-3.20,3.20 3.20,3.20 3.20,-3.20 -0.36,-2.49 -1.60,-1.60 -2.49,-0.36 -3.02,1.24">
        <request index="0" response="00" foes="00" cont="0"/>
        <request index="1" response="00" foes="00" cont="0"/>
    </junction>
    <junction id="A1" type="priority" x="0.00" y="100.00" incLanes="B1A1_0 A0A1_0" intLanes=":A1_0_0 :A1_1_0" shape="3.20,103.20 3.20,96.80 -3.20,96.80 -2.49,100.36 -1.60,101.60 -0.36,102.49 1.24,103.02">
        <request index="0" response="00" foes="00" cont="0"/>
        <request index="1" response="00" foes="00" cont="0"/>
    </junction>
    <junction id="B0" type="priority" x="100.00" y="0.00" incLanes="B1B0_0 A0B0_0" intLanes=":B0_0_0 :B0_1_0" shape="96.80,3.20 103.20,3.20 102.49,-0.36 101.60,-1.60 100.36,-2.49 98.76,-3.02 96.80,-3.20">
        <request index="0" response="00" foes="00" cont="0"/>
        <request index="1" response="00" foes="00" cont="0"/>
    </junction>
  <junction id="B1" type="priority" x="100.00" y="100.00" incLanes="B0B1_0 A1B1_0" intLanes=":B1_0_0 :B1_1_0" shape="103.20,96.80 96.80,96.80 96.80,103.20 100.36,102.49 101.60,101.60 102.49,100.36 103.02,98.76">
        <request index="0" response="00" foes="00" cont="0"/>
        <request index="1" response="00" foes="00" cont="0"/>
    </junction>

    <connection from="A0A1" to="A1B1" fromLane="0" toLane="0" via=":A1_1_0" dir="r" state="M"/>
    <connection from="A0B0" to="B0B1" fromLane="0" toLane="0" via=":B0_1_0" dir="l" state="M"/>
    <connection from="A1A0" to="A0B0" fromLane="0" toLane="0" via=":A0_0_0" dir="l" state="M"/>
    <connection from="A1B1" to="B1B0" fromLane="0" toLane="0" via=":B1_1_0" dir="r" state="M"/>
    <connection from="B0A0" to="A0A1" fromLane="0" toLane="0" via=":A0_1_0" dir="r" state="M"/>
    <connection from="B0B1" to="B1A1" fromLane="0" toLane="0" via=":B1_0_0" dir="l" state="M"/>
    <connection from="B1A1" to="A1A0" fromLane="0" toLane="0" via=":A1_0_0" dir="l" state="M"/>
    <connection from="B1B0" to="B0A0" fromLane="0" toLane="0" via=":B0_0_0" dir="r" state="M"/>

    <connection from=":A0_0" to="A0B0" fromLane="0" toLane="0" dir="l" state="M"/>
    <connection from=":A0_1" to="A0A1" fromLane="0" toLane="0" dir="r" state="M"/>
    <connection from=":A1_0" to="A1A0" fromLane="0" toLane="0" dir="l" state="M"/>
    <connection from=":A1_1" to="A1B1" fromLane="0" toLane="0" dir="r" state="M"/>
    <connection from=":B0_0" to="B0A0" fromLane="0" toLane="0" dir="r" state="M"/>
    <connection from=":B0_1" to="B0B1" fromLane="0" toLane="0" dir="l" state="M"/>
    <connection from=":B1_0" to="B1A1" fromLane="0" toLane="0" dir="l" state="M"/>
    <connection from=":B1_1" to="B1B0" fromLane="0" toLane="0" dir="r" state="M"/>

</net>
    ```

    #pagebreak()
    == Archivo `XML` para la descripción de rutas en SUMO
    ```xml
<?xml version="1.0" encoding="UTF-8"?>

<!-- generated on 2025-01-11 20:19:48 by Eclipse SUMO duarouter Version v1_17_0+0507-8eb8f3bd1d0
<configuration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://sumo.dlr.de/xsd/duarouterConfiguration.xsd">

    <input>
        <net-file value="net.net.xml"/>
        <route-files value="trips.trips.xml"/>
    </input>

    <output>
        <output-file value="routes.rou.xml"/>
    </output>

    <report>
        <ignore-errors value="true"/>
    </report>

</configuration>
-->

<routes xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://sumo.dlr.de/xsd/routes_file.xsd">
    <vehicle id="1" depart="1.00">
        <route edges="A1A0 A0B0"/>
    </vehicle>
    <vehicle id="2" depart="2.00">
        <route edges="B0B1"/>
    </vehicle>
    <vehicle id="3" depart="3.00">
        <route edges="B1B0 B0A0 A0A1"/>
    </vehicle>
    <vehicle id="4" depart="4.00">
        <route edges="A1B1 B1B0 B0A0 A0A1"/>
    </vehicle>
    <vehicle id="10" depart="10.00">
        <route edges="B1A1 A1A0 A0B0 B0B1"/>
    </vehicle>
    <vehicle id="11" depart="11.00">
        <route edges="A1A0 A0B0"/>
    </vehicle>
    <vehicle id="13" depart="13.00">
        <route edges="A0A1"/>
    </vehicle>
    <vehicle id="15" depart="15.00">
        <route edges="B1A1 A1A0 A0B0 B0B1"/>
    </vehicle>
    <vehicle id="16" depart="16.00">
        <route edges="B0A0 A0A1 A1B1 B1B0"/>
    </vehicle>
    <vehicle id="17" depart="17.00">
        <route edges="A1B1 B1B0 B0A0"/>
    </vehicle>
    <vehicle id="21" depart="21.00">
        <route edges="A0B0 B0B1 B1A1 A1A0"/>
    </vehicle>
    <vehicle id="24" depart="24.00">
        <route edges="B0B1 B1A1 A1A0"/>
    </vehicle>
    <vehicle id="25" depart="25.00">
        <route edges="A1A0 A0B0"/>
    </vehicle>
    <vehicle id="28" depart="28.00">
        <route edges="A0B0 B0B1"/>
    </vehicle>
    <vehicle id="32" depart="32.00">
        <route edges="B1A1"/>
    </vehicle>
    <vehicle id="34" depart="34.00">
        <route edges="A1A0"/>
    </vehicle>
    <vehicle id="38" depart="38.00">
        <route edges="B1B0 B0A0 A0A1 A1B1"/>
    </vehicle>
    <vehicle id="39" depart="39.00">
        <route edges="A1A0 A0B0"/>
    </vehicle>
    <vehicle id="41" depart="41.00">
        <route edges="B0A0 A0A1 A1B1 B1B0"/>
    </vehicle>
    <vehicle id="43" depart="43.00">
        <route edges="B1B0 B0A0"/>
    </vehicle>
    <vehicle id="44" depart="44.00">
        <route edges="A0A1"/>
    </vehicle>
    <vehicle id="47" depart="47.00">
        <route edges="A0A1 A1B1"/>
    </vehicle>
    <vehicle id="48" depart="48.00">
        <route edges="B1B0 B0A0"/>
    </vehicle>
</routes>
    ```
    #pagebreak()
    == Archivo `XML` para la configuración de una simulación en SUMO
    ```xml
<?xml version="1.0" ?>
<configuration xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:noNamespaceSchemaLocation="http://sumo.dlr.de/xsd/sumoConfiguration.xsd">
    <input>
		<net-file value="net.net.xml"/>
		<route-files value="routes.rou.xml"/>
    </input>
    <processing>
            <ignore-route-errors value="true"/>
    </processing>
    <routing>
        <device.rerouting.adaptation-steps value="18"/>
        <device.rerouting.adaptation-interval value="10"/>
    </routing>
    <report/>
    <gui_only/>
</configuration>
    ```

    #pagebreak()
    == Resultados para tiempos de ejecución de simulaciones secuenciales
    #let results_1 = csv("resultados_csv/results_1_partitions.csv")
    #figure(
        table(
        columns: 2,
        ..results_1.flatten()
        ),
        caption: [Tiempos para simulación secuencial]
    )
    #pagebreak()
    == Resultados para tiempos de ejecución de simulaciones paralelizadas

    #linebreak()
    #let results_4 = csv("resultados_csv/results_4_partitions.csv")
    #let results_8 = csv("resultados_csv/results_8_partitions.csv")
    #let results_16 = csv("resultados_csv/results_16_partitions.csv")
    #stack(
        dir: ltr,
        spacing: 1fr,
        figure(
            table(
            columns: 2,
            ..results_4.flatten()
            ),
            caption: [4 particiones]
        ),
        figure(
            table(
            columns: 2,
            ..results_8.flatten()
            ),
            caption: [8 particiones]
        ),
        figure(
            table(
            columns: 2,
            ..results_16.flatten()
            ),
            caption: [16 particiones]
        )
    )
    
    #pagebreak()
    #let results_32 = csv("resultados_csv/results_32_partitions.csv")
    #let results_64 = csv("resultados_csv/results_64_partitions.csv")
    #stack(
        dir: ltr,
        1fr,
        figure(
            table(
            columns: 2,
            ..results_32.flatten()
            ),
            caption: [32 particiones]
        ),
        1fr,
        figure(
            table(
            columns: 2,
            ..results_64.flatten()
            ),
            caption: [64 particiones]
        ),
        1fr
    )
    
    #pagebreak()
    == Resultados para la eficiencia de paralelización de la solución propuesta
    #let ef_4 = csv("resultados_csv/efficiency_4.csv")
    #let ef_8 = csv("resultados_csv/efficiency_8.csv")
    #figure(
        table(
            columns: 4,
            ..ef_4.flatten()
        ),
        caption: [Eficiencia calculada para 4 particiones]
    )
    #figure(
        table(
            columns: 4,
            ..ef_8.flatten()
        ),
        caption: [Eficiencia calculada para 8 particiones]
    )
    #let ef_16 = csv("resultados_csv/efficiency_16.csv")
    #let ef_32 = csv("resultados_csv/efficiency_32.csv")
    #let ef_64 = csv("resultados_csv/efficiency_64.csv")
    #figure(
        table(
            columns: 4,
            ..ef_16.flatten()
        ),
        caption: [Eficiencia calculada para 16 particiones]
    )
    #figure(
        table(
            columns: 4,
            ..ef_32.flatten()
        ),
        caption: [Eficiencia calculada para 32 particiones]
    )
    #figure(
        table(
            columns: 4,
            ..ef_64.flatten()
        ),
        caption: [Eficiencia calculada para 64 particiones]
    )
]