# # [Transmission Congestion and LMPs](@id showcase_network_lmp)
#
# In this showcase, you will investigate the impacts of transmission line congestion
# by characterizing binding corridors, line utilization, and bus locational marginal prices (LMPs) -- the price of serving one more megawatt at each bus.

# You load an RTS-GMLC data set and run one 24-hour economic dispatch with a Power Transfer Distribution Factor (PTDF) network model; this keeps run time short but can directly be extended to an annual simulation.
#
# This showcase continues from [Production Cost Modeling](@ref showcase_pcm_storage) (PCM) by enforcing
# transmission limits instead of a copper-plate network. You will use
# [`PowerNetworkMatrices.jl`](@extref PowerNetworkMatrices :doc:`index`) for the PTDF matrix,
# [`PowerSimulations.jl`](@extref PowerSimulations :doc:`index`) for the dispatch, and
# [`PowerAnalytics.jl`](@extref PowerAnalytics :doc:`index`) for corridor ranking and utilization.
# Bus LMPs are reconstructed from the system balance dual, line flow duals, and the PTDF.
#
# !!! note "Analysis questions"
#     - Which lines bind, and how do congestion duals rank them?
#     - What are typical utilization and congestion-time metrics on those corridors?
#     - How do LMPs vary across buses at a peak hour and over the full simulation period?

# ## Environment
#
# [Install Sienna\Data, Sienna\Ops, and Sienna\Net](@ref install) and the supporting packages used below, including
# [`HiGHS`](https://ergo-code.github.io/HiGHS/dev/), an open-source solver. Then, load the packages in Julia with:

using Pkg
using PowerSystems
using PowerSystemCaseBuilder
using PowerSimulations
using HydroPowerSimulations
using PowerNetworkMatrices
using PowerAnalytics
using PowerAnalytics.Metrics
using PowerGraphics
using DataFrames
using HiGHS
using Dates
using Logging
using Statistics

# If you have any issues with reproducibility, print the active package versions with
# [`Pkg.status`](@extref) and try again with these exact versions:

Pkg.status()

# Configure the solver through
# [`PowerSimulations.optimizer_with_attributes`](@extref).
# These runs are economic dispatch problems, so HiGHS only needs a time limit
# (no optimality gap is needed for a continuous problem).

solver = optimizer_with_attributes(
    HiGHS.Optimizer,
    "time_limit" => 120.0,
)

# ## Load the day-ahead system
#
# Load the modified RTS-GMLC day-ahead data set with
# [`PowerSystemCaseBuilder.build_system`](@extref). The catalog spans calendar year 2020; we use a
# high-load summer day (`2020-07-15`) when there is transmission congestion.

const INITIAL_TIME = DateTime("2020-07-15T00:00:00")

sys = build_system(PSISystems, "modified_RTS_GMLC_DA_sys"; skip_serialization = true)

# ## Build the network economic-dispatch template
#
# Set up a PCM simulation like in [Production Cost Modeling](@ref showcase_pcm_storage), but use a network model instead of a copper-plate model.
# The [`PowerSimulations.NetworkModel`](@extref) uses [`PowerSimulations.PTDFPowerModel`](@extref) with a
# [`PowerNetworkMatrices.PTDF`](@extref) matrix. Request duals on each line's
# `FlowRateConstraint` and on the system balance so you can read congestion and energy prices.

ptdf = PTDF(sys)
template_ed = ProblemTemplate()

set_device_model!(
    template_ed,
    DeviceModel(Line, StaticBranch; duals = [FlowRateConstraint]),
)

set_network_model!(
    template_ed,
    NetworkModel(
        PTDFPowerModel;
        PTDF_matrix = ptdf,
        use_slacks = true,
        duals = [CopperPlateBalanceConstraint],
    ),
)

# LMPs come from optimization duals on a linear program (LP), so this showcase uses an economic dispatch problem with continuous variables instead of a unit commitment with binary variables. Therefore, we use continuous formulations such as 
# [`PowerSimulations.ThermalBasicDispatch`](@extref):

