# World-Writable File Remediation & Testing

This repository contains a collection of Ansible playbooks and a Bash script for identifying, remediating, and testing for world-writable files on Linux systems. This is a crucial security practice as world-writable files can be exploited by local attackers to modify system configurations, escalate privileges, or hide malicious code.

---

### Purpose

The goal of this project is to automate the process of finding and fixing a common security misconfiguration. By providing a dedicated test script, this repository allows administrators to safely test the remediation and backout playbooks in a controlled environment before deploying them to production systems.

---

### Key Features

* **Automated Remediation:** The main playbook efficiently finds and fixes world-writable files by removing the 'other-writable' permission bit.

* **Safe Backups:** The remediation playbook automatically backs up original file permissions to a JSON file, allowing for easy and complete restoration.

* **Controlled Backout:** A dedicated playbook can restore the original permissions from the backup file, ensuring a safe and reversible process.

* **Integrated Testing:** The `create_wWf.sh` script generates a test environment with a known set of world-writable files, enabling secure pre-deployment testing.

* **Interactive Prompts:** Both playbooks use interactive prompts to allow for flexible, user-driven execution, such as targeting specific directories or files.

---

### File Breakdown

* `wWf_Remediation.yml`: The core Ansible playbook. It finds world-writable files, backs up their original permissions, and then corrects them.

* `wWf_BACKOUT.yml`: The backout playbook. It uses the permissions backup created by the remediation playbook to restore files to their original state.

* `create_wWf.sh`: A Bash script to create a temporary test directory and generate a set of test files, some of which are world-writable. **The script uses randomized locations to simulate real-world conditions.** This script is intended for use in a non-production environment.

---

### Technologies

* **Ansible:** The automation engine used to manage file permissions and backups.

* **Bash:** For the interactive script that creates the test environment.

* **YAML:** The language for defining all Ansible playbooks.

* **Linux:** Specifically targeting Linux systems that support standard permissions (`chmod`).

---

### Usage

**Note:** Always review the code and test in a non-production environment before applying it to critical systems.

#### Step 1: Create a Test Environment

To safely test the playbooks, first run the Bash script to generate a directory with test files.

```bash
./create_wWf.sh
```

The script will output the location of the test directory and a log file listing the world-writable files it created. **This location will be a temporary path that is randomly generated.**

#### Step 2: Run the Remediation Playbook

Run the remediation playbook. It will ask you for the target directory to scan and the location for the backup file.

```bash
ansible-playbook wWf_Remediation.yml
```

#### Step 3: Run the Backout Playbook

If you need to restore the original permissions, run the backout playbook and provide the path to the backup file you specified during remediation.

```bash
ansible-playbook wWf_BACKOUT.yml
