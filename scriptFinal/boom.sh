#!/bin/bash

NUM_STREAMS=10 # Adjust this for how many parallel streams you want

VIDEO_ORIGINAL="$HOME/Downloads/testingnew.mp4"
VIDEO_DIR="$HOME/Downloads/video_copies_cpu"
LOG_DIR="$HOME/scriptFinal/log"
	
# Model Paths
DETECTION_MODEL="$HOME/intel/person-detection-retail-0013/FP16/person-detection-retail-0013.xml"
CLASSIFICATION_MODEL="$HOME/intel/person-attributes-recognition-crossroad-0230/FP16/person-attributes-recognition-crossroad-0230.xml"
DETECTION_PROC="/opt/intel/dlstreamer/samples/gstreamer/model_proc/intel/person-detection-retail-0013.json"
CLASSIFICATION_PROC="/opt/intel/dlstreamer/samples/gstreamer/model_proc/intel/person-attributes-recognition-crossroad-0230.json"

# Create folders
mkdir -p "$VIDEO_DIR"
mkdir -p "$LOG_DIR"

# Clone videos
for ((i=1; i<=NUM_STREAMS; i++)); do
    cp "$VIDEO_ORIGINAL" "$VIDEO_DIR/video_$i.mp4"
done

# Launch each stream in its own terminal
for ((i=1; i<=NUM_STREAMS; i++)); do
    gnome-terminal --title="CPU Stream $i" -- bash -c "
        echo '>>> Running Stream $i' | tee '$LOG_DIR/cpu_stream_$i.log'
        gst-launch-1.0 -v filesrc location='$VIDEO_DIR/video_$i.mp4' ! decodebin ! \
        gvadetect model='$DETECTION_MODEL' model-proc='$DETECTION_PROC' device=CPU ! queue ! \
        gvaclassify model='$CLASSIFICATION_MODEL' model-proc='$CLASSIFICATION_PROC' device=CPU object-class=person reclassify-interval=10 ! queue ! \
        gvawatermark ! videoconvert ! fpsdisplaysink text-overlay=true sync=false video-sink=xvimagesink signal-fps-measurements=true \
        2>&1 | tee -a '$LOG_DIR/cpu_stream_$i.log'
        notify-send 'Stream $i Completed 🎉'
        exit"
done

#!/bin/bash

NUM_STREAMS=10 # Adjust this for how many parallel streams you want

VIDEO_ORIGINAL="$HOME/Downloads/testingnew.mp4"
VIDEO_DIR="$HOME/Downloads/video_copies_cpu"
LOG_DIR="$HOME/scriptFinal/log"
	
# Model Paths
DETECTION_MODEL="$HOME/intel/person-detection-retail-0013/FP16/person-detection-retail-0013.xml"
CLASSIFICATION_MODEL="$HOME/intel/person-attributes-recognition-crossroad-0230/FP16/person-attributes-recognition-crossroad-0230.xml"
DETECTION_PROC="/opt/intel/dlstreamer/samples/gstreamer/model_proc/intel/person-detection-retail-0013.json"
CLASSIFICATION_PROC="/opt/intel/dlstreamer/samples/gstreamer/model_proc/intel/person-attributes-recognition-crossroad-0230.json"

# Create folders
mkdir -p "$VIDEO_DIR"
mkdir -p "$LOG_DIR"

# Clone videos
for ((i=1; i<=NUM_STREAMS; i++)); do
    cp "$VIDEO_ORIGINAL" "$VIDEO_DIR/video_$i.mp4"
done

# Launch each stream in its own terminal
for ((i=1; i<=NUM_STREAMS; i++)); do
    gnome-terminal --title="CPU Stream $i" -- bash -c "
        echo '>>> Running Stream $i' | tee '$LOG_DIR/cpu_stream_$i.log'
        gst-launch-1.0 -v filesrc location='$VIDEO_DIR/video_$i.mp4' ! decodebin ! \
        gvadetect model='$DETECTION_MODEL' model-proc='$DETECTION_PROC' device=CPU ! queue ! \
        gvaclassify model='$CLASSIFICATION_MODEL' model-proc='$CLASSIFICATION_PROC' device=CPU object-class=person reclassify-interval=10 ! queue ! \
        gvawatermark ! videoconvert ! fpsdisplaysink text-overlay=true sync=false video-sink=xvimagesink signal-fps-measurements=true \
        2>&1 | tee -a '$LOG_DIR/cpu_stream_$i.log'
        notify-send 'Stream $i Completed 🎉'
        exit"
done

