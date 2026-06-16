---
layout: info_page
img: ""

############################ Banner ##################################
banner:
  title: Sienna\Network
  sub_title: Ensure transmission network reliability
  content: Power flow, network reductions, and reactive power planning

############################ Transition Badges ##################################
badges:
  content1: What makes Sienna\Network different?
  content2: Is Sienna\Network right for your use case?
  content3: How is Sienna\Network structured?

########################## Features #########################
what_we_do:
  title: Features and Capabilities

  service_section1:
    title: "Key Features"
    service_list:
      - service: Multiple algorithmic options for robust DC and AC power flow
      - service: Calculation and transformation of key power network matrices (PTDF, LODF, virtual matrices for large data sets)

  service_section2:
    title: "Core Capabilities"
    service_list:
      - service: Geographic network reduction to enable faster modeling of large-scale datasets
      - service: Built-in interoperability with Sienna\\Ops for simulating power flow-in-the-loop
      - service: Reactive power planning for the next generation power systems
      - service: Contingency analysis for assessing system reliability

########################## How it Works #########################
why_us:
  title: "How It Works"
  subtitle: 
  content: "Sienna\\Network is a modular platform using software packages written in the Julia programming language. All packages are open-source, free to use, and have a command-line interface. See the Documentation page for each package's documentation, general installation instructions, and tutorials."

tablist:
  # tab item1
  - name: "PowerSystems.jl"
    icon: "/assets/img/icon_transmission_org.svg"
    content: "Parse and format input data for consistent representation"
    link: "https://github.com/Sienna-Platform/PowerSystems.jl"
    version: "v1"

  # tab item2
  - name: "PowerNetworkMatrices.jl"
    icon: "/assets/img/icon_matrix_org.svg"
    content: "Build common power system matrices (Y bus, PTDF, LODF)"
    link: "https://github.com/Sienna-Platform/PowerNetworkMatrices.jl"
    version: "v3"

  # tab item3
  - name: "PowerFlows.jl"
    icon: "/assets/img/icon_network_org.svg"
    content: "Calculate simple power flows"
    link: "https://github.com/Sienna-Platform/PowerFlows.jl"
    version: "v5"

---