set_device_model!(template_ed, ThermalStandard, ThermalBasicDispatch)
set_device_model!(template_ed, TapTransformer, StaticBranch)
set_device_model!(template_ed, RenewableDispatch, RenewableFullDispatch)
set_device_model!(template_ed, RenewableNonDispatch, FixedOutput)
set_device_model!(template_ed, PowerLoad, StaticPowerLoad)
set_device_model!(template_ed, HydroDispatch, HydroDispatchRunOfRiver)
set_device_model!(template_ed, HydroTurbine, HydroDispatchRunOfRiver)

# ## Run the day-ahead simulation
#
# Follow the same single-step pipeline as [Production Cost Modeling](@ref showcase_pcm_storage):
# [`PowerSimulations.DecisionModel`](@extref) → [`PowerSimulations.SimulationSequence`](@extref) →
# [`PowerSimulations.Simulation`](@extref) → [`PowerSimulations.build!`](@extref) /
# [`PowerSimulations.execute!`](@extref).

ed_model = DecisionModel(
    template_ed,
    sys;
    name = "ED",
    optimizer = solver,
    initialize_model = false,
    optimizer_solve_log_print = false,
    check_numerical_bounds = false,
    warm_start = true,
    store_variable_names = true,
)

models = SimulationModels(; decision_models = [ed_model])
sequence = SimulationSequence(;
    models = models,
    ini_cond_chronology = InterProblemChronology(),
)

sim = Simulation(;
    name = "network_lmp_showcase",
    steps = 1,
    models = models,
    sequence = sequence,
    initial_time = INITIAL_TIME,
    simulation_folder = mktempdir(),
)

build!(sim; console_level = Logging.Warn, file_level = Logging.Error)
execute!(sim; enable_progress_bar = false)
results = get_decision_problem_results(SimulationResults(sim), "ED")

# ## Rank congested lines
#
# Under [`PowerSimulations.PTDFPowerModel`](@extref), binding lines appear as nonzero duals on
# `FlowRateConstraint`. [`PowerAnalytics.make_selector`](@extref) picks the lines to analyze;
# [`PowerAnalytics.calc_flow_rate_dual`](@extref) returns the signed dual
# ``\mu_\ell = \mathrm{dual\_ub} + \mathrm{dual\_lb}`` each hour, and
# [`PowerAnalytics.calc_is_congested`](@extref) flags hours where either bound exceeds the
# default dual threshold.
# Filter to lines present in the stored duals — PTDF network reduction can omit some
# catalog lines from the results:

lines_with_duals =
    Set(string.(unique(read_realized_dual(results, "FlowRateConstraint__Line__ub").name)))
line_sel = make_selector(l -> get_name(l) in lines_with_duals, Line)
dual_ts = calc_flow_rate_dual(line_sel, results)
cong_ts = calc_is_congested(line_sel, results)

# Timed metrics return a `DateTime` column and one data column per line (`Line__<name>`).
# Collapse each series over the horizon for peak ``|\mu|`` and the fraction of congested hours:

congestion_rank = DataFrame([
    Dict(
        "Line" => replace(string(col), r"^Line__" => ""),
        "Peak |μ|" => maximum(abs.(dual_ts[!, col])),
        "Hours congested (%)" => 100 * mean(Float64.(cong_ts[!, col])),
    ) for col in get_data_cols(dual_ts) if maximum(abs.(dual_ts[!, col])) > 1e-6
])
sort!(congestion_rank, "Peak |μ|"; rev = true)

# ## Line utilization and congestion time
#
# [`PowerAnalytics.calc_branch_utilization`](@extref) is
# ``|\mathrm{ActivePowerFlow}| / \mathrm{rating}`` each hour for each line. Aggregate for peak and
# mean utilization, and reuse the congestion fraction from above:

util_ts = calc_branch_utilization(line_sel, results)

utilization_summary = DataFrame([
    Dict(
        "Line" => replace(string(col), r"^Line__" => ""),
        "Peak utilization (%)" => 100 * maximum(util_ts[!, col]),
        "Mean utilization (%)" => 100 * mean(util_ts[!, col]),
        "Hours congested (%)" => 100 * mean(Float64.(cong_ts[!, col])),
    ) for col in get_data_cols(util_ts)
])
sort!(utilization_summary, "Peak utilization (%)"; rev = true)

