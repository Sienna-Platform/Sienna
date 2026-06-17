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
  content: "Sienna\\Ops is a modular platform using software packages written in the Julia programming language. All packages are open-source, free to use, and have a command-line interface. See the Documentation for each package's documentation, general installation instructions, and tutorials."

tablist:
  - name: "PowerSimulations.jl"
    icon: "/assets/img/icon_trajectory_org.svg"
    content: "Formulate and solve optimization problems to simulate system scheduling"
    link: "/SiennaDocs/docs/build/PowerSimulations/stable/"
    version: "v3"

  - name: "StorageSystemsSimulations.jl"
    icon: "/assets/img/icon_battery_org.svg"
    content: "Extend capabilities to simulate energy storage systems"
    link: "/SiennaDocs/docs/build/StorageSystemsSimulations/stable/"
    version: "v3"

  - name: "HydroPowerSimulations.jl"
    icon: "/assets/img/icon_hydro_org.svg"
    content: "Extend capabilities to simulate hydropower generators"
    link: "/SiennaDocs/docs/build/HydroPowerSimulations/stable/"
    version: "v3"

  - name: "SiennaPRASInterface.jl"
    icon: "/assets/img/icon_comp_$_org.svg"
    content: "Assess resource adequacy with probabilistic reliability analysis"
    link: "/SiennaDocs/docs/build/SiennaPRASInterface/stable/"
    version: "v1"

  - name: "PowerAnalytics.jl"
    icon: "/assets/img/icon_comp_$_org.svg"
    content: "Analyze common metrics and compare results across scenarios"
    link: "/SiennaDocs/docs/build/PowerAnalytics/stable/"
    version: "v4"

  - name: "PowerGraphics.jl"
    icon: "/assets/img/icon_graph_org.svg"
    content: "Visualize data inputs and results"
    link: "/SiennaDocs/docs/build/PowerGraphics/stable/"
    version: "v2"

  - name: "PowerSystems.jl"
    icon: "/assets/img/icon_transmission_org.svg"
    content: "Consistently represent power system data, including time series"
    link: "/SiennaDocs/docs/build/PowerSystems/stable/"
    version: "v1"
---
