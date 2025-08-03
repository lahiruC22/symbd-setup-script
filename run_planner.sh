#!/bin/bash

#--- Configuration ---
# Local SIF file path for the planner
SIF_FILE_PATH="symbd.sif"  # Path to your local SIF file

# The directory where your domain and problem
# PDDL files are stored
PDDL_DIR="pddl_files"

# The directory where the output files will be saved.
OUTPUT_DIR="results"

# --- Installation Function ---
# This function installs Apptainer on modern Debian/Ubuntu
# systems using apt

install_apptainer_from_repo() {
    echo "Apptainer not found. Attempting to install from the official Ubuntu repository..."
    echo "This process requires root privileges (sudo) and is recommended for Ubuntu 22.04+."

    # Prompt for sudo password at the beginning to ensure smooth installation.
    sudo -v
    if [ $? -ne 0 ]; then
        echo "Error: sudo credentials are required. Please run the script again."
        exit 1
    fi

    # Update package lists
    echo "--> Updating package lists..."
    sudo apt-get update -y

    # Install the apptainer package
    echo "--> Installing Apptainer..."
    sudo apt-get install -y apptainer

    # Check if the installation command was successful
    if [ $? -ne 0 ]; then
        echo "Error: Failed to install Apptainer using 'apt-get'."
        echo "Please ensure you are running Ubuntu 22.04+ or newer, or install Apptainer manually."
        exit 1
    fi

    echo "Apptainer has been installed successfully from the repository."
}

# --- Main Script Execution ---
echo "Starting the planner script..."

# 1. Check if Apptainer is installed, if not, run the installer function
if ! command -v apptainer &> /dev/null; then
    install_apptainer_from_repo

    if ! command -v apptainer &> /dev/null; then
        echo "Error: Apptainer installation failed. Please review the output above."
        echo "You may need to install it manually if you are not on Ubuntu 22.04+."
        exit 1
    fi
fi


# If we reach this point, Apptainer is installed
echo "Apptainer installation verfied. Version: $(apptainer --version)"

# 2. Check if the local SIF file exists
echo "Checking for local SIF file..."
if [ ! -f "${SIF_FILE_PATH}" ]; then
    echo "Error: Local SIF file '${SIF_FILE_PATH}' not found."
    echo "Please ensure the SIF file exists in the current directory or update the SIF_FILE_PATH variable."
    exit 1
fi

echo "Using local SIF file: ${SIF_FILE_PATH}"

# 3. Create the output directory
mkdir -p "${OUTPUT_DIR}"

# 4. Run the planner with the PDDL files
echo "Searching for PDDL files in the directory: ${PDDL_DIR}..."
if [ ! -d "${PDDL_DIR}" ]; then
    echo "Error: The specified PDDL directory '${PDDL_DIR}' does not exist."
    exit 1
fi

# Find the domain file
domain_file="${PDDL_DIR}/domain.pddl"
if [ ! -e "${domain_file}" ]; then
    echo "Error: Domain file 'domain.pddl' not found in '${PDDL_DIR}'. Exiting."
    exit 1
fi

echo "Processing domain file: domain.pddl"

# Find all problem files (excluding domain.pddl)
problem_found=false
for problem_file in "${PDDL_DIR}"/*.pddl; do
    # Skip the domain file
    if [ "$(basename "$problem_file")" = "domain.pddl" ]; then
        continue
    fi
    
    if [ -e "${problem_file}" ]; then
        problem_found=true
        problem_base=$(basename "$problem_file" .pddl)
        echo " -> Running Problem: ${problem_base}"

        output_file="${OUTPUT_DIR}/${problem_base}_output.txt"
        apptainer run "${SIF_FILE_PATH}" "${domain_file}" "${problem_file}" > "${output_file}" 2>&1
        echo " -> Output saved to: ${output_file}"
    fi
done

if ! $problem_found; then
    echo "No problem files found in '${PDDL_DIR}'."
fi

echo "-----------------------------------------------"
echo "Automation script finished"