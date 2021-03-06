using Crazyflie
using ProgressMeter

# temporary
using PyCall
using DelimitedFiles

#  figure8 = [
#      [1.050000, 0.000000, -0.000000, 0.000000, -0.000000, 0.830443, -0.276140, -0.384219, 0.180493, -0.000000, 0.000000, -0.000000, 0.000000, -1.356107, 0.688430, 0.587426, -0.329106, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000],  # noqa
#      [0.710000, 0.396058, 0.918033, 0.128965, -0.773546, 0.339704, 0.034310, -0.026417, -0.030049, -0.445604, -0.684403, 0.888433, 1.493630, -1.361618, -0.139316, 0.158875, 0.095799, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000],  # noqa
#      [0.620000, 0.922409, 0.405715, -0.582968, -0.092188, -0.114670, 0.101046, 0.075834, -0.037926, -0.291165, 0.967514, 0.421451, -1.086348, 0.545211, 0.030109, -0.050046, -0.068177, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000],  # noqa
#      [0.700000, 0.923174, -0.431533, -0.682975, 0.177173, 0.319468, -0.043852, -0.111269, 0.023166, 0.289869, 0.724722, -0.512011, -0.209623, -0.218710, 0.108797, 0.128756, -0.055461, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000],  # noqa
#      [0.560000, 0.405364, -0.834716, 0.158939, 0.288175, -0.373738, -0.054995, 0.036090, 0.078627, 0.450742, -0.385534, -0.954089, 0.128288, 0.442620, 0.055630, -0.060142, -0.076163, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000],  # noqa
#      [0.560000, 0.001062, -0.646270, -0.012560, -0.324065, 0.125327, 0.119738, 0.034567, -0.063130, 0.001593, -1.031457, 0.015159, 0.820816, -0.152665, -0.130729, -0.045679, 0.080444, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000],  # noqa
#      [0.700000, -0.402804, -0.820508, -0.132914, 0.236278, 0.235164, -0.053551, -0.088687, 0.031253, -0.449354, -0.411507, 0.902946, 0.185335, -0.239125, -0.041696, 0.016857, 0.016709, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000],  # noqa
#      [0.620000, -0.921641, -0.464596, 0.661875, 0.286582, -0.228921, -0.051987, 0.004669, 0.038463, -0.292459, 0.777682, 0.565788, -0.432472, -0.060568, -0.082048, -0.009439, 0.041158, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000],  # noqa
#      [0.710000, -0.923935, 0.447832, 0.627381, -0.259808, -0.042325, -0.032258, 0.001420, 0.005294, 0.288570, 0.873350, -0.515586, -0.730207, -0.026023, 0.288755, 0.215678, -0.148061, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000],  # noqa
#      [1.053185, -0.398611, 0.850510, -0.144007, -0.485368, -0.079781, 0.176330, 0.234482, -0.153567, 0.447039, -0.532729, -0.855023, 0.878509, 0.775168, -0.391051, -0.713519, 0.391628, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000, 0.000000],  # noqa
#  ]

