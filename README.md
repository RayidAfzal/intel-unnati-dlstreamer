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

## 🚀 How to Run This Project

### 🔧 1. Install & Set Up DLStreamer Environment

Follow the official steps from Intel’s docs:

https://dlstreamer.github.io/dev_guide/advanced_install/advanced_install_guide_index.html

1. Install prerequisites and DLStreamer via APT:
   ```bash
   wget -O DLS_install_prerequisites.sh https://raw.githubusercontent.com/open-edge-platform/edge-ai-libraries/main/libraries/dl-streamer/scripts/DLS_install_prerequisites.sh
   chmod +x DLS_install_prerequisites.sh
   ./DLS_install_prerequisites.sh
   sudo apt-get update
   sudo apt-get install intel-dlstreamer intel-dlstreamer-gst
   ```
2. Configure environment variables:
   ```bash
   source /opt/intel/dlstreamer/scripts/setup_dls_config.sh
   ```
   This sets up:
   - `GST_PLUGIN_PATH`
   - `LD_LIBRARY_PATH`
   - Adds DLStreamer binaries to `PATH` :contentReference[oaicite:2]{index=2}

3. (Optional) For GPU / VA‑API support:
   ```bash
   export LIBVA_DRIVERS_PATH=/usr/lib/x86_64-linux-gnu/dri
   export GST_VA_ALL_DRIVERS=1
   ```

---

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

