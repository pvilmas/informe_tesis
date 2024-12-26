#import "final.typ": conf, guia, pronombre, resumen, dedicatoria, agradecimientos, start-doc, capitulo
#import "@preview/fletcher:0.5.1" as fletcher: diagram, node, edge
#let mostrar_guias = false
#show: conf.with(
    titulo: "Paralelización de procesos de modelamiento de tráfico urbano por medio de la contenerización del software Simulation of Urban MObility (SUMO) para Supercomputadores",
    autor: (nombre: "Pablo Villar Mascaró", pronombre: pronombre.elle),
    profesores: ((nombre: "Javier Bustos Jiménez", pronombre: pronombre.el),),
    coguias: ((nombre: "Patricio Reyes", pronombre: pronombre.el),),
    comision: ("NOMBRE COMPLETO UNO", "NOMBRE COMPLETO DOS", "NOMBRE COMPLETO TRES"),
    anno: "2024",
    tesis: true,
    grado-titulo: "COMPUTACIÓN",
    espaciado_titulo: 2fr,
)

#resumen[
    #lorem(150)
    
    #lorem(100)
    
    #lorem(100)
]

#dedicatoria[
    Para todos los amores paralelos de mi vida
    #figure(image("dedicatoria.png"))
    por todo su cariño y soporte a través de estos años inciertos y hostiles.
    
]

#agradecimientos[
    Quiero partir agradeciendo a Javier Bustos, mi profesor guía, y a Patricio Reyes, mi profesor coguía, por la oportunidad de realizar este trabajo, la paciencia, los consejos y la buena convivencia durante estos dos años de tesis. Asimismo, quiero agradecer al equipo completo de NIC Labs y del _Data Analytics and Visualization Group_ del _Barcelona Supercomputing Center_ por el buen recibimiento y permitirme aprender y compartir con ustedes.

    Le debo la realización de este trabajo también a mi compañero de vida, Christopher Marín, Puntito, por ayudarme continuamente a depurar código, corazón y cabeza con su infinito amor, sabiduría y paciencia. Por todos estos meses de atravesar un camino incierto con la certeza de tu cariño y la esperanza de seguir construyendo juntos nuevos proyectos, nuevos juegos y nuevos horizontes.

    A Fran Zautzik, por esas conversaciones interminables con un tecito en mi departamento sobre nuestros trabajos que nos trajeron tantas ideas que en cierta medida nos hicieron avanzar y por acompañarme a aguantar hasta lograr lo que había que lograr.

    A mi familia, por su apoyo continuo y por soportarme en los peores tiempos para que al fin pudiera llegar a este punto.

    A mi mamá, a mi papá y a mi hermana Leticia, por todo el amor por la ciencia, las preguntas, las discusiones interesantes de sobremesa; por todo este viaje que me han ayudado a emprender y por los suyos propios que de alguna manera también han sido un aporte en mi vida y nos ha llevado a tener un lugar seguro y hermoso donde poder seguir desarrollándonos.

    A mi abuela Silvia, por la oportunidad de haber tenido una beca que, lamentablemente, fue otorgada a nuestra familia como "compensación" por las violaciones a nuestros Derechos Humanos. Siempre van a vivir en mí, de forma contradictoria, el agradecimiento por haber podido estudiar una carrera y la rabia que me produce la necesidad de una justicia real, con una reparación real, para que nunca más hayamos estudiantes cuya única oportunidad para estudiar en la educación superior se basa en haber tenido familiares torturados y desaparecidos. Esta es por ti, bueli, que hasta el día de hoy me enseñas lo importante que es mantenerse fiel a los principios y luchar con todo hasta el final.

    A mi abuela Katy, por sus llamadas a deshoras que siempre me animaron cuando más lo necesitaba, y por todo el apoyo y paciencia que nos hemos brindado durante todos estos años; tu cariño es una de las cosas que me mantienen en pie todos los días.

    A mi tía Katy, por ese amor infinito que sólo ella sabe dar de forma tan abnegada; con su apoyo no sólo yo, sino que decenas de estudiantes, hemos podido progresar y encontrar un buen puerto en nuestras vidas. Gracias por enseñarme a querer al mundo y mirarlo con compasión, por enseñarme junto con mi mamá lo bonito y lo sacrificado que es dedicar la vocación al servicio de la gente, y por estar ahí conmigo desde que era un pequeño feto ingeniero.

    A mi tía Adelina, por acogerme en su casa y en sus brazos durante las partes más duras de la carrera y de la vida; por enseñarme sobre la vida en comunidad y ayudarme no solamente a formarme como profesional, sino que como persona. Gracias por tu generosidad tan grande y tu constante guía espiritual.

    A mis tíos, Teresa y Anselmo, por recibirme durante mis turbulentos primeros años de universidad. Sé que no fue fácil, pero agradezco infinitamente su paciencia y buena voluntad para acoger a un Pablo mechón e inexperto en la vida de la gran ciudad.

    A Paulo Sandoval, Tortita, por cuidarme, enseñarme a sobrevivir a la vida universitaria y presentarme el Departamento de Ciencias de la Computación. Gracias por todos los momentos decisivos de estos años, el cariño y por enseñarme a usar git cuando apenas era un mechón. Y a Felipe Borjas, por el apañe incondicional en las noches de insomnio y trabajo interminable para los ramos de la universidad.

    A les chiques de la crew: Junne, Lía, Francis, Gabito, Nico, por todo el amor, compañía y cuidados que nos hemos dado a través de los años, sin los cuales no hubiese podido tomar las decisiones que me llevaron a poder terminar la carrera haciendo lo que me gusta, siendo quien me gusta, queriendo como me gusta.

    A quienes se han ido dejando algo importante y valioso para ser quien soy en este momento, y a quienes a cuyo pesar tuve que seguir haciendo todo lo que logré hacer estos últimos años, gracias.

    "Deja que el blanco loto florezca orgulloso,
    
    pintado en mi espalda, mi voluntad no flaqueará.
    
    En el cielo libre, cierro mis ojos."

    #align(right)[-_"Lotus"_, Dir en Grey]
]

