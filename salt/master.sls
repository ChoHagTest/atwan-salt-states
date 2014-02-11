{% from "salt/package-map.jinja" import pkgs with context %}

salt-master:
  pkg.installed:
    - name: {{ pkgs['salt-master'] }}
  file.managed:
    - name: /etc/salt/master
    - template: jinja
    - source: salt://salt/files/master
  service.running:
    - enable: True
    - watch:
      - pkg: salt-master
      - file: salt-master
    - require_in:
      - service: salt-minion

{% for backend in salt['pillar.get']('salt:master:fileserver_backend', []) %}
{{ 'salt-master-' + backend }}:
  pkg.installed:
    - require_in:
      - service: salt-master
    - name: {{ pkgs['salt-backend-' + backend] }}
{% endfor %}
