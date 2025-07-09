#!/bin/bash

NUM_STREAMS=1  # Adjust this based on GPU muscle

VIDEO_ORIGINAL="$HOME/Downloads/testingnew.mp4"
VIDEO_DIR="$HOME/Downloads/video_copies_gpu"
LOG_DIR="$HOME/scriptFinal_GPU/log"

# Model paths
DETECTION_MODEL="$HOME/intel/person-detection-retail-0013/FP16/person-detection-retail-0013.xml"
CLASSIFICATION_MODEL="$HOME/intel/person-attributes-recognition-crossroad-0230/FP16/person-attributes-recognition-crossroad-0230.xml"
DETECTION_PROC="/opt/intel/dlstreamer/samples/gstreamer/model_proc/intel/person-detection-retail-0013.json"
CLASSIFICATION_PROC="/opt/intel/dlstreamer/samples/gstreamer/model_proc/intel/person-attributes-recognition-crossroad-0230.json"

# Create required folders
mkdir -p "$VIDEO_DIR"
mkdir -p "$LOG_DIR"

# Clone the video for each stream
for ((i=1; i<=NUM_STREAMS; i++)); do
    cp "$VIDEO_ORIGINAL" "$VIDEO_DIR/video_$i.mp4"
done

# Launch each GPU stream in its own terminal
for ((i=1; i<=NUM_STREAMS; i++)); do
    gnome-terminal --title="GPU Stream $i" -- bash -c "\
        echo '>>> Running GPU Stream $i' | tee '$LOG_DIR/gpu_stream_$i.log'; \
        gst-launch-1.0 -v filesrc location='$VIDEO_DIR/video_$i.mp4' ! decodebin ! \
        gvadetect model='$DETECTION_MODEL' model-proc='$DETECTION_PROC' device=GPU ! queue ! \
        gvaclassify model='$CLASSIFICATION_MODEL' model-proc='$CLASSIFICATION_PROC' device=GPU object-class=person reclassify-interval=10 ! queue ! \
        gvawatermark ! videoconvert ! fpsdisplaysink text-overlay=true sync=false video-sink='xvimagesink force-aspect-ratio=true' signal-fps-measurements=true \
        2>&1 | tee -a '$LOG_DIR/gpu_stream_$i.log'; \
        notify-send 'GPU Stream $i Completed 🎯'; \
        exit"
done

