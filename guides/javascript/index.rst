.. _guides-javascript:

Javascript
==========

Moodle makes heavy use of Javascript to improve the experience for its users.

All new Javascript in Moodle should be written in the ES2015+ module format,
which is transpiled into the CommonJS format.
Modules are loaded in the browser using the RequireJS loader.

All Moodle Javascript can use the same Mustache templates and translated strings which are available to Moodle PHP code, and the standard Moodle web service framework can be used to fetch and store data.

This guide covers how to get started with Javascript in Moodle, and introduces key concepts and features including module format and structure, including your code, using templates, using translation features, tooling, and handling events.

.. --------------------------------------------------------------------------
   Sam:
   Probably you already are thinking of doing the new ES6 pattern already. So um, here are some things I can think of that might be useful not in any order... Passing data from PHP in the page (data attributes)... Web service calls... Getting strings... How to do jquery-ish stuff without jquery (document.querySelector etc)... Setting the flags to tell behat the page is busy (and maybe, this in conjunction with animations which is always a pain)...
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


.. note::

    You may see the terms ``ES6`` and ``ES2015`` used interchangably.
    ES2015 is the 6th generation of the Ecma Script specification.
    ES2015 respresents a big change from previous versions of the Ecma Script
    specification.


Useful References
.................

Moodle uses vanilla Javascript combined with a number of helpers for performing common actions, and
a small collection of libraries for serving and managing dependencies.

The Javascript documentation available on the Mozilla Developer Network is one of the best reference documentations
available. You may find the following references particularly useful:

* `MDN Javascript guide  <guides_javascript-mdn-javascript_guide_>`_.
* `MDN Javascript Reference <guides_javascript-mdn-javascript_reference_>`_.
* `ES2015+ Cheatsheet <guides_javascript-devhints-es6_cheatsheet_>`_


Modules
.......

Javascript in Moodle is structured into ES2015 modules which are transpiled into the CommonJS format.

Like our PHP classes and Mustache templates, our Javascript modules each belong to a particular :term:`component`
and must be named according to our standard :ref:`name and namespace conventions <policy-naming-javascript>`.

The naming scheme for Moodle’s Javascript fits into the pattern:

``[component_name]/[optional/sub/namespace/][modulename]``

The first directory in any subfolder must be either a Moodle API, or `local`.

The following are examples of valid module names:

.. code-block::

    // For a module named `discussion` in the `mod_forum` component:
    mod_forum/discussion

    // For a module named `grader` in the `mod_assign` component which is
    // part of the `grades` API:
    mod_assign/grades/grader

    // For a module named `confirmation` in the `block_newsitems` component
    // which is a modal and not part of a core API:
    block_newsitems/local/modal/confirmation

    // For a module name `selectors` in the `core_user` component and relates
    // to the `participants` module:
    core_user/local/participants/selectors


.. tip::

    When structuring a new module you may find it clearer to create a main module with a number of related modules.
    You can create a clear relationship between your modules using subdirectories.

    For example when creating a new module which controls interactions on the Participants page and which is part of
    the ``core_user`` component you will create a ``participants`` module.
    The full namespace for this module will be ``core_user/participants``.

    The ``core_user/participants`` module may interact with DOM elements which are identified by CSS Selectors.
    The Moodle convention is to place the selectors in a ``selectors`` module.

    The module will also call a set of Web Services.
    The Moodle convention is to place calls to Web Services in a ``repository`` module.

    Since ``participants`` is not a formal API in Moodle you must create your submodules in the ``local/participants``
    directory.

    .. code-block:: bash

        .
        ├── local
        │   └── participants
        │       ├── repository.js       // core_user/local/participants/selectors
        │       └── selectors.js        // core_user/local/participants/repository
        └── participants.js             // core_user/participants


Writing your first module
.........................

The convention in Moodle is to have one Javascript Module which is your
initial entrypoint.
This usually provides a function called ``init`` which is ``exported`` from
the module. This ``init`` function will be called by Moodle.

Your module will probably also have one or more dependencies which you will
``import``.

As you start to build out the structure of your code you will start to export
more functions, as well as Objects, Classes, and other data structures.

.. note::

    This guide is not intended to teach you how to write Javascript.
    If you are new to Javascript, you may want to start with the `MDN Javascript
    basics guide <guides-javascript-mdn-javascript_getting_started_>`_.

