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
