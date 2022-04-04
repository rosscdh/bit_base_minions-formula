#
# Install Chocolatey
#
# b_b_m_install_chocolatey:
#   chocolatey.bootstrap:
#     - unless:
#       - where choco*

#
# chocolatey broke their installation
#
#bit_base_minions_install_chocolatey:
  #cmd.run:
 #   - name: Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))
  #  - shell: powershell
 #   - unless:
   #   - where choco*

bit_base_minions_install_chocolatey:
  file.managed:
    - name: "C:/Windows/TEMP/chocolatey.1.0.0.zip"
    - source: salt://bit_base_minions/files/chocolatey.1.0.0.nupkg

bbm_chocolatey_unpack:
  cmd.run:
    - name: "Expand-Archive -Path '%temp%/chocolatey.1.0.0.zip' -DestinationPath '%temp%/chocolatey_salt_install'"
    - shell: powershell
    - require:
      - bit_base_minions_install_chocolatey

bbm_chocolatey_run_shell:
  cmd.run:
    - name: Powershell.exe -executionpolicy remotesigned -File  %temp%/chocolatey_salt_install/tools/chocolateyInstall.ps1
    - require:
      - bbm_chocolatey_unpack

choco_update:
  cmd.run:
    - name: choco upgrade all
    - cwd: C:\ProgramData\chocolatey
    - require: 
      - bbm_chocolatey_run_shell
