---
layout: info_page
img: "/assets/Sienna-Dyn-info-page.png"

############################ Banner ##################################
banner:
  title: Sienna\Dyn
  sub_title: "Simulate power system dynamic response to disturbances and contingencies"
  content: Capture the fast dynamics of inverter-based resources

############################ Transition Badges ##################################
badges:
  content1: What makes Sienna\Dyn different?
  content2: Is Sienna\Dyn right for your use case?
  content3: How is Sienna\Dyn structured?

########################## Features #########################
what_we_do:
  title: Features and Capabilities

  service_section1:
    title: "Key Features"
    service_list:
      - service: "Industry-standard models for synchronous machines, automatic voltage regulators, governors, and inverters"
      - service: "Novel models, including synchronous machines, machine learning surrogates and aggregate distribution systems"
      - service: "Exchangeable solvers from the scientific machine learning ecosystem"
      - service: "Separation of models from the integration algorithms coupled with novel numerical techniques"

  service_section2:
    title: "Core Capabilities"
    service_list:
      - service: "Runs quasi-static, electromagnetic time domain simulations and small signal stability analysis"
      - service: "Models novel and advanced inverter control methodologies "
      - service: "Integrates with Sienna\\Ops to perform stability analyses of systems with high share of inverter-based resources"
      - service: "Accelerates electromagnetic analysis of large interconnected systems by over 10×"
      - service: "Runs electromagnetic simulations employing averaging techniques and modern integration methods"
      - service: "Provides flexibility in choosing between precision and solution speed for distinct use cases and requirements"
      - service: "Allows researchers to assess the numerical requirements for new control techniques for inverter-based generation"

########################## How it Works #########################
### Formatting from home11, there is a subtitle option available
why_us:
  title: "How It Works"
  subtitle: 
  content: "Sienna\\Dyn is a modular platform using software packages written in the Julia programming language. All packages are open-source, free to use, and have a command-line interface. See the Documentation page for each package's documentation, general installation instructions, and tutorials."

tablist:
# tab item1
  - name: "PowerSystemDynamics.jl"
    icon: "/assets/img/icon_time_series_org.svg"
    content: "Simulate small signal stability and electromagnetic transients"
    link: "https://github.com/Sienna-Platform/PowerSimulationsDynamics.jl"
    version: "v2"

# tab item2
  - name: "PowerSystems.jl"
    icon: "/assets/img/icon_transmission_org.svg"
    content: "Consistently represent data for devices' dynamic behavior"
    link: "https://github.com/Sienna-Platform/PowerSystems.jl"
    version: "v1"
---