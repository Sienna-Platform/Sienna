# Use Sienna in VSCode

### Prerequisites

Start by completing the install steps for Julia and Sienna on the
[basic installation page](@ref install). Then:

### Step 1: Install Visual Studio Code

 1. Download from [VSCode](https://code.visualstudio.com/).
 2. Install following the on-screen instructions.
 3. Launch VSCode after installation.

### Step 2: Configure Julia in VSCode

 1. Open **VSCode**, go to **Extensions** (`Ctrl+Shift+X` on Windows, `Cmd+Shift+X` on Mac).

 2. Search for and install the **Julia extension**.
 3. Set Julia's path:
    
      + Open **Command Palette** (`Ctrl+Shift+P` on Windows, `Cmd+Shift+P` on Mac).
      + Search: `Settings` → `Julia: Executable Path`.
      + Provide the full path to your `julia` executable (`julia.exe` on Windows, `julia` on Mac and Linux).

### Step 3: Start Julia REPL in VSCode

 1. Open the **Command Palette** (`Ctrl+Shift+P`).
 2. Type `Julia: Start REPL` and press **Enter** to launch it.

Test you have access to your Sienna installation:

```julia
using PowerSystems
```

### Troubleshooting

  - **Path Issues**: Verify paths in VSCode’s settings.
  - **Package Issues**: Ensure Julia is up-to-date and has internet access.
  - **Restart Required**: If REPL does not load, restart VSCode.
