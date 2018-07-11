# Django Shopping Cart

## Setup
Use `make` to show all available commands for testing and project configurations.

## Documentation
[Link](https://readthedocs.org/)

## Installation

Create a virtualenv:
```bash
$ python3 -m venv venv
```

Install development requirements:
```bash
$ make dependencies
```

Create database tables:
```bash
$ make database
```

Create superuser:
```bash
$ make superuser
```

Run the project:
```bash
$ make run
```

## Tests

To run the test suite, execute:
```bash
$ make test
```

To show coverage details (in HTML), use:
```bash
$ make test html
```
