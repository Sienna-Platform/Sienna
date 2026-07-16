## [Basic Installation](@id install)

Sienna is a command line tool written in the Julia programming language.

### Prerequisites

  - Internet access and admin permissions.
  - Basic knowledge of command-line tools.

### Step 1: Install Julia and `juliaup`

Follow the instructions on [the Julia Downloads page](https://julialang.org/downloads/) to download Julia and `juliaup`, Julia's version manager, and add Julia to your path. 

Verify installation:
    
```bash
julia --version
```

### Step 2: Open Julia

Start the [Julia REPL](https://docs.julialang.org/en/v1/stdlib/REPL/) from a command line:

```
$ julia
```

You should see the Julia REPL start up, which looks something like this:

```
               _
   _       _ _(_)_     |  Documentation: https://docs.julialang.org
  (_)     | (_) (_)    |
   _ _   _| |_  __ _   |  Type "?" for help, "]?" for Pkg help.
  | | | | | | |/ _` |  |
  | | |_| | | | (_| |  |  Version 1.10.4 (2024-06-04)
 _/ |\__'_|_|_|\__'_|  |  Official https://julialang.org/ release
|__/                   |

julia>
```

If not, go back to check the Julia installation steps.

### Step 3: Install Sienna

Sienna is a modular set of Julia packages. Add the packages for the application you need, then follow
the Getting Started pages for a recommended learning path.

#### [Sienna\Data](@id install_data)

```julia
using Pkg
Pkg.add([
    "PowerSystems",
    "PowerSystemCaseBuilder",
])
```

#### [Sienna\Ops](@id install_ops)

```julia
using Pkg
Pkg.add([
    "PowerSystems",
    "PowerSimulations",
    "StorageSystemsSimulations",
    "HydroPowerSimulations",
    "SiennaPRASInterface",
    "PowerAnalytics",
    "PowerGraphics",
])
```

#### [Sienna\Dyn](@id install_dyn)

```julia
using Pkg
Pkg.add([
    "PowerSystems",
    "PowerSimulationsDynamics",
])
```

#### [Sienna\Net](@id install_network)

```julia
using Pkg
Pkg.add([
    "PowerFlows",
    "PowerNetworkMatrices",
    "PowerSystems",
])
```

#### Install individual packages

If instead you want to add specific packages instead of the entire application, install the latest stable release for individual packages such as:

```julia
using Pkg
Pkg.add("PowerSystems")
```

#### Install from the development branch

To use the latest unreleased code on `main` for a package:

```julia
using Pkg
Pkg.add(; name = "PowerSystems", rev = "main")
```

These commands may take a few minutes to download packages and compile them.