#show: start-doc

#capitulo(title: "Introducción")[
    El modelamiento de tráfico vehicular urbano por medio del uso de _software_ de simulación resulta ser de gran relevancia al momento de proveer información necesaria para diseños y decisiones en torno a la movilidad de distintos agentes dentro de un área determinada. En particular, se puede considerar crucial para el desarrollo de _Gemelos Digitales_ de ciudades y áreas metropolitanas. Un _Gemelo Digital_ consiste en "una representación de un producto activo o un sistema de productos-servicios único que incluye una selección de características, propiedades, condiciones y comportamientos por medio de modelos, información y datos a través de una o múltiples fases de su ciclo de vida" @Stark2019. Es decir, un _Gemelo Digital_ consiste en una representación en tiempo real de una entidad física en un ambiente digital @IETF_DT. En este contexto, el presente trabajo se desarrolla bajo la colaboración entre NIC Research Labs y el equipo de Data Analytics and Visualization Group del Barcelona Supercomputing Center (BSC) para la creación de una plataforma generadora de _Gemelos Digitales_ para las ciudades de Kobe (Japón) y Barcelona (España), los cuales tienen por objetivo contribuir a la toma de decisiones para la implementación de políticas de urbanismo en las ciudades, con el fin de mejorar la calidad de vida mediante la ejecución de cambios estructurales en éstas.

    En dicho sentido, el uso de estas herramientas de simulación cobra especial importancia al momento de querer obtener cierto nivel de precisión en el modelamiento de diferentes escenarios, tales como puntos de congestión y flujo de tráfico en horas críticas para la movilidad de las personas. Sin embargo, el obtener simulaciones detalladas a grandes escalas implica un alto costo en cuanto a recursos computacionales, por lo que durante los últimos años se ha buscado desarrollar métodos de distribución y paralelización de estos procesos, con el objetivo de optimizar los recursos disponibles para simular, por ejemplo, áreas metropolitanas grandes y concurridas.

    Dada esta problemática, la presente tesis aborda la implementación de una arquitectura de paralelización y sincronización para simulaciones de tráfico vehicular urbano orientada a su uso en supercomputadores, con el objetivo de estudiar la escalabilidad de simulaciones microscópicas (es decir, de alta granularidad), las cuales son realizadas mediante el _software_ SUMO, para áreas urbanas extensas y con alta carga de tráfico vehicular. Para esto, se propone el uso de herramientas orientadas a High-Performance Computing, tales como _Singularity Containers_ y _Message Passing Interface_ (MPI), lo cual permite tanto la contenerización de procesos y aplicaciones complejas para su uso en supercomputadores, como la comunicación y sincronización de dichos procesos. En este caso, este trabajo se encuentra orientado a su implementación en el supercomputador _MareNostrum_, ubicado en el Centro Nacional de Supercomputación de Barcelona. 

    En una etapa preliminar del proyecto, se realizó un estudio sobre la escalabilidad del _software_ de simulación en cuanto a los tiempos de ejecución y uso de CPU en un equipo Intel#sym.trademark.registered Core#sym.trademark i7-106G7 CPU \@2,30GHz. Dicho estudio señaló que existe un crecimiento exponencial respecto a los tiempos de ejecución de las simulaciones ejecutadas de forma secuencial, mientras que el uso de CPU se mantenía constante en, aproximadamente, un 100%.

    Posteriormente, el proyecto se dividió en tres etapas, a ser: la partición y contenerización de las simulaciones, la paralelización de las mismas, y la comunicación entre los procesos de simulación. En las tres etapas se hizo uso de _Singularity Containers_, mientras que en la tercera se sumó el uso de _OpenMP_.
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
            [2.3%], [2,6%], [1,7%],
            [Durante],
            [63.43%], [99.9%], [1.86%],
            [Después],
            [2.3%], [2,6%], [1,7%],
        )
    )

    A partir de esto, surge la necesidad de explorar vías de mejoramiento en la _performance_ de las simulaciones, de manera que se optimice el uso de recursos computacionales para el funcionamiento esperado del Gemelo Digital.

    == Simulaciones de tráfico vehicular urbano en High-Performance Computing

    Respecto al uso de simuladores de tráfico vehicular urbano en ambientes de High-Performance Computing, existe un precedente puesto por Klefstad et. al. @Klefstad2005 presentando ParamGrid, un framework sincronizado y escalable que distribuye una simulación a través de un _cluster_ de _performance_ ordinaria, compuesto por computadores personales de bajo costo. Este trabajo utiliza el simulador PARAMICS y se muestra que el _speedup_ de las simulaciones aumenta de forma lineal de acuerdo al número de computadores presentes en el _cluster_. Sin embargo, y dadas las limitaciones que presenta, se señala como trabajo futuro el mejoramiento del algoritmo de partición de las redes de caminos basado en la carga computacional anticipada, además de establecer como necesario el estudio sobre la distribución dinámica de carga vehicular y la implementación de enrutamientos globales más eficientes.

    Más adelante, Suzumura et. al. presentan una plataforma de simulaciones de tráfico multi-modal y altamente escalable @Suzumura2015. Si bien el estudio de _performance_ correspondiente demuestra que el simulador es 15.5 veces más rápido que el tiempo real con 12 _threads_ en paralelo, se propone como trabajo futuro una mejora dentro de la precisión de las simulaciones por medio de la calibración de los agentes y la introducción de la búsqueda del camino más corto en relación al tiempo de viaje para los algoritmos de enrutamiento. Fuera de ello, no se hace mención a la portabilidad del simulador para otros entornos de High-Performance Computing.

    Por otro lado, Umemoto et. al. realizan una serie de simulaciones implementadas en SUMO sobre la ciudad de Kobe para su ejecución en el supercomputador K @Umemoto2019. Los resultados arrojan que una demanda alta de simulaciones requiere un mayor tiempo para empezar a ejecutarse, mientras que los tiempos de simulación llegaron a ser incluso el doble de lo que toma la misma simulación en una CPU convencional.

    Finalmente, durante el año 2021 se presenta el trabajo de Franchi et. al., el cual implementa un pipeline para simulación de vehículos autónomos utilizando Webots y SUMO en paralelo en un _cluster_ HPC (Palmetto Cluster) @Franchi2021. Si bien los resultados muestran una mejora en la performance de las simulaciones multimodales, se destaca que es necesario tener en cuenta el _overhead_ que implica el levantamiento de las simulaciones y la escritura de resultados por cada simulación ejecutada en paralelo.

    == Paralelización de SUMO

    Durante los últimos años, han surgido distintas técnicas y herramientas que podrían facilitar las simulaciones de tráfico en paralelo aplicado a ambientes de High-Performance Computing, tales como supercomputadores. Algunas de estas son:

    + *Paralelización híbrida*: consiste en la combinación de múltiples técnicas de paralelización, incluyendo estándares de transmisión de mensajes para computación paralela tal como lo es MPI (_Message Passing Interface_), con el objetivo de alcanzar una mejor performance y escalabilidad. Esto permite una distribución más granular de tareas de simulación a través de múltiples nodos.
    + *Particionamiento de modelos*: refiere a la partición de modelos de simulación en submodelos que pueden ser ejecutados en paralelo, lo cual puede ayudar en reducir los costos de comunicación y mejorar la escalabilidad de las simulaciones.
    + *Simulaciones cloud-based*: implica la ejecución de modelos de simulación en Cloud Computing, lo cual ofrece la oportunidad de tener simulaciones más flexibles y escalables. Sin embargo, la latencia de la red y las posibles amenazas en torno a la seguridad de los datos son desventajas que esta opción presenta.

    Un estudio que aborda el problema de la paralelización de SUMO refiere a @Arroyave2018, en donde se presenta un modelo de particiones de mapa simplificadas para la simulación en paralelo de tráfico en zonas urbanas. Este modelo consiste en la división de las redes de caminos en forma de cuadrículas, lo cual incrementa el nivel de error de la simulación de manera proporcional con el número de particiones realizadas. Además de esto, dicho estudio señala que el método de paralelización presentado es más lento que su contraparte centralizada dado el proceso de sincronización implementado.

    Por otro lado, el trabajo titulado "QarSUMO: A Parallel, Congestion-optimized Traffic Simulator" @Chen2020, presenta una versión paralelizada de SUMO considerando la complejidad de la distribución de las redes de caminos por medio de la implementación de un esquema de partición de grafos no-regulares, abreviado como METIS @Karypis1998. Si bien este estudio logra establecer un método de paralelización de alto nivel, incrementando la eficiencia de las simulaciones para situaciones de alta congestión de tráfico, su alcance en cuanto a áreas urbanas no alcanza una escalabilidad a nivel de simulaciones completas al no considerar su implementación en ambientes de _High-Performance Computing_ tales como supercomputadores. Sumado a esto, el _software_ disminuye el nivel de granularidad de las simulaciones por medio de la simplificación del modelamiento de un gran número de vehículos a una sola entidad.

    == Pruebas de escalabilidad en SUMO

    En un estudio preliminar al desarrollo de este trabajo de tesis, se realizaron distintas pruebas de escalabilidad para observar el crecimiento de los tiempos de ejecución de SUMO en un computador personal. En particular, se realizaron dos pruebas de escalabilidad considerando dos aspectos importantes de los requerimientos para la creación de simulaciones de tráfico urbano: en primer lugar, se considera el tamaño de la red de caminos en número de aristas del grafo que representa el mapa, mientras que para el segundo se toma en consideración el número de agentes o vehículos por simulación.

    Ambos experimentos se encuentran implementados en el lenguaje de programación C++ y fueron testeados en un computador personal con Intel(R) Core(TM) i7-106G7 CPU \@1,30GHz. Para cada test se asignó únicamente una CPU, con el objetivo de mantener la simplicidad de los resultados. Adicionalmente, sólo fue considerado un tipo de agente para las simulaciones (automóviles) y cada simulación representa 1 hora de tráfico continuo en la ciudad de Barcelona, España, ciudad cuya área es de aproximadamente 101,9 km².

    === Prueba de escalabilidad basada en el tamaño de la red para computadores personales

    Para este experimento, se implementa una forma automatizada para obtener los datos necesarios desde OpenStreetMap (OSM). Esta automatización toma una localización descrita en coordenadas, y consulta los datos requeridos a través de 30 iteraciones, donde el temaño de la red es más grande con cada iteración. 

    Luego, se crean las simulaciones correspondientes mediante el _software_ SUMO. Los archivos que describen los viajes, es decir, los puntos de partida y llegada de cada vehículo, fueron creados con _randomTrips.py_ por simplicidad @Lopez, haciendo uso de una semilla de aleatoriedad definida; en tanto, los archivos correspondientes a la descripción de las rutas fueron creados mediante el uso de la herramienta _duarouter_ de SUMO @Duarouter. Finalmente, se midió el tiempo de ejecución de cada simulación versus el número de aristas del grafo correspondiente. El pipeline para la generación de estas simulaciones se muestra en la siguiente figura:

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
        caption: [Pipeline para simulaciones basadas en el tamaño de la red.]
    )


    === Prueba de escalabilidad basada en el número de agentes por simulación para computadores personales

    Por otro lado, en orden de testear la escalabilidad de las simulaciones respecto al número de agentes, se determina una red de caminos de tamaño fijo sobre la ciudad de Barcelona y se crean las simulaciones correspondientes con _randomTrips.py_ y _duarouter_. El pipeline para este experimento se muestra en la Figura 5.

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
        caption: [Pipeline para simulaciones basadas en la carga de tráfico vehicular.]
    )

    Para poder incrementar de manera uniforme la cantidad de vehículos presentes en la simulación, se configuró la tasa de inserciones de agentes de _randomTrips.py_ @Randomtrips para tomar valores decrecientes en el intervalo [0.25, 1.0], mientras que la configuración de _duarouter_ no fue alterada.

    En total, 40 simulaciones con diferentes tasas de inserción fueron realizadas, midiendo el tiempo de ejecución de cada una. El tiempo total destinado a ejecutar todas estas simulaciones fue de aproximadamente 48 horas cronológicas.

    === Resultados

    Los resultados obtenidos para ambas pruebas se muestran en los gráficos expuestos a continuación. A la izquierda, se muestran los tiempos de simulación en función del número de aristas de la red, mientras que a la derecha, se muestra el uso de CPU por cada simulación ejecutada.:

    *Resultados para simulaciones basadas en el tamaño de la red:*

    #figure(
        grid(
            columns: 2,
            gutter: 1mm,
            image("imagenes/s_time_edges.png", width: 90%),
            image("imagenes/cpu_edges.png", width: 90%),
        ),
        caption: [Resultados para la prueba de escalabilidad basada en el tamaño de la red de caminos.]
    )

    Como es posible observar, en este caso existe un crecimiento lineal de los tiempos de simulación en relación al crecimiento de la red de caminos, lo cual nos muestra que el dicho crecimiento no es realmente un problema al momento de ejecutar simulaciones sobre áreas extensas. Aún así, cabe destacar que el uso de CPU se mantiene constante en un valor máximo.

    *Resultados para simulaciones basadas en la carga de tráfico vehicular:*

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

]

