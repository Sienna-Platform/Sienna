---
layout: info_page
img: "/assets/Sienna-Ops-info-page.png"

############################ Banner ##################################
banner:
  title: Sienna\Ops
  sub_title: Simulate system scheduling with large shares of inverter-based resources
  content: Simulate sequential problems for production cost modeling

############################ Transition Badges ##################################
badges:
  content1: What makes Sienna\Ops different?
  content2: Is Sienna\Ops right for your use case?
  content3: How is Sienna\Ops structured? 

########################## Features #########################
what_we_do:
  title: Features and Capabilities

  service_section1:
    title: "Key Features"
    service_list:
      - service: Rigorous simulation definitions
      - service: Systematic, templated approach to optimization problems
      - service: Modular and composable framework with game-changing extensibility

  service_section2:
    title: "Core Capabilities"
    service_list:
      - service: "Efficiently defines and solves new optimization problems"
      - service: "Sequentially executes multiple problems with clear definitions of how decisions made in one step affect options in subsequent steps"
      - service: "Minimizes compilation time and uses incumbent solutions from previous periods to guide the search for optimal results when modifying complex optimization problems to represent new time periods"
      - service: "Enables reproducible simulations using Sienna\\Data's rigorous data models"
      - service: "Allows for custom development to represent new ways of operating devices or entirely different decision processes"

########################## How it Works #########################
why_us:
  title: "How It Works"
  subtitle: 
  content: "Sienna\\Ops has a modular framework with seven core packages written in the Julia programming language. Use whichever combination is right for your use case. All packages are open-source, free to use, and have a command-line interface. See the Sienna Documentation Hub for each package's documentation, general installation instructions, and tutorials."

tablist:
  # tab item1
  - name: "PowerSimulations.jl"
    icon: "/assets/img/icon_trajectory_org.svg"
    content: "Formulate and solve optimization problems to simulate system scheduling"
    link: "https://github.com/NREL-Sienna/PowerSimulations.jl"
    version: "v3"

  # tab item2
  - name: "StorageSystemsSimulations.jl"
    icon: "/assets/img/icon_battery_org.svg"
    content: "Extend capabilties to simulate energy storage systems"
    link: "https://github.com/NREL-Sienna/StorageSystemsSimulations.jl"
    version: "v3"

  # tab item3
  - name: "HydroPowerSimulations.jl"
    icon: "/assets/img/icon_hydro_org.svg"
    content: "Extend capabilties to simulate hydropower generators"
    link: "https://github.com/NREL-Sienna/HydroPowerSimulations.jl"
    version: "v3"

  # tab item4
  - name: "PowerSystems.jl"
    icon: "/assets/img/icon_transmission_org.svg"
    content: "Consistently represent power system data, including time series"
    link: "https://github.com/NREL-Sienna/PowerSystems.jl"
    version: "v1"

  # tab item5
  - name: "PowerFlows.jl"
    icon: "/assets/img/icon_network_org.svg"
    content: "Calculate DC and AC optimal power flows"
    link: "https://github.com/NREL-Sienna/PowerFlows.jl"
    version: "v5"

  # tab item6
  - name: "PowerAnalytics.jl"
    icon: "/assets/img/icon_comp_$_org.svg"
    content: "Analyze common metrics and compare results across scenarios"
    link: "https://github.com/NREL-Sienna/PowerAnalytics.jl"
    version: "v4"

  # tab item7
  - name: "PowerGraphics.jl"
    icon: "/assets/img/icon_graph_org.svg"
    content: "Visualize data inputs and results"
    link: "https://github.com/NREL-Sienna/PowerGraphics.jl"
    version: "v2"
---
