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