#capitulo(title: "Problema")[
    Como es posible observar a partir de lo ya expuesto, existen principalmente dos dificultades al momento de buscar mejorar la _performance_ de las simulaciones de tráfico urbano. La primera de ellas, y la más importante, refiere a la cantidad y variedad de agentes presentes en cada simulación. Dado que de la ejecución secuencial se tiene que los tiempos de ejecución aumentan de forma exponencial, al momento de querer simular redes de caminos con alta congestión de tránsito, el tiempo de ejecución de la simulación se alejará cada vez más de lo que se desea como una simulación en tiempo real.

    Otro problema a considerar tiene que ver con la paralelización misma y la sincronización de los procesos paralelos, dado que existe la posibilidad de generar cuellos de botella en las comunicaciones entre nodos y de esta forma perjudicar la _performance_ de las simulaciones.

    El problema que se plantea a partir de esto radica en la necesidad de paralelizar simulaciones que no sólo representen grandes áreas metropolitanas, sino que también presenten una alta carga de tráfico de agentes (ya sea vehicular o de peatones), manteniendo la granularidad y precisión de dichas simulaciones en un ambiente de supercomputación y mejorando el _speedup_ de éstas de manera significativa, reduciendo también los posibles cuellos de botella en la comunicación de los procesos paralelizados.
    
]

