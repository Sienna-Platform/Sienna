## [Basic Installation](@id install)

Sienna is a command line tool written in the Julia programming language.

### Prerequisites

  - Internet access and admin permissions.
  - Basic knowledge of command-line tools.

### Step 1: Install Julia

Follow the instructions on [the Julia Downloads page](https://julialang.org/downloads/).

Tips for Windows:

 1. Visit [Julia Downloads](https://julialang.org/downloads/platform/#windows).

 2. Download the **Windows installer** (`.exe`).
 3. Run the installer and follow these steps:
    
      + Choose **installation path** (default: `C:\\Users\\<YourUser>\\AppData\\Local\\Programs\\Julia`).
      + Select **"Add Julia to PATH"** for easier access from the terminal.
 4. Verify installation:
    
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

Sienna is a modular set of Julia packages, where each package can be installed with the
[Julia package manager](https://docs.julialang.org/en/v1/stdlib/Pkg/#Pkg).
To install the core packages in one of the Sienna applications,
Sienna\Data, Sienna\Ops, and/or Sienna\Dyn, run:

#### Install Sienna\Data

```julia
using Pkg;
Pkg.add([
    "PowerSystems",
    "PowerNetworkMatrices",
    "PowerFlows",
    "PowerSystemCaseBuilder",
    "PowerGraphics",
]);
```

#### Install Sienna\Ops

```julia
using Pkg;
Pkg.add([
    "PowerSystems",
    "PowerSimulations",
    "StorageSystemsSimulations",
    "HydroPowerSimulations",
    "PowerFlows",
    "PowerGraphics",
    "PowerAnalytics",
]);
```

#### Install Sienna\Dyn

```julia
using Pkg;
Pkg.add(["PowerSystems", "PowerSimulationsDynamics", "PowerGraphics", "PowerAnalytics"]);
```

These commands may take a few minutes to download the packages and compile them.

In addition to the core packages, there are auxilliary packages that extend the
capabilities for particular use cases, such as storage or hydropower modeling.

Check out the [Documentation Hub](@ref hub) to learn more.

## Troubleshooting on Windows

Users regularly report challenges installing
[`PowerGraphics.jl`](https://nrel-sienna.github.io/PowerGraphics.jl/stable/) on Windows due to
its dependency on [`PlotlyJS.jl`](https://github.com/JuliaPlots/PlotlyJS.jl).

We ask if users come across other issues and solutions to please submit a Git issue so we
can continue to build out this troubleshooting guide for other users.

### `FMMPEG.jl` error

If you get an error about building `FMMPEG.jl` (a dependency) when adding or running
`using PowerGraphics.jl`, try uninstalling `PowerGraphics.jl`:

```julia
using Pkg;
Pkg.rm("PowerGraphics")
```

Install `FMMPEG.jl` separately, then reinstall `PowerGraphics.jl`:

```julia
Pkg.add("FMMPEG")
Pkg.add("PowerGraphics")
```
