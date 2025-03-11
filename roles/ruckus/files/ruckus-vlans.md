enable
configure terminal

# Management

vlan 10 name MGMT-VLAN
router-interface ve 10
exit

interface ve 10
ip address 10.0.10.1/24
exit

# Home (WiFi and Wired)

vlan 20 name HOME-VLAN
tagged ethernet 1/1/11 to 1/1/12
router-interface ve 20
exit

interface ve 20
ip address 10.0.20.1/24
exit

# Guest (WiFi only)

vlan 30 name GUEST-VLAN
tagged ethernet 1/1/11 to 1/1/12
router-interface ve 30
exit

interface ve 30
ip address 10.0.30.1/24
exit

# IOT? With and Without Internet?

# Servers?