#capitulo(title: "Preguntas de investigación, hipótesis y objetivos")[
    == Preguntas de investigación
    - ¿Cómo se diferencian en cuanto a _performance_ la versión secuencial de simulaciones en SUMO respecto a una versión paralelizada en un ambiente de supercomputación?
    - ¿Es posible mejorar la _performance_ de simulaciones de tráfico urbano en orden de poder simular áreas metropolitanas completas a nivel microscópico?
    - ¿Cómo se comporta asintóticamente el área a simular en un ambiente de supercomputación?
    - ¿Cómo se comporta asintóticamente la carga vehicular a simular en un ambiente de supercomputación?

    == Hipótesis
    Es posible aumentar la escalabilidad de simulaciones de alta granularidad mediante la paralelización y sincronización de los procesos del _software_ SUMO en un ambiente de supercomputación, incrementando el _speedup_ de éstos en al menos un 5% de los tiempos de simulación secuenciales, y optimizando así el uso de recursos para simulaciones que contemplen áreas metropolitanas de gran extensión y alta carga de tráfico vehicular.

    == Objetivos
    === Objetivo General
    Avanzar en el estado del arte acerca de la paralelización de procesos de simulación de tráfico urbano en supercomputadores, comprobando el aumento en la escalabilidad de dichos procesos luego de su correspondiente paralelización.
    === Objetivos específicos
    + Aplicar la contenerización de SUMO en _Singularity Containers_ para su ejecución en supercomputadores.
    + Diseñar e implementar un modelo de paralelización de los procesos contenerizados, determinando los parámetros necesarios para la efectiva comunicación y sincronización entre los procesos.
    + Medir la escalabilidad de la solución implementada en un ambiente de supercomputación y comparar con las mediciones previamente realizadas.
]