A module which calls to the browser ``console.log`` function would look like:

.. code-block:: javascript
   :linenos:

    // mod/example/lib/amd/src/helloworld.js
    export const init = () => {
        window.console.log('Hello, world!');
    };

In this example a new variable called ``init`` is created and exported using
the ES2015 `export <guides_javascript-mdn-javascript_reference-export_>`_ keyword.
The variable is assigned an arrow function expression which takes no
arguments, and when executed will call the browser ``console.log`` function
with the text ``"Hello, world!"``.


Listen to a DOM Event
---------------------

In most cases you will want to perform an action in response to a user
interacting with the page.

You can use the `document.addEventListener()
<guides_javascript-mdn-javascript_reference-addEventListener_>`_ method to do
this.

To add a ``click`` listener to the entire body you would write:

.. code-block:: javascript
   :linenos:

    // mod/example/lib/amd/src/helloworld.js
    export const init = () => {
        document.addEventListener('click', e => {
            window.console.log(e.target);
        });
    };

In this example any time that a user clicks anywhere on the document the item
that was clicked on will be logged to the browser console.

Usually you won't want to listen for every click in the document but only for
some of the Elements in the page.

If you wanted to display a browser alert every time a user clicks on a buttn,
you might have a template like the following example:

.. code-block:: mustache
   :linenos:

    {{! mod/example/templates/helloworld.mustache }}
    <button data-action="mod_example/helloworld-update_button">Click me</button>

You can write a listener which only looks for clicks to this button:

.. code-block:: javascript
   :linenos:

    // mod/example/lib/amd/src/helloworld.js
    const Selectors = {
        actions: {
            showAlertButton: '[data-action="mod_example/helloworld-update_button"]',
        },
    };

    export const init = () => {
        document.addEventListener('click', e => {
            if (e.target.closest(Selectors.actions.showAlertButton)) {
                window.alert("Thank you for clicking on the button");
            }
        });
    };

This example shows several conventions that are used in Moodle:

* CSS Selectors are often stored separately to the code in a ``Selectors``
  object. This allows you to easily re-use a Selector and to group them
  together in different ways. It also places all selectors in one place so
  that you can update them more easily.
* The ``Selectors`` object is stored in a ``const`` variable which is _not_
  exported. This means that it is private and only available within your
  module.
* A ``data-*`` attribute is used to identify the button in the Javascript
  module.
  Moodle advises not to use class selectors when attaching event listeners because
  so that it is easier to restyle for different themes without any changes to
  the Javascript later.
* A namespace is used for the ``data-action`` to clearly identify what the
  button is intended for.
* By using ``e.target.closest()`` you can check whether the element that was
  clicked on, or any of its parent elements matches the supplied CSS Selector.

Instead of having one event listener for every button in your page, you can
have one event listener which checks which button was pressed.
If you have a template like the following:

.. code-block:: mustache
   :linenos:

    {{! mod/example/templates/helloworld.mustache }}
    <div>
        <button data-action="mod_example/helloworld-update_button">Click me</button>
        <button data-action="mod_example/helloworld-big_red_button">Do not click me</button>
    </div>

Then you can write one event listener which looks at all buttons on the page.
For example:

.. code-block:: javascript
   :linenos:

    // mod/example/lib/amd/src/helloworld.js
    const Selectors = {
        actions: {
            showAlertButton: '[data-action="mod_example/helloworld-update_button"],
            bigRedButton: '[data-action="mod_example/helloworld-big_red_button"],
        },
    };

    const registerEventListeners = () => {
        document.addEventListener('click', e => {
            if (e.target.closest(Selectors.actions.showAlertButton)) {
                window.alert("Thank you for clicking on the button");
            }

            if (e.target.closest(Selectors.actions.bigRedButton)) {
                window.alert("You shouldn't have clicked on that one!");
            }
        });
    };

    export const init = () => {
        registerEventListeners();
    };

In this example the call to ``document.addEventListener`` has been moved to
a new ``registerEventListeners`` function. This is another Moodle convention
which encourages you to structure your code so that each part has clear
responsibilites.

There is only one event listener and it checks if the Element clicked on was
one that it is interested in.

Including Javascript from your pages
....................................

