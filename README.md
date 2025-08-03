# SymBD Planner Setup Script

A comprehensive automation script for running the SymBD planner on bulk PDDL problems. This repository includes the planner container (`symbd.sif`) and automation scripts for both Ubuntu and Windows users.

## 📋 Prerequisites

### For Ubuntu Users
- Ubuntu 22.04+ (recommended)
- Root/sudo access for initial setup
- Internet connection (for initial Apptainer installation)

### For Windows Users
- Windows 10/11 with WSL2 enabled
- Ubuntu 22.04+ installed in WSL2
- Windows Terminal (recommended)

## 🚀 Quick Start

### Ubuntu Users

1. **Clone the repository:**
   ```bash
   git clone https://github.com/lahiruC22/symbd-setup-script.git
   cd symbd-setup-script
   ```

2. **Make the script executable:**
   ```bash
   chmod +x run_planner.sh
   ```

3. **Run the planner:**
   ```bash
   ./run_planner.sh
   ```

The script will automatically:
- Install Apptainer if not present
- Use the included `symbd.sif` container
- Process all PDDL files in the `pddl_files/` directory
- Save results to the `results/` directory

### Windows Users

#### Step 1: Install WSL2 (if not already installed)

1. **Open PowerShell as Administrator** and run:
   ```powershell
   wsl --install
   ```

2. **Restart your computer** when prompted.

3. **Set up Ubuntu:**
   - Open Microsoft Store
   - Search for "Ubuntu 22.04" and install it
   - Launch Ubuntu and complete the initial setup

#### Step 2: Set up the environment in WSL2

1. **Open Ubuntu terminal in WSL2:**
   ```bash
   # Update package lists
   sudo apt update && sudo apt upgrade -y
   
   # Install git (if not present)
   sudo apt install git -y
   ```

2. **Clone the repository:**
   ```bash
   git clone https://github.com/lahiruC22/symbd-setup-script.git
   cd symbd-setup-script
   ```

3. **Make the script executable:**
   ```bash
   chmod +x run_planner.sh
   ```

4. **Run the planner:**
   ```bash
   ./run_planner.sh
   ```

#### Step 3: Access results from Windows

Your results will be available in:
- **WSL2 path:** `/home/[username]/symbd-setup-script/results/`
- **Windows path:** `\\wsl$\Ubuntu-22.04\home\[username]\symbd-setup-script\results\`

You can also access files through Windows Explorer by typing `\\wsl$\Ubuntu-22.04` in the address bar.

## 📁 Repository Structure

```
symbd-setup-script/
├── run_planner.sh          # Main automation script
├── symbd.sif              # SymBD planner container (Singularity/Apptainer)
├── pddl_files/            # Directory containing PDDL domain and problem files
│   ├── domain.pddl        # Domain definition
│   ├── easy01.pddl        # Problem files
│   ├── easy02.pddl
│   ├── moderate01.pddl
│   ├── hard01.pddl
│   └── ...
├── results/               # Output directory (created automatically)
├── README.md              # This file
└── .gitignore            # Git ignore rules
```

## 🔧 Configuration

### Script Configuration

The script can be configured by editing the variables at the top of `run_planner.sh`:

```bash
# Local SIF file path for the planner
SIF_FILE_PATH="symbd.sif"

# The directory where your domain and problem PDDL files are stored
PDDL_DIR="pddl_files"

# The directory where the output files will be saved
OUTPUT_DIR="results"
```

### Adding Your Own PDDL Files

1. Place your domain file as `pddl_files/domain.pddl`
2. Add problem files to `pddl_files/` with `.pddl` extension
3. Run the script - it will automatically process all problem files

## 📊 Output

The script generates individual output files for each problem:
- `results/easy01_output.txt`
- `results/moderate01_output.txt`
- `results/hard01_output.txt`
- etc.

Each output file contains:
- Planner execution log
- Solution plan (if found)
- Performance statistics
- Error messages (if any)

## 🔍 Troubleshooting

### Common Issues

#### 1. Permission Denied
```bash
chmod +x run_planner.sh
```

#### 2. Apptainer Installation Failed
- Ensure you're on Ubuntu 22.04+
- Check internet connection
- Run with sudo when prompted

#### 3. SIF File Not Found
- Ensure `symbd.sif` is in the same directory as the script
- Check file permissions: `ls -la symbd.sif`

#### 4. No PDDL Files Found
- Check that `pddl_files/` directory exists
- Ensure `domain.pddl` is present
- Verify `.pddl` file extensions

### Windows-Specific Issues

#### WSL2 Not Working
1. Enable Windows Subsystem for Linux:
   ```powershell
   dism.exe /online /enable-feature /featurename:Microsoft-Windows-Subsystem-Linux /all /norestart
   ```

2. Enable Virtual Machine Platform:
   ```powershell
   dism.exe /online /enable-feature /featurename:VirtualMachinePlatform /all /norestart
   ```

3. Restart Windows and update WSL:
   ```powershell
   wsl --update
   ```

#### File Access Issues
- Use WSL2 file system paths (`/home/username/...`) for better performance
- Avoid Windows paths (`/mnt/c/...`) for large files like SIF containers

## 🤝 Contributing

1. Fork the repository
2. Create a feature branch: `git checkout -b feature-name`
3. Commit changes: `git commit -am 'Add feature'`
4. Push to branch: `git push origin feature-name`
5. Submit a pull request

## 📝 License

This project is licensed under the terms specified in the [LICENSE](LICENSE) file.

## 📞 Support

For issues and questions:
1. Check the troubleshooting section above
2. Create an issue on GitHub
3. Provide your OS version, error messages, and steps to reproduce

## 🙏 Acknowledgments

- SymBD Planner developers
- Apptainer/Singularity community
- PDDL planning community