#capitulo(title: "Metodología")[
    == Herramientas utilizadas
    === _Singularity Containers_
    _Singularity_ es un proyecto _open-source_ que permite la creación de contenedores de forma portable y reproducible @Singularity. A diferencia de _Docker_, _Singularity_ fue creado para ejecutar aplicaciones complejas en _clusters_ HPC, cobrando popularidad de manera significativa para su uso en supercomputadores; sin embargo, es posbile construir contenedores de _Singularity_ a partir de contenedores de _Docker_.

    Adicionalmente, este _software_ soporta la generación de imágenes _custom_ a través de sus archivos de definición, permitiendo envolver todas las imágenes necesarias en un sólo archivo que provee facilidad de manejo, además de simplificar el despliegue de los contenedores @Younge2017. La interoperabilidad que ofrece _Singularity_ permite también su portabilidad a través de distintas arquitecturas HPC.
    === _OpenMP_
    _OpenMP_ es una API de modelo escalable que ofrece una interfaz flexifle y sencilla de manejar para programación paralela @OpenMP. Provee soporte para los lenguajes `C`, `C++` y `Fortran`, y permite el desarrollo de aplicaciones portables, encontrándose orientado principalmente a la programación para multiprocesadores de memoria compartida.

    Esta API consiste en una especificación para un set de directivas de compilación, rutinas de librería y variables de ambiente que pueden ser usadas para especificar paralelismo de alto nivel. Actualmente, se encuentra en la versión 5.2.
    === SUMO y _libtraci_
    La librería _libtraci_ de SUMO es una herramienta que compatibiliza el uso de TraCI con códigos de C++ @libtraci, de manera que no sólo se pueda ejecutar una simulación, sino que también pueda controlarse y monitorearse sin necesidad de una GUI. _Libtraci_ provee, además de las funcionalidades de TraCI, soporte para el uso de múltiples clientes, lo cual resulta conveniente al momento de pensar en la paralelización de las simulaciones. 

    == Partición de mapas de Barcelona y Viladecans

    Para realizar la división de los mapas originales de Barcelona y Viladecans se utilizó una implementación en `Java` ya existente del algoritmo de _SPartSim_ @SPartSim, el cual ejecuta una división por zonas geográficas eligiendo puntos distantes en el mapa dada una heurística inicial y va expandiendo las particiones con los nodos cercanos en cada iteración, para luego balancear la carga de las particiones moviendo aquellos nodos con más peso a particiones vecinas que tengan un menor peso. El objetivo de esto es entregar un mapa particionado de manera relativamente equitativa, de forma que los hilos de ejecución de cada sub-simulación no se vean sobrecargados.

    En orden de mantener la compatibilidad con los archivos de entrada de las simulaciones con SUMO, a dicha implementación se le agregó un módulo de comptabilidad con archivos XML, ya que el código original sólo trabajaba con archivos `GeoJSON`, los cuales además perdían información importante al momento de convertir desde archivos `XML`. A raíz de esto, se debió implementar una clase que conservase dicha información, para después restaurarla al momento de hacer la conversión desde los grafos generados por el _software_ hacia la clase de grafos compatibles con la estructura `XML`requerida por las simulaciones. La siguiente figura ilustra el proceso de conversión implementado para la compatibilidad del _software_ de particionamiento de rutas con archivos `XML`.
    // TO-DO: Figura
    

    == Generación y partición de rutas vehiculares

    Para la generación de las rutas vehiculares se consideraron, en primer lugar, dos enfoques distintos: por un lado, el generar dichas rutas a partir de datos reales de movilidad urbana, y por otro lado, generarlas de manera aleatoria o pseudo-aleatoria por medio de la herramienta _randomTrips.py_, provista por SUMO y utilizada para realizar las pruebas de escalabilidad de las simulaciones secuenciales.

    Respecto al primer enfoque, se obtuvieron los datos de movilidad de la población de Barcelona en formato de matrices de Origen-Destino obtenidas a partir de los datos recolectados de las redes móviles por parte del ayuntamiento de Barcelona. Sin embargo, por simplicidad para la generación de las rutas, se decidió tomar el segundo enfoque.

    Para la partición de las rutas generadas se hizo uso de la herramienta _cutRoutes.py_ de SUMO, la cual corta las rutas acorde a la partición del mapa que se busca simular. No obstante, dicha herramienta presenta problemas en tanto termina descartando ciertas rutas particionadas y recalculando los tiempos de partida para cada una; si bien existe una extensión que soluciona este problema para la futura paralelización de los procesos de simulación @Acosta2016, no fue posible acceder a ella, por lo que sólo se consideraron aquellas rutas resultantes de _cutRoutes.py_ para la posterior reconstrucción.


    == Contenerización de simulaciones secuenciales
    En una primera instancia de exploración del uso de Singularity Containers, se procedió a implementar la contenerización de simulaciones sin paralelizar. El resultado de esto fue la creación de un archivo de definición de _containers_ con extensión `.def`, el cual construye el entorno necesario para la ejecución de las simulaciones de manera aislada. A continuación, se muestra un ejemplo de estos archivos de definición para el levantamiento de los contenedores.

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
        ./traci_simulation"
    ```

    El _script_ de C++ _traci_simulation_ tiene por objetivo ejecutar simulaciones aisladas de forma secuencial. Para esto, luego de configurar el entorno de la simulación, el código llama a una instancia de SUMO con el archivo de configuración previamente definido a partir de un _script_ en _Python_, el cual genera un archivo `XML` especificando, entre otras cosas, cuáles son los archivos a utilizar para las redes de caminos y las rutas de los vehículos.
    // TO-DO: Anexo -> Ejemplo de archivo de configuración

    == Paralelización de las simulaciones particionadas

    La paralelización de las simulaciones particionadas consistió en la implementación de un código en `C++` con la ayuda de _OpenMP_ para las directivas de compilación. Este código implementa una arquitectura de _multi-threading_, en la cual cada hilo de ejecución posee una instancia de SUMO contenerizada que simula una partición dada del mapa original, con las rutas propiamente particionadas de acuerdo con el algoritmo de _cutRoutes.py_.

    En la siguiente figura, se muestra el funcionamiento general de la paralelización realizada con 5 threads. Primero se realiza un proceso de configuración de forma secuencial, en el cual se generan los archivos de configuración _sim.sumocfg_ a partir de los cuales se ejecutan las simulaciones en forma paralela mediante una instancia de SUMO contenerizada con _Singularity_. De esta manera, una vez que se crean los archivos de configuración, se realiza un llamado con el comando `#pragma omp parallel`, configurando el número de threads a ejecutarse como el número de particiones hechas previamente con _SPartSim_.
    //TO-DO: hacer diagrama de paralelización
    
    #figure(
        diagram(
            spacing: (10mm, 5mm),
            node-stroke: 1pt,
            edge-stroke: 1pt,
            node((-7,0), `Generate sim_i.sumocfg`, name: <1>, width: 35mm),
            edge((-9,0), "r,r", "-|>", label: `start`),
            node((-2,0), `SUMO instance`, name: <2>, width: 25mm),
            node((-2,1), `SUMO instance`, name: <3>, width: 25mm),
            node((-2,-1), `SUMO instance`, name: <4>, width: 25mm),
            node((-2,2), `SUMO instance`, name: <5>, width: 25mm),
            node((-2,-2), `SUMO instance`, name: <6>, width: 25mm),
            node((0,0), `partition_3.log`, name: <7>, width: 35mm),
            node((0,1), `partition_4.log`, name: <8>, width: 35mm),
            node((0,-1), `partition_2.log`, name: <9>, width: 35mm),
            node((0,2), `partition_5.log`, name: <10>, width: 35mm),
            node((0,-2), `partition_1.log`, name: <11>, width: 35mm),
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

    == Sincronización de las simulaciones particionadas
    === Reensamblaje de rutas
    En cuanto a la reconstrucción de las rutas, se implementó un código en _Python_ que toma tanto las rutas originales como las particionadas y, por cada ruta particionada, busca la ruta original y las agrupa en un diccionario indicando sus aristas, la partición a la que pertenece la ruta, y su índice de ocurrencia en la ruta original. De esta manera, fue posible realizar una reconstrucción parcial de los viajes generados por _randomTrips.py_.
    
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
    === Impedimentos para la sincronización
    Como se menciona en la sección 5.3, la herramienta de particionamiento de rutas _cutRoutes.py_ presenta limitaciones al momento de considerarla para la sincronización de simulaciones de tráfico urbano mediante SUMO, principalmente al momento de definir los tiempos de partida de los vehículos (_departure times_), redefiniendo aquellas rutas que cruzan más de una partición como rutas independientes con el mismo tiempo de partida; esto radica en problemas tales como que al ingreso de nuevas rutas, no se reconozca el vehículo a insertar dado que el mismo ya ha salido de la simulación.
    == Diseño e implementación de test de carga
    === Test versión secuencial
    Para poder realizar la comparación en cuanto al crecimiento de los tiempos de ejecución para las simulaciones secuenciales, se implementó un módulo de test en el lenguaje `C++`, el cual contempla una primera fase de _setup_, donde se definen los períodos de generación de vehículos a partir de los cuales se generan los archivos de rutas necesarios para el mapa definido. En total, se definen veinte períodos para los cuales se definen también los archivos de configuración a utilizar para cada simulación.

    La segunda etapa contempla de ejecución de cada simulación de forma secuencial, midiendo y registrando el tiempo que toma cada una en finalizar. Para esto, cada simulación se ejecutó un total de cincuenta veces, para luego obtener el tiempo total como el promedio de los tiempos de cada iteración.
    === Test versión paralelizada
    Para probar el escalamiento de la solución implementada, se siguió un procedimiento similar a los test secuenciales, resultando en la implementación de los siguientes módulos:

    - *_setup_*: este módulo genera los períodos, rutas, particiones y archivos de configuración necesarios para cada simulación, y organiza los archivos en sus directorios correspondientes.
    - *_start_test_*: por cada set de particiones realizadas, este módulo se encarga de entrar a cada directorio e iniciar el test de carga para cada período dado.
    - *_load_test_*: este módulo implementa el test de carga, el cual, a partir de los archivos de configuración y la imagen de _Singularity_ construida para las instancias de SUMO, ejecuta las simulaciones llamando al módulo encargado de paralelizar los procesos de simulación según el número de particiones realizadas. Como en el test para la versión secuencial, cada simulación se ejecuta un total de cincuenta veces, para luego promediar los tiempos de cada iteración.
]