Once you have written a Javascript module you need a way to include it within your content.

There are three main ways to include your Javascript and the best way will depend on your content. These are:

* from a template via ``requirejs``;
* from PHP via the output requirements API; and
* from other Javascript via ``import`` or ``requirejs``.


Including from a template
-------------------------

Most recent code in Moodle makes heavy use of Mustache templates and you will usually find that your Javascript is
directly linked to the content of one of your templates.

All javascript in Mustache templates must be places in a ``{{#js}}`` tag.
This tag ensures that all Javascript is called in a consistent and reliable way.

.. caution::

    Javascript placed in Templates is not transpiled for consistent use in all browsers and it is not passed through minification processes.

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

Any time that this template is rendered and placed on the page the ``mod_forum/discussion`` module will be fetched and the ``init()`` function called on it.

.. important::

    Do not use :term:`arrow functions<Arrow functions>` directly in templates. Internet Explorer does not support arrow functions in any version.


Often you may want to link the Javascript to a specific ``DOMElement`` in the template.
You can easily use the ``{{uniqid}}`` Mustache tag to give that DOM Element a unique ID and then pass that into the Module.

.. code-block:: mustache

    <div id=“mod_forum-discussion-wrapper-{{uniqid}}”>
        <!—- Your template content goes here. —->
    </div>

    {{#js}}
    require([‘mod_forum/discussion’], function(Discussion) {
        Discussion.init(document.querySelector(“mod_forum-discussion-wrapper-{{uniqid}}”));
    });
    {{/js}}

In this example you have added a new ``id`` to the ``div`` element.
You then fetch the DOM Element using this id and pass it into the ``init`` function.

.. note::

    The ``{{uniqid}}`` tag gives a new unique string for each rendered template including all of its children.
    It is not a true unique id and must be combined with other information in the template to make it unique.



Including from PHP
------------------

Much of Moodle’s code still creates HTML content in PHP directly.
This might be a simple ``echo`` statement or using the ``html_writer`` output functions.
A lot of this content is being migrated to use Mustache Templates which are the recommended approach for new content.

Where content is generated in PHP you will need to include your Javascript at the same time.

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

.. caution::

    There is a limit to the length of the parameters passed in the third argument.
    You should only pass information required by the Javascript which is not alrady available in the DOM.


Passing data to your Module
...........................

You will often need to work with data as part of your Javascript module.
This might be simple data, like the a database id, or it may be more complex
like full Objects.

In most cases you will be able to store this data in the DOM as a data
attribute which you can fetch with your Javascript.
In some cases you will need to use Moodle Web Services to fetch this data
instead.
A small amount of data can be passed into the initialisation of your
Javascript module, but this is no longer recommended.

Using data attributes
---------------------

The easiest way to pass data is to use data attributes.

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


Glossary
........

.. glossary::

    Arrow functions
      An arrow function is a shorthand way of writing a regular function.
      They have a number of small but important differences to regular functions which make them easier to use in most
      cases, but unsuitable in some others.

      They are not suitable for use in code which is not transpiled as Internet Explorer does not offer any support for
      them.

      For more information see the `MDN documentation for Arrow function expressions <guides_javascript-mdn-arrow_functions_>`_.


..  ------------------------------------------------------------------------
    Links used on the current page go here.
    All links must be namespaced in the format:

        `guides_javascript-[domain_or_acronym]-[specialty]`

    These links should be kept sorted alphabetically

.. _guides_javascript-devhints-es6_cheatsheet: https://devhints.io/es6
.. _guides_javascript-mdn-arrow_functions: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference/Functions/Arrow_functions
.. _guides-javascript-mdn-javascript_getting_started: https://developer.mozilla.org/en-US/docs/Learn/Getting_started_with_the_web
.. _guides_javascript-mdn-javascript_guide:  https://developer.mozilla.org/en-US/docs/Web/JavaScript
.. _guides_javascript-mdn-javascript_reference: https://developer.mozilla.org/en-US/docs/Web/JavaScript/Reference
.. _guides_javascript-mdn-javascript_reference-addEventListener: https://developer.mozilla.org/en-US/docs/Web/API/EventTarget/addEventListener
.. _guides_javascript-mdn-javascript_reference-export: https://developer.mozilla.org/en-US/docs/web/javascript/reference/statements/export
