# Moodle Developer Documentation Project

Please note: This is a trial project to help examine a range of different documentation systems for Moodle Developer documentation.

It is not the official source of Moodle Developer documentation at this time.

## Building

### Building the current version only

```
pip install '.[docs]'
cd docs
make html
```

### Building all versions

```
pip install '.[docs]'
sphinx-multiversion docs build/html
```

## Hosting

These docs are currently automatically built for the main version branches and
are automatically deployed to:

- https://andrewnicols.github.io/docs/master
- https://arn-moodledocs.readthedocs.io/en/latest/
