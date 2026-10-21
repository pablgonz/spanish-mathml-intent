## spanish-mathml-intent — Spanish parse intent
![GitHub release (latest by date)](https://img.shields.io/github/v/release/pablgonz/spanish-mathml-intent?label=version)
![GitHub Release Date](https://img.shields.io/github/release-date/pablgonz/spanish-mathml-intent)
![GitHub last commit](https://img.shields.io/github/last-commit/pablgonz/spanish-mathml-intent)

## Descripción

El paquete <code>&langle;spanish-mathml-intent&rangle;</code> agrega el atributo
_intent_ de MathML a las matemáticas escritas en español con `LuaLaTeX`. El
atributo le indica a un lector de pantalla qué concepto es una expresión y cómo
se debe leer, de modo que NVDA con MathCAT lea correctamente las fórmulas en
documentos `PDF` accesibles \(_tagged_ PDF\). Sus comandos escriben y etiquetan
números, unidades, dinero, fechas y horas, geometría, álgebra y estadística,
cada uno con la lectura en español que le corresponde. Está pensado para
docentes de educación primaria y secundaria.

## Requerimientos

El requisito mínimo es el release de `LaTeX` 2026-11-01. Se carga y depende
de una versión actualizada de [unicode-math](https://ctan.org/pkg/unicode-math).

Se recomienda tener instalado
[newcomputermodern](https://ctan.org/pkg/newcomputermodern) (fuente
`NewCMMath-Regular.otf`), que el paquete usa para `\mathcal` y para el símbolo
del ángulo recto. Si no la encuentra, avisa y usa la fuente matemática cargada.

## Instalación

El paquete <code>&langle;spanish-mathml-intent&rangle;</code> está disponible en
[TeX Live](https://www.tug.org/texlive/); utilice el gestor de paquetes
para instalarlo (`tlmgr install spanish-mathml-intent`).

Para probar la versión de desarrollo, que puede contener cambios aún no
publicados, clone el repositorio y ejecute `l3build install`:

```
$ git clone https://github.com/pablgonz/spanish-mathml-intent.git
$ cd spanish-mathml-intent
$ l3build install
```

Para generar la documentación con el código fuente, ejecute `l3build doc`.

## Ejemplos

El archivo <code>&langle;spanish-mathml-intent.pdf&rangle;</code> contiene ejemplos
adjuntos, los cuales se pueden extraer desde el visor de PDF o desde la línea
de comandos ejecutando:

```
$ pdfdetach -saveall spanish-mathml-intent.pdf
```

y luego compilarlos con `lualatex-dev`.

### Ejemplos de PDF accesible (etiquetado)

Los mismos ejemplos del manual están en
[`sources/test-pkg/`](sources/test-pkg/), para verlos o descargarlos sin
abrir el manual. Los cinco primeros prueban _todos_ los comandos del
paquete, agrupados por eje; los tres últimos son ejemplos reales, del tipo de
documento que haría un docente de aula. Cada uno se compila en los dos modos
de matemáticas:

- `mathml-SE` (_Structure Elements_): el MathML de cada fórmula va en el árbol
  de etiquetas del `PDF`.
- `mathml-AF` (_Associated Files_): el MathML se lee desde un archivo asociado.

Los `PDF` se validan con `rnv-wrapp` y `veraPDF` (`PDF/UA-2`). Haga clic en
un enlace para verlo; GitHub también permite descargarlo desde esa página.

| Ejemplo | Contenido | Fuente | `mathml-SE` | `mathml-AF` |
|:--|:--|:-:|:-:|:-:|
| 01 | `\spnum`, `\spunit`, `\spmoney`, `\spshort`, `\spnewunit` y `\spunitalias` | [tex](sources/test-pkg/spintent-01.tex) | [pdf](sources/test-pkg/spintent-01.pdf) | [pdf](sources/test-pkg/spintent-01-AF.pdf) |
| 02 | Utilidades generales (`\spsiglo`, `\sptime`, `\spdate`) y de símbolos (`\spnewread`, `\spread`, `\spusep`, `\spdsym`, `\spmsym`) | [tex](sources/test-pkg/spintent-02.tex) | [pdf](sources/test-pkg/spintent-02.pdf) | [pdf](sources/test-pkg/spintent-02-AF.pdf) |
| 03 | Utilidades para números | [tex](sources/test-pkg/spintent-03.tex) | [pdf](sources/test-pkg/spintent-03.pdf) | [pdf](sources/test-pkg/spintent-03-AF.pdf) |
| 04 | Utilidades para geometría | [tex](sources/test-pkg/spintent-04.tex) | [pdf](sources/test-pkg/spintent-04.pdf) | [pdf](sources/test-pkg/spintent-04-AF.pdf) |
| 05 | Utilidades para álgebra y estadística | [tex](sources/test-pkg/spintent-05.tex) | [pdf](sources/test-pkg/spintent-05.pdf) | [pdf](sources/test-pkg/spintent-05-AF.pdf) |
| 06 | Ejemplo real: guía de divisibilidad, fracciones, razones y enteros | [tex](sources/test-pkg/spintent-06.tex) | [pdf](sources/test-pkg/spintent-06.pdf) | [pdf](sources/test-pkg/spintent-06-AF.pdf) |
| 07 | Ejemplo real: guía de geometría con ángulos, áreas y perímetros | [tex](sources/test-pkg/spintent-07.tex) | [pdf](sources/test-pkg/spintent-07.pdf) | [pdf](sources/test-pkg/spintent-07-AF.pdf) |
| 08 | Ejemplo real: guía de estadística y probabilidad | [tex](sources/test-pkg/spintent-08.tex) | [pdf](sources/test-pkg/spintent-08.pdf) | [pdf](sources/test-pkg/spintent-08-AF.pdf) |

> Estos archivos muestran la compatibilidad de
> <code>&langle;spanish-mathml-intent&rangle;</code> con `PDF` etiquetado usando `LuaLaTeX`.
> Para compilarlos se requieren `babel` (opción `spanish`),
> <code>&langle;spanish-mathml-intent&rangle;</code> y `hyperref`, junto con la línea de
> `\DocumentMetadata`. Las versiones `mathml-AF` se obtienen cambiando
> `mathml-SE` por `mathml-AF` después de ejecutar `spmmli-tool`.

## Desarrollo

Se garantiza que los números de versión y las fechas son correctos en el
repositorio en el archivo de configuración de `l3build` llamado `build.lua`.

El formato de la fecha es `AAAA-MM-DD`. Si para usted es importante que los
archivos creados tengan la versión y la fecha correctas, debe ejecutar
`l3build tag` antes de cualquier otra tarea relacionada con la compilación.

Puede ejecutar:

- `l3build unpack` para extraer los archivos de código en el directorio
  `build/unpacked/`.
- `l3build doc` para generar la documentación.
- `l3build install` para colocar todos los archivos en su `TEXMFHOME`.
- `l3build uninstall` desinstalará los archivos de `TEXMFHOME`.
- `l3build check` para ejecutar las pruebas de regresión (`testfiles/`).
- `l3build testSE` para compilar y validar los archivos de `tagged-test/`
  con `mathml-SE`.
- `l3build testAF` para lo mismo con `mathml-SE` y `mathml-AF`.
- `l3build example` para compilar los archivos de `sources/test-pkg` y copiar
  los PDF.

## Licencia

El paquete <code>&langle;spanish-mathml-intent&rangle;</code> se puede modificar y distribuir
bajo los términos y condiciones de la
[LaTeX Project Public License](https://www.latex-project.org/lppl/),
versión 1.3c o superior.

## Contenido del Repositorio

```
├── README.md
├── build.lua
├── ctan.ann
├── spmmli-tool.1
├── spmmli-tool.man1.pdf
├── tagged-test
├── testfiles
└── sources
    ├── CTANREADME.md
    ├── spanish-mathml-intent.dtx
    ├── spanish-mathml-intent.ins
    ├── spintent.lua
    ├── spanish-mathml-intent.sty
    ├── spmmli-tool.lua
    └── test-pkg
        ├── spintent-01.tex
        ├── spintent-02.tex
        ├── spintent-03.tex
        ├── spintent-04.tex
        ├── spintent-05.tex
        ├── spintent-06.tex
        ├── spintent-07.tex
        └── spintent-08.tex
```

## Copyright

Copyright &#169; 2026 por Pablo González L <pablgonz@educarchile.cl>
