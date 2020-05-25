.. _guides-javascript:

Javascript
==========

Moodle makes heavy use of Javascript to improve the experience for its users.

All new Javascript in Moodle should be written in the ES2015+ module format.
It is transpiled into a CommonJS format.
Modules are loaded in the browser using the RequireJS loader.

All Moodle Javascript can use the same Mustache templates, and translated strings which are available to Moodle PHP code, and the standard Moodle web service framework can be used to fetch and store data.

This guide covers how to get started with Javascript in Moodle, and introduces key concepts and features including module format and structure, including your code, using templates, using translation features, tooling, and handling events.

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

Moodle uses vanilla Javascript combined with a number of helpers for performing common actions, and
a small collection of libraries for serving and managing dependencies.

The Javascript documentation available on the Mozilla Developer Network is one of the best reference documentations
available. You may find the following references particularly useful:

* `MDN Javascript guide  <https://developer.mozilla.org/en-US/docs/Web/JavaScript>`__.
* `MDN Javascript Reference <https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference>`__.
* `ES2015+ Cheatsheet <https://devhints.io/es6>`__


Modules
.......

Javascript in Moodle is structured into ES6 modules which are transpiled into the CommonJS format.

Like our PHP classes and Mustache templates, our Javascript modules each belong to a particular :term:`component`
and must be named according to our standard :ref:`name and namespace conventions <policy-naming-javascript>`.

The naming scheme for Moodle’s Javascript fits into the pattern:

``[component_name]/[optional/sub/namespace/][modulename]``

The first directory in any subfolder must be either a Moodle API, or `local`.

The following are examples of valid module names:

.. code-block::

    // For a module named `discussion` in the `mod_forum` component:
    mod_forum/discussion
    
    // For a module named `grader` in the `mod_assign` component, which is part of the `grades` API:
    mod_assign/grades/grader
    
    // For a module named `confirmation` in the `block_newsitems` component, which is a modal and not part of a core API:
    block_newsitems/local/modal/confirmation
    
    // For a module name `selectors` in the `core_user` component, and relates to the `participants` module:
    core_user/local/participants/selectors
    
    
.. tip::

    When structuring modules, you may find it clearer to create a main module, with a number of related modules.
    You can create a clear relationship between your modules using subdirectories, for 
    
    The `participants` module is a part of `core_user`:
        
        ``core_user/participants``
        
    To clearly break the code down into reusable chunks we can break out:
    
    * all CSS Selectors into a `selectors` module; and
    * all AJAX requests into a `repository` module.
    
        ``core_user/local/participants/selectors``
        ``core_user/local/participants/repository``


Including Javascript from your pages
....................................

Once you have written a Javascript module, you need a way to include it within your content.

There are three main ways to include your Javascript, and the best way will depend on your content. These are:

* from a template via ``requirejs``;
* from PHP via the output requirements API; and
* from other Javascript via ``import`` or ``requirejs``.


Including from a template
-------------------------

Most recent code in Moodle makes heavy use of Mustache templates, and you will usually find that your Javascript is
directly linked to the content of one of your templates.

All javascript in Mustache templates must be places in a ``{{#js}}`` tag.
This tag ensures that all Javascript is called in a consistent and reliable way.

Technically any javascript can be placed in these tags however we strongly recommend that you make use of the ``requirejs`` loader to load and initialise your Javascript modules.
Javascript placed in Templates is not transpiled for consistent use in all browsers, and it is not passed through minification processes.

This simplest form of this is:

.. code-block:: mustache

    <div>
        <!—- Your template content goes here. —->
    </div>
    
    {{#js}}
    require(['mod_forum/discussion'], function(Discussion) {
        Discussion.init();
    });
    {{/js}}

Any time that this template is rendered and placed on the page the ``mod_forum/discussion`` module will be fetched, and the ``init()`` function called on it.

.. important::

    Do not use :term:`arrow functions` directly in templates. Internet Explorer does not support arrow functions in any version.


Often you may want to link the Javascript to a specific ``DOMElement`` in the template.
We can easily use the ``{{uniqid}}`` Mustache tag to give that DOM Element a unique ID, and then pass that into the Module.

.. code-block:: mustache

    <div id=“mod_forum-discussion-wrapper-{{uniqid}}”>
        <!—- Your template content goes here. —->
    </div>
    
    {{#js}}
    require([‘mod_forum/discussion’], function(Discussion) {
        Discussion.init(document.querySelector(“mod_forum-discussion-wrapper-{{uniqid}}”));
    });
    {{/js}}

In this example we now add a new id to the ``div``.
We then use the same id to fetch the DOM Element, which is passed into the ``init`` function.

.. note::

    The ``{{uniqid}}`` tag gives a new unique string for each rendered template, including all of its children.
    It is not a true unique id and must be combined with other information in the template to make it unique.



Including from PHP
------------------

Much of Moodle’s code still creates HTML content in PHP directly.
This may be by echoing HTML tags directly, or using the ``html_writer`` output functions.
A lot of this content is now being migrated to use Mustache Templates, which is the recommended approach for new content.

Where content is generated in PHP, you will need to include your Javascript at the same time.

There are several older ways to include Javascript from PHP, but for all new Javascript we recommend only using the ``js_call_amd`` function on the ``page_requirements_manager``.
This has a very similar format to the version used in Templates:

.. code-block:: php

    // Call the `init` function on `mod_forum/discussion`.
    $PAGE->requires->js_call_amd('mod_forum/discussion', 'init');

The ``js_call_amd`` function turns this into a ``requirejs`` call.

You can also pass arguments to your function by passing an array as the third argument to ``js_call_amd``, for example:

.. code-block:: php

    // Call the `init` function on `mod_forum/discussion`.
    $PAGE->requires->js_call_amd(‘mod_forum/discussion’, ‘init’, [$course->id]);

If you pass a multi-dimensional array as the third argument, then you can use Array destructuring within the Javascript to get named values. 

.. code-block:: php

    $PAGE->requires->js_call_amd(‘mod_forum/discussion’, ‘init’, [[
        ‘courseid’ => $course->id,
        ‘categoryid’ => $course->category,
    ]]);
    
.. code-block:: javascript

    export const init = ({courseid, category}) => {
        window.console.log(courseid);
        window.console.log(category);
    };

.. note::

    There is a length limit on the parameters that you can pass as the third argument.
    We recommend that you only pass information required by the Javascript which is not available in the DOM.


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
