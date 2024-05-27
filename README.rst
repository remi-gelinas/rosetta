.. image:: .github/assets/logo.svg
   :height: 140px
   :width: 140px

Rosetta
=======


Structure
---------

.. code-block:: python

   .
   ├── _sources # Pinned package sources using nvfetcher
   ├── modules # Module definitions for nix-darwin and home-manager
   ├── packages # Package definitions
   ├── parts # Module definitions for flake-parts
   └── systems # System configurations

|mit| |cachix| |trunk-workflows|

.. |mit| image:: https://img.shields.io/github/license/remi-gelinas/rosetta.svg?color=%23ECEFF4&label=license&logoColor=88C0D0&style=flat-square&colorA=4c566a&colorB=88c0d0
    :alt: License
    :target: https://github.com/remi-gelinas/rosetta/blob/trunk/LICENSE

.. |cachix| image:: https://img.shields.io/static/v1.svg?color=%23ECEFF4&label=cachix&message=remi-gelinas-nix&style=flat-square&colorA=4c566a&colorB=88c0d0
    :alt: Cachix cache
    :target: https://app.cachix.org/cache/remi-gelinas-nix

.. |trunk-workflows| image:: https://img.shields.io/github/actions/workflow/status/remi-gelinas/rosetta/trunk.yaml.svg?style=flat-square&label=trunk&labelColor=4c566a
    :alt: Trunk workflows
    :target: https://github.com/remi-gelinas/rosetta/actions/workflows/trunk.yaml