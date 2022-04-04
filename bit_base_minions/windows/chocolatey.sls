
bit_base_minions_install_chocolatey:
  file.managed:
    - name: "C:/Windows/TEMP/chocolatey.1.1.0.zip"
    - source: salt://bit_base_minions/files/chocolatey.1.1.0.nupkg

bbm_chocolatey_unpack:
  cmd.run:
    - name: "Expand-Archive -Path '%temp%/chocolatey.1.1.0.zip' -DestinationPath '%temp%/chocolatey_salt_install'"
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
