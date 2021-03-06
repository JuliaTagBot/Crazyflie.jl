using Crazyflie
using MeshCat, GeometryTypes, CoordinateTransformations

function plotcflie(vis, uri="radio://0/80/2M")
    play(uri) do cf
        lconfig = logger.LogConfig(name="Configuration", period_in_ms=100)
        lconfig.add_variable("stateEstimateZ.x", "int16_t")
        lconfig.add_variable("stateEstimateZ.y", "int16_t")
        lconfig.add_variable("stateEstimateZ.z", "int16_t")
        lconfig.add_variable("stateEstimate.qx", "float")
        lconfig.add_variable("stateEstimate.qy", "float")
        lconfig.add_variable("stateEstimate.qz", "float")
        lconfig.add_variable("stateEstimate.qw", "float")
        record(cf, lconfig) do logs
            for entry in logs
                data = entry[2]
                pos = Translation(data["stateEstimateZ.x"]/1.0e3,
                                  data["stateEstimateZ.y"]/1.0e3,
                                  data["stateEstimateZ.z"]/1.0e3)
                quat = LinearMap(Quat(data["stateEstimate.qw"],
                                      data["stateEstimate.qx"],
                                      data["stateEstimate.qy"],
                                      data["stateEstimate.qz"]))
                print("qw = ", data["stateEstimate.qz"], "\n")
                settransform!(vis, pos ∘ quat)
            end
        end
    end
end

function drawcflie()
    vis = Visualizer()
    open(vis)
    setobject!(vis, HyperRectangle(Vec(-0.1, -0.1, 0), Vec(0.2, 0.2, 0.01)))
    return vis
end


