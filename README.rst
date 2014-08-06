===============
openvpn-formula
===============

A saltstack formula to install and configure OpenVPN servers and clients.

.. note::

    See the full `Salt Formulas installation and usage instructions
    <http://docs.saltstack.com/topics/conventions/formulas.html>`_.

Available states
================

.. contents::
    :local:

``openvpn``
-----------
Installs the OpenVPN package.

``openvpn.server``
------------------
Configures OpenVPN server instances using data from Pillar.

Example minimum Pillar:

.. code:: yaml

    openvpn:
      minimal-example: # Name of instance, must be unique per host
        ca_cert: |
          # Public CA Certificate should go here
        cert: |
          # Server's public certificate should go here
        key: |
          # Server's private key should go here
        ta_key: |
          # Public TLS Authentication key should go here
        dh: |
          # Diffie-Helman Parameters should go here

``openvpn.client``
------------------
Configures OpenVPN client instances using data from Pillar.

Example minimum Pillar:

.. code:: yaml

    openvpn:
      minimal-example: # Name of instance, must be unique per host
        remotes:
          - server: 123.123.123.123 # Reachable IP address of OpenVPN server
        ca_cert: |
          # Public CA Certificate should go here
        cert: |
          # Client's public certificate should go here
        key: |
          # Client's private key should go here
        ta_key: |
          # Public TLS Authentication key should go here

Pillar settings
===============

.. contents::
    :local:

``package``
-----------
Set the basic package and service options.

.. code:: yaml

    openvpn:
      lookup:
        pkg: openvpn            # Name of package to install
        service: openvpn        # Service name to manage
        conf_dir: /etc/openvpn  # Location that OpenVPN will look for configuration files

``Shared``
----------
.. csv-table:: The pillar settings that are shared (and should be the same) between client and server.
   :header: "Pillar", "OpenVPN", "Description", "Default"
   
   "proto", "proto", "Network protocol (tcp or udp)", "udp"
   "dev", "dev", "Network type (tun or tap)", "tun"
   "cipher", "cipher", "Encryption scheme", "BF-CBC"
   "ca_cert", "ca", "Contents of the Certificate Authority public certificate", ""
   "ta_key", "tls_auth", "Contents of the TLS shared secret", ""
   "compression", "comp-lzo", "Enable compression for the VPN", "True"

``Common``
----------
.. csv-table:: The pillar settings that are common to both client and server, but don't have to be the same.
   :header: "Pillar", "OpenVPN", "Description", "Default"
   
   "user", "user", "User to run OpenVPN as after initialization", "root"
   "group", "group", "Group to run OpenVPN as after initialization", "root"
   "cert", "cert", "Contents of the host public certificate", ""
   "key", "key", "Contents of the host private key", ""
   "common_name", "", "Common name of host to match certificates", "grains['host']"
   "log_level", "verb", "Set level of logging from silent 0-9 extremley verbose", "3"
   "log_file", "log-append", "File to log messages. If not specified, all logging will go to syslog", ""

``Server``
----------
.. csv-table:: Settings for the OpenVPN server.
   :header: "Pillar", "OpenVPN", "Description", "Default"

   "local", "local", "Local IP address to listen on", ""
   "dh", "dh", "Diffie-Hellman parameters"
   "keepalive_send", "keepalive", "Interval (in seconds) to send keepalive packets", "10"
   "keepalive_timeout", "keepalive", "Interval (in seconds) before a connection without packets is considered dead", "120"
   "server_networks", "push ""route <network> <netmask>""", "Push routes for the network(s) listed to the clients", ""
   "client_to_client", "client-to-client", "Allow communication between clients connected to the VPN", "False"
   "redirect_gateway", "push ""redirect-gateway""", "Configure all clients to redirect all default traffic to the OpenVPN server", "False"
   "status_file", "status", "File to write the OpenVPN server status to each minute", "<conf_dir>/<vpn_name>/status"
   "clients", "N\A", "Section for per-client settings. See table below.", ""

.. csv-table:: Per-clients settings for the OpenVPN server.
   :header: "Pillar", "OpenVPN", "Description", "Default"

   "client_networks", "iroute <network> <netmask>", "Define routes for the network(s) reachable via the client", ""
   "server_networks", "push ""route <network> <netmask>""", "Push routes for the network(s) listed to the client", ""
   "redirect_gateway", "push ""redirect-gateway""", "Configures the client to redirect all default traffic to the OpenVPN server", "False"
 
``Client``
----------
.. csv-table:: Settings for the OpenVPN client.
   :header: "Pillar", "OpenVPN", "Description", "Default"

   "remotes", "remote", "A list of server port descriptors that the client should connect to", ""
   
