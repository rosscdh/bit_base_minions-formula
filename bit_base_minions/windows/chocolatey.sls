#
# Install Chocolatey
#
b_b_m_install_chocolatey:
  chocolatey.bootstrap: []

#bit_base_minions_install_chocolatey:
#  cmd.run:
#    - name: Set-ExecutionPolicy Bypass -Scope Process -Force; [System.Net.ServicePointManager]::SecurityProtocol = [System.Net.ServicePointManager]::SecurityProtocol -bor 3072; iex ((New-Object System.Net.WebClient).DownloadString("https://chocolatey.org/install.ps1"))
#    - shell: powershell
#    - unless:
#      - where choco*
