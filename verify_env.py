#!/usr/bin/env python3
"""
Environment Verification Script
This script validates that all required packages are installed
and the lab environment is properly configured.
"""

import os
import sys

def check_package(package_name):
    """Check if a package is installed."""
    try:
        __import__(package_name)
        return True
    except ImportError:
        return False

def verify_environment():
    """Verify the MLOps lab environment setup."""
    print("=" * 50)
    print("🔍 MLOps Lab Environment Verification")
    print("=" * 50)
    print()

    all_checks_passed = True

    # Check Python packages
    print("📦 Checking Python Packages...")
    required_packages = {
        'mlflow': 'MLflow',
        'sklearn': 'scikit-learn',
        'pandas': 'Pandas',
        'numpy': 'NumPy',
        'matplotlib': 'Matplotlib'
    }

    for package, name in required_packages.items():
        if check_package(package):
            print(f"  ✅ {name} installed")
        else:
            print(f"  ❌ {name} NOT installed")
            all_checks_passed = False

    print()

    # Check MLflow version
    print("🔬 Checking MLflow Version...")
    try:
        import mlflow
        print(f"  ✅ MLflow version: {mlflow.__version__}")
    except Exception as e:
        print(f"  ❌ Error checking MLflow: {e}")
        all_checks_passed = False

    print()

    # Check dataset
    print("📊 Checking Dataset...")
    dataset_path = '/root/code/devops_metrics.csv'
    if os.path.exists(dataset_path):
        import pandas as pd
        try:
            df = pd.read_csv(dataset_path)
            print(f"  ✅ Dataset found: {len(df)} rows, {len(df.columns)} columns")
            print(f"  ✅ Features: {', '.join(df.columns.tolist())}")
        except Exception as e:
            print(f"  ❌ Error reading dataset: {e}")
            all_checks_passed = False
    else:
        print(f"  ❌ Dataset not found at {dataset_path}")
        all_checks_passed = False

    print()

    # Check MLflow tracking directory
    print("📁 Checking MLflow Tracking Directory...")
    mlruns_path = '/root/mlruns'
    if os.path.exists(mlruns_path):
        print(f"  ✅ MLflow tracking directory exists: {mlruns_path}")
    else:
        print(f"  ❌ MLflow tracking directory not found: {mlruns_path}")
        all_checks_passed = False

    print()

    # Check MLflow UI
    print("🌐 Checking MLflow UI...")
    try:
        import urllib.request
        response = urllib.request.urlopen('http://localhost:5000', timeout=2)
        if response.status == 200:
            print("  ✅ MLflow UI is accessible on port 5000")
            print("  💡 Access via: Hamburger menu (≡) → View Port → 5000")
        else:
            print(f"  ⚠️  MLflow UI responded with status: {response.status}")
    except Exception as e:
        print(f"  ⚠️  MLflow UI not yet accessible (this is OK if just started)")
        print(f"  💡 It may take a few seconds to start")

    print()
    print("=" * 50)

    if all_checks_passed:
        print("✅ Environment Verification PASSED")
        print("=" * 50)
        print()
        print("🚀 You're ready to start the lab!")
        print()

        # Create success marker
        os.makedirs('/root/markers', exist_ok=True)
        with open('/root/markers/environment_verified.txt', 'w') as f:
            f.write("SUCCESS")
        print("✅ Marker file created: /root/markers/environment_verified.txt")

        return 0
    else:
        print("❌ Environment Verification FAILED")
        print("=" * 50)
        print()
        print("⚠️  Please check the errors above and contact support if needed.")
        return 1

if __name__ == "__main__":
    exit_code = verify_environment()
    sys.exit(exit_code)
