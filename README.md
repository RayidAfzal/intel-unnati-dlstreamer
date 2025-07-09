# Intel Unnati Internship – DLStreamer CPU Pipeline Stress Test

This repository documents the Intel Unnati Internship project focused on evaluating the performance of **Intel DLStreamer** on a system with Intel Iris Xe graphics. The goal was to test real-time video inference pipelines using **OpenVINO-compatible models** running on both **CPU** and **iGPU (Iris Xe)**.

---

## 🧠 System Configuration

| Component            | Details                        |
|----------------------|--------------------------------|
| **Processor**        | Intel Core i5-1235U (10-core)  |
| **Integrated GPU**   | Intel Iris Xe Graphics         |
| **RAM**              | 8 GB                           |
| **Storage**          | SSD                            |
| **Operating System** | Ubuntu 24.04 LTS               |
| **DLStreamer Target**| CPU&iGPU(Iris Xe) benchmarking |


---

## 🧪 Models Used

| Task            | Model Name                                       | Format             |
|-----------------|--------------------------------------------------|--------------------|
| Object Detection| `person-detection-retail-0013`                   | OpenVINO IR (FP16) |
| Classification  | `person-attributes-recognition-crossroad-0230`  | OpenVINO IR (FP16) |

- **Model Proc Files** were sourced from the DLStreamer sample directory:  
  `/opt/intel/dlstreamer/samples/gstreamer/model_proc/intel/`

---

## 🎞️ Pipeline Description

Each stream launches a GStreamer pipeline performing:

```bash
filesrc → decodebin → gvadetect → gvaclassify → gvawatermark → fpsdisplaysink
```
## 🚀 How to Run This Project

### 🔧 1. Install & Set Up DLStreamer Environment

Follow the official guide:  
https://dlstreamer.github.io/get_started/install/install_guide_ubuntu.html

---

#### 📥 Step 1: Download the Prerequisites Installation Script

```bash
mkdir -p ~/intel/dlstreamer_gst
cd ~/intel/dlstreamer_gst/
wget -O DLS_install_prerequisites.sh https://raw.githubusercontent.com/open-edge-platform/edge-ai-libraries/main/libraries/dl-streamer/scripts/DLS_install_prerequisites.sh
chmod +x DLS_install_prerequisites.sh
```

---

#### 🛠️ Step 2: Run the Script

```bash
./DLS_install_prerequisites.sh
```

This installs:
- **GPU**: `libze-intel-gpu1`, `libze1`, `intel-opencl-icd`, `clinfo`, `intel-gsc`
- **Media**: `intel-media-va-driver-non-free`
- **NPU**: `intel-driver-compiler-npu`, `intel-fw-npu`, `intel-level-zero-npu`, `level-zero`

---

#### 🔐 Step 3: Add Intel Repositories

```bash
sudo -E wget -O- https://apt.repos.intel.com/intel-gpg-keys/GPG-PUB-KEY-INTEL-SW-PRODUCTS.PUB | \
gpg --dearmor | sudo tee /usr/share/keyrings/oneapi-archive-keyring.gpg > /dev/null

sudo wget -O- https://eci.intel.com/sed-repos/gpg-keys/GPG-PUB-KEY-INTEL-SED.gpg | \
sudo tee /usr/share/keyrings/sed-archive-keyring.gpg > /dev/null

sudo bash -c 'echo "deb [signed-by=/usr/share/keyrings/sed-archive-keyring.gpg] https://eci.intel.com/sed-repos/$(source /etc/os-release && echo $VERSION_CODENAME) sed main" > /etc/apt/sources.list.d/sed.list'

sudo bash -c 'echo "deb [signed-by=/usr/share/keyrings/oneapi-archive-keyring.gpg] https://apt.repos.intel.com/openvino/2025 ubuntu24 main" > /etc/apt/sources.list.d/intel-openvino-2025.list'

sudo bash -c 'echo -e "Package: *\nPin: origin eci.intel.com\nPin-Priority: 1000" > /etc/apt/preferences.d/sed'
```

---

#### 📦 Step 4: Install DLStreamer

```bash
sudo apt update
sudo apt-get install intel-dlstreamer
```

---

#### 🧠 Step 5: Post-Installation Setup

1. **Download a Sample Model (YOLO11s)**:
   ```bash
   mkdir -p /home/${USER}/models
   export MODELS_PATH=/home/${USER}/models
   /opt/intel/dlstreamer/samples/download_public_models.sh yolo11s
   ```

2. **Run a Sample Test Pipeline**:
   ```bash
   /opt/intel/dlstreamer/scripts/hello_dlstreamer.sh
   ```

---

#### 📌 Important: Persistent Environment Setup

To ensure the DLStreamer environment is always configured, add this to your `~/.bashrc`:

```bash
export LIBVA_DRIVER_NAME=iHD
export GST_PLUGIN_PATH=/opt/intel/dlstreamer/build/intel64/Release/lib:/opt/intel/dlstreamer/gstreamer/lib/gstreamer-1.0:/opt/intel/dlstreamer/gstreamer/lib/
export LD_LIBRARY_PATH=/opt/intel/dlstreamer/gstreamer/lib:/opt/intel/dlstreamer/build/intel64/Release/lib:/opt/intel/dlstreamer/lib/gstreamer-1.0:/usr/lib:/opt/intel/dlstreamer/build/intel64/Release/lib:/opt/opencv:/opt/openh264:/opt/rdkafka:/opt/ffmpeg:/usr/local/lib/gstreamer-1.0:/usr/local/lib
export LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri
export GST_VA_ALL_DRIVERS=1
export PATH=/opt/intel/dlstreamer/gstreamer/bin:/opt/intel/dlstreamer/build/intel64/Release/bin:$PATH
export GST_PLUGIN_FEATURE_RANK=${GST_PLUGIN_FEATURE_RANK},ximagesink:MAX
```

Then apply it:
```bash
source ~/.bashrc
```


### 📼 2. Place Your Input Video

Place the test video here:

```bash
~/Downloads/testingnew.mp4
```

The script will clone it for each parallel stream.

---

### 🧠 3. Run the CPU Stream Pipeline

```bash
chmod +x scripts/boom.sh
./scripts/boom.sh
```

- Spawns 10 streams (one per GNOME terminal)
- Runs each pipeline using CPU
- Logs output: `~/scriptFinal/log/cpu_stream_X.log`

---

### 💻 4. Run the GPU Stream Pipeline (Optional)

> ⚠️ This didn't perform well in testing — acceleration fell back to CPU.

```bash
chmod +x scripts/boom_gpu.sh
./scripts/boom_gpu.sh
```

- Logs saved at: `~/scriptFinal_GPU/log/gpu_stream_X.log`

---

### 📝 5. Notes & Tips

- Ensure `gnome-terminal` is installed for parallel stream launching.
- Avoid using more than 8 streams on an 8 GB RAM system to prevent OOM issues.
- Logs include `fpsdisplaysink` outputs, inference times, and crash info.

