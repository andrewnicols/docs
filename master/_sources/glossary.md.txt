---
title: Glossary
---

:::{glossary}
component

  Moodle is composed of a number of {term}`plugins <plugin>` and {term}`subsystems <subsystem>`. Collectively these are known as
  components.

  Components all have a {term}`frankenstyle namespace` which is used across Moodle to reference files, classes,
  templates, modules, and other features.

subsystem

  Moodle subsystems are the core structures which make up the platform.
  They provide a variety of APIs to support common actions ranging from output handling, to the use of javascript,
  to database interactions, logging, and more.

  Moodle's subsystems are all in the {term}`frankenstyle namespace` under `core`.

plugin

  Plugins are the easiest and most common way to add functionality to the core product.

  Plugins have a {term}`frankenstyle namespace` of `[plugintype]_[pluginname]`.

frankenstyle namespace

  All code in Moodle belongs to a component.
  Components are uniquely identified by a frankenstyle namespace.

  Frankenstyle namespaces are all in the format `[core|plugintype]_[subsystem|pluginname]`.

Web Services

  Moodle offers a number of Web Services.

  These allow for integration with the Moodle frontend Javascript, the Moodle Mobile App, and can also be used for
  other third-party integrations.
:::
