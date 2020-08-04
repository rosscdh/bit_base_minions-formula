def test_file_exists(host):
    bit_base_windows_minions = host.file('/etc/salt/minion')
    print(bit_base_windows_minions.content)
    assert bit_base_windows_minions.exists
    assert bit_base_windows_minions.contains('master: queen.bienert.tech')
    assert bit_base_windows_minions.contains('id: bit.labs.monkeytest')

# def test_bit_base_windows_minions_is_installed(host):
#     bit_base_windows_minions = host.package('bit_base_windows_minions')
#     assert bit_base_windows_minions.is_installed
#
#
# def test_user_and_group_exist(host):
#     user = host.user('bit_base_windows_minions')
#     assert user.group == 'bit_base_windows_minions'
#     assert user.home == '/var/lib/bit_base_windows_minions'
#
#
# def test_service_is_running_and_enabled(host):
#     bit_base_windows_minions = host.service('bit_base_windows_minions')
#     assert bit_base_windows_minions.is_enabled
#     assert bit_base_windows_minions.is_running
