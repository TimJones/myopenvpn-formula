{% from "openvpn/map.jinja" import openvpn with context %}

include:
  - openvpn

openvpn_service:
  service.running:
    - name: {{ openvpn.service }}
    - watch:
      - pkg: openvpn

{% for name, settings in salt['pillar.get']('openvpn', {}).iteritems() %}
{% set config = salt['pillar.get']('openvpn:'+name, {}) %}

openvpn_{{ name }}_ca_cert:
  file.managed: 
    - name: {{ openvpn.conf_dir }}/{{ name }}/ca.crt
    - contents_pillar: openvpn:{{ name }}:ca_cert
    - makedirs: True
    - require_in:
      - file: openvpn_{{ name }}_conf

openvpn_{{ name }}_cert:
  file.managed: 
    - name: {{ openvpn.conf_dir }}/{{ name }}/{{ config.get('common_name', grains['host']) }}.crt
    - contents_pillar: openvpn:{{ name }}:cert
    - makedirs: True
    - require_in:
      - file: openvpn_{{ name }}_conf

openvpn_{{ name }}_key:
  file.managed: 
    - name: {{ openvpn.conf_dir }}/{{ name }}/{{ config.get('common_name', grains['host']) }}.key
    - contents_pillar: openvpn:{{ name }}:key
    - makedirs: True
    - require_in:
      - file: openvpn_{{ name }}_conf

openvpn_{{ name }}_dh:
  file.managed: 
    - name: {{ openvpn.conf_dir }}/{{ name }}/dh.pem
    - contents_pillar: openvpn:{{ name }}:dh
    - makedirs: True
    - require_in:
      - file: openvpn_{{ name }}_conf

{% if settings.get('ta_key') %}
openvpn_{{ name }}_ta_key:
  file.managed: 
    - name: {{ openvpn.conf_dir }}/{{ name }}/ta.key
    - contents_pillar: openvpn:{{ name }}:ta_key
    - makedirs: True
    - require_in:
      - file: openvpn_{{ name }}_conf
{% endif %}

openvpn_{{ name }}_conf:
  file.managed:
    - name: {{ openvpn.conf_dir }}/{{ name }}.conf
    - source: salt://openvpn/openvpn.jinja
    - template: jinja
    - context:
        type: server
        name: {{ name }}
#    - watch_in:
#      - service: openvpn_service
{% endfor %}
