{% from "openvpn/map.jinja" import openvpn with context %}

openvpn:
  pkg.latest:
    - name: {{ openvpn.pkg }}
