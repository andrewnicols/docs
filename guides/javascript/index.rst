.. _guides-javascript:

==========
Javascript
==========

As is commonplace in web development, Moodle makes heavy use of Javascript to improve the experience for its users.

Javascript is structured into Modules, which can be included from Templates or from PHP, and which can fetch and store data via
:term:`Web Services`.

Modules
=======

We structure our Javascript into ES6 modules which are transpiled into the CommonJS format.

Much like our PHP :ref:`classes <_guides-php-classes>` and :ref:`Mustache templates <_guides-templates>`, our Javascript
modules each belong to a particular :term:`component` and must be named according to our standard
:ref:`name and namespace conventions <policy-naming-javascript>`.

Example
=======
.. literalinclude:: _examples/str.js


Templates
=========

Tools
=====

We make use of a number of common and popular tools to ensure the quality of our code, and to improve the end-user
experience.

Most of our Javascript tooling requires :ref:`NodeJS <tools-nodejs>`.


Grunt
-----

`Grunt`_ is a command-line tool used to compile Javascript, and CSS, and to validate and lint Javascript, CSS, Behat tests,
and more.

.. _Grunt: https://gruntjs.com/

Installing grunt
^^^^^^^^^^^^^^^^

.. code-block:: bash

   npm -g install grunt-cli

Using grunt
^^^^^^^^^^^

.. code-block:: bash

   grunt

ESLint
------

References
==========
