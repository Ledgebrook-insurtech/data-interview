import sys
import os
from parse_e02 import ParseE02  # pylint: disable=import-error, wrong-import-order

def main():
    """
    Main Entry Point for Python Script
    """

    try:
        
        e02 = ParseE02()
        e02.load_schema()
        e02.load_e02_file()

    except Exception as error: # pylint: disable=broad-exception-caught
        print(f"Exception occurred: {error}")
        
        sys.exit(1)  # Exit with error if any exceptions are caught


if __name__ == "__main__":

    main()