#capitulo(title: "Resultados")[
    A continuación, se muestran los resultados obtenidos para el test de carga de la versión paralelizada de las simulaciones implementadas en SUMO:
    #figure(
        grid(
            columns: 2,
            gutter: 1mm,
            image("resultados_test_de_carga/4_particiones.png", width: 70%),
            image("resultados_test_de_carga/8_particiones.png", width: 70%),
            image("resultados_test_de_carga/16_particiones.png", width: 70%),
            image("resultados_test_de_carga/32_particiones.png", width: 70%),
            image("resultados_test_de_carga/64_particiones.png", width: 70%)
        ),
        caption: [Resultados para la prueba de escalabilidad basada en la carga de tráfico vehicular para la versión paralelizada de SUMO.]
    )

    Asímismo, en la siguiente figura se puede apreciar la comparación de la escalabilidad entre las simulaciones ejecutadas con distintos números de particiones:

    #figure(
        grid(
            columns: 2,
            gutter: 1mm,
            image("resultados_test_de_carga/conjunto.png", width: 90%),
            image("resultados_test_de_carga/logaritmico.png", width: 90%)
        ),
        caption: [Comparación de escalabilidad de simulaciones ejecutadas con diferentes números de particiones.]
    )
]

#capitulo(title: "Discusión")[

]

#capitulo(title: "Conclusiones")[

]

#bibliography(
    "bibliografia.yml",
    title: "Referencias",
    style: "ieee",
)