heart = [
[0.608998,0,0,0,0,8.42094,-20.1848,17.4023,-5.13733,0,0,0,0,-5.25294,19.5805,-26.0513,12.0229,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0.779122,0.195632,0.637789,0.0169511,-0.469071,1.13898,-5.83124,8.3787,-3.63444,-0.0377946,-0.0794284,-0.0646026,0.0244159,-3.78373,9.99798,-9.63602,3.27284,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0.757723,0.467339,-0.036739,-0.110484,0.0639573,0.108074,-1.39392,2.11362,-0.935232,-0.236257,-0.347344,-0.032209,-0.0141377,-1.22068,4.0166,-4.3725,1.62188,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0.957797,0.357255,-0.274841,-0.111489,-0.0115323,-3.42962,8.38992,-7.1466,2.09672,-0.518182,-0.328702,0.0913417,0.0150219,0.733687,-1.05708,0.479298,-0.0521867,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0.95006,-0.108941,-0.502428,-0.0278039,-0.0132172,-2.03991,5.51081,-5.00167,1.53592,-0.639182,0.0542293,0.051927,0.014188,3.04728,-7.84289,6.93303,-2.09398,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0.998431,-0.624157,-0.461845,-0.0138318,-0.00967601,-2.04884,5.5933,-4.99039,1.48711,-0.481169,0.114548,0.029441,0.000554473,3.31264,-7.6003,6.14741,-1.71994,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0.812602,-1.06789,-0.279874,-0.0292519,-0.0503488,-3.7103,10.0379,-9.64748,3.24897,-0.197235,0.269061,-0.00363612,0.0151035,0.916496,-3.79814,4.50747,-1.72174,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0.419508,-1.42038,-0.468108,0.0856745,0.221818,3.92471,-0.277235,-23.883,26.7762,-0.0240585,0.0921,-0.0459625,0.0111955,-3.86908,19.5572,-35.3542,22.4094,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0.64054,-1.5363,-0.00325354,0.514808,0.0803983,-2.16099,9.25223,-14.0528,6.98868,0.000127304,0.0443542,0.0111982,0.0261656,1.57639,-5.36123,6.53792,-2.78901,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0.893144,-1.33358,0.558221,0.00558749,-0.182813,1.17326,-3.86353,4.22095,-1.49454,0.05546,0.116935,0.0458194,0.000332267,2.56277,-6.40182,5.67683,-1.7497,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[1.0137,-0.944994,0.264934,0.0564772,0.0488614,3.09438,-7.21848,5.83434,-1.62251,0.277414,0.275656,0.00454676,0.0105108,1.06699,-2.79915,2.41189,-0.698664,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0.941904,-0.480716,0.458841,0.0299512,0.00400315,2.13691,-5.30337,4.62042,-1.38829,0.551501,0.16792,-0.0455683,-0.000158787,-0.00812595,-0.31599,0.457477,-0.175203,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0.902676,0.0448938,0.563892,0.0356819,-0.0204628,3.81762,-12.3689,12.5856,-4.21939,0.632664,-0.0105303,-0.0563382,-0.0149921,-4.47262,11.1707,-9.8176,2.99179,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0.696637,0.437821,0.0271313,-0.0955769,0.0683252,-3.88281,13.7328,-16.7036,6.91373,0.441299,-0.197977,0.0795611,-0.0410307,-17.0929,56.5153,-65.8397,26.5171,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0.790226,0.413439,0.0024842,-0.0197612,-0.0573184,-9.94595,26.5283,-25.7537,8.8682,0.160997,-0.308277,0.0562815,0.00236697,1.27222,-2.73425,2.12724,-0.57832,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0],
[0.418106,0.106269,-0.544119,0.234554,1.02684,3.93774,-3.17014,-30.7186,40.0474,0.0139615,-0.0875489,0.0363838,0.0507818,5.39905,-25.4338,43.0935,-25.8168,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0,0]
]

function collectdata(cf, N)
    Ω = Array{Float64,2}(undef, N, 3) # p, q, r
    U = Array{Float64,2}(undef, N, 3) # roll, pitch, yaw PWM
    progress = Progress(N, 0.01, "Collecting Data: ")
    lconfig = logger.LogConfig(name="Stabilizer", period_in_ms=10) # 100 Hz
    lconfig.add_variable("gyro.x", "float")
    lconfig.add_variable("gyro.y", "float")
    lconfig.add_variable("gyro.z", "float")
    lconfig.add_variable("controller.ctr_roll", "int16_t")
    lconfig.add_variable("controller.ctr_pitch", "int16_t")
    lconfig.add_variable("controller.ctr_yaw", "int16_t")
    record(cf, lconfig) do logs
        i = 1
        for entry in logs
            data = entry[2]
            Ω[i, 1] =  data["gyro.x"]*π/180.0
            Ω[i, 2] = -data["gyro.y"]*π/180.0 # negative
            Ω[i, 3] =  data["gyro.z"]*π/180.0
            U[i, 1] =  data["controller.ctr_roll"]/14324.0
            U[i, 2] =  data["controller.ctr_pitch"]/14324.0
            U[i, 3] = -data["controller.ctr_yaw"]/14324.0 # negative
            next!(progress)
            if i ≥ N
                break
            end
            i += 1
        end
    end
    return Ω, U
end

py"""
import time
from cflib.crazyflie.mem import MemoryElement
from cflib.crazyflie.mem import Poly4D

class Uploader:
    def __init__(self):
        self._is_done = False

    def upload(self, trajectory_mem):
        print('Uploading data')
        trajectory_mem.write_data(self._upload_done)

        while not self._is_done:
            time.sleep(0.2)

    def _upload_done(self, mem, addr):
        print('Data uploaded')
        self._is_done = True


def upload_trajectory(cf, trajectory_id, trajectory):
    trajectory_mem = cf.mem.get_mems(MemoryElement.TYPE_TRAJ)[0]

    total_duration = 0
    for row in trajectory:
        duration = row[0]
        x = Poly4D.Poly(row[1:9])
        y = Poly4D.Poly(row[9:17])
        z = Poly4D.Poly(row[17:25])
        yaw = Poly4D.Poly(row[25:33])
        trajectory_mem.poly4Ds.append(Poly4D(duration, x, y, z, yaw))
        total_duration += duration

    Uploader().upload(trajectory_mem)
    cf.high_level_commander.define_trajectory(trajectory_id, 0,
                                              len(trajectory_mem.poly4Ds))
    return total_duration
"""

#  function upload_traj(cf, id, traj)
#      trajmem = cf.mem.get_mems(mem.MemoryElement.TYPE_TRAJ)[1]
#      total_duration = 0
#      for row in traj
#          duration = row[1]
#          x = mem.Poly4D.Poly(row[2:9])
#          y = mem.Poly4D.Poly(row[10:17])
#          z = mem.Poly4D.Poly(row[18:25])
#          yaw = mem.Poly4D.Poly(row[26:33])
#          push!(trajmem.poly4Ds, mem.Poly4D(duration, x, y, z, yaw))
#          total_duration += duration
#      end
#      py"""
#      import time
#      class Uploader:
#          def __init__(self):
#              self._is_done = False
#
#          def upload(self, trajectory_mem):
#              print('Uploading data')
#              trajectory_mem.write_data(self._upload_done)
#
#              while not self._is_done:
#                  time.sleep(0.2)
#
#          def _upload_done(self, mem, addr):
#              print('Data uploaded')
#              self._is_done = True
#      """
#      py"Uploader().upload($trajmem)"
#      for i = 1:5
#          cf.high_level_commander.define_trajectory(id, 0, length(trajmem.poly4Ds))
#          sleep(0.1)
#      end
#      print("Uploaded a $total_duration seconds trajectory\n")
#      return total_duration
#  end

function reset_estimator(cf)
    cf.param.set_value("kalman.resetEstimation", "1")
    sleep(0.1)
    cf.param.set_value("kalman.resetEstimation", "0")
    lconfig = logger.LogConfig(name="Kalman Variance", period_in_ms=500)
    lconfig.add_variable("kalman.varPX", "float")
    lconfig.add_variable("kalman.varPY", "float")
    lconfig.add_variable("kalman.varPZ", "float")
    varx = ones(10)*1000
    vary = ones(10)*1000
    varz = ones(10)*1000
    record(cf, lconfig) do logs
        for entry in logs
            data = entry[2]
            push!(varx, data["kalman.varPX"])
            push!(vary, data["kalman.varPY"])
            push!(varz, data["kalman.varPZ"])
            popfirst!(varx); popfirst!(vary); popfirst!(varz)
            threshx = (maximum(varx) - minimum(varx)) < 0.001
            threshy = (maximum(vary) - minimum(vary)) < 0.001
            threshz = (maximum(varz) - minimum(varz)) < 0.001
            if threshx && threshy && threshz
                break
            end
        end
    end
end

function enable_commander(cf)
    cf.param.set_value("commander.enHighLevel", "1")
    cf.high_level_commander
end

# because commander.land is not reliable
function land(commander, duration)
    print("Landing\n")
    for i = 1:10
        commander.land(0.0, duration)
        sleep(0.1)
    end
    sleep(duration)
    commander.stop()
end

# because commander.takeoff is not reliable
function takeoff(commander, height, duration)
    print("Taking Off\n")
    for i = 1:5
        commander.takeoff(height, duration)
        sleep(0.1)
    end
    sleep(duration)
end

# because commander.start_trajectory is not reliable
function start_trajectory(commander, id, rel)
    print("Starting Trajectory\n")
    for i = 1:5
        commander.start_trajectory(id, relative=rel)
        sleep(0.1)
    end
    sleep(1.0)
end


function learn2fly(uri="radio://0/80/2M")
    Ω = []; U = []
    play(uri) do cf
        commander = enable_commander(cf)
        duration = py"upload_trajectory($cf, $1, $heart)"
        reset_estimator(cf)
        takeoff(commander, 1.0, 2.0)
        start_trajectory(commander, 1, true)
        N = round(Int, duration*100)
        Ω, U = collectdata(cf, N)
        sleep(1.0)
        land(commander, 5.0)
    end
    writedlm("/tmp/omega.txt", Ω)
    writedlm("/tmp/controls.txt", U)
    return nothing
end
