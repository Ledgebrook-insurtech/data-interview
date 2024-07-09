# parse-e02-files

## Challenge

As a Data Engineer, if you've never had the opportunity
to parse an e02 file, you're in for a treat!

## Starting Point

To execute your code, run `make build-and-run INTERVIEW_TYPE=parse-e02-files` at
the root of the repo. This will build the Docker image and run the container.

A `ParseE02` (`src/parse_e02.py`) class has been initialized for you, which loads
the e02 file (`data/e029924d.012924`) and schema(s) (`data/schemas`).

There is a breakpoint in `__main__.py` where you can inspect the data.

## Objective

The end result should be an object that can be loaded into a SQL database.

## Notes

- e02 format is well documented, feel free to use any resources you see fit
- Poetry is installed but not required
- Pandas is installed but not required, feel free to use any library you see fit
- The `ParseE02` class is a starting point, feel free to modify it as needed
