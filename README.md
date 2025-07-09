# Intel Unnati Internship – DLStreamer CPU Pipeline Stress Test

This project is part of the **Intel Unnati Internship** and explores the performance of **Intel DLStreamer** using **CPU-only GStreamer pipelines** for video analytics. It benchmarks the ability to process **multiple parallel video streams** using pre-trained OpenVINO models for object detection and classification.

---

## 🧠 System Specs

- **Device:** Laptop with Intel Iris Xe iGPU
- **Execution Target:** CPU (no GPU acceleration used)
- **OS:** Ubuntu (GNOME Terminal environment)
- **Parallel Streams Tested:** Up to 10
- **Video Input:** Cloned copies of a single MP4 file

---

## 🧪 Models Used

| Purpose        | Model Name                                       | Framework  |
|----------------|--------------------------------------------------|------------|
| Detection      | person-detection-retail-0013                     | OpenVINO IR (FP16) |
| Classification | person-attributes-recognition-crossroad-0230    | OpenVINO IR (FP16) |

> JSON-based `model-proc` files from DLStreamer sample paths were used for post-processing.

---

## 🛠️ Pipeline Overview

Each stream runs this GStreamer pipeline:

```bash
filesrc ! decodebin ! \
gvadetect ! gvaclassify ! gvawatermark ! videoconvert ! fpsdisplaysink
