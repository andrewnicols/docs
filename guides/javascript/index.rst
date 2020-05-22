.. _guides-javascript:

Javascript
==========

Moodle makes heavy use of Javascript to improve the experience for its users.

Javascript is structured into Modules, which can be included from Templates or from PHP, and which can fetch and store data via
:term:`Web Services`.

.. --------------------------------------------------------------------------
   Sam:
   Probably you already are thinking of doing the new ES6 pattern already. So um, here are some things I can think of that might be useful not in any order... Passing data from PHP in the page (data attributes)... Web service calls... Getting strings... How to do jquery-ish stuff without jquery (document.querySelector etc)... Setting the flags to tell behat the page is busy (and maybe, this in conjunction with animations, which is always a pain)...
   David:
   I would suggest to provide a lot of simple yet solid and actually useful working code examples. One thing I think is particularly useful are events.
   Tim:
   That is a good point David> Examples in documentation/need to be kept simple to make the key point you are trying to make. It is good if you can do that (but hopefully for semi-relalistic examples) and then link to real code examples in the Moodle code.


   Passing data from PHP
   - output functions
   - data attributes
   Web service calls
   Strings
   PendingJS
   ES6 References
   --------------------------------------------------------------------------


Useful References
.................

Javascript in Moodle is largely Vanilla Javascript combined with a number of helpers for performing common actions, and
a small collection of libraries for serving and managing dependencies.

The Javascript documentation available on the Mozilla Developer Network is probably the best reference documentation
available.

* `MDN Javascript guide  <https://developer.mozilla.org/en-US/docs/Web/JavaScript>`__.
* `MDN Javascript Reference <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference>`__.
* `ES2015+ Cheatsheet <https://devhints.io/es6>`__


Modules
.......

We structure our Javascript into ES6 modules which are transpiled into the CommonJS format.

Much like our PHP classes and Mustache templates, our Javascript modules each belong to a particular :term:`component`
and must be named according to our standard :ref:`name and namespace conventions <policy-naming-javascript>`.

.. important::

    Make sure you read the Level 2 Namespace rules.

Including Javascript from your pages
....................................

Now that you know where to place your Javascript content, you need to include it within the page.

There are three main ways to include your Javascript, and the best way will depend on your content.


Including from a template
-------------------------

Most recent code in Moodle makes heavy use of Mustache templates, and you will usually find that your Javascript is
responding to user interactions with one of your templates.

Moodle uses the ``requirejs`` loader to fetch Javascript modules complete with all dependencies, and to initialise it
within the page:

.. code-block:: mustache

    {{#js}}
    require(['mod_example/mymodule'], function(MyModule) {
        MyModule.init();
    });
    {{/js}}


Any time that this template is rendered and placed on the page, the Javascript will be executed.

.. important::

    It may be possible for a template to be included multiple times.
    You may need to write your code so that it only loads once, or that it only works with a single DOM Element.


Including from PHP
------------------

.. TODO::

    Document how we include Javascript from PHP.


.. code-block:: php

    // Call the `init` function on `mod_example/mymodule`.
    $PAGE->requires->js_call_amd('mod_example/mymodule', 'init');


Passing data to your Module
...........................

.. TODO::

    Document the main ways that we pass data.

    Focus on:

        * data- attributes in HTML being ready
        * the limitations of the data passed into `js_call_amd`
        * web services



Promises
........

.. TODO::

    We should document things like:

        * Use ``then`` and ``catch`` consistently (thennables)
        * Don't use ``catch`` if you are returning a Promise just by habit - only use it if you mean to
        * You _must_ return at the end of a thennable
        * It's generally a good idea to return a Promise from a fucntion if the function is primarily tasked with
          creating that Promise

.. important::

    You should not use the ``done``, ``fail``, or ``always`` functions on Promises.
    These are a jQuery feature which is not present in the Native Promise implementation.

Examples
--------

.. code-block:: javascript

    const getModal = questionBody => {
        return ModalFactory.create({
            title: getString('mytitle', 'mod_example'),
            body: renderTemplate('mod_example/example_body', questionBody),
            removeOnClose: true,
        })
        .then(modal => {
            modal.show();

            return modal;
        });
    };


Working with Strings
....................

One of the most helpful core modules is ``core/str`` which allows you to easily fetch and render language Strings in
Javascript.

The ``core/str`` module has two main functions, which both return Promises containing the resolved string.

Strings are fetched on request from Moodle, and are then cached in LocalStorage.

Example
.......
.. literalinclude:: _examples/str.js


Templates
.........

Modals
......

Notifications
.............

AJAX Calls
..........

Preferences
...........

Prefetch
........

Tools
.....

We make use of a number of common and popular tools to ensure the quality of our code, and to improve the end-user
experience.

Most of our Javascript tooling requires :ref:`NodeJS <tools-nodejs>`.


Grunt
-----

`Grunt`_ is a command-line tool used to compile Javascript, and CSS, and to validate and lint Javascript, CSS, Behat tests,
and more.

.. tip::

    Rather than running ``grunt`` on the entire Moodle source every time you make changes, you can use ``grunt watch``
    in the background to build just the files you change as you write them.


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
..........
