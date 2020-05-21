.. _tools-nodejs:

======
NodeJS
======

A number of development tools require the installation and use of `NodeJS <https://nodejs.org/en/>`_, which is a JavaScript runtime
environment available freely for most operating systems.

Each version of Moodle requires a specific version of NodeJS. Currently this is version 14.0.0, which came out in May
2020.

We highly recommend using :ref:`NVM <tool-nodejs-nvm>` to install NodeJS rather than installing it directly.


.. _tool-nodejs-nvm:

NVM
===

`NVM <https://github.com/nvm-sh/nvm>`_ is the Node Version Manager. Its purpose is to simplify the installation, and use of multiple versions of NodeJS.

Moodle includes a ``.nvmrc`` which ``nvm`` can use to select the correct version of NodeJS.