# ## Reconstruct bus LMPs
#
# The LMP at bus ``b`` is ``\lambda + \mu^\top \mathrm{PTDF}_{:,b}``, where ``\lambda`` is the dual
# of [`PowerSimulations.CopperPlateBalanceConstraint`](@extref). Each hour, take ``\mu`` from the
# same `dual_ts` used for ranking above, then index the PTDF by branch name and bus number.

# !!! details "When PTDF rows are arc-indexed"
#     After network reductions, some PSI line duals (for example parallel groups)
#     are not PTDF rows. Keep only branches in `direct_branch_map`, or map arcs with
#     `get_arc_axis` / `direct_branch_map` before aligning ``\mu``.

λ_df = read_realized_dual(results, "CopperPlateBalanceConstraint__System")
nr = get_network_reduction_data(ptdf)
line_names = [get_name(b) for b in values(nr.direct_branch_map)]

times = sort(unique(λ_df.DateTime))
hourly_lmp_stats = DataFrame(;
    hour_index = Int[],
    DateTime = DateTime[],
    lmp_mean = Float64[],
    lmp_min = Float64[],
    lmp_max = Float64[],
    lmp_spread = Float64[],
)
hourly_bus_lmps = Dict{DateTime, Dict{String, Float64}}()

for (h, t) in enumerate(times)
    λ = Float64(only(λ_df[λ_df.DateTime .== t, :value]))
    dual_row = dual_ts[dual_ts.DateTime .== t, :]
    μ = [
        let col = "Line__" * name
            col in names(dual_row) ? Float64(only(dual_row[!, col])) : 0.0
        end for name in line_names
    ]
    lmps = Dict{String, Float64}()
    for bus in get_components(ACBus, sys)
        col = [ptdf[name, get_number(bus)] for name in line_names]
        lmps[get_name(bus)] = λ + sum(μ[i] * col[i] for i in eachindex(μ); init = 0.0)
    end
    vals = collect(values(lmps))
    spread = maximum(vals) - minimum(vals)
    hourly_bus_lmps[t] = lmps
    push!(
        hourly_lmp_stats,
        (
            hour_index = h,
            DateTime = t,
            lmp_mean = mean(vals),
            lmp_min = minimum(vals),
            lmp_max = maximum(vals),
            lmp_spread = spread,
        ),
    )
end

# Show the LMP stats for the hours 10-15:
hourly_lmp_stats[10 .<= hourly_lmp_stats.hour_index .<= 15, :]

# Those hourly mean LMPs and the min–max envelope are visualized below:
# 
#md # ![Hourly system LMP mean and range](assets/G1_lmp_trajectory.png)

# Compare the hourly LMP trajectory to the fuel mix from [`PowerGraphics.plot_fuel`](@extref):
#
# ```julia
# plot_fuel(results)
# ```
#
#md # ![Network LMP day fuel stack](assets/G1_fuel_stack.png)
#
# LMPs are zero most of the day due to excess curtailed renewable generation, with thermal generation
# committed on to serve the peak net-load hour at the end of the solar ramp-down. 
# LMPs increase during the period that the thermal generation has to ramp
# up to meet the net-load.

# ## Takeaways and Next Steps
#
# - [`PowerAnalytics.jl`](@extref PowerAnalytics :doc:`index`) ranks binding corridors and reports
#   utilization from the same `FlowRateConstraint` duals and branch flows used in the dispatch.
# - Reconstructing bus LMPs from ``\lambda``, ``\mu``, and the PTDF links those corridors to
#   locational prices on the same snapshot day.
# - [`PowerNetworkMatrices.jl`](@extref PowerNetworkMatrices :doc:`index`) and
#   [`PowerSimulations.jl`](@extref PowerSimulations :doc:`index`) stay modular: swap the network
#   model without rebuilding device templates.
#
# Next, check whether the schedule is feasible with AC power flow inside the loop in
# [Unit Commitment with Power Flow In The Loop](@ref showcase_uc_power_flow_in_the_loop). For more depth, see the
# [PowerNetworkMatrices introduction tutorial](@extref PowerNetworkMatrices :doc:`tutorials/generated_introduction`) and the
# [single-step decision problem tutorial](@extref PowerSimulations :doc:`tutorials/generated_decision_problem`).
