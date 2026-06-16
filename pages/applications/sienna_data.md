---
layout: info_page
img: "/assets/Sienna-Data-info-page.png"

############################ Banner ##################################
banner:
  title: Sienna\Data
  sub_title: Efficiently input and use energy systems data
  content: Exceptional performance for large data

############################ Transition Badges ##################################
badges:
  content1: What makes Sienna\Data different?
  content2: Is Sienna\Data right for your use case?
  content3: How is Sienna\Data structured?

########################## Features #########################
what_we_do:
  title: Features and Capabilities

  service_section1:
    title: "Key Features"
    service_list:
      - service: Comprehensive, extensible library of data structures for energy systems modeling
      - service: Well-defined user interface
      - service: Large-scale dataset development tools based on common text-based data formats (e.g., PSS/e .raw and .dyr, and MATPOWER .m) and configurable tabular data (e.g., CSV) parsing capabilities
      - service: Optimized container for component data and time series

  service_section2:
    title: "Core Capabilities"
    service_list:
      - service: Efficient management of large quantities of time-series data, including time-series data for any device parameter
      - service: Expanded access for more users to solve more problems as energy systems evolve
      - service: Open-source sharing of publicly available data with a repository of 200+ data sets
      - service: Optimized serialization of huge datasets into compressed file formats, allowing users to easily save and load  data
      - service: Comprehensive validation rules for every parameter of every device
      - service: Consistent representation of millions of devices with automatic crosschecking for data compatability

########################## How it Works #########################
why_us:
  title: "How It Works"
  subtitle: 
  content: "Sienna\\Data is a modular platform using software packages written in the Julia programming language. All packages are open-source, free to use, and have a command-line interface. See the Documentation page for each package's documentation, general installation instructions, and tutorials."

tablist:
  # tab item1
  - name: "PowerSystems.jl"
    icon: "/assets/img/icon_transmission_org.svg"
    content: "Data models for consistent representation of power system devices"
    link: "https://github.com/Sienna-Platform/PowerSystems.jl"
    version: "v1"

  # tab item2
  - name: "PowerSystemsCaseBuilder.jl"
    icon: "/assets/img/icon_save_org.svg"
    content: "Load saved test systems and custom system data"
    link: "https://github.com/Sienna-Platform/PowerSystemCaseBuilder.jl"
    version: "v4"
---
