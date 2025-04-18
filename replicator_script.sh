#!/bin/bash

CURRENT_DIR="$(pwd)"
OUTPUT_DIR="../dumped_generated_units/high_freq_single_unit_tests/"

mkdir -p "$OUTPUT_DIR"

START_FREQ=2500
END_FREQ=5000
STEP=500

OPERATIONS=("Adder" "Multiplier" "Divider" "Subtractor")

for freq in $(seq $START_FREQ $STEP $END_FREQ); do
    for op in "${OPERATIONS[@]}"; do
        echo "Processing $op at frequency: $freq MHz"

        cat > float_config.json << EOF
{
  "operators": [
    {
      "name": "FloatingPoint$op",
      "bitSize": 32,
      "targetFrequencyMHz": $freq
    }
  ]
}
EOF

        WRAPPER_NAME="wrapper_${op,,}_freq${freq}.vhd"
        OUTPUT_NAME="${op,,}_freq${freq}.vhd"

        sudo python3 float_gen.py --vhdl_output_dir "$OUTPUT_DIR" \
                                  --wrapper_file_name "$WRAPPER_NAME" \
                                  --out_file_name "$OUTPUT_NAME"

	
        echo "Completed generation for $op at $freq MHz"
    done
done

echo "Parameter sweep complete"
