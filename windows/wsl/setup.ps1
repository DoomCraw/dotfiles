if (!(& wsl.exe --status).length -eq 0) {
    wsl --install
  }
