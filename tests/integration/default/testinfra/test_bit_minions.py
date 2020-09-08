def test_file_exists(host):
    bit_base_minions = host.file('/etc/salt/minion')
    print(bit_base_minions.content)
    assert bit_base_minions.exists
    assert bit_base_minions.contains('master: queen.bienert.tech')
    assert bit_base_minions.contains('id: bit.labs.monkeytest')

# def test_bit_base_minions_is_installed(host):
#     bit_base_minions = host.package('bit_base_minions')
#     assert bit_base_minions.is_installed
#
#
# def test_user_and_group_exist(host):
#     user = host.user('bit_base_minions')
#     assert user.group == 'bit_base_minions'
#     assert user.home == '/var/lib/bit_base_minions'
#
#
# def test_service_is_running_and_enabled(host):
#     bit_base_minions = host.service('bit_base_minions')
#     assert bit_base_minions.is_enabled
#     assert bit_base_minions.is_running
